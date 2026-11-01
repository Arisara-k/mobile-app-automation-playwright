*** Settings ***
Documentation       Login Page Object - Encapsulates user actions and assertions for the Login screen.

Resource            ../locators/${PLATFORM_NAME}/LoginLocators.robot
Resource            CommonPo.robot
Resource            ../../constants/LoginConstants.robot


*** Keywords ***
# Navigation (used by [Test Setup] to return to a known state between tests)
Open Login Screen
    [Documentation]    Opens the drawer menu and navigates to the Login screen.
    Open Drawer Menu
    Wait Until Element Is Visible    ${MENU_LOG_IN_ITEM}    ${SMALL_RETRY_SCALE}
    Click Element    ${MENU_LOG_IN_ITEM}
    Wait Until Element Is Visible    ${LOGIN_SCREEN_CONTAINER}    ${MEDIUM_RETRY_SCALE}

Relaunch To Login Screen
    [Documentation]    Returns the app to the Login screen from a clean, logged-out state, independent
    ...    of where a previous test left off (e.g. after a prior test logged in successfully).
    Relaunch Application
    Open Login Screen

Log In As Standard User
    [Documentation]    Composite setup action: relaunches the app, logs in with the given credentials,
    ...    and confirms landing on the Products screen. Useful as a [Test Setup] for suites that need
    ...    an authenticated starting state (e.g. Logout).
    [Arguments]    ${username}    ${password}
    Relaunch Application
    Open Login Screen
    Submit Login Form    ${username}    ${password}
    Verify Navigated To Products Screen

# Actions (verify immediate effect where practical - fail-fast)

Enter Username
    [Documentation]    Types the given username into the username field and confirms it was accepted.
    [Arguments]    ${username}
    Wait Until Element Is Visible    ${LOGIN_USERNAME_FIELD}    ${MEDIUM_RETRY_SCALE}
    Input Text    ${LOGIN_USERNAME_FIELD}    ${username}
    Element Text Should Be    ${LOGIN_USERNAME_FIELD}    ${username}

