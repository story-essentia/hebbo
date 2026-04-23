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
  final AudioPlayer _correctPlayer = AudioPlayer();
  final AudioPlayer _wrongPlayer = AudioPlayer();
  
  bool _isInitialized = false;

  Future<void> _ensureInitialized() async {
    if (_isInitialized) return;

    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.music());
    
    // Pre-load sounds for immediate playback
    try {
      await _correctPlayer.setAsset('assets/sounds/correct_tap.mp3');
      await _wrongPlayer.setAsset('assets/sounds/wrong_tap.mp3');
      await _correctPlayer.setVolume(0.4);
      await _wrongPlayer.setVolume(0.4);
    } catch (e) {
      print("Audio Preload Error: $e");
    }

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
        await _ambiencePlayer.setVolume(0.25); 
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
    unawaited(_ambiencePlayer.stop());
    unawaited(_sfxPlayer.stop());
    unawaited(_correctPlayer.stop());
    unawaited(_wrongPlayer.stop());
    
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
      await _sfxPlayer.setVolume(0.4);
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

  Future<void> playCorrectTap() async {
    await _ensureInitialized();
    try {
      if (_correctPlayer.playing) {
        await _correctPlayer.stop();
      }
      await _correctPlayer.seek(Duration.zero);
      unawaited(_correctPlayer.play());
    } catch (e) {
      print("Audio Error: $e");
    }
  }

  Future<void> playWrongTap() async {
    await _ensureInitialized();
    try {
      if (_wrongPlayer.playing) {
        await _wrongPlayer.stop();
      }
      await _wrongPlayer.seek(Duration.zero);
      unawaited(_wrongPlayer.play());
    } catch (e) {
      print("Audio Error: $e");
    }
  }

  void dispose() {
    _ambiencePlayer.dispose();
    _sfxPlayer.dispose();
    _correctPlayer.dispose();
    _wrongPlayer.dispose();
  }
}
