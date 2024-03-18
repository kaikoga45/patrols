import 'package:flutter_test/flutter_test.dart';
import 'package:patrol/patrol.dart';
import 'package:patrols/main.dart';

void main() {
  patrolTest(
    'Camera Preview should Display',
    (tester) async {
      await tester.pumpWidgetAndSettle(const MyApp());
      await tester.pump(const Duration(seconds: 10));
    },
    nativeAutomation: true,
    framePolicy: LiveTestWidgetsFlutterBindingFramePolicy.fullyLive,
    config: const PatrolTesterConfig(
      settlePolicy: SettlePolicy.trySettle,
    ),
  );
}
