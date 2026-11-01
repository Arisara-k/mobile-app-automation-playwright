*** Comments ***
Drawer (Hamburger Menu) Locators - Android
Pure selector variables only. No keywords, no actions, no assertions.
Every variable name defined here MUST have a same-named counterpart in
object-repository/locators/ios/DrawerLocators.robot.

Shared across every screen's Page Object that needs to open the drawer or navigate via its
menu items - these are app-wide chrome, not specific to any one screen.

Selector priority: accessibility_id > id=<resource-id> > -android uiautomator (UiSelector) as a last resort.


*** Variables ***
${OPEN_MENU_BUTTON}             accessibility_id=open menu
${MENU_LOG_IN_ITEM}             accessibility_id=menu item log in
${MENU_LOG_OUT_ITEM}            accessibility_id=menu item log out
${PRODUCTS_SCREEN_CONTAINER}    accessibility_id=products screen
