import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../app/controller/ConnectorControl.dart';
import '../app/data/DropDownValue.dart';
import '../app/providers/SizeDefine.dart';
import 'LabelTextStyle.dart';
import 'LoadingDialog.dart';

class ProgramSearchDropDown extends StatefulWidget {
  ProgramSearchDropDown(
      {Key? key,
      required this.onslected,
      required this.api,
      this.widthRatio = 0.20,
      this.height,
      this.leftPad,
      this.controller,
      this.validator,
      this.topPad,
      this.hint = "Program",
      this.isEnable = true,
      this.autoFocus = false,
      this.parseKey = "programCode",
      this.parseValue = "programName"})
      : super(key: key);
  final String? Function(String?)? validator;
  final Function? onslected;
  final String? parseKey;
  final String? parseValue;
  final String? hint;
  final String api;

  final double widthRatio;
  final double? leftPad;

  final double? height;

  final double? topPad;
  final bool? isEnable;
  final bool autoFocus;

  TextEditingController? controller;

  @override
  State<ProgramSearchDropDown> createState() => _ProgramSearchDropDownState();
}

class _ProgramSearchDropDownState extends State<ProgramSearchDropDown> {
  // TextEditingController searchTextController = TextEditingController();

  @override
  void initState() {
    // print(">>API NAME>>"+widget.api);
    super.initState();
  }

  List<DropDownValue> items = [];
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(
              left: widget.leftPad ?? 10, top: widget.topPad ?? 0),
          child: LabelText.style(
            hint: widget.hint,
          ),
        ),
        Container(
          decoration: BoxDecoration(
              border: Border.all(
                  color: (widget.isEnable!)
                      ? Colors.deepPurpleAccent
                      : Colors.grey)),
          height: widget.height ?? SizeDefine.heightInputField,
          margin: EdgeInsets.only(
              left: widget.leftPad ?? 10, top: widget.topPad ?? 0),
          width: Get.width * widget.widthRatio,
          child: InkWell(
            autofocus: widget.autoFocus,
            onTap: () {
              // log("Api is::::"+widget.api);
              if (widget.hint != null &&
                  widget.hint == "Asset Name" &&
                  !widget.api.contains("Slot") &&
                  !widget.api.contains("=Program")) {
                // Snack.callError("Please select category");
                LoadingDialog.showErrorDialog("Please select category");
                return;
              }
              if (!(widget.isEnable)!) {
                return;
              }
              showDialog(
                  context: context,
                  useRootNavigator: true,
                  builder: (context) {
                    return StatefulBuilder(builder: (context, setState) {
                      getItmes(filter) async {
                        log("${widget.api}$filter");
                        Get.find<ConnectorControl>().GETMETHODCALL(
                            api: "${widget.api}$filter",
                            fun: (map) async {
                              log(map.toString());
                              setState(() {
                                items.clear();
                                for (var item in map) {
                                  items.add(DropDownValue(
                                      key: item[widget.parseKey].toString(),
                                      value: item[widget.parseValue]));
                                }
                                isLoading = false;
                              });
                            });
                      }

                      return Dialog(
                        elevation: 2,
                        child: Container(
                          width: MediaQuery.of(context).size.width / 3,
                          constraints: BoxConstraints(
                              maxHeight:
                                  MediaQuery.of(context).size.height / 2),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextField(
                                  style: TextStyle(
                                    fontSize: SizeDefine.fontSizeInputField,
                                  ),
                                  autofocus: true,
                                  onChanged: (value) {
                                    if (value.length > 2) {
                                      setState(() {
                                        isLoading = true;
                                      });
                                      getItmes(value.toLowerCase());
                                    } else {
                                      items.clear();
                                    }
                                  },
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'What do you want to search?'),
                                ),
                                Expanded(
                                    child: Scrollbar(
                                  child: ListView(
                                    shrinkWrap: true,
                                    children: [
                                      if (isLoading) LinearProgressIndicator(),
                                      for (var item in items)
                                        ListTile(
                                          onTap: () {
                                            widget.controller?.text =
                                                item.value!;
                                            widget.onslected!(item);
                                            Navigator.pop(context);
                                          },
                                          title: Text(
                                            item.value!,
                                            style: TextStyle(
                                              fontSize:
                                                  SizeDefine.fontSizeInputField,
                                            ),
                                          ),
                                        )
                                    ],
                                  ),
                                ))
                              ],
                            ),
                          ),
                        ),
                      );
                    });
                  });
            },
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: (Get.width * widget.widthRatio) - 30,
                  child: AbsorbPointer(
                    child: TextFormField(
                      enabled: false,
                      validator: widget.validator,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      style: TextStyle(
                        fontSize: SizeDefine.fontSizeInputField,
                        color: Colors.black,
                      ),
                      readOnly: true,
                      controller: widget.controller,
                      decoration: InputDecoration(
                        disabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent)),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent)),
                        errorBorder: InputBorder.none,
                        contentPadding: EdgeInsets.only(left: 10),

                        labelStyle: TextStyle(
                          fontSize: SizeDefine.labelSize,
                          color: Colors.black,
                        ),

                        border: InputBorder.none,

                        // suffixIcon: Icon(
                        //   Icons.calendar_today,
                        //   size: 14,
                        //   color: Colors.deepPurpleAccent,
                        // ),
                      ),
                    ),
                  ),
                ),
                Icon(
                  Icons.arrow_drop_down,
                  color: (widget.isEnable!)
                      ? Colors.deepPurpleAccent
                      : Colors.grey,
                  size: 24,
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
