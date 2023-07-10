import 'package:flutter/material.dart';

class RadioRow extends StatefulWidget {
  final List items;
  final String groupValue;
  final bool? isVertical;
  final Function? onchange;
  final List<String>? disabledRadios;
  const RadioRow({
    Key? key,
    required this.items,
    required this.groupValue,
    this.onchange,
    this.isVertical,
    this.disabledRadios,
  }) : super(key: key);

  @override
  State<RadioRow> createState() => _RadioRowState();
}

class _RadioRowState extends State<RadioRow> {
  @override
  Widget build(BuildContext context) {
    return (widget.isVertical ?? false)
        ? Column(
            children: buildRadio(),
          )
        : Row(
            children: buildRadio(),
          );
  }

  buildRadio() {
    return widget.items
        .map(
          (e) => Padding(
            padding: const EdgeInsets.only(left: 5),
            child: Row(
              children: [
                Radio<String>(
                    value: e,
                    groupValue: widget.groupValue,
                    onChanged: widget.disabledRadios?.contains(e) ?? false
                        ? null
                        : (value) {
                            widget.onchange!(value);
                          }),
                Text(
                  e,
                  style: TextStyle(
                    color: widget.disabledRadios?.contains(e) ?? false ? Colors.grey : Colors.black,
                  ),
                ),
              ],
            ),
          ),
        )
        .toList();
  }
}
