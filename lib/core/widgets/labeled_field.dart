import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/app_tokens.dart';
import 'eyebrow.dart';

/// Eyebrow label stacked 8px above any form control. Field-level errors are
/// rendered by the control itself (via `InputDecoration.errorText`) so client
/// validation and server `fieldErrors` look identical.
class LabeledField extends StatelessWidget {
  const LabeledField({
    super.key,
    required this.label,
    required this.child,
    this.trailing,
  });

  final String label;
  final Widget child;

  /// Optional widget on the label row's right edge ("Forgot password?").
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (trailing == null)
          Eyebrow(label)
        else
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [Eyebrow(label), trailing!],
          ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }
}

/// `LabeledField` + `TextFormField` with the prototype's input chrome
/// (56 high, radius 20, hint only — no floating label) and an eye toggle
/// when [obscureText] is set.
class AppTextField extends StatefulWidget {
  const AppTextField({
    super.key,
    required this.label,
    this.controller,
    this.initialValue,
    this.hint,
    this.errorText,
    this.labelTrailing,
    this.obscureText = false,
    this.enabled = true,
    this.readOnly = false,
    this.autofocus = false,
    this.keyboardType,
    this.textInputAction,
    this.textCapitalization = TextCapitalization.none,
    this.autofillHints,
    this.inputFormatters,
    this.maxLines = 1,
    this.maxLength,
    this.focusNode,
    this.validator,
    this.onChanged,
    this.onFieldSubmitted,
    this.onTap,
    this.prefixIcon,
    this.suffixIcon,
  });

  final String label;
  final TextEditingController? controller;
  final String? initialValue;
  final String? hint;

  /// Server-side error for this field. Shown in place of the validator's
  /// message when both exist.
  final String? errorText;
  final Widget? labelTrailing;
  final bool obscureText;
  final bool enabled;
  final bool readOnly;
  final bool autofocus;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final TextCapitalization textCapitalization;
  final Iterable<String>? autofillHints;
  final List<TextInputFormatter>? inputFormatters;
  final int maxLines;
  final int? maxLength;
  final FocusNode? focusNode;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onFieldSubmitted;
  final VoidCallback? onTap;
  final Widget? prefixIcon;

  /// Ignored when [obscureText] is true — the eye toggle takes the slot.
  final Widget? suffixIcon;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late bool _obscure = widget.obscureText;

  @override
  Widget build(BuildContext context) {
    final suffix = widget.obscureText
        ? IconButton(
            onPressed: widget.enabled
                ? () => setState(() => _obscure = !_obscure)
                : null,
            tooltip: _obscure ? 'Show password' : 'Hide password',
            icon: Icon(
              _obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined,
              size: 20,
            ),
          )
        : widget.suffixIcon;

    return LabeledField(
      label: widget.label,
      trailing: widget.labelTrailing,
      child: TextFormField(
        controller: widget.controller,
        initialValue: widget.initialValue,
        enabled: widget.enabled,
        readOnly: widget.readOnly,
        autofocus: widget.autofocus,
        obscureText: _obscure,
        // Multi-line text areas keep the 20px radius but grow vertically.
        maxLines: widget.obscureText ? 1 : widget.maxLines,
        maxLength: widget.maxLength,
        keyboardType: widget.keyboardType,
        textInputAction: widget.textInputAction,
        textCapitalization: widget.textCapitalization,
        autofillHints: widget.autofillHints,
        inputFormatters: widget.inputFormatters,
        focusNode: widget.focusNode,
        validator: widget.validator,
        onChanged: widget.onChanged,
        onFieldSubmitted: widget.onFieldSubmitted,
        onTap: widget.onTap,
        style: Theme.of(context).textTheme.bodyLarge,
        decoration: InputDecoration(
          hintText: widget.hint,
          errorText: widget.errorText,
          prefixIcon: widget.prefixIcon,
          suffixIcon: suffix,
          counterText: '',
        ),
      ),
    );
  }
}

/// Read-only 56px row that opens a picker (date, gender, branch). Looks like
/// an input, shows [value] or the muted [placeholder], chevron on the right.
class AppPickerField extends StatelessWidget {
  const AppPickerField({
    super.key,
    required this.label,
    required this.onTap,
    this.value,
    this.placeholder,
    this.errorText,
    this.enabled = true,
    this.icon = Icons.expand_more,
  });

  final String label;
  final VoidCallback? onTap;
  final String? value;
  final String? placeholder;
  final String? errorText;
  final bool enabled;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final textTheme = Theme.of(context).textTheme;
    final hasValue = value != null && value!.isNotEmpty;
    final hasError = errorText != null;

    return LabeledField(
      label: label,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Semantics(
            button: true,
            enabled: enabled,
            label: label,
            value: hasValue ? value : placeholder,
            child: Material(
              color: tokens.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.input),
                side: BorderSide(
                  color: hasError ? tokens.error : tokens.line,
                  width: hasError ? 1.5 : 1,
                ),
              ),
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                onTap: enabled ? onTap : null,
                child: SizedBox(
                  height: AppSize.control,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20, right: 16),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            hasValue ? value! : (placeholder ?? ''),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: textTheme.bodyLarge?.copyWith(
                              color: hasValue ? tokens.ink : tokens.muted,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Icon(icon, size: 20, color: tokens.muted),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          if (hasError)
            Padding(
              // Matches InputDecoration's error offset so mixed forms align.
              padding: const EdgeInsets.only(top: 8, left: 20),
              child: Text(
                errorText!,
                style: textTheme.bodySmall?.copyWith(color: tokens.error),
              ),
            ),
        ],
      ),
    );
  }
}
