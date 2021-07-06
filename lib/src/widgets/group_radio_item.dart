import 'package:flutter_tex/flutter_tex.dart';
import 'package:flutter_tex/src/models/widget_meta.dart';

class TeXViewGroupRadioItem extends TeXViewWidget {
  final String id;

  /// A [TeXViewWidget] as child.
  final TeXViewWidget child;

  final bool? rippleEffect;

  final bool initiallySelected;

  const TeXViewGroupRadioItem(
      {required this.id,
      required this.child,
      this.rippleEffect,
      this.initiallySelected = false});

  @override
  TeXViewWidgetMeta meta() {
    return TeXViewWidgetMeta(
        id: this.id,
        tag: 'div',
        classList: 'tex-view-group-radio-item' +
            (initiallySelected ? ' selected' : ''),
        node: Node.InternalChild);
  }

  @override
  Map toJson() => {
        'meta': meta().toJson(),
        'data': this.child.toJson(),
        'rippleEffect': this.rippleEffect ?? true,
      };
}
