*** Comments ***
Appium server connection and per-platform desired capabilities.
Select which capability dictionary to use based on ${PLATFORM_NAME}, supplied on the
command line (-v PLATFORM_NAME:android or -v PLATFORM_NAME:ios).


*** Variables ***
${APPIUM_SERVER_URL}    http://127.0.0.1:4723


*** Keywords ***
Build Android Capabilities
    [Documentation]    Builds the desired capabilities dictionary for an Android session.
    VAR    &{capabilities}
    ...    platformName=Android
    ...    automationName=UiAutomator2
    ...    deviceName=${ANDROID_DEVICE_NAME}
    ...    app=${ANDROID_APP_PATH}
    ...    appPackage=${ANDROID_APP_PACKAGE}
    ...    appActivity=${ANDROID_APP_ACTIVITY}
    ...    noReset=${FALSE}
    RETURN    &{capabilities}

Build IOS Capabilities
    [Documentation]    Builds the desired capabilities dictionary for an iOS session.
    VAR    &{capabilities}
    ...    platformName=iOS
    ...    automationName=XCUITest
    ...    deviceName=${IOS_DEVICE_NAME}
    ...    platformVersion=${IOS_PLATFORM_VERSION}
    ...    app=${IOS_APP_PATH}
    ...    bundleId=${IOS_BUNDLE_ID}
    ...    noReset=${FALSE}
    RETURN    &{capabilities}
