import 'package:flutter/material.dart';

class ParentIcon extends StatelessWidget {
  const ParentIcon({Key? key, required this.id, this.selected = false})
      : super(key: key);
  final int id;
  final bool selected;
  @override
  Widget build(BuildContext context) {
    switch (id) {
      case 1:
        return Icon(
          Icons.settings_applications_rounded,
          size: selected ? 35 : 25,
          color: selected ? Colors.white : Colors.white54,
        );

      case 2:
        return Icon(
          Icons.lock_clock_outlined,
          size: selected ? 35 : 25,
          color: selected ? Colors.white : Colors.white54,
        );

      default:
        return Icon(Icons.settings_applications_rounded);
    }
  }
}
