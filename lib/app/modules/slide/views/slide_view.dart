import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../widgets/DateTime/DateWithThreeTextField.dart';
import '../../../../widgets/FormButton.dart';
import '../../../../widgets/PlutoGrid/src/helper/pluto_move_direction.dart';
import '../../../../widgets/PlutoGrid/src/manager/pluto_grid_state_manager.dart';
import '../../../../widgets/PlutoGrid/src/pluto_grid.dart';
import '../../../../widgets/dropdown.dart';
import '../../../../widgets/gridFromMap.dart';
import '../../../controller/HomeController.dart';
import '../controllers/slide_controller.dart';

class SlideView extends GetView<SlideController> {
  const SlideView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
            child: SizedBox(
              width: double.maxFinite,
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                runSpacing: 5,
                spacing: 5,
                children: [
                  Obx(
                    () => DropDownField.formDropDown1WidthMap(
                      controller.locationList.value,
                      controller.getChannel,
                      "Location",
                      0.12,
                      selected: controller.selectedLocation,
                      autoFocus: true,
                      dialogWidth: 330,
                      dialogHeight: Get.height * .7,
                      inkWellFocusNode: controller.locationFN,
                    ),
                  ),
                  Obx(
                    () => DropDownField.formDropDown1WidthMap(
                      controller.channelList.value,
                      (value) => controller.selectedChannel = value,
                      "Channel",
                      0.12,
                      selected: controller.selectedChannel,
                      autoFocus: true,
                      dialogWidth: 330,
                      dialogHeight: Get.height * .7,
                    ),
                  ),
                  DateWithThreeTextField(
                    title: "Telecast Date",
                    widthRation: 0.12,
                    onFocusChange: (data) {
                      controller.onleaveTelecasteDate();
                    },
                    mainTextController: controller.telecastedateTC,
                  ),
                  DateWithThreeTextField(
                    title: "Import Date",
                    widthRation: 0.12,
                    mainTextController: controller.importDateTc,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 17.0),
                    child: FormButton(
                      btnText: "Import",
                      callback: () {},
                    ),
                  ),
                ],
              ),
            ),
          ),

          // data table will be here
          Expanded(
              child: Obx(
            () => Container(
              margin: EdgeInsets.all(10),
              decoration: controller.dataTableList.isEmpty
                  ? BoxDecoration(
                      border: Border.all(
                      color: Colors.grey,
                    ))
                  : null,
              child: controller.dataTableList.isEmpty
                  ? null
                  : DataGridFromMap3(
                      enableSort: true,
                      showSecondaryDialog: false,
                      mapData: controller.dataTableList.value
                          .map((e) => e.toJson())
                          .toList(),
                      checkBoxStrComparison: "true",
                      uncheckCheckBoxStr: "false",
                      hideCode: true,
                      onload: (event) {
                        controller.stateManager = event.stateManager;
                        event.stateManager
                            .setSelectingMode(PlutoGridSelectingMode.row);
                        event.stateManager.setSelecting(true);
                        event.stateManager.setCurrentCell(
                            event.stateManager
                                .getRowByIdx(controller.lastSelectedIdx)
                                ?.cells['stationIdCheck'],
                            controller.lastSelectedIdx);
                        event.stateManager.moveCurrentCellByRowIdx(
                            controller.lastSelectedIdx, PlutoMoveDirection.down,
                            notify: true);
                      },
                      onEdit: controller.onEdit,
                      actionOnPress: controller.actionOnPress,
                      colorCallback: (row) => (row.row.cells.containsValue(
                              controller.stateManager?.currentCell))
                          ? Colors.deepPurple.shade200
                          : Colors.white,
                      checkBoxColumnKey: const [
                        "stationIdCheck",
                        "presentsCheck",
                        "presentationCheck",
                        "commProgCheck",
                        "commMenuCheck",
                        "commUpTom",
                        "networkId",
                        "marrideId"
                      ],
                      actionIconKey: const [
                        "stationIdCheck",
                        "presentsCheck",
                        "presentationCheck",
                        "commProgCheck",
                        "commMenuCheck",
                        "commUpTom",
                        "networkId",
                        "marrideId"
                      ],
                      mode: PlutoGridMode.selectWithOneTap,
                    ),
            ),
          )),
          // Expanded(child: Container(),),
          GetBuilder<HomeController>(
              id: "transButtons",
              init: Get.find<HomeController>(),
              builder: (controllerX) {
                if (controllerX.buttons != null) {
                  return SizedBox(
                    height: 40,
                    child: ButtonBar(
                      alignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      // pa
                      children: [
                        for (var btn in controllerX.buttons!)
                          FormButtonWrapper(
                            btnText: btn["name"],
                            callback: () => controller.formHandler(btn['name']),
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
    );
  }
}
