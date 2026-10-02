import 'dart:async';

import 'package:google_fonts/google_fonts.dart';

/// Runs before every test file. Keeps `google_fonts` from trying to download
/// Inter inside the test sandbox (which would log errors and slow tests);
/// text falls back to the default test font.
Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  GoogleFonts.config.allowRuntimeFetching = false;
  await testMain();
}
