# path to YOUR Android SDK
export AIR_ANDROID_SDK_HOME="D:\sdks\android-sdk"

# path to the ADT tool in Flash Builder sdks
#ADT="/Applications/Adobe Flash Builder 4.7/sdks/4.6.0-air3.9New/bin/adt"
#ADT="D:/sdks/flex-sdks/4.12.1.air-14.0/bin/adt.bat"
ADT="D:/sdks/flex-sdks/4.12.1.air-14.0/lib/adt.jar"
ADB="D:\sdks\flex-sdks\4.12.1.air-14.0\lib\android\bin\adb"

# native project folder
NATIVE_FOLDER=android

# AS lib folder
LIB_FOLDER=lib

# Default lib folder
DEF_FOLDER=DefaultLib

# app folder
APP_PROJECT=MyTestProject

# name of ANE file
ANE_NAME=appsflyer.ane

# JAR filename
JAR_NAME=AppsFlyerExtension.jar

# APK name
APK_NAME=AppsFlyerAir.apk

# cert path
CERT_NAME=cert.p12

# cert password
CERT_PASS=password

#===================================================================

echo "****** preparing ANE package sources *******"

rm ${ANE_NAME}
rm -rf ./build/ane
mkdir -p ./build/ane
mkdir -p ./build/ane/Android-ARM
mkdir -p ./build/ane/Android-ARM/res/values
mkdir -p ./build/ane/iPhone-ARM
mkdir -p ./build/ane/default

# copy resources
#cp -R ./${NATIVE_FOLDER}/res/* ./build/ane/Android-ARM/res

# create the JAR file
#jar cf ./build/ane/Android-ARM/${JAR_NAME} -C ./${NATIVE_FOLDER}/bin/classes .	 

cp ./${JAR_NAME} ./build/ane/Android-ARM/${JAR_NAME}

# grab the extension descriptor and SWC library 
cp ./${LIB_FOLDER}/src/extension.xml ./build/ane/
cp ./${LIB_FOLDER}/bin/*.swc ./build/ane/
#cp ./google-play-services_lib/libs/google-play-services.jar ./build/ane/Android-ARM
cp ./google-play-services.jar ./build/ane/Android-ARM
#cp ./android/libs/android-support-v4.jar ./build/ane/Android-ARM
cp ./android/libs/AF-Android-SDK-v2.3.1.9.jar ./build/ane/Android-ARM
cp -R ./google-play-services-res/values/ ./build/ane/Android-ARM/res
unzip ./build/ane/*.swc -d ./build/ane
mv ./build/ane/library.swf ./build/ane/Android-ARM
cp ./build/ane/Android-ARM/library.swf ./build/ane/iPhone-ARM
cp ./ios/libAdobeeAirExtensionIOS.a ./build/ane/iPhone-ARM
#cp ./${DEF_FOLDER}/bin/*.swc ./build/ane/default
unzip ./${DEF_FOLDER}/bin/*.swc -d ./build/ane/default



echo "****** creating ANE package *******"

java -jar ${ADT} -package -storetype PKCS12 -keystore ./cert.p12 -storepass password -tsa none \
		-target ane \
		${ANE_NAME} \
		./build/ane/extension.xml \
		-swc ./build/ane/*.swc \
		-platform Android-ARM \
		-platformoptions ./platform.xml \
		-C ./build/ane/Android-ARM/ . \
		-platform default \
		-C ./build/ane/default .
		#-platform iPhone-ARM \
		#-platformoptions ./ios/ios_options.xml \
		#-C ios/ libAppsFlyerLib.a \
		#-C ./build/ane/iPhone-ARM/ . \
		
		
		
		 

echo "****** ANE package created *******"

echo "****** preparing APK package sources *******"

rm ${APK_NAME}
rm -rf ./build/apk
#rm -rf ./build/ipa
mkdir -p ./build/apk
#mkdir -p ./build/ipa

cp ./${APP_PROJECT}/bin-debug/${APP_PROJECT}-app.xml ./build/apk
cp ./${APP_PROJECT}/bin-debug/${APP_PROJECT}.swf ./build/apk
#cp ./${APP_PROJECT}/bin-debug/${APP_PROJECT}-app.xml ./build/ipa
#cp ./${APP_PROJECT}/bin-debug/${APP_PROJECT}.swf ./build/ipa



#echo "****** creating IOS APP ********"

#cd ./build/ipa

#"$ADT" -package -target ipa-test \
#    -keystore ../../Certificates.p12 -storetype pkcs12 -storepass sql2009@ \
#    -provisioning-profile ../../myWildCard.mobileprovision \
#    HelloWorld.ipa \
#    ./${APP_PROJECT}-app.xml \
#    ./${APP_PROJECT}.swf -extdir ../..

#cd ../..

echo "****** creating APK package *******"

cd ./build/apk

java -jar ${ADT} -package -target apk -storetype PKCS12 -keystore ../../${CERT_NAME} -storepass ${CERT_PASS} \
		../../${APK_NAME} \
		./${APP_PROJECT}-app.xml \
		./${APP_PROJECT}.swf -extdir ../..
cd ../..

echo "****** APK package created *******"

#"$ADB" uninstall air.${APP_PROJECT}.debug
#"$ADB" install ${APK_NAME}
