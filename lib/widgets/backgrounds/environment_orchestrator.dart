import 'package:flutter/material.dart';

/// Orchestrates the animation state for the dynamic environments.
/// Handles speed multipliers for the forward movement effect.
class EnvironmentOrchestrator extends ChangeNotifier {
  double _baseOffset = 0.0;
  double _multiplier = 1.0;
  bool _isResetting = false;
  
  double get multiplier => _multiplier;

  void setResetting(bool value) {
    _isResetting = value;
  }

  /// Updates the cumulative scroll offset based on time delta.
  void tick(double deltaTimeInSeconds) {
    // Dialed back to 8.0x for a significant but less distracting movement signal
    final double targetMultiplier = _isResetting ? 8.0 : 1.0;
    
    // Smoother acceleration (4.0 factor) to reduce visual snap/distraction
    if ((_multiplier - targetMultiplier).abs() > 0.01) {
      _multiplier += (targetMultiplier - _multiplier) * deltaTimeInSeconds * 4.0;
    } else {
      _multiplier = targetMultiplier;
    }

    // Moderate base speed (100 px/sec) for pleasant ambient movement
    _baseOffset += deltaTimeInSeconds * 100 * _multiplier;
    notifyListeners();
  }

  /// Returns the offset for a specific layer based on its speed factor.
  double getOffsetForSpeed(double layerSpeed) {
    return _baseOffset * layerSpeed;
  }
}
