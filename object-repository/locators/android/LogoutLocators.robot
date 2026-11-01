*** Comments ***
Logout Flow Locators - Android
Pure selector variables only. No keywords, no actions, no assertions.
Every variable name defined here MUST have a same-named counterpart in
object-repository/locators/ios/LogoutLocators.robot.

The "Log Out" confirm/success dialogs are native OS AlertDialogs, not app-drawn React Native
views, so their buttons carry no custom accessibility id. Android renders their button text in
UPPERCASE ("CANCEL" / "LOG OUT") per Material theme styling, which would make a text-based
selector fragile - the stable Android system resource-ids are used instead (last-resort tier,
justified since accessibility_id is genuinely unavailable on these native buttons).

Selector priority: accessibility_id > id=<resource-id> > -android uiautomator (UiSelector) as a last resort.


*** Variables ***
# Section: Confirm Dialog ("Are you sure you sure you want to logout?")
${LOGOUT_CONFIRM_BUTTON}        id=android:id/button1
${LOGOUT_CANCEL_BUTTON}         id=android:id/button2

# Section: Success Alert ("You are successfully logged out.")
${LOGOUT_SUCCESS_OK_BUTTON}     id=android:id/button1
