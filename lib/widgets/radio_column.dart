import 'package:flutter/material.dart';

class RadioColumn extends StatefulWidget {
  const RadioColumn({Key? key, required this.items, required this.groupValue, this.onchange, this.disabledRadios}) : super(key: key);
  final List items;
  final String groupValue;
  final Function? onchange;
  final List<String>? disabledRadios;

  @override
  State<RadioColumn> createState() => _RadioColumnState();
}

class _RadioColumnState extends State<RadioColumn> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: widget.items
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
                      fontSize: 12
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}
