import 'dart:io';

import 'package:integration_test/integration_test_driver_extended.dart';

/// Host side of `flutter drive`: writes every `takeScreenshot()` from the
/// integration test to `build/screenshots/<name>.png`.
///
/// ```sh
/// fvm flutter drive --driver=test_driver/integration_test.dart \
///   --target=integration_test/foundation_smoke_test.dart \
///   --dart-define-from-file=env/dev.json -d <device>
/// ```
Future<void> main() => integrationDriver(
  onScreenshot: (name, bytes, [args]) async {
    final file = File('build/screenshots/$name.png')
      ..createSync(recursive: true);
    await file.writeAsBytes(bytes);
    return true;
  },
);
