import 'package:flutter/material.dart';

import '../app/providers/SizeDefine.dart';

class RadioRow extends StatefulWidget {
  final List items;
  final String groupValue;
  final bool? isVertical;
  final Function? onchange;
  final List<String>? disabledRadios, unFocusRadios;
  const RadioRow({
    Key? key,
    required this.items,
    required this.groupValue,
    this.onchange,
    this.isVertical,
    this.disabledRadios,
    this.unFocusRadios,
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
    return List.generate(
        widget.items.length,
        (index) => Padding(
              padding: EdgeInsets.only(
                  left: (widget.isVertical ?? false)
                      ? 0
                      : (index == 0)
                          ? 0
                          : 5),
              child: ExcludeFocus(
                excluding:
                    widget.unFocusRadios?.contains(widget.items[index]) ??
                        false,
                child: Row(
                  children: [
                    Radio<String>(
                        value: widget.items[index],
                        groupValue: widget.groupValue,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        visualDensity:
                            const VisualDensity(horizontal: -4, vertical: -4),
                        onChanged: widget.disabledRadios
                                    ?.contains(widget.items[index]) ??
                                false
                            ? null
                            : (value) {
                                widget.onchange!(value);
                              }),
                    Text(
                      widget.items[index],
                      style: TextStyle(
                        color: widget.disabledRadios
                                    ?.contains(widget.items[index]) ??
                                false
                            ? Colors.grey
                            : Colors.black,
                        fontSize: SizeDefine.labelSize1,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            )).toList();
    // return widget.items
    //     .map(
    //       (e) {
    //         if(givePadding){
    //           givePadding = true;
    //         }
    //         return Padding(
    //         padding: EdgeInsets.only(left: givePadding? 0:5),
    //         child: Row(
    //           children: [
    //             Radio<String>(
    //                 value: e,
    //                 groupValue: widget.groupValue,
    //                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    //                  visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
    //                 onChanged: widget.disabledRadios?.contains(e) ?? false
    //                     ? null
    //                     : (value) {
    //                         widget.onchange!(value);
    //                       }),
    //             Text(
    //               e,
    //               style: TextStyle(
    //                 color: widget.disabledRadios?.contains(e) ?? false ? Colors.grey : Colors.black,
    //               ),
    //             ),
    //           ],
    //         ),
    //       );
    //       },
    //     )
    //     .toList();
  }
}
