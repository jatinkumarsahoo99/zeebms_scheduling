import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:pluto_grid/pluto_grid.dart';

import '../../../../widgets/DateTime/DateWithThreeTextField.dart';
import '../../../../widgets/FormButton.dart';
import '../../../../widgets/dropdown.dart';
import '../../../../widgets/gridFromMap1.dart';
import '../../../../widgets/input_fields.dart';
import '../../../../widgets/radio_row.dart';
import '../../../controller/HomeController.dart';
import '../../../providers/SizeDefine.dart';
import '../controllers/LogAdditionsController.dart';

class LogAdditionsView extends GetView<LogAdditionsController> {
  LogAdditionsController controllerX =
      Get.put<LogAdditionsController>(LogAdditionsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: double.maxFinite,
        width: double.maxFinite,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GetBuilder<LogAdditionsController>(
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
                              controllerX.getChannels(
                                  controllerX.selectLocation?.key ?? "");
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
                        Obx(
                          () => RadioRow(
                            items: const ["Primary", "Secondary"],
                            groupValue: controllerX.verifyType.value ?? "",
                            onchange: (val) {
                              print("Response>>>" + val);
                              controllerX.verifyType.value = val;
                            },
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
                        SizedBox(
                          width: Get.width * 0.077,
                          child: Row(
                            children: [
                              SizedBox(width: 5),
                              Obx(() => Padding(
                                    padding: const EdgeInsets.only(top: 15.0),
                                    child: Checkbox(
                                      value: controllerX.isIgnoreSpot.value,
                                      onChanged: (val) {
                                        controllerX.isIgnoreSpot.value = val!;
                                      },
                                      materialTapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                    ),
                                  )),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 15.0, left: 5),
                                child: Text(
                                  "Ignore Sports in Log",
                                  style: TextStyle(
                                      fontSize: SizeDefine.labelSize1),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(),

                        InputFields.formFieldNumberMask(
                            hintTxt: "Remarks",
                            controller: controllerX.remarks,
                            widthRatio: 0.12,
                            isTime: true,
                            paddingLeft: 0),
                        /// channel
                        Obx(
                              () => DropDownField.formDropDown1WidthMap(
                            controllerX.additions.value,
                                (value) {
                              controllerX.selectAdditions = value;
                            },
                            "Additions",
                            0.12,
                            isEnable: controllerX.isEnable.value,
                            selected: controllerX.selectAdditions,
                            autoFocus: true,
                            dialogWidth: 330,
                            dialogHeight: Get.height * .7,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 14.0, left: 10, right: 10),
                          child: FormButtonWrapper(
                            btnText: "Show Details",
                            callback: () {},
                            showIcon: false,
                          ),
                        ),
                        /// duration

                      ],
                    ),
                  ),
                );
              },
            ),
            // Divider(),

            GetBuilder<LogAdditionsController>(
              id: "transmissionList",
              init: controllerX,
              builder: (controller) {
                return Expanded(
                  // width: Get.width,
                  // height: Get.height * .33,
                  child: (controllerX.logAdditionModel != null &&
                          (controllerX.logAdditionModel?.isNotEmpty)!)
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
                           /* if (controller.selectedIndex != null) {
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
                            }*/
                          },
                          hideKeys: ["color", "modifed", ""],
                          showSrNo: true,
                          colorCallback: (PlutoRowColorContext plutoContext) {
                            /* return (controllerX
                                              .dailyFpcListData![plutoContext.rowIdx].selectItem)!
                                              ? Colors.red
                                              : Colors.white;*/
                            return Color(controllerX
                                    .logAdditionModel![plutoContext.rowIdx]
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
                          mapData: controllerX.logAdditionModel!
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
                id: "buttons",
                init: Get.find<HomeController>(),
                builder: (controller) {
                  /* PermissionModel formPermissions = Get.find<MainController>()
                      .permissionList!
                      .lastWhere((element) {
                    return element.appFormName == "frmSegmentsDetails";
                  });*/
                  if (controller.tranmissionButtons != null) {
                    return SizedBox(
                      height: 40,
                      child: ButtonBar(
                        // buttonHeight: 20,
                        alignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        // pa
                        children: [
                          for (var btn in controller.buttons!)
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
                        ],
                      ),
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
