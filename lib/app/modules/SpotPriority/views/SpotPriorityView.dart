import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pluto_grid/pluto_grid.dart';
import '../../../../widgets/DateTime/DateWithThreeTextField.dart';
import '../../../../widgets/FormButton.dart';
import '../../../../widgets/dropdown.dart';
import '../../../../widgets/gridFromMap.dart';
import '../../../controller/HomeController.dart';
import '../controllers/SpotPriorityController.dart';

class SpotPriorityView extends GetView<SpotPriorityController> {
  SpotPriorityController controllerX = Get.put<SpotPriorityController>(SpotPriorityController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: double.maxFinite,
        width: double.maxFinite,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GetBuilder<SpotPriorityController>(
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
                            title: "From",
                            splitType: "-",
                            widthRation: 0.12,
                            isEnable: controllerX.isEnable.value,
                            onFocusChange: (data) {},
                            mainTextController: controllerX.frmDate,
                          ),
                        ),
                        Obx(
                          () => DateWithThreeTextField(
                            title: "To",
                            splitType: "-",
                            widthRation: 0.12,
                            isEnable: controllerX.isEnable.value,
                            onFocusChange: (data) {},
                            mainTextController: controllerX.toDate,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 14.0, left: 5, right: 10),
                          child: FormButtonWrapper(
                            btnText: "Show Details",
                            callback: () {
                              controllerX.getShowDetails();
                            },
                            showIcon: false,
                          ),
                        ),
                        SizedBox(
                          width: 25,
                        ),

                        /// channel
                        Obx(
                          () => DropDownField.formDropDown1WidthMap(
                            controllerX.priorityList.value,
                            (value) {
                              controllerX.selectPriority = value;
                            },
                            "Select Priority",
                            0.12,
                            // isEnable: controllerX.isEnable.value,
                            selected: controllerX.selectPriority,
                            autoFocus: true,
                            dialogWidth: 200,
                            dialogHeight: Get.height * .3,
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

            GetBuilder<SpotPriorityController>(
              id: "spotPriorityList",
              init: controllerX,
              builder: (controller) {
                return Expanded(
                  // width: Get.width,
                  // height: Get.height * .33,
                  child: (controllerX.spotPriorityModel != null &&
                          (controllerX.spotPriorityModel?.lstbookingdetail?.isNotEmpty)!)
                      ? DataGridFromMap(
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
                          hideKeys: ["color", "modifed", ""],
                          showSrNo: true,
                          onSelected: (event) {},
                          mode: controllerX.selectedPlutoGridMode,
                          widthRatio: (Get.width / 11.4),
                          mapData: (controllerX
                              .spotPriorityModel?.lstbookingdetail!
                              .map((e) => e.toJson())
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

  formHandler(btn) {}
}
