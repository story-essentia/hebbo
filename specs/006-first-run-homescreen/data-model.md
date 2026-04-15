# Data Model: First-Run Experience & Home Screen

## Shared Preferences
| Key | Type | Description |
|---|---|---|
| `has_seen_honesty_screen` | `bool` | Flag indicating whether the user has seen the onboarding radical honesty screen. If `true`, the app skips the honesty screen on boot. |
| `has_run_dev_cleanup` | `bool` | Flag indicating whether the development data cleanup has run. This ensures the one-time cleanup only runs once. |

## SQLite Data Deletions (Cleanup Migration)
Target tables for complete row wipe (one-time on boot before logic check):
- `trials`
- `sessions`
- `difficulty_states`
