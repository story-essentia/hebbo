import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hebbo/providers/spatial_span_progress_provider.dart';
import 'package:hebbo/providers/spatial_span_provider.dart';
import 'package:hebbo/screens/spatial_span_screen.dart';
import 'package:hebbo/theme/app_theme.dart';
import 'package:hebbo/widgets/backgrounds/cosmic_spacetime_background.dart';
import 'package:hebbo/widgets/backgrounds/progression_map_painter.dart';
import 'package:hebbo/widgets/spatial_span_tutorial_sheet.dart';

class ProgressionMapScreen extends ConsumerStatefulWidget {
  const ProgressionMapScreen({super.key});

  @override
  ConsumerState<ProgressionMapScreen> createState() => _ProgressionMapScreenState();
}

class _ProgressionMapScreenState extends ConsumerState<ProgressionMapScreen> {
  final TransformationController _transformationController =
      TransformationController();

  List<ConstellationNode> _generateNodes(
    int track1Max,
    int track2Max,
    int track3Max,
    Size screenSize,
  ) {
    final List<ConstellationNode> nodes = [];

    // Fit 8 nodes (3 to 10) vertically
    final availableHeight = screenSize.height - 250; // Leave space for header
    final spacingY = availableHeight / 7; // 8 nodes = 7 gaps
    final startY = screenSize.height - 100.0; // Bottom

    final colSpacing = 80.0;
    // We now have 3 columns. Center them.
    final startX = (screenSize.width - (colSpacing * 2)) / 2;

    // Track 1 (Main Trunk)
    for (int span = 3; span <= 10; span++) {
      // Default track1Max is 2 or 3. Node 3 should be unlocked if max >= 3
      final isUnlocked = span <= math.max(3, track1Max);

      final offsetX = startX;
      final offsetY = startY - ((span - 3) * spacingY);

      nodes.add(
        ConstellationNode(
          span: span,
          track: 1,
          isUnlocked: isUnlocked,
          position: Offset(offsetX, offsetY),
        ),
      );
    }

    // Track 2 (Second Column) - unlocks if Track 1 reached span 7
    final bool track2Visible = track1Max >= 7;

    for (int span = 3; span <= 10; span++) {
      // Node 3 is inherently unlocked when Track 2 becomes visible
      final isUnlocked = track2Visible && span <= math.max(3, track2Max);

      final offsetX = startX + colSpacing;
      final offsetY = startY - ((span - 3) * spacingY);

      nodes.add(
        ConstellationNode(
          span: span,
          track: 2,
          isUnlocked: isUnlocked,
          position: Offset(offsetX, offsetY),
        ),
      );
    }
    
    // Track 3 (Third Column) - unlocks if Track 2 reached span 7
    final bool track3Visible = track2Max >= 7;

    for (int span = 3; span <= 10; span++) {
      // Node 3 is inherently unlocked when Track 3 becomes visible
      final isUnlocked = track3Visible && span <= math.max(3, track3Max);

      final offsetX = startX + (colSpacing * 2);
      final offsetY = startY - ((span - 3) * spacingY);

      nodes.add(
        ConstellationNode(
          span: span,
          track: 3,
          isUnlocked: isUnlocked,
          position: Offset(offsetX, offsetY),
        ),
      );
    }

    return nodes;
  }

  void _handleNodeTap(ConstellationNode node) {
    if (!node.isUnlocked) return;

    ref
        .read(spatialSpanProvider.notifier)
        .startSession(trackId: node.track, startingSpan: node.span);

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SpatialSpanScreen()),
    );
  }

  @override
  void initState() {
    super.initState();
    // No longer need to center view since we fit to screen
    _transformationController.value = Matrix4.identity();
  }

  @override
  void dispose() {
    _transformationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final progressState = ref.watch(spatialSpanProgressProvider);

    if (progressState.isInitialLoading) {
      return const Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: CircularProgressIndicator(color: AppColors.neonBlue),
        ),
      );
    }

    final size = MediaQuery.of(context).size;
    final nodes = _generateNodes(
      progressState.track1MaxSpan,
      progressState.track2MaxSpan,
      progressState.track3MaxSpan,
      size,
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          const CosmicSpacetimeBackground(),
          InteractiveViewer(
            transformationController: _transformationController,
            constrained: true, // Fit to screen
            minScale: 1.0,
            maxScale: 2.0,
            child: GestureDetector(
              onTapUp: (details) {
                // Hit testing
                final tapPosition = details.localPosition;
                for (final node in nodes) {
                  final distance = (node.position - tapPosition).distance;
                  if (distance <= node.radius + 15) {
                    // 15px generous hit area
                    _handleNodeTap(node);
                    return;
                  }
                }
              },
              child: SizedBox.expand(
                child: CustomPaint(painter: ProgressionMapPainter(nodes: nodes)),
              ),
            ),
          ),

          // Header
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back,
                      color: AppColors.textPrimary,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      'Progression Map',
                      style: AppTextStyles.plusJakarta(
                        color: AppColors.textPrimary,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.help_outline,
                      color: AppColors.textPrimary,
                      size: 28,
                    ),
                    onPressed: () => SpatialSpanTutorialSheet.show(context),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
