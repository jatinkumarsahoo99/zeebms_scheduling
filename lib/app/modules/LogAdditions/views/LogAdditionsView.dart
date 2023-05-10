import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:pluto_grid/pluto_grid.dart';

import '../../../../widgets/DateTime/DateWithThreeTextField.dart';
import '../../../../widgets/FormButton.dart';
import '../../../../widgets/dropdown.dart';
import '../../../../widgets/gridFromMap1.dart';
import '../../../../widgets/input_fields.dart';
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
                      runSpacing: 0.0,
                      direction: Axis.horizontal,
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
                              controllerX.getAdditionList();
                            },
                            mainTextController: controllerX.selectedDate,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 15.0),
                          child: Radio<String>(
                              value: "Primary",
                              groupValue: controllerX.verifyType.value,
                              onChanged: (value) {
                                controllerX.verifyType.value = value;
                                controllerX.update(["updateView"]);
                              }),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(top: 15.0),
                          child: Text("Primary"),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 15.0),
                          child: Radio<String>(
                              value: "Secondary",
                              groupValue: controllerX.verifyType.value,
                              onChanged: (value) {
                                controllerX.verifyType.value = value;
                                controllerX.update(["updateView"]);
                              }),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(top: 15.0),
                          child: Text("Secondary"),
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
                          width: Get.width * 0.1,
                          child: Row(
                            children: [
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

                        InputFields.formField1Width(
                            hintTxt: "Remarks",
                            controller: controllerX.remarks,
                            widthRatio: 0.245,
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
                            // isEnable: controllerX.isEnable.value,
                            selected: controllerX.selectAdditions,
                            autoFocus: true,
                            dialogWidth: 200,
                            dialogHeight: Get.height * .3,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 14.0, left: 5, right: 10),
                          child: FormButtonWrapper(
                            btnText: "Show Details",
                            callback: () {
                              controllerX.showDetails();
                            },
                            showIcon: false,
                          ),
                        ),
                        SizedBox(
                          width: 25,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 15.0),
                          child: const Text("Additional Count: "),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Obx(
                          () => Padding(
                            padding: const EdgeInsets.only(top: 15.0),
                            child: Text(controllerX.additionCount.value ?? "--"),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 15.0),
                          child: const Text("Cancellation Count: "),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Obx(
                          () => Padding(
                            padding: const EdgeInsets.only(top: 15.0),
                            child: Text(controllerX.cancelCount.value ?? "--"),
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
                          controllerX.logAdditionModel?.displayPreviousAdditon
                                  ?.previousAdditons !=
                              null &&
                          (controllerX.logAdditionModel?.displayPreviousAdditon
                              ?.previousAdditons?.isNotEmpty)!)
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
                          },
                          showSrNo: true,
                          hideCode: false,
                          mode: controllerX.selectedPlutoGridMode,
                          // widthRatio: (Get.width / 12.4),
                          mapData: (controllerX.logAdditionModel
                              ?.displayPreviousAdditon?.previousAdditons
                              ?.map((e) => e.toJson())
                              .toList())!)
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

  formHandler(String btn) {
    switch (btn.toLowerCase()) {
      case "save":
        controllerX.saveAddition();
        break;
      case "clear":
        // controllerX.saveAddition();
        break;
      // case "clear":
      //   break;
    }
  }
}
