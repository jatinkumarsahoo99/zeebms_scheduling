import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import '../app/controller/ConnectorControl.dart';
import '../app/data/DropDownValue.dart';
import '../app/data/MovieMapMasterModel.dart';
import '../app/data/MovieSearchModel.dart';
import '../app/providers/SizeDefine.dart';
import 'LabelTextStyle.dart';

class OFPCProgramSearchDropDown extends StatefulWidget {
  OFPCProgramSearchDropDown(
      {Key? key,
      this.controller,
      required this.onslected,
      required this.api,
      this.controller1,
      this.widthRatio = 0.20,
      this.validator,
      this.type,
      this.height,
      this.autoFocus = false,
      this.leftPad,
      this.topPad,
      this.margin = true,
      this.title})
      : super(key: key);
  final String? Function(String?)? validator;
  final Function? onslected;
  final controller;
  final controller1;
  final String api;
  final double widthRatio;
  final String? type;
  final bool margin;
  final String? title;
  final double? leftPad;
  final bool autoFocus;
  final double? height;

  final double? topPad;
  // List<DropDownValue> list;

  @override
  State<OFPCProgramSearchDropDown> createState() =>
      _OFPCProgramSearchDropDownState();
}

class _OFPCProgramSearchDropDownState extends State<OFPCProgramSearchDropDown> {
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(
              left: widget.margin ? (widget.leftPad ?? 10) : 0,
              top: widget.margin ? (widget.topPad ?? 10) : 0),
          child: LabelText.style(hint: widget.title ?? "Program"),
        ),
        InkWell(
          autofocus: widget.autoFocus,
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
                            if (widget.type == 'movieScheduler') {
                              var response = MovieSearchModel.fromJson(map);
                              var movies = response.moviesearch;
                              setState(() {
                                items.clear();
                                for (var item in movies!) {
                                  items.add(DropDownValue(
                                      key: item.programDescriptionid.toString(),
                                      value: item.programDescription));
                                }
                              });
                            } else if (widget.type == 'movieMapSlot') {
                              var response =
                                  MovieMapBillingMaster.fromJson(map);
                              var slot = response.lstSlot;
                              setState(() {
                                items.clear();
                                for (var item in slot!) {
                                  items.add(DropDownValue(
                                      key: item.programCode.toString(),
                                      value: item.programName));
                                }
                              });
                            } else if (widget.type == 'movieMap') {
                              var response =
                                  MovieMapBillingMaster.fromJson(map);
                              var slot = response.lstProgram;
                              setState(() {
                                items.clear();
                                for (var item in slot!) {
                                  items.add(DropDownValue(
                                      key: item.programCode.toString(),
                                      value: item.programName));
                                }
                              });
                            } else if (widget.type == 'moviePlannerRights') {
                              setState(() {
                                items.clear();
                                for (var item in map) {
                                  items.add(DropDownValue(
                                      key: item["ProgramCode"].toString(),
                                      value: item["ProgramName"]));
                                }
                              });
                            } else {
                              setState(() {
                                items.clear();
                                for (var item in map) {
                                  items.add(DropDownValue(
                                      key: item[widget.type ==
                                                  'moviePlannerStarCast'
                                              ? "StarCastCode"
                                              : "programCode"]
                                          .toString(),
                                      value: item[
                                          widget.type == 'moviePlannerStarCast'
                                              ? "StarCast"
                                              : "programName"]));
                                }
                              });
                            }
                            isLoading = false;
                          });
                    }

                    return Dialog(
                      elevation: 2,
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
                                style: TextStyle(
                                  fontSize: SizeDefine.fontSizeInputField,
                                ),
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
                                          widget.controller1?.text = item.key!;
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
          child: AbsorbPointer(
            child: Container(
                height: widget.height ?? SizeDefine.heightInputField,
                margin: EdgeInsets.only(
                    left: widget.margin ? 10 : 0, top: widget.margin ? 10 : 0),
                width: Get.width * widget.widthRatio,
                child: TextFormField(
                  validator: widget.validator,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: SizeDefine.fontSizeInputField),
                  enableInteractiveSelection: true,
                  autofocus: false,
                  readOnly: true,
                  controller: widget.controller,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(left: 10),
                    // labelText: widget.hint,
                    suffixIcon: Padding(
                      padding: const EdgeInsets.only(left: 5),
                      child: Icon(
                        Icons.arrow_drop_down,
                        color: Colors.deepPurpleAccent,
                        size: 24,
                      ),
                    ),
                    labelStyle: TextStyle(
                        fontSize: SizeDefine.labelSize, color: Colors.black),

                    border: InputBorder.none,
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    // suffixIcon: Icon(
                    //   Icons.calendar_today,
                    //   size: 14,
                    //   color: Colors.deepPurpleAccent,
                    // ),

                    errorBorder: InputBorder.none,
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.deepPurpleAccent),
                      borderRadius: BorderRadius.circular(0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.deepPurpleAccent),
                      borderRadius: BorderRadius.circular(0),
                    ),
                  ),
                )),
          ),
        )
      ],
    );
  }
}
