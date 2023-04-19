import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class FocusCheckBox extends StatelessWidget {
  FocusCheckBox({
    Key? key,
    required this.value,
    required this.onchanged,
    this.onFocusChange,
  }) : super(key: key);
  final bool value;
  final void Function()? onchanged;
  final void Function(bool)? onFocusChange;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onchanged,
      onFocusChange: (value) {
        if (value) {
          Scrollable.ensureVisible(context);
        }
      },
      child: Icon(
        value ? Icons.check_box_rounded : Icons.check_box_outline_blank_rounded,
        color: Colors.deepPurple,
      ),
    );
  }
}
