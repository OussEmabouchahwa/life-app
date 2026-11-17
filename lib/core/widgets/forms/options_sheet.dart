import 'package:flutter/material.dart';

import '../../responsive/responsive.dart';
import '../../theme/app_icons.dart';
import '../../theme/theme_context.dart';
import '../app_tile.dart';
import '../status_marks.dart';

/// Bottom sheet to pick one value. Long lists get a search box.
Future<T?> showOptionsSheet<T>({
  required BuildContext context,
  required String title,
  required List<T> options,
  required String Function(T) labelOf,
  String? Function(T)? subtitleOf,
  T? selected,
}) => showModalBottomSheet<T>(
  context: context,
  isScrollControlled: true,
  showDragHandle: true,
  backgroundColor: context.colors.bgCard,
  constraints: BoxConstraints(maxHeight: context.hp(0.75)),
  builder: (_) => _OptionsSheet<T>(
    title: title,
    options: options,
    labelOf: labelOf,
    subtitleOf: subtitleOf,
    selected: selected,
  ),
);

class _OptionsSheet<T> extends StatefulWidget {
  const _OptionsSheet({
    required this.title,
    required this.options,
    required this.labelOf,
    required this.subtitleOf,
    required this.selected,
  });

  final String title;
  final List<T> options;
  final String Function(T) labelOf;
  final String? Function(T)? subtitleOf;
  final T? selected;

  @override
  State<_OptionsSheet<T>> createState() => _OptionsSheetState<T>();
}

class _OptionsSheetState<T> extends State<_OptionsSheet<T>> {
  static const _searchFrom = 8;
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final q = _query.toLowerCase();
    final shown = q.isEmpty
        ? widget.options
        : widget.options.where((o) => widget.labelOf(o).toLowerCase().contains(q)).toList();

    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: context.padSym(h: 22),
            child: Text(widget.title, style: context.text.title),
          ),
          if (widget.options.length >= _searchFrom)
            Padding(
              padding: context.padSym(h: 22, v: 8),
              child: TextField(
                autofocus: true,
                onChanged: (v) => setState(() => _query = v),
                style: context.text.body,
                decoration: InputDecoration(
                  isDense: true,
                  prefixIcon: Icon(AppIcons.search, color: c.textSecondary),
                  hintText: 'Search',
                  border: const OutlineInputBorder(),
                ),
              ),
            ),
          Flexible(
            child: ListView(
              shrinkWrap: true,
              children: [
                for (final o in shown)
                  AppTile(
                    title: widget.labelOf(o),
                    subtitle: widget.subtitleOf?.call(o),
                    onTap: () => Navigator.pop(context, o),
                    trailing: o == widget.selected ? const CheckCircle(checked: true) : null,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
