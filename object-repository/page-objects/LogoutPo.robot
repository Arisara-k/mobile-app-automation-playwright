*** Settings ***
Documentation       Logout Page Object - Encapsulates the drawer "Log Out" action and its native
...                 confirm/success dialogs.

Resource            ../locators/${PLATFORM_NAME}/LogoutLocators.robot
Resource            ../locators/${PLATFORM_NAME}/LoginLocators.robot
Resource            CommonPo.robot
Resource            ../../constants/LogoutConstants.robot


*** Keywords ***
# Actions (verify immediate effect where practical - fail-fast)
Open Logout Confirmation Dialog
    [Documentation]    Opens the drawer and taps "Log Out", surfacing the native confirm dialog.
    Open Drawer Menu
    Wait Until Element Is Visible    ${MENU_LOG_OUT_ITEM}    ${SMALL_RETRY_SCALE}
    Click Element    ${MENU_LOG_OUT_ITEM}
    Wait Until Element Is Visible    ${LOGOUT_CONFIRM_BUTTON}    ${SMALL_RETRY_SCALE}

Tap Logout Confirm Button
    [Documentation]    Confirms the logout, triggering the "successfully logged out" alert.
    Click Element    ${LOGOUT_CONFIRM_BUTTON}

Tap Logout Cancel Button
    [Documentation]    Cancels the logout, leaving the current session and screen unaffected.
    Click Element    ${LOGOUT_CANCEL_BUTTON}

Dismiss Logout Success Alert
    [Documentation]    Dismisses the "successfully logged out" alert by tapping its OK button.
    Wait Until Element Is Visible    ${LOGOUT_SUCCESS_OK_BUTTON}    ${SMALL_RETRY_SCALE}
    Click Element    ${LOGOUT_SUCCESS_OK_BUTTON}

# Verifications (named "Verify *" - no raw AppiumLibrary assertions in test cases)

Verify Logout Confirmation Dialog Is Displayed
    [Documentation]    Verifies the native confirm dialog shows the expected title, message, and buttons.
    Page Should Contain Text    ${LOGOUT_EXPECTED_CONFIRM_TITLE}
    Page Should Contain Text    ${LOGOUT_EXPECTED_CONFIRM_MESSAGE}
    Expect Element    ${LOGOUT_CONFIRM_BUTTON}    visible    ${SMALL_RETRY_SCALE}
    Expect Element    ${LOGOUT_CANCEL_BUTTON}    visible    ${SMALL_RETRY_SCALE}

Verify Logout Success Message Is Displayed
    [Documentation]    Verifies the "successfully logged out" alert is showing, before it is dismissed.
    Wait Until Element Is Visible    ${LOGOUT_SUCCESS_OK_BUTTON}    ${SMALL_RETRY_SCALE}
    Page Should Contain Text    ${LOGOUT_EXPECTED_SUCCESS_MESSAGE}

Verify Navigated To Login Screen
    [Documentation]    Verifies logging out landed the user back on the Login screen.
    Wait Until Element Is Visible    ${LOGIN_SCREEN_CONTAINER}    ${MEDIUM_RETRY_SCALE}

Verify Still On Products Screen
    [Documentation]    Verifies the user is still on the Products screen, e.g. after cancelling logout.
    Expect Element    ${PRODUCTS_SCREEN_CONTAINER}    visible    ${MEDIUM_RETRY_SCALE}
