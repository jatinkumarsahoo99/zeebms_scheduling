import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../../widgets/DateTime/DateWithThreeTextField.dart';
import '../../../../widgets/FormButton.dart';
import '../../../../widgets/PlutoGrid/src/pluto_grid.dart';
import '../../../../widgets/gridFromMap.dart';
import '../../../controller/HomeController.dart';
import '../controllers/EuropeCommercialImportStatusController.dart';

class EuropeCommercialImportStatusView extends GetView<EuropeCommercialImportStatusController> {
  EuropeCommercialImportStatusController controllerX = Get.put(EuropeCommercialImportStatusController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: double.maxFinite,
        width: double.maxFinite,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GetBuilder<EuropeCommercialImportStatusController>(
              init: controllerX,
              id: "updateView",
              builder: (control) {

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8,horizontal: 10),
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    runSpacing: 5,
                    spacing: 5,
                    children: [
                     DateWithThreeTextField(
                          title: "Effective Date",
                          splitType: "-",
                          widthRation: 0.12,
                          // isEnable: controller.isEnable.value,
                          onFocusChange: (data) {
                            // controller.selectedDate.text =
                            //     DateFormat('dd/MM/yyyy').format(
                            //         DateFormat("dd-MM-yyyy").parse(data));
                            // DateFormat("dd-MM-yyyy").parse(data);
                            print("Called when focus changed");
                            /*controller.getDailyFPCDetailsList(
                                  controller.selectedLocationId.text,
                                  controller.selectedChannelId.text,
                                  controller.convertToAPIDateType(),
                                );*/

                            // controller.isTableDisplayed.value = true;
                          },
                          mainTextController: controller.selectedDate,
                        ),
                      /// Add Btn
                      Padding(
                        padding: const EdgeInsets.only(left: 10, top: 15),
                        child: FormButton(
                          btnText: "Generate",
                          callback: () {
                            controllerX.getGenerate();
                            // controllerX.addTable();
                          },
                          showIcon: true,

                        ),
                      ), Padding(
                        padding: const EdgeInsets.only(left: 10, top: 15),
                        child: FormButton(
                          btnText: "Exit",
                          callback: () {
                            if(controllerX.stateManager != null){
                              Get.find<HomeController>().postUserGridSetting(listStateManager: [controllerX.stateManager!]);
                            }
                            // controllerX.calculateSegDur();
                            // controllerX.addTable();
                          },
                          showIcon: true,
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
            GetBuilder<EuropeCommercialImportStatusController>(
                id: "listUpdate",
                init: controllerX,
                // init: CreateBreakPatternController(),
                builder: (controller) {
                  if (controller.listData != null &&
                      (controller.listData!.isNotEmpty)) {
                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: DataGridFromMap(
                          mapData: (controller.listData!),
                          widthRatio: (Get.width / 9) + 5,

                          onRowDoubleTap: (event) {

                          },
                          onSelected: (event) {

                          },
                          showSrNo: true,
                          witdthSpecificColumn: controllerX.userGridSetting1?[0]??{},
                          onload: (PlutoGridOnLoadedEvent grid) {
                            controllerX.stateManager = grid.stateManager;
                          },
                        ),
                      ),
                    );
                  } else {
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
                  }
                }),
            // Divider(),


          ],
        ),
      ),
    );
  }

  formHandler(btn) {}
}
