import 'package:flutter/material.dart';
import 'package:hebbo/widgets/backgrounds/shallow_reef_background.dart';
import 'package:hebbo/widgets/backgrounds/open_ocean_background.dart';
import 'package:hebbo/widgets/backgrounds/deep_sea_background.dart';

/// Maps game levels to the appropriate environment background widget.
class EnvironmentFactory {
  static Widget getBackgroundForLevel(int level) {
    if (level <= 3) {
      return const ShallowReefBackground();
    } else if (level <= 7) {
      return const OpenOceanBackground();
    } else {
      return const DeepSeaBackground();
    }
  }
}
