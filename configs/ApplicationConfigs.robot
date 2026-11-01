*** Comments ***
App paths/identifiers per platform, and the retry-scale variables used for every explicit wait
in the Page Object layer instead of a hardcoded Sleep. Adjust the scale values to match how
slow/fast the target emulator, simulator, or real device farm actually is.


*** Variables ***
# Android
${ANDROID_DEVICE_NAME}      emulator-5554
${ANDROID_APP_PATH}         ${CURDIR}/../apps/Android-MyDemoAppRN.1.0.0.build-130.apk
${ANDROID_APP_PACKAGE}      com.saucelabs.mydemoapp.rn
${ANDROID_APP_ACTIVITY}     com.saucelabs.mydemoapp.rn.MainActivity

# iOS
${IOS_DEVICE_NAME}          iPhone 15
${IOS_PLATFORM_VERSION}     17.0
${IOS_APP_PATH}             ${CURDIR}/../apps/MyRNDemoApp.app
${IOS_BUNDLE_ID}            com.saucelabs.mydemoapp.rn

# Retry Scales (seconds) - pass the larger scale for network-bound or animation-heavy screens
${SMALL_RETRY_SCALE}        5s
${MEDIUM_RETRY_SCALE}       10s
${LARGE_RETRY_SCALE}        20s
