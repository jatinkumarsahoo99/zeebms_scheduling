import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:bms_scheduling/widgets/PlutoGrid/pluto_grid.dart';

import '../../../../widgets/DateTime/DateWithThreeTextField.dart';
import '../../../../widgets/FormButton.dart';
import '../../../../widgets/dropdown.dart';
import '../../../../widgets/gridFromMap.dart';
import '../../../../widgets/input_fields.dart';
import '../../../../widgets/radio_row.dart';
import '../../../controller/HomeController.dart';
import '../../../controller/MainController.dart';
import '../../../data/PermissionModel.dart';
import '../../../data/user_data_settings_model.dart';
import '../../../providers/Utils.dart';
import '../controllers/SalesAuditNotTelecastReportController.dart';

class SalesAuditNotTelecastReportView extends StatelessWidget {
  SalesAuditNotTelecastReportController controllerX =
      Get.put<SalesAuditNotTelecastReportController>(
          SalesAuditNotTelecastReportController());

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
        Get.find<HomeController>().postUserGridSetting2(listStateManager: [
          {"stateManager": controllerX.stateManager},
        ]);
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
        policy: OrderedTraversalPolicy(),
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
                                policy: OrderedTraversalPolicy(),
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
                                          inkWellFocusNode:
                                              controllerX.locationNode,
                                          autoFocus: true,
                                          dialogWidth: 330,
                                          dialogHeight: Get.height * .35,
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 8.0),
                                        child: Row(
                                          children: [
                                            Obx(() => Checkbox(
                                                  value:
                                                      controllerX.checked.value,
                                                  onChanged: (bool? value) {
                                                    controllerX.checked.value =
                                                        value!;
                                                    if (value!) {
                                                      for (var element
                                                          in controllerX
                                                              .channelList) {
                                                        element.ischecked =
                                                            true;
                                                      }
                                                      controllerX.update(
                                                          ['updateTable1']);
                                                    } else {
                                                      for (var element
                                                          in controllerX
                                                              .channelList) {
                                                        element.ischecked =
                                                            false;
                                                      }
                                                      controllerX.update(
                                                          ['updateTable1']);
                                                    }
                                                  },
                                                )),
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
                                                  controllerX.search(val);
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
                                                            .channelList
                                                            ?.length ??
                                                        0,
                                                    itemBuilder:
                                                        (context, int index) {
                                                      return Row(
                                                        children: [
                                                          Checkbox(
                                                            value: controllerX
                                                                .channelList[
                                                                    index]
                                                                .ischecked,
                                                            onChanged:
                                                                (bool? value) {
                                                              controllerX
                                                                  .channelList[
                                                                      index]
                                                                  .ischecked = value;
                                                              controllerX
                                                                  .update([
                                                                'updateTable1'
                                                              ]);
                                                            },
                                                          ),
                                                          Expanded(
                                                            child: Text(
                                                              controllerX
                                                                      .channelList[
                                                                          index]
                                                                      .channelName ??
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
                                                controllerX.selectValue.value ??
                                                    "",
                                            onchange: (String v) {
                                              controllerX.selectValue.value = v;
                                              controllerX.getType(v);
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
                                                controllerX.fetchGetGenerate();
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
              SizedBox(height: 8),
              GetBuilder<HomeController>(
                  id: "buttons",
                  init: Get.find<HomeController>(),
                  builder: (controller) {
                    PermissionModel formPermissions = Get.find<MainController>()
                        .permissionList!
                        .lastWhere((element) =>
                            element.appFormName == "frmsalesauditnottelecast");
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
                                  : () => controllerX.formHandler(
                                        btn['name'],
                                      ),
                            )
                        ],
                      );
                    }
                    return Container();
                  })
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
          if (controllerX.chk_radnottel) {
            if ((controllerX.salesAuditNotTRLstChannelModel?.generate?.lstnottel
                        ?.length ??
                    0) >
                0) {
              return Expanded(
                flex: 10,
                // height: 400,
                child: DataGridFromMap(
                  // showSrNo: false,
                  onload: (sm) {
                    controllerX.stateManager = sm.stateManager;
                  },

                  witdthSpecificColumn: (controller
                      .userDataSettings?.userSetting
                      ?.firstWhere(
                          (element) => element.controlName == "stateManager",
                          orElse: () => UserSetting())
                      .userSettings),
                  exportFileName: "Sales Audit NotTelecast Report",
                  formatDate: false,
                  mapData: (controllerX
                      .salesAuditNotTRLstChannelModel?.generate?.lstnottel
                      ?.map((e) => e.toJson())
                      .toList())!,
                  // mapData: (controllerX.dataList)!,
                  widthRatio: Get.width / 9 - 1,
                  hideCode: false,
                ),
              );
            } else {
              return Expanded(
                flex: 10,
                child: Container(
                  // height: Get.height - (2 * kToolbarHeight),
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.grey)),
                ),
              );
            }
          } else if (controllerX.chk_raderror) {
            if ((controllerX.salesAuditNotTRLstChannelModel?.generate?.lsterror
                        ?.length ??
                    0) >
                0) {
              return Expanded(
                flex: 10,
                // height: 400,
                child: DataGridFromMap(
                  // showSrNo: true,
                  onload: (sm) {
                    controllerX.stateManager = sm.stateManager;
                  },
                  witdthSpecificColumn: (controller
                      .userDataSettings?.userSetting
                      ?.firstWhere(
                          (element) => element.controlName == "stateManager",
                          orElse: () => UserSetting())
                      .userSettings),
                  exportFileName: "Sales Audit NotTelecast Report",
                  formatDate: false,
                  mapData: (controllerX
                      .salesAuditNotTRLstChannelModel?.generate?.lsterror
                      ?.map((e) => e.toJson())
                      .toList())!,
                  // mapData: (controllerX.dataList)!,
                  widthRatio: Get.width / 9 - 1,
                  hideCode: false,
                ),
              );
            } else {
              return Expanded(
                flex: 10,
                child: Container(
                  // height: Get.height - (2 * kToolbarHeight),
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.grey)),
                ),
              );
            }
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
