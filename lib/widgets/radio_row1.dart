import 'package:flutter/material.dart';

class RadioRow1 extends StatefulWidget {
  const RadioRow1({Key? key, required this.items, required this.groupValue, this.onchange, this.disabledRadios}) : super(key: key);
  final List items;
  final String groupValue;
  final Function? onchange;
  final List<String>? disabledRadios;

  @override
  State<RadioRow1> createState() => _RadioRow1State();
}

class _RadioRow1State extends State<RadioRow1> {
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
                  groupValue: widget.groupValue,
                  onChanged:(( widget.disabledRadios?.contains(e) ?? false) || (e == "Non-Dated"))
                      ? null
                      : (value) {
                    widget.onchange!(value);
                  }),
              Text(
                e,
                style: TextStyle(
                  color: ((widget.disabledRadios?.contains(e) ?? false)||   (e == "Non-Dated")) ? Colors.grey : Colors.black,
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
