import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:pluto_grid/pluto_grid.dart';

import '../../../../widgets/DateTime/DateWithThreeTextField.dart';
import '../../../../widgets/FormButton.dart';
import '../../../../widgets/dropdown.dart';
import '../../../../widgets/gridFromMap.dart';
import '../../../../widgets/input_fields.dart';
import '../../../../widgets/radio_row.dart';
import '../../../controller/HomeController.dart';
import '../controllers/SalesAuditNotTelecastReportController.dart';

class SalesAuditNotTelecastReportView
    extends GetView<SalesAuditNotTelecastReportController> {
  SalesAuditNotTelecastReportController controllerX =
      Get.put(SalesAuditNotTelecastReportController());
  final GlobalKey rebuildKey = GlobalKey();

  void formHandler(btnText) {
    switch (btnText) {
      case "Save":
        // controllerX.save();
        break;
      case "Clear":
        Get.delete<SalesAuditNotTelecastReportController>();
        Get.find<HomeController>().clearPage1();
        // controllerX.clear();
        break;
      case "Exit":
        Get.delete<SalesAuditNotTelecastReportController>();
        break;
      case "Refresh":
        controllerX.refresh();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: rebuildKey,
      body: FocusTraversalGroup(
        policy: ReadingOrderTraversalPolicy(),
        child: SizedBox(
          height: double.maxFinite,
          width: double.maxFinite,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GetBuilder<SalesAuditNotTelecastReportController>(
                        id: "initialData",
                        builder: (control) {
                          return Expanded(
                            flex: 3,
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 10.0, top: 0),
                              child: FocusTraversalGroup(
                                policy: WidgetOrderTraversalPolicy(),
                                child: SingleChildScrollView(
                                  // padding: EdgeInsets.only(top: 1),
                                  controller: ScrollController(),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Obx(
                                        () =>
                                            DropDownField.formDropDown1WidthMap(
                                          controllerX.locations.value,
                                          (value) {
                                            controllerX.selectLocation = value;
                                            /*controllerX.getChannels(
                                                controllerX.selectLocation?.key ?? "");*/
                                          },
                                          "Location",
                                          0.22,
                                          isEnable: controllerX.isEnable.value,
                                          selected: controllerX.selectLocation,
                                          autoFocus: true,
                                          dialogWidth: 330,
                                          dialogHeight: Get.height * .7,
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 8.0),
                                        child: Row(
                                          children: [
                                            Checkbox(
                                              value: ((controllerX.progNameList
                                                          ?.isNotEmpty)! &&
                                                      controllerX
                                                              .selectedProgramIndexes
                                                              ?.length ==
                                                          controllerX
                                                              .progNameList
                                                              ?.length)
                                                  ? true
                                                  : false,
                                              onChanged: (bool? value) {
                                                if (value!) {
                                                  controllerX.selectedProgramIndexes =
                                                      List.generate(
                                                          controllerX
                                                                  .progNameList
                                                                  ?.length ??
                                                              0,
                                                          (index) => 0 + index);
                                                } else {
                                                  controllerX
                                                      .selectedProgramIndexes
                                                      ?.clear();
                                                }

                                                controllerX
                                                    .update(["initialData"]);
                                              },
                                            ),
                                            Text(
                                              "Channel",
                                              style: TextStyle(fontSize: 12),
                                            ),
                                            Spacer(),
                                            InputFields.formField1Width(
                                                widthRatio: 0.12,
                                                paddingLeft: 5,
                                                hintTxt: "Search",
                                                controller: controllerX.search_,
                                                onChange: (val) {
                                                  controllerX.debouncer
                                                      .call(() {
                                                    // if (val != null && val != "")
                                                    controllerX
                                                        .fetchProgram(val);
                                                  });
                                                }),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      Container(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                .3,
                                        // margin: EdgeInsets.symmetric(vertical: 10),
                                        child: GetBuilder<
                                            SalesAuditNotTelecastReportController>(
                                          id: "updateTable1",
                                          builder: (control) {
                                            return Stack(
                                              children: [
                                                Container(
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: Colors
                                                            .deepPurpleAccent),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            0),
                                                  ),
                                                  margin:
                                                      EdgeInsets.only(top: 8),
                                                  child: ListView.builder(
                                                    controller:
                                                        ScrollController(),
                                                    itemCount: controllerX
                                                            .progNameList
                                                            ?.length ??
                                                        0,
                                                    itemBuilder:
                                                        (context, int index) {
                                                      return Row(
                                                        children: [
                                                          Checkbox(
                                                            value: controllerX
                                                                .selectedProgramIndexes
                                                                ?.contains(
                                                                    index),
                                                            onChanged:
                                                                (bool? value) {
                                                              if (controllerX
                                                                      .selectedProgramIndexes
                                                                      ?.contains(
                                                                          index) ??
                                                                  false) {
                                                                controllerX
                                                                    .selectedProgramIndexes
                                                                    ?.remove(
                                                                        index); // unselect
                                                              } else {
                                                                controllerX
                                                                    .selectedProgramIndexes
                                                                    ?.add(
                                                                        index); // select
                                                              }
                                                              controllerX
                                                                  .update([
                                                                "initialData"
                                                              ]);
                                                              /*controllerX.update(
                                                                  ["updateTable1"]);*/
                                                            },
                                                          ),
                                                          Expanded(
                                                            child: Text(
                                                              controllerX
                                                                      .progNameList![
                                                                          index]
                                                                      .value ??
                                                                  "",
                                                              style: TextStyle(
                                                                  fontSize: 12),
                                                            ),
                                                          )
                                                        ],
                                                      );
                                                    },
                                                  ),
                                                ),
                                              ],
                                            );
                                          },
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Obx(
                                        () => DateWithThreeTextField(
                                          title: "From",
                                          splitType: "-",
                                          widthRation: 0.22,
                                          isEnable: controllerX.isEnable.value,
                                          onFocusChange: (data) {},
                                          mainTextController:
                                              controllerX.frmDate,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Obx(
                                        () => DateWithThreeTextField(
                                          title: "To",
                                          splitType: "-",
                                          widthRation: 0.22,
                                          isEnable: controllerX.isEnable.value,
                                          onFocusChange: (data) {},
                                          mainTextController:
                                              controllerX.toDate,
                                        ),
                                      ),
                                      Obx(() => RadioRow(
                                            items: [
                                              "Not telecasted",
                                              "Error Sports"
                                            ],
                                            groupValue:
                                                controllerX.selectValue.value ?? "",
                                            onchange: (v) {
                                              controllerX.selectValue.value=v;
                                            },
                                          )),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: FormButton(
                                              btnText: "Generate",
                                              callback: () {
                                                controllerX.fetchGenerate();
                                              },
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      VerticalDivider(),
                      _dataTable1(context),
                    ],
                  ),
                ),
              ),
              /*GetBuilder<HomeController>(
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
                  }),*/
            ],
          ),
        ),
      ),
    );
  }

  Widget _dataTable1(context) {
    return GetBuilder<SalesAuditNotTelecastReportController>(
        id: "listUpdate",
        // init: CreateBreakPatternController(),
        builder: (controller) {
          if (controllerX.programTapeList != null &&
              (controllerX.programTapeList?.isNotEmpty)!) {
            // final key = GlobalKey();
            int count = 0;
            return Expanded(
              flex: 10,
              // height: 400,
              child: DataGridFromMap(
                showSrNo: false,
                mapData: (controllerX.programTapeList
                    ?.map((e) => e.toJson1())
                    .toList())!,
                // mapData: (controllerX.dataList)!,
                widthRatio: Get.width / 9 - 1,
              ),
            );
          } else {
            // return _dataTable2();
            return Expanded(
              flex: 10,
              child: Container(
                // height: Get.height - (2 * kToolbarHeight),
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.grey)),
              ),
            );
          }
        });
  }
}
