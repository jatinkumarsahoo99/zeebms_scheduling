import 'package:bms_scheduling/widgets/gridFromMap.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../widgets/DateTime/DateWithThreeTextField.dart';
import '../../../../widgets/FormButton.dart';
import '../../../../widgets/PlutoGrid/src/helper/pluto_move_direction.dart';
import '../../../../widgets/PlutoGrid/src/manager/pluto_grid_state_manager.dart';
import '../../../../widgets/PlutoGrid/src/pluto_grid.dart';
import '../../../../widgets/dropdown.dart';
import '../../../controller/HomeController.dart';
import '../../../controller/MainController.dart';
import '../../../data/PermissionModel.dart';
import '../../../providers/Utils.dart';
import '../controllers/ros_distribution_controller.dart';

class RosDistributionView extends GetView<RosDistributionController> {
  const RosDistributionView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            child: SizedBox(
              width: Get.width,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: GetBuilder(
                    init: controller,
                    id: "headRowBtn",
                    builder: (_) {
                      return Wrap(
                        crossAxisAlignment: WrapCrossAlignment.end,
                        alignment: WrapAlignment.spaceBetween,
                        spacing: 10,
                        children: [
                          Obx(() {
                            return DropDownField.formDropDown1WidthMap(
                              controller.location.value,
                              controller.handleOnLocationChanged,
                              "Location",
                              0.12,
                              selected: controller.selectedLocation,
                              autoFocus: true,
                              inkWellFocusNode: controller.locationFN,
                              isEnable: controller.enableControllos.value,
                            );
                          }),
                          Obx(() {
                            return DropDownField.formDropDown1WidthMap(
                              controller.channel.value,
                              (val) => controller.selectedChannel = val,
                              "Channel",
                              0.12,
                              selected: controller.selectedChannel,
                              isEnable: controller.enableControllos.value,
                            );
                          }),
                          Obx(() {
                            return DateWithThreeTextField(
                              widthRation: 0.12,
                              title: "From Date",
                              mainTextController: controller.date,
                              isEnable: controller.enableControllos.value,
                            );
                          }),
                          for (int index = 0; index < controller.topButtons.length; index++) ...{
                            FormButtonWrapper(
                              btnText: controller.topButtons.value[index]['name'],
                              callback: controller.topButtons.value[index]['callback'],
                              isEnabled: controller.topButtons.value[index]['isEnabled'],
                            )
                          },
                        ],
                      );
                    }),
              ),
            ),
          ),
          Expanded(
            child: Obx(() {
              return Container(
                margin: const EdgeInsets.all(8),
                decoration: (controller.showDataModel.value.infoShowBucketList?.lstROSSpots?.isEmpty ?? true)
                    ? BoxDecoration(
                        border: Border.all(
                        color: Colors.grey,
                      ))
                    : null,
                child: (controller.showDataModel.value.infoShowBucketList?.lstROSSpots?.isEmpty ?? true)
                    ? null
                    : DataGridFromMap(
                        mapData: (controller.showDataModel.value.infoShowBucketList?.lstROSSpots ?? []).map((e) => e.toJson()).toList(),
                        formatDate: true,
                        witdthSpecificColumn: {
                          "zoneName": 150,
                          "scheduledate": 150,
                        },
                        onload: (event) {
                          controller.mainGSM = event.stateManager;
                          event.stateManager.setSelectingMode(PlutoGridSelectingMode.row);
                          event.stateManager.setSelecting(true);
                          event.stateManager
                              .setCurrentCell(event.stateManager.getRowByIdx(controller.mainGridIdx)!.cells['allocatedSpot'], controller.mainGridIdx);
                          event.stateManager.moveCurrentCellByRowIdx(controller.mainGridIdx, PlutoMoveDirection.down);
                        },
                        exportFileName: "ROS Distribution",
                        enableSort: true,
                        colorCallback: (row) =>
                            (row.row.cells.containsValue(controller.mainGSM?.currentCell)) ? Colors.deepPurple.shade200 : Colors.white,
                        hideKeys: ['rid'],
                        widthRatio: 220,
                        hideCode: false,

                        onSelected: (row) => controller.mainGridIdx = row.rowIdx ?? 0,
                        // mode: PlutoGridMode.selectWithOneTap,
                        onRowDoubleTap: (row) {
                          controller.mainGridIdx = row.rowIdx;
                          controller.handleAllocationTap();
                        },
                      ),
              );
            }),
          ),
          GetBuilder<HomeController>(
              id: "buttons",
              init: Get.find<HomeController>(),
              builder: (btncontroller) {
                PermissionModel formPermissions = Get.find<MainController>().permissionList!.lastWhere((element) {
                  return element.appFormName == "FrmRosDistribution";
                });

                return Card(
                  margin: const EdgeInsets.fromLTRB(4, 4, 4, 0),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                  ),
                  clipBehavior: Clip.hardEdge,
                  child: Container(
                    width: Get.width,
                    padding: EdgeInsets.all(Get.width * 0.005),
                    child: Obx(
                      () => Wrap(
                        alignment: WrapAlignment.start,
                        spacing: 10,
                        // pa
                        children: [
                          for (var btn in (btncontroller.buttons??[])) ...{
                            FormButtonWrapper(
                              btnText: btn["name"],
                              callback: ((Utils.btnAccessHandler(btn['name'], controller.formPermissions!) == null))
                                  ? null
                                  : () => controller.bottomFormHandler(btn['name']),
                            )
                          },
                          for (var checkBox in controller.checkBoxes)
                            InkWell(
                              onTap: () {
                                controller.checkBoxes[controller.checkBoxes.indexOf(checkBox)]["value"] =
                                    !(controller.checkBoxes[controller.checkBoxes.indexOf(checkBox)]["value"]! as bool);
                                if (controller.checkBoxes.indexOf(checkBox) == 0) {
                                  controller.handleOnChangedInOpenDeals();
                                } else if (controller.checkBoxes.indexOf(checkBox) == 1) {
                                  controller.handleOnChangedInROSSpots();
                                } else if (controller.checkBoxes.indexOf(checkBox) == 2) {
                                  controller.handleOnChangedInSpotBuys();
                                }
                                controller.checkBoxes.refresh();
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(checkBox["value"] as bool ? Icons.check_box_rounded : Icons.check_box_outline_blank),
                                  Text(checkBox["name"].toString())
                                ],
                              ),
                            )
                        ],
                      ),
                    ),
                  ),
                );
              }),
        ],
      ),
    );
  }
}
