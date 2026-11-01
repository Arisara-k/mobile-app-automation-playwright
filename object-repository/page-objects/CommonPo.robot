*** Settings ***
Documentation       Shared keywords reused across every screen's Page Object: app session lifecycle
...                 and native dialog handling. Screen-specific Page Objects Resource this file -
...                 they should never re-implement app open/close or dialog handling themselves.

Library             AppiumLibrary
Resource            ../../configs/AppiumConfigs.robot
Resource            ../../configs/ApplicationConfigs.robot
Resource            ../locators/${PLATFORM_NAME}/DrawerLocators.robot


*** Keywords ***
Open App Session
    [Documentation]    Opens a single Appium session for the whole suite, for the platform
    ...    passed on the command line via -v PLATFORM_NAME:android|ios.
    IF    '${PLATFORM_NAME}' == 'android'
        &{capabilities}=    Build Android Capabilities
    ELSE IF    '${PLATFORM_NAME}' == 'ios'
        &{capabilities}=    Build IOS Capabilities
    ELSE
        Fail    Unsupported PLATFORM_NAME "${PLATFORM_NAME}" - pass -v PLATFORM_NAME:android or -v PLATFORM_NAME:ios
    END
    Open Application    ${APPIUM_SERVER_URL}    &{capabilities}

Close App Session
    [Documentation]    Closes the Appium session opened by "Open App Session".
    Close Application

Relaunch Application
    [Documentation]    Fully restarts the Appium session to clear in-memory app state (e.g. an active
    ...    login session) between tests. A plain Terminate + Activate Application was verified on a
    ...    real device/emulator to leave stale React Navigation state behind that breaks deep-linking
    ...    back into certain screens on the next attempt - closing and reopening the session avoids that.
    Close Application
    Open App Session

Open Drawer Menu
    [Documentation]    Opens the app's drawer/hamburger menu. Shared by every screen's Page Object
    ...    that navigates via a drawer menu item (e.g. Login, Logout).
    Wait Until Element Is Visible    ${OPEN_MENU_BUTTON}    ${MEDIUM_RETRY_SCALE}
    Click Element    ${OPEN_MENU_BUTTON}

Dismiss Permission Dialog If Present
    [Documentation]    Grants or dismisses an OS permission dialog if one appears after an action,
    ...    without failing when no dialog appears at all (appearance is OS/first-run
    ...    dependent, so it must never be assumed either way).
    ${dialog_present}=    Run Keyword And Return Status
    ...    Wait Until Page Contains Element    accessibility_id=Allow    ${SMALL_RETRY_SCALE}
    IF    ${dialog_present}    Click Element    accessibility_id=Allow
