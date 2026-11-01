*** Variables ***
# Section: Screen Container
${LOGIN_SCREEN_CONTAINER}                   accessibility_id=login screen

# Section: Form Elements
${LOGIN_USERNAME_FIELD}                     accessibility_id=Username input field
${LOGIN_PASSWORD_FIELD}                     accessibility_id=Password input field
${LOGIN_SUBMIT_BUTTON}                      accessibility_id=Login button

# Section: Autofill Convenience Links
${LOGIN_AUTOFILL_STANDARD_USER_LINK}        accessibility_id=bob@example.com-autofill
${LOGIN_AUTOFILL_LOCKED_OUT_USER_LINK}      accessibility_id=alice@example.com (locked out)-autofill

# Section: Feedback & Alerts
${LOGIN_GENERIC_ERROR_MESSAGE}              accessibility_id=generic-error-message
${LOGIN_USERNAME_ERROR_MESSAGE}             accessibility_id=Username-error-message
${LOGIN_PASSWORD_ERROR_MESSAGE}             accessibility_id=Password-error-message
