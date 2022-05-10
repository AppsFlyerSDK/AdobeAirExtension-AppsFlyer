#!/bin/bash

# Apktool check
a=$(which apktool)

if [[ $a == "apktool not found" ]]; then
  echo apktool is not installed or not in the PATH. Please install it from https://ibotpeaches.github.io/Apktool/ and add to PATH to proceed. Aborting
  exit
else
  echo Using apktool found at $a
fi

z=$(which zipalign)
if [ $z == "zipalign not found" ]; then
  echo zipalign is not installed or not in the PATH. Please add it to PATH to proceed It should be located under .../Android/sdk/build-tools/{build_tool_version}/zipalign. Aborting
  exit
else
  echo Using zipalign found at $z
fi

read -p 'Enter apk filename without extension (e.g. Main (NOT Main.apk):' APP_NAME
read -p 'Enter keystore filename (e.g. my-release-key (NOT my-release-key.keystore):' KEYSTORE

if [ $APP_NAME == "" ]; then
  echo App name was not provided, aborting
  exit
fi
if [ $KEYSTORE == "" ]; then
  echo Keystore name was not provided, aborting
  exit
fi

mkdir tmp

# Download relevant SDK version for further extraction of needed files
curl -o ./tmp/android_sdk.zip 'https://repo.maven.apache.org/maven2/com/appsflyer/af-android-sdk/6.5.4/af-android-sdk-6.5.4.aar'

# Extract jar from the aar
unzip ./tmp/android_sdk.zip -d tmp/android_sdk

# Extract needed files from the jar
mv tmp/android_sdk/classes.jar tmp/classes.zip
unzip tmp/classes.zip -d tmp/classes

# Disassemble apk
apktool d $APP_NAME.apk

# Add necessary files into the disassembled apk folder to the com/appsflyer/internal path
mkdir $APP_NAME/unknown
mkdir $APP_NAME/unknown/com
mkdir $APP_NAME/unknown/com/appsflyer
mkdir $APP_NAME/unknown/com/appsflyer/internal
cp tmp/classes/com/appsflyer/internal/a- $APP_NAME/unknown/com/appsflyer/internal
cp tmp/classes/com/appsflyer/internal/b- $APP_NAME/unknown/com/appsflyer/internal

# Add new files into apktool markup so that they will be added to the new apk
mv $APP_NAME/apktool.yml $APP_NAME/apktool.yml.bckp
touch $APP_NAME/apktool.yml
sed $'s/unknownFiles: {/unknownFiles: {\
  com\/appsflyer\/internal\/a-: \'0\',\
  com\/appsflyer\/internal\/b-: \'0\'\
  /' $APP_NAME/apktool.yml.bckp >$APP_NAME/apktool.yml

# Build the new apk
apktool b $APP_NAME

# Zipalign
zipalign -p -f -v 4 $APP_NAME/dist/$APP_NAME.apk $APP_NAME/dist/$APP_NAME-aligned.apk

# Sign
apksigner sign -v --ks $KEYSTORE.jks --out $APP_NAME/dist/$APP_NAME-aligned-signed.apk $APP_NAME/dist/$APP_NAME-aligned.apk

# Verify signature
apksigner verify $APP_NAME/dist/$APP_NAME-aligned-signed.apk

# Verify alignment
zipalign -c -v 4 $APP_NAME/dist/$APP_NAME-aligned-signed.apk

# Place result apk into current folder
rm ./fixed_$APP_NAME.apk
mv $APP_NAME/dist/$APP_NAME-aligned-signed.apk ./fixed_$APP_NAME.apk

# remove temp folders
if [ $APP_NAME != "" ]; then
  rm -rf $APP_NAME/
fi
rm -rf tmp/

echo DONE! Please test fixed_$APP_NAME.apk
