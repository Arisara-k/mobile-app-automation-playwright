*** Comments ***
Test Tags:
Purpose: smoke (critical path), functional (core feature), regression (prevent regressions)
Priority: critical (high impact), high (main flows), medium (validations/filters), low (minor edges)


*** Settings ***
Documentation       Verify the drawer "Log Out" action and its native confirm/success dialogs.

Resource            ../object-repository/page-objects/CommonPo.robot
Resource            ../object-repository/page-objects/LoginPo.robot
Resource            ../object-repository/page-objects/LogoutPo.robot
Resource            ../resources/dataTest/common.robot

Suite Setup         Open App Session
Suite Teardown      Close App Session
Test Setup          Log In As Standard User    ${STANDARD_USERNAME}    ${STANDARD_PASSWORD}


*** Test Cases ***
Verify Logout Confirmation Dialog Matches Design
    [Documentation]    Tapping "Log Out" from the drawer shows the expected confirm dialog.
    [Tags]    smoke    high
    Open Logout Confirmation Dialog
    Verify Logout Confirmation Dialog Is Displayed

Verify Cancelling Logout Keeps The User Signed In
    [Documentation]    Tapping Cancel on the confirm dialog leaves the session and screen unaffected.
    [Tags]    functional    medium
    Open Logout Confirmation Dialog
    Tap Logout Cancel Button
    Verify Still On Products Screen

Verify User Can Log Out Successfully
    [Documentation]    Confirming logout shows a success message and returns the user to the Login screen.
    [Tags]    smoke    critical
    Open Logout Confirmation Dialog
    Tap Logout Confirm Button
    Verify Logout Success Message Is Displayed
    Dismiss Logout Success Alert
    Verify Navigated To Login Screen

Verify Logout Works Even When Not Authenticated
    [Documentation]    The drawer always exposes "Log Out" regardless of auth state; tapping it while
    ...    not logged in should still complete without crashing the app.
    [Tags]    functional    low
    [Setup]    Relaunch Application
    Open Logout Confirmation Dialog
    Tap Logout Confirm Button
    Verify Logout Success Message Is Displayed
    Dismiss Logout Success Alert
    Verify Navigated To Login Screen
