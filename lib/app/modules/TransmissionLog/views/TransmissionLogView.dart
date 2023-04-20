import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:pluto_grid/pluto_grid.dart';

import '../../../../widgets/DateTime/DateWithThreeTextField.dart';
import '../../../../widgets/FormButton.dart';
import '../../../../widgets/LoadingDialog.dart';
import '../../../../widgets/dropdown.dart';
import '../../../../widgets/gridFromMap.dart';
import '../../../../widgets/gridFromMap1.dart';
import '../../../../widgets/input_fields.dart';
import '../../../controller/HomeController.dart';
import '../../../controller/MainController.dart';
import '../../../data/DropDownValue.dart';
import '../../../data/PermissionModel.dart';
import '../../../providers/ApiFactory.dart';
import '../../../providers/SizeDefine.dart';
import '../../../providers/Utils.dart';
import '../controllers/TransmissionLogController.dart';

class TransmissionLogView extends GetView<TransmissionLogController> {
  TransmissionLogController controllerX = Get.put(TransmissionLogController());
  final GlobalKey rebuildKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: double.maxFinite,
        width: double.maxFinite,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GetBuilder<TransmissionLogController>(
              init: controllerX,
              id: "updateView",
              builder: (control) {
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                  child: SizedBox(
                    width: double.maxFinite,
                    child: Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      runSpacing: 5,
                      spacing: 5,
                      children: [
                        Obx(
                          () => DropDownField.formDropDown1WidthMap(
                            controllerX.locations.value,
                            (value) {
                              controllerX.selectLocation = value;
                              // controllerX.selectedLocationId.text = value.key!;
                              // controllerX.selectedLocationName.text = value.value!;
                              // controller.getChannelsBasedOnLocation(value.key!);
                            },
                            "Location",
                            0.12,
                            isEnable: controllerX.isEnable.value,
                            selected: controllerX.selectLocation,
                            autoFocus: true,
                            dialogWidth: 330,
                            dialogHeight: Get.height * .7,
                          ),
                        ),

                        /// channel
                        Obx(
                          () => DropDownField.formDropDown1WidthMap(
                            controllerX.channels.value,
                            (value) {
                              controllerX.selectChannel = value;
                              // controllerX.selectedLocationId.text = value.key!;
                              // controllerX.selectedLocationName.text = value.value!;
                              // controller.getChannelsBasedOnLocation(value.key!);
                            },
                            "Channel",
                            0.12,
                            isEnable: controllerX.isEnable.value,
                            selected: controllerX.selectChannel,
                            autoFocus: true,
                            dialogWidth: 330,
                            dialogHeight: Get.height * .7,
                          ),
                        ),
                        SizedBox(
                          width: Get.width * 0.077,
                          child: Row(
                            children: [
                              SizedBox(width: 5),
                              Obx(() => Padding(
                                    padding: const EdgeInsets.only(top: 15.0),
                                    child: Checkbox(
                                      value: controllerX.isStandby.value,
                                      onChanged: (val) {
                                        controllerX.isStandby.value = val!;
                                      },
                                      materialTapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                    ),
                                  )),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 15.0, left: 5),
                                child: Text(
                                  "Standby Log",
                                  style: TextStyle(
                                      fontSize: SizeDefine.labelSize1),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Obx(
                          () => DateWithThreeTextField(
                            title: "Schedule Date",
                            splitType: "-",
                            widthRation: 0.12,
                            isEnable: controllerX.isEnable.value,
                            onFocusChange: (data) {
                              // controllerX.selectedDate.text =
                              //     DateFormat('dd/MM/yyyy').format(
                              //         DateFormat("dd-MM-yyyy").parse(data));
                              // DateFormat("dd-MM-yyyy").parse(data);
                              print("Called when focus changed");
                              /*controller.getDailyFPCDetailsList(
                                controllerX.selectedLocationId.text,
                                controllerX.selectedChannelId.text,
                                controllerX.convertToAPIDateType(),
                              );*/

                              // controller.isTableDisplayed.value = true;
                            },
                            mainTextController: controllerX.selectedDate,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 14.0, left: 10, right: 10),
                          child: FormButtonWrapper(
                            btnText: "Retrieve",
                            callback: () {},
                            showIcon: false,
                          ),
                        ),
                        InputFields.formFieldNumberMask(
                            hintTxt: "Start Time",
                            controller: controllerX.startTime_,
                            widthRatio: 0.12,
                            isTime: true,
                            paddingLeft: 0),

                        /// duration
                        InputFields.formFieldNumberMask(
                            hintTxt: "Offset Time",
                            controller: controllerX.startTime_,
                            widthRatio: 0.12,
                            isTime: true,
                            paddingLeft: 0),
                        SizedBox(
                          width: Get.width * 0.1,
                          child: Row(
                            children: [
                              SizedBox(width: 5),
                              Obx(() => Padding(
                                    padding: const EdgeInsets.only(top: 15.0),
                                    child: Checkbox(
                                      value: controllerX.isStandby.value,
                                      onChanged: (val) {
                                        controllerX.isStandby.value = val!;
                                      },
                                      materialTapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                    ),
                                  )),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 15.0, left: 5),
                                child: Text(
                                  "Tx Comm.",
                                  style: TextStyle(
                                      fontSize: SizeDefine.labelSize1),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            // Divider(),

            GetBuilder<TransmissionLogController>(
              id: "transmissionList",
              init: controllerX,
              builder: (controller) {
                return Expanded(
                  // width: Get.width,
                  // height: Get.height * .33,
                  child: (controllerX.transmissionLogList != null &&
                          (controllerX.transmissionLogList?.isNotEmpty)!)
                      ? DataGridFromMap1(
                          onFocusChange: (value) {
                            controllerX.gridStateManager!
                                .setGridMode(PlutoGridMode.selectWithOneTap);
                            controllerX.selectedPlutoGridMode =
                                PlutoGridMode.selectWithOneTap;
                          },
                          onload: (loadevent) {
                            controllerX.gridStateManager =
                                loadevent.stateManager;
                            if (controller.selectedIndex != null) {
                              loadevent.stateManager.moveScrollByRow(
                                  PlutoMoveDirection.down,
                                  controller.selectedIndex);
                              loadevent.stateManager.setCurrentCell(
                                  loadevent
                                      .stateManager
                                      .rows[controller.selectedIndex!]
                                      .cells
                                      .entries
                                      .first
                                      .value,
                                  controller.selectedIndex);
                            }
                          },
                          hideKeys: ["color", "modifed", ""],
                          showSrNo: true,
                          colorCallback: (PlutoRowColorContext plutoContext) {
                            /* return (controllerX
                                              .dailyFpcListData![plutoContext.rowIdx].selectItem)!
                                              ? Colors.red
                                              : Colors.white;*/
                            return Color(controllerX
                                    .transmissionLogList![plutoContext.rowIdx]
                                    .colorNo ??
                                Colors.white.value);
                          },
                          onSelected: (event) {
                            /*  controllerX.segmentList?.value = [];
                          controller.update(["segmentList"]);

                          DailyFPCModel data = controllerX.dailyFpcListData![event.rowIdx!];
                          selectedLanguage.text = data.languageCode ?? "";
                          selectedProgramType.text = data.programTypeCode ?? "";
                          controller.selectedProgram = data;
                          selectProgram = DropDownValue(
                            key: controller.selectedProgram?.programCode ?? "",
                            value: controller.selectedProgram?.programName ?? "",
                          );
                          controllerX.selectedIndex = event.rowIdx;
                          controllerX.selectedColumn = event.cell!.column.field;
                          selectedTapeId.text = data.tapeid!;
                          selectedProgram.text = data.programName.toString();
                          selectedProgramId.text = data.programCode.toString();
                          controllerX.tapeId.text = data.tapeid.toString();
                          episodeNo.value = data.epsNo!;
                          print("Here is the episode duration>>>>" + data.episodeDuration.toString());
                          */ /* controller
                                                  .getSegmentDetailsList(
                                                      controllerX.selectedLocationId.text,
                                                      controllerX.selectedChannelId.text,
                                                      data.episodeDuration,
                                                      data.programName);*/ /*

                          controller.getSegmentDetailsList1(
                            data,
                            controllerX.selectedLocationId.text,
                            controllerX.selectedChannelId.text,
                          );

                          try {
                            controller.showSegments.value = false;
                            controller.showNewSegments.value = false;
                            controller.selectedFpc.value = data;
                            controller.showSegments.value = true;

                            selectedOriRep.text = data.oriRep!;
                            selectedOriRepId.text = data.originalRepeatCode ?? "";

                            timeinController.text = controller.selectedProgram!.fpcTime.toString();

                            controller.update(["segmentList", "selectedProgram"]);
                          } catch (e) {
                            print("DataGridFromMap1 OPERATION FPC PAGE ${e.toString()}");
                          }*/
                          },
                          mode: controllerX.selectedPlutoGridMode,
                          widthRatio: (Get.width / 11.4),
                          mapData: controllerX.transmissionLogList!
                              .map((e) => e.toJson1())
                              .toList())
                      : Container(
                          // height: Get.height * .33,
                          // width: Get.width,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey.shade400,
                              width: 1,
                            ),
                          ),
                        ),
                );
              },
            ),
            // Expanded(child: Container(),),
            GetBuilder<HomeController>(
                id: "transButtons",
                init: Get.find<HomeController>(),
                builder: (controller) {
                  /* PermissionModel formPermissions = Get.find<MainController>()
                      .permissionList!
                      .lastWhere((element) {
                    return element.appFormName == "frmSegmentsDetails";
                  });*/
                  if (controller.tranmissionButtons != null) {
                    return ButtonBar(
                      alignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        for (var btn in controller.tranmissionButtons!)
                          FormButtonWrapper(
                            btnText: btn["name"],
                            showIcon: false,
                            // isEnabled: btn['isDisabled'],
                            callback: /*btn["name"] != "Delete" &&
                                    Utils.btnAccessHandler2(btn['name'],
                                            controller, formPermissions) ==
                                        null
                                ? null
                                :*/
                                () => formHandler(btn['name']),
                          ),
                        IconButton(
                            onPressed: () {}, icon: Icon(Icons.arrow_upward)),
                        IconButton(
                            onPressed: () {}, icon: Icon(Icons.arrow_downward)),
                        FormButtonWrapper(
                          btnText: "Aa",
                          showIcon: false,
                          // isEnabled: btn['isDisabled'],
                          callback: /*btn["name"] != "Delete" &&
                                    Utils.btnAccessHandler2(btn['name'],
                                            controller, formPermissions) ==
                                        null
                                ? null
                                :*/
                              () => formHandler("Aa"),
                        ),
                        FormButtonWrapper(
                          btnText: "CL",
                          showIcon: false,
                          isEnabled: false,
                          callback: /*btn["name"] != "Delete" &&
                                    Utils.btnAccessHandler2(btn['name'],
                                            controller, formPermissions) ==
                                        null
                                ? null
                                :*/
                              () => formHandler("CL"),
                        ),
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
