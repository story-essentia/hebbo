# Implementation Plan: App Scaffold and Local Storage Layer

**Branch**: `001-scaffold-local-storage` | **Date**: 2026-04-04 | **Spec**: [spec.md](file:///home/samuelmorse/Projects/hebbo/specs/001-scaffold-local-storage/spec.md)
**Input**: Feature specification from `/specs/001-scaffold-local-storage/spec.md`

**Note**: This template is filled in by the `/speckit.plan` command. See `.specify/templates/plan-template.md` for the execution workflow.

## Summary

This feature establishes the foundational infrastructure for the Hebbo app. It involves scaffolding a new Flutter project named "Hebbo" using a Clean Architecture directory structure (models, repositories, providers). A local persistence layer will be implemented using the Drift (SQLite) package, with three core tables: `trials`, `sessions`, and `difficulty_state`. Success is measured by a successful Android emulator launch and an integration test verifying data persistence across hot restarts with zero network activity.

## Technical Context

**Language/Version**: Flutter 3.x, Dart 3.x  
**Primary Dependencies**: `drift`, `sqlite3_flutter_libs`, `path_provider`, `path`, `drift_dev` (dev), `build_runner` (dev)  
**Storage**: [MANDATORY: On-device only (SQLite via Drift), no remote sync for MVP]  
**Testing**: `integration_test` package for cross-restart verification  
**Target Platform**: Android (Emulator validation), iOS (implicit)
**Project Type**: [MANDATORY: Open Source, Mobile App]  
**Performance Goals**: Sub-10ms database operations on local storage  
**Constraints**: [MANDATORY: Offline-only, Privacy-first (no data collection), Scientific evidence for games]  
**Scale/Scope**: [MANDATORY: MVP limited to 3 tables and basic scaffold infrastructure]

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

| Principle | Status | Rationale |
|-----------|--------|-----------|
| I. Scientific Honesty | ✅ Pass | Milestone is architectural; future games require evidence citations. |
| II. Privacy by Default | ✅ Pass | Local SQLite only; zero network libraries planned or permitted. |
| III. Design | ✅ Pass | Clean architecture provides a professional foundation for later UX work. |
| IV. Open Source | ✅ Pass | Project is developed in the open from Day One. |
| V. Community | ✅ Pass | Clean architecture + repository pattern ensures modular game additions. |
| VI. Scope Discipline | ✅ Pass | Strictly limited to scaffold + 3 tables; no UI or game logic. |

## Project Structure

### Documentation (this feature)

```text
specs/001-scaffold-local-storage/
├── plan.md              # This file
├── research.md          # Phase 0 output
├── data-model.md        # Phase 1 output
├── quickstart.md        # Phase 1 output
├── contracts/           # Phase 1 output
└── tasks.md             # Phase 2 output (/speckit.tasks command)
```

### Source Code (repository root)

```text
lib/
├── models/             # Domain entities
├── repositories/       # Data access layer (Drift interfaces)
├── providers/          # DI and state management (Clean architecture)
├── database/           # Drift database definition
└── main.dart           # App entry point

test_driver/            # Integration test driver
integration_test/       # Persistence verification tests
```

**Structure Decision**: Single project structure with `lib/` subdirectories for models, repositories, and providers as requested by the user's specific "What to build" list.

## Complexity Tracking

> **Fill ONLY if Constitution Check has violations that must be justified**

*No violations identified.*
