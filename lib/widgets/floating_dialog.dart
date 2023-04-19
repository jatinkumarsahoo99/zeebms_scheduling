import 'package:flutter/material.dart';

class DraggableFab extends StatefulWidget {
  final Widget child;
  final Offset? initPosition;
  final double securityBottom;

  const DraggableFab({Key? key, required this.child, this.initPosition, this.securityBottom: 0}) : super(key: key);

  @override
  _DraggableFabState createState() => _DraggableFabState();
}

class _DraggableFabState extends State<DraggableFab> {
  late Size _widgetSize;
  double? _left, _top;
  double _screenWidth = 0.0, _screenHeight = 0.0;
  double? _screenWidthMid, _screenHeightMid;
  GlobalKey key = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _getWidgetSize(context));
  }

  void _getWidgetSize(BuildContext context) {
    _widgetSize = context.size!;

    if (widget.initPosition != null) {
      _calculatePosition(widget.initPosition!);
    } else {
      final RenderBox renderBox = key.currentContext?.findRenderObject() as RenderBox;
      final offset = renderBox.localToGlobal(Offset.zero) / 2;
      _calculatePosition(offset);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          left: _left,
          top: _top,
          child: Container(
            key: key,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              boxShadow: const [
                BoxShadow(color: Colors.black54),
              ],
              borderRadius: BorderRadius.circular(12),
              color: Colors.grey.shade300,
            ),
            child: Draggable(
              feedback: widget.child,
              onDragEnd: _handleDragEnded,
              childWhenDragging: widget.child,
              child: widget.child,
            ),
          ),
        )
      ],
    );
  }

  void _handleDragEnded(DraggableDetails draggableDetails) {
    _calculatePosition(draggableDetails.offset);
  }

  void _calculatePosition(Offset targetOffset) {
    if (_screenWidthMid == null || _screenHeightMid == null) {
      Size screenSize = MediaQuery.of(context).size;
      _screenWidth = screenSize.width;
      _screenHeight = screenSize.height;
      _screenWidthMid = _screenWidth / 2;
      _screenHeightMid = _screenHeight / 2;
    }
    _left = targetOffset.dx;
    _top = targetOffset.dy;

    setState(() {});
  }
}
