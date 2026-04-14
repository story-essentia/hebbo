import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hebbo/logic/flanker_domain.dart';
import 'package:hebbo/providers/flanker_game_provider.dart';
import 'package:hebbo/screens/session_end_placeholder.dart';
import 'package:hebbo/widgets/fish_row_widget.dart';
import 'package:hebbo/providers/database_provider.dart';

class FlankerGameScreen extends ConsumerStatefulWidget {
  const FlankerGameScreen({super.key});

  @override
  ConsumerState<FlankerGameScreen> createState() => _FlankerGameScreenState();
}

class _FlankerGameScreenState extends ConsumerState<FlankerGameScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(flankerGameProvider.notifier).startSession(1));
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(flankerGameProvider);

    ref.listen(flankerGameProvider.select((s) => s.isSessionComplete), (previous, next) {
      if (next) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const SessionEndPlaceholder()),
        );
      }
    });

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Stimuli Layout
          Center(
            child: FishRowWidget(state: state),
          ),

          // Tap Zones — behavior depends on game state
          Positioned.fill(
            child: state.isWaitingForContinue
                // Timeout hold: any tap is a continue signal
                ? GestureDetector(
                    onTapDown: (_) => ref.read(flankerGameProvider.notifier).continueAfterTimeout(),
                    behavior: HitTestBehavior.opaque,
                    child: Container(color: Colors.transparent),
                  )
                // Normal trial: left/right tap zones
                : Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTapDown: (_) => ref.read(flankerGameProvider.notifier).reportResponse(Side.left),
                          behavior: HitTestBehavior.opaque,
                          child: Container(color: Colors.transparent),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTapDown: (_) => ref.read(flankerGameProvider.notifier).reportResponse(Side.right),
                          behavior: HitTestBehavior.opaque,
                          child: Container(color: Colors.transparent),
                        ),
                      ),
                    ],
                  ),
          ),

          // Trial Counter
          Positioned(
            top: 40,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                'Trials Remaining: ${state.trialsRemaining}',
                style: const TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ),
          
          // Debug Buttons
          Positioned(
            top: 40,
            right: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const SessionEndPlaceholder()),
                    );
                  },
                  child: const Text("Debug Progress"),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () async {
                    final db = ref.read(databaseProvider);
                    await db.clearAllData();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Database cleared")),
                    );
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red.withOpacity(0.8)),
                  child: const Text("Reset DB", style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
