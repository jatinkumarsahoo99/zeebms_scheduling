import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../../widgets/DateTime/DateWithThreeTextField.dart';
import '../../../../widgets/FormButton.dart';
import '../controllers/EuropeCommercialImportStatusController.dart';

class EuropeCommercialImportStatusView
    extends GetView<EuropeCommercialImportStatusController> {
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
                          title: "Schedule Date",
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
                            // controllerX.calculateSegDur();
                            // controllerX.addTable();
                          },
                          showIcon: false,
                        ),
                      ), Padding(
                        padding: const EdgeInsets.only(left: 10, top: 15),
                        child: FormButton(
                          btnText: "Exit",
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
            GetBuilder<EuropeCommercialImportStatusController>(
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


          ],
        ),
      ),
    );
  }

  formHandler(btn) {}
}
