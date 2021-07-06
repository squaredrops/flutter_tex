import 'dart:convert';

import 'package:flutter_tex/flutter_tex.dart';
import 'package:flutter_tex/src/models/widget_meta.dart';
import 'package:flutter_tex/src/utils/style_utils.dart';

class TeXViewGroupRadio extends TeXViewWidget {
  final String? id;

  final List<TeXViewGroupRadioItem> children;

  final Function(String id)? onTap;

  /// Style TeXView Widget with [TeXViewStyle].
  final TeXViewStyle? style;

  /// Style TeXView Widget with [TeXViewStyle].
  final TeXViewStyle? selectedItemStyle;

  /// Style TeXView Widget with [TeXViewStyle].
  final TeXViewStyle? normalItemStyle;

  const TeXViewGroupRadio(
      {this.id,
      required this.children,
      required this.onTap,
      this.style,
      this.selectedItemStyle,
      this.normalItemStyle});

  @override
  TeXViewWidgetMeta meta() {
    return TeXViewWidgetMeta(
        tag: 'div',
        classList: 'tex-view-group-radio',
        node: Node.InternalChildren);
  }

  @override
  void onTapManager(String id) {
    for (TeXViewGroupRadioItem child in this.children)
      if (child.id == id) this.onTap!(id);
  }

  @override
  Map toJson() => {
        'meta': meta().toJson(),
        'data': this.children.map((child) => child.toJson()).toList(),
        'style': this.style?.initStyle() ?? teXViewDefaultStyle,
        'selectedItemStyle':
            this.selectedItemStyle?.initStyle() ?? teXViewDefaultStyle,
        'normalItemStyle':
            this.normalItemStyle?.initStyle() ?? teXViewDefaultStyle,
      };
}
