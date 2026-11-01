# mobile-app-automation-playwright
End-to-end mobile testing automation for Android &amp; iOS using Robot Framework and Appium.

## Project Structure

```text
apps/                                  # App binaries under test (.apk / .ipa / .app) - gitignored
configs/                               # Appium server + app capability configs
constants/                             # Static expected copy (labels, error/toast text)
object-repository/
  locators/
    android/                           # *** Variables *** only - Android selectors
    ios/                               # *** Variables *** only - iOS selectors
  page-objects/                        # Action + "Verify " keywords per screen, CommonPo.robot for shared keywords
resources/
  dataTest/                            # Test inputs/payloads (valid/invalid credentials, etc.)
test-cases/                            # *.robot suites - orchestration only, no raw AppiumLibrary keywords
results/                               # Test execution output - gitignored
```

## Setup

1. Python dependencies:
   ```bash
   python -m venv venv
   source venv/bin/activate   # Windows: venv\Scripts\activate
   pip install -r requirements.txt
   ```
2. Appium server and drivers:
   ```bash
   npm install -g appium
   appium driver install uiautomator2
   appium driver install xcuitest
   ```
3. Start the Appium server (separate terminal):
   ```bash
   appium
   ```
4. Place the app build under test in `apps/` (`.apk` for Android, `.app`/`.ipa` for iOS) and update
   `configs/ApplicationConfigs.robot` with its path, package name / bundle id, and device name.

## Running Tests

Run the full suite against Android:
```bash
python -m robot -v PLATFORM_NAME:android -d results test-cases
```

Run against iOS:
```bash
python -m robot -v PLATFORM_NAME:ios -d results test-cases
```

Run only smoke tests:
```bash
python -m robot -v PLATFORM_NAME:android -i smoke -d results test-cases
```

## Code Quality

Format:
```bash
python -m robotidy .
```

Lint:
```bash
python -m robocop check .
```

Dry-run (syntax/import check only, no device needed):
```bash
python -m robot --dryrun -v PLATFORM_NAME:android -d results test-cases
```

## CI

`.github/workflows/ci.yml` runs on every push to `main` and every PR targeting it:

1. **`lint-and-dryrun`** (always runs, no device needed): `robotidy --check`, `robocop check`, and a dry-run of every suite for both `android` and `ios`.
2. **`regression-android`** (runs after lint passes): boots a real Android emulator (`reactivecircus/android-emulator-runner`) and runs only the tests tagged `regression` (`-i regression`) for real.
   - The app `.apk` is downloaded from this repo's **latest GitHub Release** (`gh release download --pattern '*.apk'`) using the default `GITHUB_TOKEN` - no extra secret needed.
   - **To keep this job working, attach the Android `.apk` as an asset on every GitHub Release you cut** (any filename ending in `.apk` - the workflow renames it to match `configs/ApplicationConfigs.robot`).
   - There is no iOS equivalent in CI, since the `xcuitest` driver requires a macOS host with Xcode/Simulator - run the iOS suite locally or on a macOS-based CI runner with Xcode installed.
