import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:audio_session/audio_session.dart';

final gameAudioProvider = Provider<GameAudioNotifier>((ref) {
  final notifier = GameAudioNotifier();
  ref.onDispose(() => notifier.dispose());
  return notifier;
});

class GameAudioNotifier {
  final AudioPlayer _ambiencePlayer = AudioPlayer();
  final AudioPlayer _sfxPlayer = AudioPlayer();
  
  bool _isInitialized = false;

  Future<void> _ensureInitialized() async {
    if (_isInitialized) return;

    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.music());
    
    _isInitialized = true;
  }

  /// Claims exclusive audio focus and starts the background ambience.
  Future<void> startSessionAmbience() async {
    await _ensureInitialized();
    
    final session = await AudioSession.instance;
    if (await session.setActive(true)) {
      // Load and play ambience on loop
      try {
        await _ambiencePlayer.setAsset('assets/sounds/underwater-ambience.mp3');
        await _ambiencePlayer.setLoopMode(LoopMode.one);
        await _ambiencePlayer.setVolume(0.25); // Initial volume, will refine in Polish phase
        unawaited(_ambiencePlayer.play());
      } catch (e) {
        // Silent fallback as per spec
        print("Audio Error: $e");
      }
    }
  }

  Future<void> pauseAmbience() async {
    await _ambiencePlayer.pause();
  }

  Future<void> resumeAmbience() async {
    unawaited(_ambiencePlayer.play());
  }

  Future<void> stopSessionAudio() async {
    print("GameAudio: Stopping all session audio");
    // Fire and forget stop calls to ensure they are triggered even if context is being torn down
    unawaited(_ambiencePlayer.stop());
    unawaited(_sfxPlayer.stop());
    
    // Release audio session focus
    try {
      final session = await AudioSession.instance;
      await session.setActive(false);
    } catch (e) {
      print("GameAudio: Error releasing session: $e");
    }
  }

  Future<void> playLevelUp() async {
    await _ensureInitialized();
    try {
      await _sfxPlayer.setAsset('assets/sounds/level-up.mp3');
      await _sfxPlayer.setVolume(0.4); // Reduced to 40%
      unawaited(_sfxPlayer.play());
    } catch (e) {
      print("Audio Error: $e");
    }
  }

  Future<void> playSessionComplete() async {
    await _ensureInitialized();
    try {
      await _sfxPlayer.setAsset('assets/sounds/session-complete.mp3');
      await _sfxPlayer.setVolume(0.6);
      unawaited(_sfxPlayer.play());
    } catch (e) {
      print("Audio Error: $e");
    }
  }

  void dispose() {
    print("GameAudio: Disposing notifier");
    _ambiencePlayer.stop();
    _sfxPlayer.stop();
    _ambiencePlayer.dispose();
    _sfxPlayer.dispose();
  }
}
