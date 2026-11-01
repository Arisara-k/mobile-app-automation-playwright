*** Settings ***
Documentation       Shared keywords reused across every screen's Page Object: app session lifecycle
...                 and native dialog handling. Screen-specific Page Objects Resource this file -
...                 they should never re-implement app open/close or dialog handling themselves.
Library             AppiumLibrary
Resource            ../../configs/AppiumConfigs.robot
Resource            ../../configs/ApplicationConfigs.robot


*** Keywords ***
Open App Session
    [Documentation]    Opens a single Appium session for the whole suite, for the platform
    ...                passed on the command line via -v PLATFORM_NAME:android|ios.
    IF    '${PLATFORM_NAME}' == 'android'
        &{capabilities}=    Build Android Capabilities
    ELSE IF    '${PLATFORM_NAME}' == 'ios'
        &{capabilities}=    Build iOS Capabilities
    ELSE
        Fail    Unsupported PLATFORM_NAME "${PLATFORM_NAME}" - pass -v PLATFORM_NAME:android or -v PLATFORM_NAME:ios
    END
    Open Application    ${APPIUM_SERVER_URL}    &{capabilities}

Close App Session
    [Documentation]    Closes the Appium session opened by "Open App Session".
    Close Application

Dismiss Permission Dialog If Present
    [Documentation]    Grants or dismisses an OS permission dialog if one appears after an action,
    ...                without failing when no dialog appears at all (appearance is OS/first-run
    ...                dependent, so it must never be assumed either way).
    ${dialog_present}=    Run Keyword And Return Status
    ...    Wait Until Page Contains Element    accessibility_id=Allow    ${SMALL_RETRY_SCALE}
    IF    ${dialog_present}
        Click Element    accessibility_id=Allow
    END
