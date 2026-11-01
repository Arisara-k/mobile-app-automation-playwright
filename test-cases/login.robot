*** Comments ***
Test Tags:
Purpose: smoke (critical path), functional (core feature), regression (prevent regressions)
Priority: critical (high impact), high (main flows), medium (validations/filters), low (minor edges)


*** Settings ***
Documentation       Verify component and functionality on the Login screen.

Resource            ../object-repository/page-objects/CommonPo.robot
Resource            ../object-repository/page-objects/LoginPo.robot
Resource            ../resources/dataTest/login.robot

Suite Setup         Open App Session
Suite Teardown      Close App Session
Test Setup          Relaunch To Login Screen


*** Test Cases ***
Verify Login Screen Elements Match Design
    [Documentation]    All required elements and copy are visible on first render of the Login screen.
    [Tags]    smoke    high
    Verify Login Screen Elements Are Displayed

Verify Username Required Error When Username Is Blank
    [Documentation]    Leaving the username blank and submitting shows the "Username is required" inline error.
    [Tags]    functional    high
    Enter Username    ${EMPTY_INPUT}
    Enter Password    ${STANDARD_PASSWORD}
    Tap Login Button
    Verify Username Required Error

Verify Password Required Error When Password Is Blank
    [Documentation]    Leaving the password blank and submitting shows the "Password is required" inline error.
    [Tags]    functional    high
    Enter Username    ${STANDARD_USERNAME}
    Enter Password    ${EMPTY_INPUT}
    Tap Login Button
    Verify Password Required Error

Verify Successful Login With Valid Credentials
    [Documentation]    A standard user can log in successfully and lands on the Products screen.
    [Tags]    smoke    critical
    Submit Login Form    ${STANDARD_USERNAME}    ${STANDARD_PASSWORD}
    Verify Navigated To Products Screen

Verify Locked Out User Cannot Log In
    [Documentation]    A locked-out user is rejected with the account-locked error and stays on the Login screen.
    [Tags]    regression    critical
    Submit Login Form    ${LOCKED_OUT_USERNAME}    ${LOCKED_OUT_PASSWORD}
    Verify Locked Out Error

Verify Login Fails With Unmatched Credentials
    [Documentation]    Credentials that match no user show the generic "no match" error.
    [Tags]    regression    medium
    Submit Login Form    ${INVALID_USERNAME}    ${INVALID_PASSWORD}
    Verify Invalid Credentials Error

Verify Autofill Link Populates Standard User Credentials
    [Documentation]    Tapping the standard-user autofill link fills both fields without submitting the form.
    [Tags]    functional    medium
    ${standard_password_length}=    Get Length    ${STANDARD_PASSWORD}
    Tap Autofill Link For Standard User
    Verify Username Field Contains    ${STANDARD_USERNAME}
    Verify Password Field Is Masked With Length    ${standard_password_length}

Verify Autofill Link Populates Locked Out User Credentials
    [Documentation]    Tapping the locked-out-user autofill link fills both fields without submitting the form.
    [Tags]    functional    low
    ${locked_out_password_length}=    Get Length    ${LOCKED_OUT_PASSWORD}
    Tap Autofill Link For Locked Out User
    Verify Username Field Contains    ${LOCKED_OUT_USERNAME}
    Verify Password Field Is Masked With Length    ${locked_out_password_length}
