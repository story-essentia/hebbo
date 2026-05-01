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
  
  // Spatial Span specific players
  final AudioPlayer _ssCorrectPlayer = AudioPlayer();
  final AudioPlayer _ssWrongPlayer = AudioPlayer();
  final AudioPlayer _ssFlashPlayer = AudioPlayer();

  // Task Switching specific players
  final AudioPlayer _tsCorrectPlayer = AudioPlayer();
  final AudioPlayer _tsWrongPlayer = AudioPlayer();

  // Flanker specific players
  final AudioPlayer _flankerCorrectPlayer = AudioPlayer();
  final AudioPlayer _flankerWrongPlayer = AudioPlayer();
  
  bool _isInitialized = false;

  Future<void> _ensureInitialized() async {
    if (_isInitialized) return;

    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.music());
    
    // Pre-load sounds for immediate playback
    Future<void> load(AudioPlayer player, String path, double vol) async {
      try {
        await player.setAsset(path);
        await player.setVolume(vol);
      } catch (e) {
        print("Audio Preload Error for $path: $e");
      }
    }

    await load(_correctPlayer, 'assets/sounds/correct_tap.mp3', 0.4);
    await load(_wrongPlayer, 'assets/sounds/wrong_tap.mp3', 0.4);
    
    await load(_ssCorrectPlayer, 'assets/sounds/spatial_span_sounds/correct_tap.ogg', 0.5);
    await load(_ssWrongPlayer, 'assets/sounds/spatial_span_sounds/incorrect_tap.mp3', 0.5);
    await load(_ssFlashPlayer, 'assets/sounds/spatial_span_sounds/shard_activation.ogg', 0.5);

    await load(_tsCorrectPlayer, 'assets/sounds/task_switching_sounds/correct_tap.mp3', 0.4);
    await load(_tsWrongPlayer, 'assets/sounds/task_switching_sounds/incorrect_tap.mp3', 0.4);

    await load(_flankerCorrectPlayer, 'assets/sounds/flanker_sounds/correct_tap.mp3', 0.4);
    await load(_flankerWrongPlayer, 'assets/sounds/flanker_sounds/wrong_tap.mp3', 0.4);

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
    unawaited(_ssCorrectPlayer.stop());
    unawaited(_ssWrongPlayer.stop());
    unawaited(_ssFlashPlayer.stop());
    unawaited(_tsCorrectPlayer.stop());
    unawaited(_tsWrongPlayer.stop());
    unawaited(_flankerCorrectPlayer.stop());
    unawaited(_flankerWrongPlayer.stop());
    
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

  Future<void> playSpatialSpanCorrectTap() async {
    await _ensureInitialized();
    try {
      if (_ssCorrectPlayer.playing) {
        await _ssCorrectPlayer.stop();
      }
      await _ssCorrectPlayer.seek(Duration.zero);
      unawaited(_ssCorrectPlayer.play());
    } catch (e) {
      print("Audio Error: $e");
    }
  }

  Future<void> playSpatialSpanWrongTap() async {
    await _ensureInitialized();
    try {
      if (_ssWrongPlayer.playing) {
        await _ssWrongPlayer.stop();
      }
      await _ssWrongPlayer.seek(Duration.zero);
      unawaited(_ssWrongPlayer.play());
    } catch (e) {
      print("Audio Error: $e");
    }
  }

  Future<void> playSpatialSpanFlash() async {
    await _ensureInitialized();
    try {
      if (_ssFlashPlayer.playing) {
        await _ssFlashPlayer.stop();
      }
      await _ssFlashPlayer.seek(Duration.zero);
      unawaited(_ssFlashPlayer.play());
    } catch (e) {
      print("Audio Error: $e");
    }
  }

  Future<void> playTaskSwitchCorrectTap() async {
    await _ensureInitialized();
    try {
      if (_tsCorrectPlayer.playing) {
        await _tsCorrectPlayer.stop();
      }
      await _tsCorrectPlayer.seek(Duration.zero);
      unawaited(_tsCorrectPlayer.play());
    } catch (e) {
      print("Audio Error: $e");
    }
  }

  Future<void> playTaskSwitchWrongTap() async {
    await _ensureInitialized();
    try {
      if (_tsWrongPlayer.playing) {
        await _tsWrongPlayer.stop();
      }
      await _tsWrongPlayer.seek(Duration.zero);
      unawaited(_tsWrongPlayer.play());
    } catch (e) {
      print("Audio Error: $e");
    }
  }

  Future<void> playFlankerCorrectTap() async {
    await _ensureInitialized();
    try {
      if (_flankerCorrectPlayer.playing) {
        await _flankerCorrectPlayer.stop();
      }
      await _flankerCorrectPlayer.seek(Duration.zero);
      unawaited(_flankerCorrectPlayer.play());
    } catch (e) {
      print("Audio Error: $e");
    }
  }

  Future<void> playFlankerWrongTap() async {
    await _ensureInitialized();
    try {
      if (_flankerWrongPlayer.playing) {
        await _flankerWrongPlayer.stop();
      }
      await _flankerWrongPlayer.seek(Duration.zero);
      unawaited(_flankerWrongPlayer.play());
    } catch (e) {
      print("Audio Error: $e");
    }
  }

  void dispose() {
    _ambiencePlayer.dispose();
    _sfxPlayer.dispose();
    _correctPlayer.dispose();
    _wrongPlayer.dispose();
    _ssCorrectPlayer.dispose();
    _ssWrongPlayer.dispose();
    _ssFlashPlayer.dispose();
    _tsCorrectPlayer.dispose();
    _tsWrongPlayer.dispose();
    _flankerCorrectPlayer.dispose();
    _flankerWrongPlayer.dispose();
  }
}
