import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../responsive/responsive.dart';
import '../../theme/app_dimens.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/theme_context.dart';

/// Labelled input in the card style. Owns its controller, so forms only pass
/// the initial value and listen to changes.
class AppTextField extends StatefulWidget {
  const AppTextField({
    super.key,
    required this.label,
    required this.onChanged,
    this.initialValue = '',
    this.hint,
    this.suffix,
    this.keyboardType,
    this.inputFormatters,
    this.maxLines = 1,
    this.autofocus = false,
  });

  final String label;
  final ValueChanged<String> onChanged;
  final String initialValue;
  final String? hint;

  /// Unit shown at the end ("kg", "/ 20").
  final String? suffix;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final int maxLines;
  final bool autofocus;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late final _controller = TextEditingController(text: widget.initialValue);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      padding: context.padSym(h: 14, v: 10),
      decoration: BoxDecoration(
        color: c.bgCard,
        borderRadius: BorderRadius.circular(context.dp(AppRadius.md)),
        border: Border.all(color: c.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.label, style: context.text.caption.tint(c.textSecondary)),
          TextField(
            controller: _controller,
            onChanged: widget.onChanged,
            autofocus: widget.autofocus,
            keyboardType: widget.keyboardType,
            inputFormatters: widget.inputFormatters,
            maxLines: widget.maxLines,
            style: context.text.bodyStrong,
            decoration: InputDecoration(
              isDense: true,
              border: InputBorder.none,
              hintText: widget.hint,
              hintStyle: context.text.bodyStrong.tint(c.textSecondary.withValues(alpha: 0.5)),
              contentPadding: EdgeInsets.only(top: context.dp(4)),
              suffixText: widget.suffix,
              suffixStyle: context.text.body.tint(c.textSecondary),
            ),
          ),
        ],
      ),
    );
  }
}

/// Decimal input ("14.5", "14,5"). Reports null while the text is not a number.
class NumberField extends StatelessWidget {
  const NumberField({
    super.key,
    required this.label,
    required this.onChanged,
    this.value,
    this.suffix,
    this.hint,
  });

  final String label;
  final ValueChanged<double?> onChanged;
  final double? value;
  final String? suffix;
  final String? hint;

  static String format(double? v) => v == null
      ? ''
      : v == v.roundToDouble()
      ? v.toStringAsFixed(0)
      : v.toString();

  @override
  Widget build(BuildContext context) => AppTextField(
    label: label,
    hint: hint,
    suffix: suffix,
    initialValue: format(value),
    keyboardType: const TextInputType.numberWithOptions(decimal: true),
    inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]'))],
    onChanged: (t) => onChanged(double.tryParse(t.trim().replaceAll(',', '.'))),
  );
}
