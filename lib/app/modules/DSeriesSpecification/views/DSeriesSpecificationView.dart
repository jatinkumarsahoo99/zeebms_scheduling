import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';

import '../../../../widgets/FormButton.dart';
import '../../../../widgets/LoadingScreen.dart';
import '../../../../widgets/dropdown.dart';
import '../../../../widgets/input_fields.dart';
import '../../../controller/HomeController.dart';
import '../../../controller/MainController.dart';
import '../../../data/PermissionModel.dart';
import '../../../providers/SizeDefine.dart';
import '../../../providers/Utils.dart';
import '../controllers/DSeriesSpecificationController.dart';

class DSeriesSpecificationView extends GetView<DSeriesSpecificationController> {
  DSeriesSpecificationController controllerX =
      Get.put(DSeriesSpecificationController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: double.maxFinite,
        width: double.maxFinite,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GetBuilder<DSeriesSpecificationController>(
              init: controllerX,
              id: "updateView",
              builder: (control) {
                if (controllerX.locationList == null ) {
                  return SizedBox(
                      width: Get.width,
                      height: Get.height * 0.2,
                      child: LoadingScreen());
                }
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8,horizontal: 10),
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    runSpacing: 5,
                    spacing: 5,
                    children: [
                      Obx(() => DropDownField.formDropDown1WidthMap(
                            controllerX.locationList.value,
                            (data) {
                              controllerX.selectLocation=data;
                              controllerX.getChannel(data.key);
                            },
                            "Location",
                            controllerX.widthSize,
                            // isEnable: controllerX.isEnable.value,
                            searchReq: true,
                            // selected: controllerX.selectOrgValue,
                          )),

                      Obx(() => DropDownField.formDropDown1WidthMap(
                            controllerX.channelList.value,
                            (data) {
                              controllerX.selectChannel=data;
                              controllerX.getChannelLeave();
                            },
                            "Channel",
                            controllerX.widthSize,
                            // isEnable: controllerX.isEnable.value,
                            searchReq: true,
                            // selected: controllerX.selectOrgValue,
                          )),
                      Obx(() => DropDownField.formDropDown1WidthMap(
                            controllerX.channelList.value,
                            (data) {
                              // controllerX.orgRepeatId = data.key;
                              // controllerX.getEpisodeAndSegment();
                              // controllerX.txtEditingControl[0].text = "AUTO";
                              // controllerX.selectOrgValue.value = data;
                            },
                            "Event",
                            controllerX.widthSize,
                            // isEnable: controllerX.isEnable.value,
                            searchReq: true,
                            // selected: controllerX.selectOrgValue,
                          )),
                      FittedBox(
                        child: Row(
                          children: [
                            Obx(() => Padding(
                              padding: const EdgeInsets.only(top: 15.0),
                              child: Checkbox(
                                value: controller.chckLastSegment.value,
                                onChanged: (val) {
                                  controller.chckLastSegment.value =
                                  val!;
                                },
                                materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                              ),
                            )),
                            Padding(
                              padding:
                              const EdgeInsets.only(top: 15.0, left: 5),
                              child: Text(
                                "Last Segment",
                                style: TextStyle(
                                    fontSize: SizeDefine.labelSize1),
                              ),
                            ),
                          ],
                        ),
                      ),
                      InputFields.numbers(
                        hintTxt: "From",
                        inputformatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                        ],
                        controller: controllerX.from_,
                        onchanged: (v) {},
                        padLeft: 5,
                        isNegativeReq: false,
                        width: controllerX.widthSize,
                      ),

                      /// Part NO#
                      InputFields.numbers3(
                        hintTxt: "To",
                        controller: controllerX.desc_,
                        padLeft: 0,
                        inputformatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                        ],
                        onchanged: (v) {},
                        isNegativeReq: false,
                        width: controllerX.widthSize,
                        // fN: controllerX.partNoFocus,
                      ),
                     /// Part NO#
                      InputFields.formField1Width(
                        hintTxt: "Value",
                        paddingLeft: 0,
                        controller: controllerX.desc_,
                        widthRatio: controllerX.widthSize,
                        // fN: controllerX.partNoFocus,
                      ),
                      InputFields.formField1Width(
                        hintTxt: "Desc",
                        paddingLeft: 0,
                        controller: controllerX.desc_,
                        widthRatio: controllerX.widthSize,
                        // fN: controllerX.partNoFocus,
                      ),
                      /// Add Btn
                      Padding(
                        padding: const EdgeInsets.only(left: 10, top: 15),
                        child: FormButton(
                          btnText: "Add",
                          callback: () {
                            // controllerX.calculateSegDur();
                            // controllerX.addTable();
                          },
                          showIcon: false,
                        ),
                      ), Padding(
                        padding: const EdgeInsets.only(left: 10, top: 15),
                        child: FormButton(
                          btnText: "Remove",
                          callback: () {
                            // controllerX.calculateSegDur();
                            // controllerX.addTable();
                          },
                          showIcon: false,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            // Divider(),
            /* GetBuilder<SegmentController>(
                init: controllerX,
                id: "segmentDefaultLoad",
                builder: (controller) {
                  return Expanded(
                      child: */ /*(controller.actualDefaults != null &&
                              (controller.actualDefaults?.isNotEmpty)! &&
                              controller.tableSegment != null)
                          ? */ /*
                          _dataTable2() */ /*: Container()*/ /*);
                }),*/
            GetBuilder<DSeriesSpecificationController>(
                id: "listUpdate",
                init: controllerX,
                // init: CreateBreakPatternController(),
                builder: (controller) {
                  print("Called this Update >>>listUpdate");
                  // if (controller.actualDefaults != null &&
                  //     (controller.actualDefaults!.isNotEmpty)) {
                  //   print("Actual Defaults Not Empty");
                  //   // final key = GlobalKey();
                  //   return Expanded(
                  //     child: Padding(
                  //       padding: const EdgeInsets.symmetric(horizontal: 10),
                  //       child: DataGridFromMap(
                  //         onFocusChange: (f) {
                  //           if (f) {
                  //             controllerX.gridcanFocus =
                  //                 PlutoGridMode.selectWithOneTap;
                  //           }
                  //         },
                  //         mapData: (controller.actualDefaults
                  //             ?.map((e) => e.toJson1())
                  //             .toList())!,
                  //         widthRatio: (Get.width / 9) + 5,
                  //         actionOnPress: (index) {
                  //           print("Tapping $index");
                  //           // LoadingDialog.modify(
                  //           //   title,
                  //           //   confirm,
                  //           //   cancel,
                  //           // );
                  //           // Loadi
                  //           LoadingDialog.delete(
                  //               "Do you want to remove this row?", () {
                  //             // Get.find<TechnicalCheckController>().tcMasterModel1?.faultDetails?.removeAt(index);
                  //             // notifyListeners();
                  //             controller.actualDefaults?.removeAt(index);
                  //             controllerX.totalCalc();
                  //             controller.update(["listUpdate"]);
                  //           });
                  //
                  //           //     /*controller.stateManager!.updateRowData(controllerX.actualDefaults
                  //           // ?.map((e) => e.toJson1())
                  //           // .toList());*/
                  //
                  //           // controller.stateManager!.updateRowData(controllerX
                  //           //     .actualDefaults
                  //           //     ?.map((e) => e.toJson1())
                  //           //     .toList());
                  //         },
                  //         onRowDoubleTap: (event) {
                  //           var data = controller.actualDefaults![event.rowIdx];
                  //           controllerX.wholeCap.value =
                  //               data.segmentCaption ?? ""; //caption
                  //           controllerX.tcIn_.text = data.som!;
                  //           controllerX.segCtr.text = data.segNo!;
                  //           controllerX.segsNo.value = int.parse(data.segNo!);
                  //           controllerX.partNo.value =
                  //               int.parse(data.partnumber!);
                  //           controllerX.partCtr.text =
                  //               (data.partnumber ?? "").toString();
                  //           controllerX.tcOut_.text = data.eom!; //out
                  //           controllerX.durationVal.value =
                  //               data.segdur ?? ""; //duration
                  //         },
                  //         onSelected: (event) {
                  //           var data =
                  //               controller.actualDefaults![event.rowIdx ?? 0];
                  //           controllerX.segsNo.value = int.parse(data.segNo!);
                  //           controllerX.segCtr.text = data.segNo!;
                  //           controllerX.partNo.value =
                  //               int.parse(data.partnumber!);
                  //           controllerX.partCtr.text =
                  //               (data.partnumber ?? "").toString();
                  //           controllerX.wholeCap.value =
                  //               data.segmentCaption ?? ""; //caption
                  //           controllerX.tcIn_.text = data.som!; //in
                  //           controllerX.tcOut_.text = data.eom!; //out
                  //           controllerX.durationVal.value =
                  //               data.segdur ?? ""; //duration
                  //         },
                  //         showSrNo: true,
                  //         onload: (val) {
                  //           // print("onload Called ");
                  //           controller.stateManager = val.stateManager;
                  //           // print(controller.stateManager!.rows.length);
                  //           val.stateManager.setColumnSizeConfig(
                  //               PlutoGridColumnSizeConfig(
                  //                   autoSizeMode: PlutoAutoSizeMode.scale));
                  //         },
                  //         actionIcon: Icons.delete_forever_rounded,
                  //         actionIconKey: "Action",
                  //         // mode: controllerX.gridcanFocus,
                  //       ),
                  //     ),
                  //   );
                  // } else {
                    return Expanded(
                      child: Card(
                        clipBehavior: Clip.hardEdge,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(0), // if you need this
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
                  // }
                }),
            // Divider(),

            GetBuilder<HomeController>(
                id: "buttons",
                init: Get.find<HomeController>(),
                builder: (controller) {
                  PermissionModel formPermissions = Get.find<MainController>()
                      .permissionList!
                      .lastWhere((element) {
                    return element.appFormName == "frmDSeriesSpecs";
                  });
                  if (controller.buttons != null) {
                    return ButtonBar(
                      alignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        for (var btn in controller.buttons!)
                          FormButtonWrapper(
                            btnText: btn["name"],
                            // isEnabled: btn['isDisabled'],
                            callback: btn["name"] != "Delete" &&
                                    Utils.btnAccessHandler2(btn['name'],
                                            controller, formPermissions) ==
                                        null
                                ? null
                                : () => formHandler(btn['name']),
                          )
                      ],
                    );
                  } else {
                    return Container();
                  }
                }),
            const SizedBox(height: 5),
          ],
        ),
      ),
    );
  }

  formHandler(btn) {}
}
