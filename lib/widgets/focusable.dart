import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FadButton extends StatefulWidget {
  const FadButton({
    Key? key,
    required this.child,
    this.onTapClick,
    this.onDoubleTapPress,
    this.onLongPress,
    this.onSecondaryPress,
  }) : super(key: key);

  final Function? onTapClick;
  final Function? onDoubleTapPress;
  final Function? onLongPress;
  final Function? onSecondaryPress;

  final Widget child;

  @override
  State<FadButton> createState() => _FadButtonState();
}

class _FadButtonState extends State<FadButton> {
  bool _focused = false;
  bool _hovering = false;
  bool _on = false;
  late final Map<Type, Action<Intent>> _actionMap;
  final Map<ShortcutActivator, Intent> _shortcutMap =
      const <ShortcutActivator, Intent>{
    SingleActivator(LogicalKeyboardKey.keyX): ActivateIntent(),
  };

  @override
  void initState() {
    super.initState();
    _actionMap = <Type, Action<Intent>>{
      ActivateIntent: CallbackAction<Intent>(
        onInvoke: (Intent intent) => _toggleState(),
      ),
    };
  }

  Color get color {
    Color baseColor = Colors.transparent;
    if (_focused) {
      baseColor = Color.alphaBlend(Colors.black.withOpacity(0.25), baseColor);
    }
    if (_hovering) {
      baseColor = Color.alphaBlend(Colors.black.withOpacity(0.1), baseColor);
    }
    return baseColor;
  }

  void _toggleState() {
    setState(() {
      _on = !_on;
    });
  }

  void _handleFocusHighlight(bool value) {
    setState(() {
      _focused = value;
    });
  }

  void _handleHoveHighlight(bool value) {
    setState(() {
      _hovering = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onTapClick!();
      },
      onDoubleTap: () {
        widget.onDoubleTapPress!();
      },
      onLongPress: () {
        widget.onLongPress!();
      },
      onSecondaryTap: () {
        widget.onSecondaryPress!();
      },
      child: FocusableActionDetector(
        actions: _actionMap,
        shortcuts: _shortcutMap,
        onShowFocusHighlight: _handleFocusHighlight,
        onShowHoverHighlight: _handleHoveHighlight,
        child: Container(
          padding: const EdgeInsets.all(1.0),
          color: color,
          child: widget.child,
        ),
      ),
    );
  }
}
