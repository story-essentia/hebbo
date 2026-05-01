# Data Model: Premium Progression Map

The progression map relies on the existing `ConstellationNode` class. No new database tables or persistent state properties are required, but the UI data model used for rendering will be updated.

## UI Entities

### ConstellationNode (Updated)
*File: `lib/widgets/backgrounds/progression_map_painter.dart`*

```dart
class ConstellationNode {
  final int span;
  final int track;
  final bool isUnlocked;
  final Offset position;
  final double radius;

  // Existing fields are sufficient. 
  // isUnlocked controls whether the node uses the "premium locked" 
  // vs "premium unlocked" visual states.
}
```
