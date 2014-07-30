# path to YOUR Android SDK
export AIR_ANDROID_SDK_HOME="D:\sdks\android-sdk"

ADT="../../sdks/flex-sdk-4.13.0.air14.0/bin/adt"
ADB="../../sdks/flex-sdk-4.13.0.air14.0/lib/android/bin/adb"

# AS lib folder
LIB_FOLDER=lib

# Default lib folder
DEF_FOLDER=DefaultLib

# app folder
APP_PROJECT=TestProject

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

cp ./android/${JAR_NAME} ./build/ane/Android-ARM/${JAR_NAME}

# grab the extension descriptor and SWC library 
cp ./${LIB_FOLDER}/src/extension.xml ./build/ane/
cp ./${LIB_FOLDER}/bin/*.swc ./build/ane/
cp ./android/google-play-services.jar ./build/ane/Android-ARM
cp ./android/AF-Android-SDK-v2.3.1.9.jar ./build/ane/Android-ARM
cp -R ./android/google-play-services-res/values/ ./build/ane/Android-ARM/res/values
unzip ./build/ane/*.swc -d ./build/ane
mv ./build/ane/library.swf ./build/ane/Android-ARM
cp ./build/ane/Android-ARM/library.swf ./build/ane/iPhone-ARM
cp ./ios/libAdobeeAirExtensionIOS.a ./build/ane/iPhone-ARM
cp ./${DEF_FOLDER}/bin/*.swc ./build/ane/default
unzip ./${DEF_FOLDER}/bin/*.swc -d ./build/ane/default



echo "****** creating ANE package *******"

"$ADT" -package -storetype PKCS12 -keystore ./cert.p12 -storepass password -tsa none \
		-target ane \
		${ANE_NAME} \
		./build/ane/extension.xml \
		-swc ./build/ane/*.swc \
		-platform Android-ARM \
		-platformoptions ./android/platform-android.xml \
		-C ./build/ane/Android-ARM/ . \
		-platform iPhone-ARM \
		-platformoptions ./ios/platform-ios.xml \
		-C ios/ libAppsFlyerLib.a \
		-C ./build/ane/iPhone-ARM/ . \
        -platform default \
        -C ./build/ane/default .

		
		 

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

"$ADT" -package -target apk -storetype PKCS12 -keystore ../../${CERT_NAME} -storepass ${CERT_PASS} \
		../../${APK_NAME} \
		./${APP_PROJECT}-app.xml \
		./${APP_PROJECT}.swf -extdir ../..
cd ../..

echo "****** APK package created *******"

#"$ADB" uninstall air.${APP_PROJECT}.debug
#"$ADB" install ${APK_NAME}
