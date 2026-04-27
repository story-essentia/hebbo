# Quickstart: Game Start Countdown

## How to Verify

1. Navigate to the **Flanker** or **Task Switching** game detail page.
2. Tap the **Play** button.
3. Observe a large, stylized countdown: **3... 2... 1...**
4. Verify that the first game item (fish or number) only appears *after* "1" disappears.
5. Exit mid-countdown and re-start to ensure no timer leaks or ghost trials.

## Key Files to Watch
- `lib/widgets/game_countdown_overlay.dart`: UI implementation.
- `lib/providers/flanker_game_provider.dart`: Logic implementation.
- `lib/providers/task_switch_provider.dart`: Logic implementation.
