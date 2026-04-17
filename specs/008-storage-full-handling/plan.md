# Implementation Plan: Storage full edge case

**Branch**: `008-storage-full-handling` | **Date**: 2026-04-16 | **Spec**: [spec.md](file:///home/samuelmorse/Projects/hebbo/specs/008-storage-full-handling/spec.md)
**Input**: Feature specification from `/specs/008-storage-full-handling/spec.md`

## Summary

This feature implements graceful error handling for device storage exhaustion during database write operations. We will wrap Drift repository operations in `try-catch` blocks, catch Sqlite-level I/O errors, and trigger a global notification (Snackbar) while preserving the current in-memory session state for potential manual recovery.

## Technical Context

**Language/Version**: Dart / Flutter  
**Primary Dependencies**: Drift (sqlite), flutter_riverpod, google_fonts  
**Storage**: On-device SQLite (Drift), No remote sync for MVP.  
**Testing**: flutter test (unit/widget)  
**Target Platform**: Mobile (Android/iOS), offline-first.
**Project Type**: Open Source, Brain Training App.  
**Performance Goals**: Instantaneous notification on write failure.  
**Constraints**: Fully offline, No data leaves device.  
**Scale/Scope**: Graceful handling for Flanker, Task Switching, and Spatial Span session/trial persistence.

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

- **Scientific Honesty**: Verified. This feature protects data integrity for scientifically validated games.
- **Privacy by Default**: Verified. Local-only data is treated as precious; failure to save is communicated clearly without compromising privacy.
- **Design**: Verified. A non-blocking snackbar is used for a premium, non-disruptive feel.
- **Scope Discipline**: Verified. This is a robust refinement of existing persistence logic, not a new feature creep.

## Project Structure

### Documentation (this feature)

```text
specs/008-storage-full-handling/
├── plan.md              # This file
├── research.md          # Phase 0 output
├── data-model.md        # Phase 1 output
├── quickstart.md        # Phase 1 output
├── contracts/           # Phase 1 output (N/A)
└── tasks.md             # To be created by speckit-tasks
```

### Source Code (repository root)

```text
lib/
├── database/            # Drift DB definitions
├── repositories/        # Repository implementations to be modified
├── providers/           # State management handling write failures
├── widgets/             # Snackbar and Confirmation Dialog triggers
└── screens/             # Navigation guards for unsaved progress
```

**Structure Decision**: No new directories needed. We will modify existing repository patterns in `lib/repositories/` and state management in `lib/providers/`.

## Complexity Tracking

> **Fill ONLY if Constitution Check has violations that must be justified**

| Violation | Why Needed | Simpler Alternative Rejected Because |
|-----------|------------|-------------------------------------|
| N/A       | N/A        | N/A                                 |
