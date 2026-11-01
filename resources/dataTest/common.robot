*** Comments ***
Reusable test inputs shared across multiple screens' test suites (e.g. Login and Logout both need
the same standard/locked-out test user credentials). Screen-specific inputs that only one suite
needs belong in that screen's own resources/dataTest/<screen>.robot file instead.


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
