import 'package:flutter/material.dart';

import '../../../../core/theme/app_tokens.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/eyebrow.dart';
import '../../models/event_detail.dart';
import '../../models/event_position.dart';
import '../event_formats.dart';
import 'sheet_scaffold.dart';

/// C4 "Apply · choose position" bottom sheet. Resolves with the chosen
/// `position_id`, or `null` when dismissed.
///
/// Exactly one position is selectable at a time (D-09); positions that do
/// not match the user's roles are listed locked. When only one position
/// matches, the title becomes `Apply as {role}` and the list is dropped — a
/// plain confirm, as the prototype annotation asks.
class ApplySheet extends StatefulWidget {
  const ApplySheet({super.key, required this.detail});

  final EventDetail detail;

  static Future<int?> show(
    BuildContext context, {
    required EventDetail detail,
  }) => showModalBottomSheet<int>(
    context: context,
    isScrollControlled: true,
    builder: (_) => ApplySheet(detail: detail),
  );

  @override
  State<ApplySheet> createState() => _ApplySheetState();
}

class _ApplySheetState extends State<ApplySheet> {
  late final List<EventPosition> _matching = widget.detail.matchingPositions;
  late int? _selectedId = _matching.firstOrNull?.id;

  bool get _single => _matching.length == 1;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final text = Theme.of(context).textTheme;
    final detail = widget.detail;

    return SheetScaffold(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Eyebrow(
              EventFormats.dayStampWithTime(detail.date, detail.timeRange),
            ),
            const SizedBox(height: 8),
            Text(
              _single ? 'Apply as ${_matching.single.role.name}' : 'Apply as',
              style: text.headlineMedium,
            ),
          ],
        ),
        if (!_single)
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (final (index, position) in detail.positions.indexed) ...[
                if (index > 0) const SizedBox(height: 10),
                _PositionOption(
                  position: position,
                  selected: position.id == _selectedId,
                  onTap: position.matchesMyRole
                      ? () => setState(() => _selectedId = position.id)
                      : null,
                ),
              ],
            ],
          ),
        Text(
          'You can withdraw until '
          '${EventFormats.deadlineStamp(detail.applyDeadline)}.',
          style: tokens.caption,
        ),
        AppButton(
          label: 'Send application',
          onPressed: _selectedId == null ? null : _submit,
        ),
      ],
    );
  }

  void _submit() => Navigator.of(context).pop(_selectedId);
}

/// One selectable card (prototype C4 :776-783): 2 px ink border on blush
/// when selected, hairline otherwise; the padding shifts by 1 px so both
/// states are the same size. Locked (non-matching) rows are muted with a
/// lock where the radio would be.
class _PositionOption extends StatelessWidget {
  const _PositionOption({
    required this.position,
    required this.selected,
    required this.onTap,
  });

  final EventPosition position;
  final bool selected;

  /// `null` for a locked position.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final text = Theme.of(context).textTheme;
    final locked = onTap == null;
    final foreground = locked ? tokens.muted : tokens.ink;

    return Semantics(
      button: !locked,
      selected: selected,
      enabled: !locked,
      child: Material(
        color: selected ? tokens.accent : Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.note),
          side: BorderSide(
            color: selected ? tokens.ink : tokens.line,
            width: selected ? 2 : 1,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: selected
                ? const EdgeInsets.symmetric(horizontal: 20, vertical: 18)
                : const EdgeInsets.symmetric(horizontal: 21, vertical: 19),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        position.role.name,
                        style: text.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w500,
                          color: foreground,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        EventFormats.needed(position.needed).toUpperCase(),
                        style: tokens.eyebrow.copyWith(letterSpacing: 0),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 14),
                _buildTrailing(tokens, locked),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTrailing(AppTokens tokens, bool locked) {
    if (locked) {
      return Icon(Icons.lock_outline, size: 16, color: tokens.muted);
    }
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: selected ? tokens.ink : null,
        border: selected ? null : Border.all(color: tokens.line, width: 2),
      ),
      child: selected
          ? Icon(Icons.check, size: 14, color: tokens.surface)
          : null,
    );
  }
}
