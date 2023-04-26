import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pluto_grid/pluto_grid.dart';

import '../../../../widgets/DateWidget.dart';
import '../../../../widgets/FormButton.dart';
import '../../../../widgets/dropdown.dart';
import '../../../../widgets/gridFromMap.dart';
import '../../../controller/HomeController.dart';
import '../../../controller/MainController.dart';
import '../../../data/PermissionModel.dart';
import '../../../providers/Utils.dart';
import '../controllers/FpcMismatchController.dart';

class FpcMismatchView extends GetView<FpcMismatchController> {
  void formHandler(btnText) {
    switch (btnText) {
      case "Save":
        controllerX.saveFPCMistmatch();
        break;
      case "Clear":
        Get.delete<FpcMismatchController>();
        Get.find<HomeController>().clearPage1();
        // controllerX.clear();
        break;
      case "Exit":
        Get.delete<FpcMismatchController>();
        break;
      case "Refresh":
      // controllerX.fetchMismatchAll();
        break;
    }
  }

  FpcMismatchController controllerX = Get.put(FpcMismatchController());
  final GlobalKey rebuildKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: rebuildKey,
      // appBar: PreferredSize(
      //   preferredSize: const Size.fromHeight(50),
      //   child: FormAppBar(title: 'DailyFPC', isBackBtnVisible: false),
      // ),
      // appBar: FormAppBar.appBar("FPC Mismatch", () {
      //   Get.back();
      // }, context, false),
      body: SizedBox(
        height: double.maxFinite,
        width: double.maxFinite,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            GetBuilder<FpcMismatchController>(
              id: "initialData",
              builder: (control) {
                return Padding(
                  padding: const EdgeInsets.only(left: 18.0, top: 10),
                  child: Row(
                    children: [
                      DropDownField.formDropDownSelected(
                          controllerX.locationList ?? [], (value) {
                        controllerX.selectedLocation = value;
                        controllerX.fetchChannel();
                      }, "Location", null, widthRatio: controllerX.widthSize),
                      DropDownField.formDropDownSelected(
                          controllerX.channelList ?? [], (value) {
                        controllerX.selectedChannel = value;
                      }, "Channel", null,
                          searchReq: true,
                          widthRatio: controllerX.widthSize,
                          paddingLeft: 5),
                      DateWidget.dateStartDtEndDt3(context, "As On Date",
                              (data) {
                            log(">>>>" + data.toString());
                            // controllerX.inwardToDt = data;
                            controllerX.selectedDate = data;
                            controllerX.date_.text =
                                DateFormat("dd/MM/yyyy").format(data);
                          },
                          startDt: DateTime.now(),
                          //Note: Data Availble on 1 OCT 2012
                          // startDt: DateTime.now().subtract(Duration(days: 5000)),
                          endDt: DateTime.now().add(Duration(days: 1825)),
                          initialValue: controllerX.date_.text,
                          widthRatio: controllerX.widthSize),
                      const SizedBox(
                        width: 5,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 15.0),
                        child: Row(
                          children: [
                            FormButton(
                              btnText: "Display Mismatch",
                              callback: () {
                                controllerX.fetchMismatch();
                                controllerX.fetchProgram();
                              },
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            FormButton(
                              btnText: "Display Error",
                              callback: () {
                                controllerX.fetchMismatchError();
                                controllerX.fetchProgram();
                              },
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            FormButton(
                              btnText: "Display All",
                              callback: () {
                                controllerX.fetchMismatchAll();
                                controllerX.fetchProgram();
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            Divider(),
            Expanded(
              child: Row(
                children: [
                  /*Expanded(
                      flex: 8,
                      child: (controllerX.dataTable != null)
                          ? _dataTable2()
                          : Container()),*/
                  _dataTable1(context),
                  programTable(context)
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              child: Row(
                children: [
                  FormButton(
                    btnText: "  Make Error  ",
                    callback: () {
                      controllerX.saveMarkError();
                      // controllerX.fetchMismatch();
                      // controllerX.fetchProgram();
                    },
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  FormButton(
                    btnText: "  Undo Error  ",
                    callback: () {
                      controllerX.saveUndoMarkError();
                      // controllerX.fetchMismatchError();
                      // controllerX.fetchProgram();
                    },
                  ),
                ],
              ),
            ),
            GetBuilder<HomeController>(
                id: "buttons",
                init: Get.find<HomeController>(),
                builder: (controller) {
                  PermissionModel formPermissions = Get.find<MainController>()
                      .permissionList!
                      .lastWhere(
                          (element) => element.appFormName == "frmFPCMismatch");
                  if (controller.buttons != null) {
                    return ButtonBar(
                      alignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        for (var btn in controller.buttons!)
                          FormButtonWrapper(
                            btnText: btn["name"],
                            callback: Utils.btnAccessHandler2(btn['name'],
                                controller, formPermissions) ==
                                null
                                ? null
                                : () => formHandler(
                              btn['name'],
                            ),
                          )
                      ],
                    );
                  }
                  return Container();
                }),
          ],
        ),
      ),
    );
  }

  Widget _dataTable1(context) {
    return GetBuilder<FpcMismatchController>(
        id: "fpcMaster",
        // init: CreateBreakPatternController(),
        builder: (controller) {
          if (controllerX.dataList != null &&
              (controllerX.dataList?.isNotEmpty)!) {
            // final key = GlobalKey();
            return SizedBox(
              width: Get.width * 0.78,
              child: Expanded(
                // height: 400,
                // flex: 5,
                child: DataGridFromMap(
                  mapData:
                  (controllerX.dataList?.map((e) => e.toJson1()).toList())!,
                  widthRatio: 90,
                  colorCallback: (PlutoRowColorContext plutoContext) {
                    return (controllerX
                        .dataList![plutoContext.rowIdx].selectItem)!
                        ? Colors.red
                        : Colors.white;
                  },
                  mode: PlutoGridMode.select,
                  onSelected: (PlutoGridOnSelectedEvent plutoEvnt) {
                    controllerX.dataList![plutoEvnt.rowIdx!].selectItem =
                    ((controllerX.dataList![plutoEvnt.rowIdx!].selectItem)!)
                        ? false
                        : true;
                    controller.update(["fpcMaster"]);
                  },
                ),
              ),
            );
          } else {
            return SizedBox(
              width: Get.width * 0.75,
              child: Card(
                clipBehavior: Clip.hardEdge,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0), // if you need this
                  side: BorderSide(
                    color: Colors.grey.shade300,
                    width: 1,
                  ),
                ),
                child: Container(
                  height: Get.height - (4 * kToolbarHeight),
                ),
              ),
            );
          }
        });
  }

  Widget programTable(context) {
    return GetBuilder<FpcMismatchController>(
        id: "programTable",
        // init: CreateBreakPatternController(),
        builder: (controller) {
          if (controllerX.programList != null &&
              (controllerX.programList?.isNotEmpty)!) {
            // final key = GlobalKey();
            return Expanded(
              // height: 400,
              child: DataGridFromMap(
                mapData: (controllerX.programList
                    ?.map((e) => e.toJson1())
                    .toList())!,
                widthRatio: (Get.width * 0.2) / 2 + 7,
                mode: PlutoGridMode.select,
                onSelected: (plutoGrid) {
                  controllerX.selectedProgram =
                  controllerX.programList![plutoGrid.rowIdx!];
                  print(">>>>>>Program Data>>>>>>" +
                      jsonEncode(controllerX.selectedProgram?.toJson()));
                },
              ),
            );
          } else {
            return Expanded(
              child: Card(
                clipBehavior: Clip.hardEdge,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0), // if you need this
                  side: BorderSide(
                    color: Colors.grey.shade300,
                    width: 1,
                  ),
                ),
                child: Container(
                  height: Get.height - (4 * kToolbarHeight),
                ),
              ),
            );
          }
        });
  }


}
