import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';

import '../app/controller/ConnectorControl.dart';
import '../app/data/DropDownValue.dart';
import '../app/providers/SizeDefine.dart';

class ParentDropDown extends StatefulWidget {
  ParentDropDown({
    Key? key,
    required this.onslected,
    required this.api,
    this.widthRatio = 0.20,
    this.controller,
    this.validator,
  }) : super(key: key);
  final String? Function(String?)? validator;
  final Function? onslected;

  final String api;
  final double widthRatio;
  TextEditingController? controller;

  @override
  State<ParentDropDown> createState() => _ParentDropDownState();
}

class _ParentDropDownState extends State<ParentDropDown> {
  // TextEditingController searchTextController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  List<DropDownValue> items = [];
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 10),
      height: 40,
      width: Get.width * widget.widthRatio,
      child: TextFormField(
        validator: widget.validator,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        style: TextStyle(
            fontSize: SizeDefine.fontSizeInputField, color: Colors.black),
        enableInteractiveSelection: true,
        autofocus: false,
        readOnly: true,
        controller: widget.controller,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.only(left: 10),
          labelText: "Program",
          suffixIcon: Icon(Icons.arrow_drop_down),
          labelStyle:
              TextStyle(fontSize: SizeDefine.labelSize, color: Colors.black),

          border: InputBorder.none,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          // suffixIcon: Icon(
          //   Icons.calendar_today,
          //   size: 14,
          //   color: Colors.deepPurpleAccent,
          // ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.deepPurpleAccent),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.deepPurpleAccent),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onTap: () {
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
                                  key: item["programCode"].toString(),
                                  value: item["programName"]));
                            }
                            isLoading = false;
                          });
                        });
                  }

                  return Dialog(
                    child: Container(
                      width: MediaQuery.of(context).size.width / 3,
                      constraints: BoxConstraints(
                          maxHeight: MediaQuery.of(context).size.height / 2),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextField(
                              style: TextStyle(fontSize: 12),
                              autofocus: true,
                              controller: widget.controller ?? null,
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
                              isAlwaysShown: true,
                              child: ListView(
                                shrinkWrap: true,
                                children: [
                                  if (isLoading) LinearProgressIndicator(),
                                  for (var item in items)
                                    ListTile(
                                      onTap: () {
                                        widget.controller?.text = item.value!;
                                        widget.onslected!(item);
                                        Navigator.pop(context);
                                      },
                                      title: Text(item.value!),
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
      ),
    );
  }
}