Enter Password
    [Documentation]    Types the given password into the password field and confirms a value of the
    ...    same length was accepted (the field is masked, so its exact text can't be compared).
    [Arguments]    ${password}
    Wait Until Element Is Visible    ${LOGIN_PASSWORD_FIELD}    ${MEDIUM_RETRY_SCALE}
    Input Text    ${LOGIN_PASSWORD_FIELD}    ${password}
    ${expected_length}=    Get Length    ${password}
    Verify Password Field Is Masked With Length    ${expected_length}

Tap Login Button
    [Documentation]    Taps the Login button and dismisses any permission dialog that may appear as a result.
    Wait Until Element Is Visible    ${LOGIN_SUBMIT_BUTTON}    ${SMALL_RETRY_SCALE}
    Click Element    ${LOGIN_SUBMIT_BUTTON}
    Dismiss Permission Dialog If Present

Submit Login Form
    [Documentation]    Composite action: fills username & password and taps the Login button. Used for
    ...    both valid and invalid credential scenarios.
    [Arguments]    ${username}    ${password}
    Enter Username    ${username}
    Enter Password    ${password}
    Tap Login Button

Tap Autofill Link For Standard User
    [Documentation]    Taps the "bob@example.com" quick-login link, which populates the
    ...    username/password fields without submitting, and confirms the username field was filled.
    Wait Until Element Is Visible    ${LOGIN_AUTOFILL_STANDARD_USER_LINK}    ${SMALL_RETRY_SCALE}
    Click Element    ${LOGIN_AUTOFILL_STANDARD_USER_LINK}
    Wait Until Keyword Succeeds    ${SMALL_RETRY_SCALE}    1s    Field Should Not Be Empty    ${LOGIN_USERNAME_FIELD}

Tap Autofill Link For Locked Out User
    [Documentation]    Taps the "alice@example.com (locked out)" quick-login link, which populates
    ...    the username/password fields without submitting, and confirms the username field was filled.
    Wait Until Element Is Visible    ${LOGIN_AUTOFILL_LOCKED_OUT_USER_LINK}    ${SMALL_RETRY_SCALE}
    Click Element    ${LOGIN_AUTOFILL_LOCKED_OUT_USER_LINK}
    Wait Until Keyword Succeeds    ${SMALL_RETRY_SCALE}    1s    Field Should Not Be Empty    ${LOGIN_USERNAME_FIELD}

Field Should Not Be Empty
    [Documentation]    Fails unless the given field holds a non-empty value - used as a fail-fast check for
    ...    actions that populate a field without knowing its expected value upfront (e.g. an autofill link).
    [Arguments]    ${locator}
    ${value}=    Get Text    ${locator}
    Should Not Be Empty    ${value}

# Verifications (named "Verify *" - no raw AppiumLibrary assertions in test cases)

Verify Login Screen Elements Are Displayed
    [Documentation]    Verifies every required element on the Login screen is visible and matches expected copy.
    Wait Until Element Is Visible    ${LOGIN_SCREEN_CONTAINER}    ${MEDIUM_RETRY_SCALE}
    Page Should Contain Text    ${LOGIN_EXPECTED_HEADER}
    Page Should Contain Text    ${LOGIN_EXPECTED_SUBTEXT}
    Expect Element    ${LOGIN_USERNAME_FIELD}    visible    ${MEDIUM_RETRY_SCALE}
    Expect Element    ${LOGIN_PASSWORD_FIELD}    visible    ${MEDIUM_RETRY_SCALE}
    Expect Element    ${LOGIN_SUBMIT_BUTTON}    visible    ${MEDIUM_RETRY_SCALE}
    Page Should Contain Text    ${LOGIN_EXPECTED_SUBMIT_BUTTON_TEXT}
    Expect Element    ${LOGIN_AUTOFILL_STANDARD_USER_LINK}    visible    ${MEDIUM_RETRY_SCALE}
    Expect Element    ${LOGIN_AUTOFILL_LOCKED_OUT_USER_LINK}    visible    ${MEDIUM_RETRY_SCALE}

Verify Username Required Error
    [Documentation]    Verifies the inline error shown under the username field when it is left blank.
    ...    The error text lives in a child Text node with no accessibility id of its own, so the
    ...    container's own "text" attribute is always empty - checking the page's visible text is
    ...    the reliable way to confirm the exact message, alongside the container becoming visible.
    Wait Until Element Is Visible    ${LOGIN_USERNAME_ERROR_MESSAGE}    ${SMALL_RETRY_SCALE}
    Page Should Contain Text    ${LOGIN_EXPECTED_ERROR_USERNAME_REQUIRED}

Verify Password Required Error
    [Documentation]    Verifies the inline error shown under the password field when it is left blank.
    Wait Until Element Is Visible    ${LOGIN_PASSWORD_ERROR_MESSAGE}    ${SMALL_RETRY_SCALE}
    Page Should Contain Text    ${LOGIN_EXPECTED_ERROR_PASSWORD_REQUIRED}

Verify Locked Out Error
    [Documentation]    Verifies the generic error shown when logging in with a locked-out account.
    Wait Until Element Is Visible    ${LOGIN_GENERIC_ERROR_MESSAGE}    ${SMALL_RETRY_SCALE}
    Page Should Contain Text    ${LOGIN_EXPECTED_ERROR_LOCKED_OUT}

Verify Invalid Credentials Error
    [Documentation]    Verifies the generic error shown when logging in with credentials that match no user.
    Wait Until Element Is Visible    ${LOGIN_GENERIC_ERROR_MESSAGE}    ${SMALL_RETRY_SCALE}
    Page Should Contain Text    ${LOGIN_EXPECTED_ERROR_NO_MATCH}

Verify Navigated To Products Screen
    [Documentation]    Verifies a successful login landed the user on the Products (catalog) screen.
    Wait Until Element Is Visible    ${PRODUCTS_SCREEN_CONTAINER}    ${LARGE_RETRY_SCALE}

Verify Username Field Contains
    [Documentation]    Verifies the username field holds the given value, e.g. after tapping an autofill link.
    [Arguments]    ${expected_username}
    Element Text Should Be    ${LOGIN_USERNAME_FIELD}    ${expected_username}

Verify Password Field Is Masked With Length
    [Documentation]    Verifies the password field holds a masked value of the given length, e.g. after
    ...    tapping an autofill link. The field uses secureTextEntry, so its reported text is masked
    ...    bullet characters rather than the real value - checking the mask length is the reliable,
    ...    platform-accurate way to confirm a password was actually populated.
    [Arguments]    ${expected_length}
    ${actual_value}=    Get Text    ${LOGIN_PASSWORD_FIELD}
    ${actual_length}=    Get Length    ${actual_value}
    Should Be Equal As Integers    ${actual_length}    ${expected_length}
