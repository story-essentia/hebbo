# Quickstart: Game detail bottom sheet

## Dependency Setup
1. Add `shimmer` to `pubspec.yaml`:
   ```yaml
   dependencies:
     shimmer: ^3.0.0
   ```
2. Run `flutter pub get`.

## Development Workflow
1. **Database Update**:
   - Update `HebboDatabase` with refined query for session-average personal best.
   - Run `build_runner` to regenerate drift code.
2. **UI Integration**:
   - Create `FlankerDetailSheet` widget in `lib/widgets/flanker_detail_sheet.dart`.
   - Update `HomeScreen` to call `showModalBottomSheet` when the Flanker card is tapped.
3. **Verification**:
   - Use `clearAllData()` in main entry or debug menu to test first-run experience.
   - Run a Flanker session to verify stat chips appear on the next tap.
