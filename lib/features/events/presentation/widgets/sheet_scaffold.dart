import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/theme/app_tokens.dart';

/// Body of a C4/C6 bottom sheet: the 40×4 drag handle, then [children]
/// separated by 22 px, inside the prototype's `12 24 36` padding (the bottom
/// grows with the home indicator). The sheet shape and colour come from the
/// theme's `bottomSheetTheme` (radius 40, white).
class SheetScaffold extends StatelessWidget {
  const SheetScaffold({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(24, 12, 24, math.max(36, bottomInset + 16)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: ShapeDecoration(
                color: tokens.line,
                shape: const StadiumBorder(),
              ),
            ),
          ),
          for (final child in children) ...[const SizedBox(height: 22), child],
        ],
      ),
    );
  }
}
