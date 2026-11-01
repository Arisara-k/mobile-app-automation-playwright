*** Comments ***
Test input payloads for the Login screen.
Reference these variables from test-cases/login.robot instead of typing literal credentials.


*** Variables ***
# Valid / Standard User
${STANDARD_USERNAME}        bob@example.com
${STANDARD_PASSWORD}        10203040

# Locked-Out User (same password, account is locked server-side)
${LOCKED_OUT_USERNAME}      alice@example.com
${LOCKED_OUT_PASSWORD}      10203040

# Invalid / Negative Input
${INVALID_USERNAME}         not_a_real_user@example.com
${INVALID_PASSWORD}         wrong-password
${EMPTY_INPUT}              ${EMPTY}
