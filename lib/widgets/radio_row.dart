import 'package:flutter/material.dart';

class RadioRow extends StatefulWidget {
  const RadioRow(
      {Key? key, required this.items, required this.groupValue, this.onchange})
      : super(key: key);
  final List items;
  final String groupValue;
  final Function? onchange;

  @override
  State<RadioRow> createState() => _RadioRowState();
}

class _RadioRowState extends State<RadioRow> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: widget.items
          .map(
            (e) => Padding(
              padding: const EdgeInsets.only(left: 5),
              child: Row(
                children: [
                  Radio<String>(
                      value: e,
                      groupValue: "groupValue",
                      onChanged: (value) {
                        widget.onchange!(value);
                      }),
                  Text(e),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}
