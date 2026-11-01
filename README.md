# Mobile App Automation Framework with Robot Framework & Appium

[![CI](https://github.com/Arisara-k/mobile-app-automation-playwright/actions/workflows/ci.yml/badge.svg)](https://github.com/Arisara-k/mobile-app-automation-playwright/actions/workflows/ci.yml)
[![Python](https://img.shields.io/badge/Python-v3.x-blue.svg)](https://www.python.org/)
[![Robot Framework](https://img.shields.io/badge/Robot%20Framework-v7+-black.svg)](https://robotframework.org/)
[![Appium](https://img.shields.io/badge/Appium-v3-9B59B6.svg)](https://appium.io/)
[![Robocop](https://img.shields.io/badge/Linter-Robocop-orange.svg)](https://robocop.readthedocs.io/)
[![Pair Programmed with Claude Code](https://img.shields.io/badge/Pair%20Programmed%20with-Claude%20Code-CC785C?logo=anthropic&logoColor=white)](https://claude.com/claude-code)

An enterprise-grade, native mobile (Android & iOS) test automation framework built with **Robot Framework**, **AppiumLibrary**, and a strict **Object Repository** architecture. Features a 3-tier Locator/Page Object/Test Case separation, platform-agnostic Page Objects that resolve `android`/`ios` locators at runtime, data-driven fixtures, and an automated CI/CD pipeline via GitHub Actions that runs real regression tests on a live Android emulator.

---

## 📑 Table of Contents

- [Key Architecture & Features](#-key-architecture--features)
- [Project Directory Structure](#-project-directory-structure)
- [Prerequisites & Environment Setup](#-prerequisites--environment-setup)
- [Installation](#-installation)
- [Test Execution Commands](#-test-execution-commands)
- [Test Tagging Strategy](#-test-tagging-strategy)
- [Reporting & Artifacts](#-reporting--artifacts)
- [Code Quality & Linting](#-code-quality--linting)
- [CI/CD Pipeline (GitHub Actions)](#-cicd-pipeline-github-actions)
- [AI Pair Programming & Attribution](#-ai-pair-programming--attribution)

---

## 🌟 Key Architecture & Features

1. **Strict 3-Tier Object Repository**:
   - **Test Cases (`test-cases/`):** Pure scenario orchestration — zero raw AppiumLibrary keywords, every action/assertion delegates to a Page Object.
   - **Page Objects (`object-repository/page-objects/`):** `*Po.robot` files encapsulating action keywords (imperative verbs) and `Verify *` assertion keywords, with `CommonPo.robot` holding shared app-lifecycle and dialog-handling keywords.
   - **Locators (`object-repository/locators/`):** Pure `*** Variables ***` files, split into `android/` and `ios/` siblings — never logic, never actions.
2. **Cross-Platform, Not Cross-Branching**:
   - Page Objects `Resource` the correct locator file at runtime via `../locators/${PLATFORM_NAME}/...Locators.robot`, so the same keyword code drives both platforms. `accessibility_id` is preferred wherever the app exposes one, so the same selector value often works unchanged on both platforms.
3. **Data-Driven & Zero Inline Literals**:
   - Expected UI copy lives in `constants/*Constants.robot`; test inputs (credentials, payloads) live in `resources/dataTest/*.robot`, with shared values consolidated in `common.robot` instead of duplicated per screen.
4. **Deterministic, Real-Device-Verified**:
   - Zero hardcoded `Sleep` — every wait uses `Wait Until Element Is Visible` / `Expect Element` with the retry-scale variables (`SMALL`/`MEDIUM`/`LARGE`) from `configs/ApplicationConfigs.robot`. Flows involving native OS dialogs (confirm/success alerts, permission prompts) were reverse-engineered and verified against a real Android emulator, not guessed from the app's source alone.
5. **Clean Session Lifecycle**:
   - `Suite Setup`/`Suite Teardown` own the Appium session; each `[Test Setup]` fully relaunches the app to a known, logged-out state so tests never depend on execution order.
6. **Strict Tagging System**:
   - Every test case carries exactly one Purpose tag (`smoke` / `functional` / `regression`) and one Priority tag (`critical` / `high` / `medium` / `low`), plus an optional `android-only`/`ios-only` tag for genuinely platform-exclusive behavior.

---

## 📁 Project Directory Structure

```plaintext
mobile-app-automation-playwright/
├── .github/
│   └── workflows/
│       └── ci.yml                     # GitHub Actions CI: lint/dry-run + real Android regression run
├── apps/                               # App binaries under test (.apk / .ipa / .app) - git-ignored
├── configs/
│   ├── AppiumConfigs.robot             # Appium server URL + per-platform desired capabilities
│   └── ApplicationConfigs.robot        # App paths/package-bundle ids + retry-scale wait variables
├── constants/
│   ├── LoginConstants.robot            # Expected UI copy for the Login screen
│   └── LogoutConstants.robot           # Expected UI copy for the Logout confirm/success dialogs
├── object-repository/
│   ├── locators/
│   │   ├── android/                    # *** Variables *** only - Android selectors
│   │   │   ├── DrawerLocators.robot    # Shared drawer/hamburger-menu chrome
│   │   │   ├── LoginLocators.robot
│   │   │   └── LogoutLocators.robot
│   │   └── ios/                        # Same variable names, iOS selector strategies
│   │       ├── DrawerLocators.robot
│   │       ├── LoginLocators.robot
│   │       └── LogoutLocators.robot
│   └── page-objects/
│       ├── CommonPo.robot              # App session lifecycle, drawer, dialog-handling keywords
│       ├── LoginPo.robot                # Login screen actions + verifications
│       └── LogoutPo.robot              # Logout confirm/success dialog actions + verifications
├── resources/
│   └── dataTest/
│       └── common.robot                # Shared test credentials (standard / locked-out / invalid user)
├── test-cases/
│   ├── login.robot                     # 8 test cases - screen, validation, happy path, errors, autofill
│   └── logout.robot                    # 4 test cases - dialog, cancel, happy path, unauthenticated edge case
├── results/                            # Test execution output - git-ignored
├── pyproject.toml                      # Robocop lint configuration
└── requirements.txt                    # Python dependencies
```

---

## ⚙️ Prerequisites & Environment Setup

- **Python**: `v3.x`
- **Node.js** + **npm**: required to install the Appium server and drivers
- **Appium server** with the **uiautomator2** (Android) and **xcuitest** (iOS) drivers
- **Android SDK** + an emulator/AVD (Android), or **Xcode** + Simulator (iOS, macOS host only)
- The app build under test (`.apk` for Android, `.app`/`.ipa` for iOS)

---

## 📦 Installation

Clone the repository and install all dependencies:

```bash
git clone https://github.com/Arisara-k/mobile-app-automation-playwright.git
cd mobile-app-automation-playwright

# Python dependencies
python -m venv venv
source venv/bin/activate   # Windows: venv\Scripts\activate
pip install -r requirements.txt

# Appium server and drivers
npm install -g appium
appium driver install uiautomator2
appium driver install xcuitest
```

Place the app build under test in `apps/` and update `configs/ApplicationConfigs.robot` with its path, package name / bundle id, and device name. Then start the Appium server in a separate terminal:

```bash
appium
```

---

## 🚀 Test Execution Commands

| Command | Purpose |
| --- | --- |
| `python -m robot -v PLATFORM_NAME:android -d results test-cases` | Runs the full suite against Android |
| `python -m robot -v PLATFORM_NAME:ios -d results test-cases` | Runs the full suite against iOS |
| `python -m robot -v PLATFORM_NAME:android -i smoke -d results test-cases` | Runs only `smoke`-tagged tests |
| `python -m robot -v PLATFORM_NAME:android -i regression -d results test-cases` | Runs only `regression`-tagged tests (same filter used in CI) |
| `python -m robot --dryrun -v PLATFORM_NAME:android -d results test-cases` | Dry-run: syntax/import check only, no device needed |

---

## 🏷️ Test Tagging Strategy

Every test case carries exactly one Purpose tag and one Priority tag:

- **Purpose Tags**:
  - `smoke`: critical-path checks
  - `functional`: core feature behavior
  - `regression`: guards against regressions (also the tag CI runs on a real device)
- **Priority Tags**:
  - `critical`: high business impact (e.g. successful login, successful logout)
  - `high`: main flows (e.g. screen rendering, required-field validation)
  - `medium`: filters/validations (e.g. cancel flows)
  - `low`: minor edge cases (e.g. locked-out-user autofill, logout while unauthenticated)
- **Platform Tags** (optional): `android-only` / `ios-only` — reserved for genuinely platform-exclusive behavior; none of the current suites need them, since `accessibility_id` keeps the same locator working on both platforms.

---

## 📊 Reporting & Artifacts

Every run writes Robot Framework's standard report set to the `-d` output directory:

```bash
# Open the interactive HTML log/report after a run
start results/report.html   # Windows; use `open` on macOS or `xdg-open` on Linux
```

Output files:
- `results/report.html`: High-level pass/fail summary with timing per suite.
- `results/log.html`: Detailed keyword-by-keyword execution log, including screenshots on failure.
- `results/output.xml`: Machine-readable XML result, consumed by CI artifact uploads.

---

## 🧹 Code Quality & Linting

The project uses **Robotidy** (formatting) and **Robocop** (linting), configured in [`pyproject.toml`](pyproject.toml):

```bash
# Auto-format all .robot files
python -m robotidy .

# Check formatting without modifying files (used in CI)
python -m robotidy --check .

# Lint for architecture/style violations
python -m robocop check .
```

---

## 🔄 CI/CD Pipeline (GitHub Actions)

Continuous Integration is automated via [`.github/workflows/ci.yml`](.github/workflows/ci.yml).

### Workflow Jobs

1. **`lint-and-dryrun`** (always runs, no device needed): `robotidy --check`, `robocop check`, and a dry-run of every suite for both `android` and `ios`.
2. **`regression-android`** (runs after lint passes): boots a real Android emulator with KVM acceleration (`reactivecircus/android-emulator-runner` on `ubuntu-latest`) and runs only the `regression`-tagged tests for real.

### GitHub Release Setup

The `regression-android` job downloads the Android `.apk` from this repo's **latest GitHub Release** using the default `GITHUB_TOKEN` — no extra secret needed. To keep it working, attach the `.apk` as an asset on every release you cut (any filename ending in `.apk`; the workflow renames it to match `configs/ApplicationConfigs.robot`), and make sure the release is **not** marked as a pre-release (otherwise it won't count as "latest").

### Accessing CI Reports

1. Go to the **Actions** tab on GitHub.
2. Select the latest workflow run.
3. Under **Artifacts**, download `dryrun-results` or `regression-android-results` to review the Robot Framework HTML logs.

> iOS has no CI job yet, since the `xcuitest` driver requires a macOS host with Xcode/Simulator — run the iOS suite locally or on a macOS-based runner with Xcode installed.

---

## 🤖 AI Pair Programming & Attribution

This project was designed, implemented, and debugged with the pair-programming collaboration of **Claude Code** (Anthropic's Claude Sonnet 5), including test matrix design, Page Object/locator architecture, reverse-engineering the app's native-dialog behavior against a real Android emulator, and building/debugging the GitHub Actions CI pipeline.
