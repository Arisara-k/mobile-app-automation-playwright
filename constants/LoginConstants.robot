*** Comments ***
Static expected UI copy for the Login screen.
Reference these variables from LoginPo.robot "Verify *" keywords instead of typing literal strings.


*** Variables ***
${LOGIN_EXPECTED_HEADER}                        Login
${LOGIN_EXPECTED_SUBTEXT}                       Select a username and password from the list below, or click on the
...                                             usernames to automatically populate the username and password.
${LOGIN_EXPECTED_SUBMIT_BUTTON_TEXT}            Login
${LOGIN_EXPECTED_ERROR_USERNAME_REQUIRED}       Username is required
${LOGIN_EXPECTED_ERROR_PASSWORD_REQUIRED}       Password is required
${LOGIN_EXPECTED_ERROR_NO_MATCH}                Provided credentials do not match any user in this service.
${LOGIN_EXPECTED_ERROR_LOCKED_OUT}              Sorry, this user has been locked out.
