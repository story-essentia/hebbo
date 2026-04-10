# Quickstart: Fish Animation Integration

## Verification Steps
Follow these steps to verify the feature on the Pixel 6a:

1. **Environment Setup**:
   ```bash
   flutter pub add path_drawing
   ```

2. **Feature Toggle**:
   - Ensure the `main.dart` or `app_router` is set to launch the `FlankerGameScreen`.

3. **In-App Verification**:
   - **Correct Flow**: Tap the correct side. The center fish must glow green for 400ms.
   - **Wrong Flow**: Tap the wrong side. The center fish must glow red for 400ms.
   - **Timeout Flow**: Wait for 2s. All fish must turn semi-transparent for 300ms.
   - **Mirroring**: Verify that in "Right" target trials, the center fish faces right.

4. **Performance Check**:
   - Use the Flutter Performance Overlay or DevTools to confirm 60FPS consistently during animations.
