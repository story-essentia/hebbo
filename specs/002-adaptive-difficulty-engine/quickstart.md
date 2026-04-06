# Quickstart: Adaptive Difficulty Engine

## Overview
How to verify the Hebbo logic-only difficulty engine.

## Setup Requirements
- Flutter SDK (latest stable)
- Dart SDK

## Installation

1. **Initialize Engine Features**:
    ```bash
    flutter pub get
    ```

## Logic Verification

1. **Execute Unit Tests**:
   The primary method for confirming the adaptive logic is through the automated unit test suite.
    ```bash
    # Run core engine tests
    flutter test test/providers/adaptive_engine_test.dart
    ```

2. **Verify State Updates**:
   The engine's `reportTrial` logic handles all rolling window trimming and Slate Reset events. No UI is required to see these transitions.

## Key Tasks for this Milestone
- Confirm `currentLevel` only saves to repository at session end.
- Verify "Slate Reset" (window clearing) after any level change.
- Ensure level-down ONLY evaluates after a failure (`correct: false`).
- Zero UI built or navigation changes.
