import 'package:flutter/material.dart';

/// Page frame shared by Sign in / Forgot / Check email / Reset: content at the
/// top, [actions] pinned to the thumb zone, everything scrollable once the
/// keyboard takes the space (prototype A2: `padding: 72px 20px 40px`).
class AuthPage extends StatelessWidget {
  const AuthPage({
    super.key,
    required this.children,
    required this.actions,
    this.leading,
  });

  /// Optional row above the intro (the circle back button).
  final Widget? leading;
  final List<Widget> children;

  /// Buttons at the bottom, 10 px apart.
  final List<Widget> actions;

  static const horizontalPadding = 20.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  horizontalPadding,
                  16,
                  horizontalPadding,
                  24,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (leading != null) ...[
                      Align(alignment: Alignment.centerLeft, child: leading),
                      const SizedBox(height: 32),
                    ] else
                      const SizedBox(height: 56),
                    ...children,
                    const SizedBox(height: 32),
                    const Spacer(),
                    for (var index = 0; index < actions.length; index++) ...[
                      if (index > 0) const SizedBox(height: 10),
                      actions[index],
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
