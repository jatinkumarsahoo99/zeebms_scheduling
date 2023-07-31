import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bms_scheduling/widgets/PlutoGrid/pluto_grid.dart';
import '../../../../widgets/DateTime/DateWithThreeTextField.dart';
import '../../../../widgets/FormButton.dart';
import '../../../../widgets/Snack.dart';
import '../../../../widgets/dropdown.dart';
import '../../../../widgets/gridFromMap.dart';
import '../../../controller/HomeController.dart';
import '../../../controller/MainController.dart';
import '../../../data/PermissionModel.dart';
import '../../../providers/DataGridMenu.dart';
import '../../../providers/Utils.dart';
import '../../../routes/app_pages.dart';
import '../controllers/SpotPriorityController.dart';

class SpotPriorityView extends GetView<SpotPriorityController> {
  SpotPriorityController controllerX =
      Get.put<SpotPriorityController>(SpotPriorityController());

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
              // init: controllerX,
              builder: (controller) {
                print("Print called test");
                return Expanded(
                  // width: Get.width,
                  // height: Get.height * .33,
                  child: (controllerX.spotPriorityModel != null &&
                          (controllerX.spotPriorityModel?.lstbookingdetail
                              ?.isNotEmpty)!)
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
                          hideCode: false,
                          onContextMenuClick:
                              (DataGridMenuItem? valData, int rowIdx) {
                            switch (valData) {
                              case DataGridMenuItem.setPriority:
                                if (controllerX.selectPriority == null) {
                                  Snack.callError("Please select priority");
                                } else {
                                  controllerX.gridStateManager?.rows[rowIdx]
                                          .cells["priorityname"]?.value =
                                      controllerX.selectPriority?.value ?? "";
                                  controllerX.gridStateManager?.rows[rowIdx]
                                          .cells["priorityCode"]?.value =
                                      int.tryParse(
                                          controllerX.selectPriority?.key ??
                                              "0");
                                  controllerX
                                          .spotPriorityModel
                                          ?.lstbookingdetail![rowIdx]
                                          .priorityname =
                                      controllerX.selectPriority?.value ?? "";
                                  controllerX
                                      .spotPriorityModel
                                      ?.lstbookingdetail![rowIdx]
                                      .priorityCode = int.tryParse(controllerX
                                          .selectPriority?.key ??
                                      "0");
                                  controllerX.gridStateManager
                                      ?.notifyListeners();
                                }
                                break;
                              case DataGridMenuItem.clearPriority:
                                controllerX.gridStateManager?.rows[rowIdx]
                                    .cells["priorityname"]?.value = "";
                                controllerX.gridStateManager?.rows[rowIdx]
                                    .cells["priorityCode"]?.value = 0;
                                controllerX
                                    .spotPriorityModel
                                    ?.lstbookingdetail![rowIdx]
                                    .priorityname = null;
                                controllerX
                                    .spotPriorityModel
                                    ?.lstbookingdetail![rowIdx]
                                    .priorityCode = 0;
                                controllerX.gridStateManager?.notifyListeners();
                                break;
                            }
                          },
                          formatDate: false,
                          // hideKeys: ["color", "modifed", ""],
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
                   PermissionModel formPermissions = Get.find<MainController>()
                      .permissionList!
                      .lastWhere((element) {
                    return element.appFormName == Routes.SPOT_PRIORITY.replaceAll("/", "");
                  });
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
                              callback: Utils.btnAccessHandler2(btn['name'],
                                              controller, formPermissions) ==
                                          null
                                  ? null
                                  : () => formHandler(btn['name']),
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

  formHandler(btn) {
    switch (btn) {
      case "Save":
        controllerX.saveSpotPriority();
        break;
      case "Clear":
        Get.delete<SpotPriorityController>();
        Get.find<HomeController>().clearPage1();
        // controllerX.clear();
        break;
    }
  }
}
