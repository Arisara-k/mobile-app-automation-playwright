*** Comments ***
Logout Flow Locators - iOS
Pure selector variables only. No keywords, no actions, no assertions.
Every variable name defined here MUST have a same-named counterpart in
object-repository/locators/android/LogoutLocators.robot.

The "Log Out" confirm/success dialogs are native OS alerts (UIAlertController), not app-drawn
React Native views, so there is no custom accessibility id to target. iOS does not uppercase
alert button titles (unlike Android's Material theme), and UIAlertController buttons normally
expose their visible title as their accessibility_id - this is the standard approach, but it has
NOT been verified on a real iOS device/simulator (no macOS host was available while building
this suite). Confirm with Appium Inspector before relying on this in a real iOS run; fall back to
`-ios predicate string=label == '<text>' AND type == 'XCUIElementTypeButton'` if it doesn't match.

Selector priority: accessibility_id > -ios predicate string > -ios class chain as a last resort.


*** Variables ***
# Section: Confirm Dialog ("Are you sure you sure you want to logout?")
${LOGOUT_CONFIRM_BUTTON}        accessibility_id=Log Out
${LOGOUT_CANCEL_BUTTON}         accessibility_id=Cancel

# Section: Success Alert ("You are successfully logged out.")
${LOGOUT_SUCCESS_OK_BUTTON}     accessibility_id=OK
