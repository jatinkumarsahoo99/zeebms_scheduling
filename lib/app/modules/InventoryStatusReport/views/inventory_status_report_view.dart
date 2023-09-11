import 'package:bms_scheduling/widgets/CheckBoxWidget.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../../widgets/DateTime/DateWithThreeTextField.dart';
import '../../../../widgets/FormButton.dart';
import '../../../../widgets/PlutoGrid/src/manager/pluto_grid_state_manager.dart';
import '../../../../widgets/PlutoGrid/src/pluto_grid.dart';
import '../../../../widgets/dropdown.dart';
import '../../../../widgets/gridFromMap.dart';
import '../../../../widgets/radio_row.dart';
import '../../../controller/HomeController.dart';
import '../../../providers/Utils.dart';
import '../controllers/inventory_status_report_controller.dart';

class InventoryStatusReportView
    extends GetView<InventoryStatusReportController> {
  const InventoryStatusReportView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: context.width,
        height: context.height,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Expanded(
                child: Row(
                  children: [
                    ///
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Obx(() {
                            return DropDownField.formDropDown1WidthMap(
                              controller.onLoadModel.value?.info?.locations ??
                                  [],
                              (v) => controller.selectedLocation = v,
                              "Location",
                              .16,
                              autoFocus: true,
                              selected: controller.selectedLocation,
                              inkWellFocusNode: controller.locationFN,
                            );
                          }),
                          SizedBox(height: 10),
                          Obx(() {
                            return CheckBoxWidget1(
                              title: "Channel",
                              value: controller.channelAllSelected.value,
                              onChanged: controller.hanldeChangedOnAllChannel,
                            );
                          }),
                          SizedBox(height: 10),
                          // Obx(() {
                          //   return ExcludeFocus(
                          //     excluding: true,
                          //     child: Container(
                          //       height: context.height * .3,
                          //       decoration: BoxDecoration(
                          //         border: Border.all(
                          //           color: Colors.grey,
                          //         ),
                          //       ),
                          //       child: ListView.builder(
                          //         itemCount: (controller.onLoadModel.value?.info?.channels ?? []).length,
                          //         itemBuilder: (context, index) {
                          //           return CheckBoxWidget1(
                          //             title: controller.onLoadModel.value?.info?.channels?[index].downValue?.value ?? "",
                          //             value: controller.onLoadModel.value?.info?.channels?[index].isSelected ?? false,
                          //             onChanged: (val) {
                          //               controller.onLoadModel.value?.info?.channels?[index].isSelected = val;
                          //             },
                          //           );
                          //         },
                          //       ),
                          //     ),
                          //   );
                          // }),
                          Container(
                            height: MediaQuery.of(context).size.height * .3,
                            decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.deepPurpleAccent),
                              borderRadius: BorderRadius.circular(0),
                            ),
                            // margin: EdgeInsets.only(top: 8),
                            child: Obx(() {
                              return ListView.builder(
                                controller: ScrollController(),
                                itemCount: (controller.onLoadModel.value?.info
                                            ?.channels ??
                                        [])
                                    .length,
                                itemBuilder: (context, int index) {
                                  return Row(
                                    children: [
                                      StatefulBuilder(
                                          builder: (context, reCreate) {
                                        return Checkbox(
                                          value: controller
                                                  .onLoadModel
                                                  .value
                                                  ?.info
                                                  ?.channels?[index]
                                                  .isSelected ??
                                              false,
                                          onChanged: (bool? value) {
                                            controller
                                                .onLoadModel
                                                .value
                                                ?.info
                                                ?.channels?[index]
                                                .isSelected = value ?? false;
                                            reCreate(() {});
                                          },
                                        );
                                      }),
                                      Expanded(
                                        child: Text(
                                          controller
                                                  .onLoadModel
                                                  .value
                                                  ?.info
                                                  ?.channels?[index]
                                                  .downValue
                                                  ?.value ??
                                              "",
                                          style: TextStyle(fontSize: 12),
                                        ),
                                      )
                                    ],
                                  );
                                },
                              );
                            }),
                          ),
                          SizedBox(height: 10),
                          Obx(() {
                            return RadioRow(
                              items: [
                                'Old Format',
                                'Detail (KAM-NON CAM)',
                                'Summary (KAM-NON KAM)'
                              ],
                              groupValue: controller.selectedRadio.value,
                              isVertical: true,
                              onchange: (val) =>
                                  controller.selectedRadio.value = val,
                            );
                          }),
                          SizedBox(height: 10),
                          DateWithThreeTextField(
                            title: "From Date",
                            mainTextController: controller.fromDateTC,
                            widthRation: 0.17,
                          ),
                          const SizedBox(height: 10),
                          DateWithThreeTextField(
                            title: "To Date",
                            mainTextController: controller.toDateTC,
                            widthRation: 0.17,
                          ),
                          const Spacer(),
                          SizedBox(
                            width: context.width * 0.17,
                            child: FormButton(
                                btnText: "Generate",
                                callback: controller.generateData),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(
                                  child: FormButton(
                                      btnText: "Clear",
                                      callback: controller.clearPage)),
                              const SizedBox(width: 10),
                              const Expanded(
                                  child: FormButton(btnText: "Exit")),
                            ],
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      flex: 5,
                      child: Obx(
                        () {
                          return Container(
                            decoration: controller.dataTableList.isEmpty
                                ? BoxDecoration(
                                    border: Border.all(
                                      color: Colors.grey,
                                    ),
                                  )
                                : null,
                            child: controller.dataTableList.isEmpty
                                ? null
                                : DataGridFromMap(
                                    mapData: controller.dataTableList.value,
                                    mode: PlutoGridMode.selectWithOneTap,
                                    // colorCallback: (row) => (row.row.cells.containsValue(controller.stateManager?.currentCell))
                                    //     ? Colors.deepPurple.shade200
                                    //     : Colors.white,
                                    // onload: (event) {
                                    //   controller.stateManager = event.stateManager;
                                    //   event.stateManager.setSelectingMode(PlutoGridSelectingMode.row);
                                    //   event.stateManager.setSelecting(true);
                                    // },
                                    witdthSpecificColumn: {
                                      "programtype": 130,
                                      "programname": 200,
                                      "rmsProgram": 200,
                                    },
                                  ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),

              ///Common Buttons
              Align(
                alignment: Alignment.topLeft,
                child: GetBuilder<HomeController>(
                  id: "buttons",
                  init: Get.find<HomeController>(),
                  builder: (btncontroller) {
                    if (btncontroller.buttons != null) {
                      return Wrap(
                        spacing: 5,
                        runSpacing: 15,
                        alignment: WrapAlignment.center,
                        children: [
                          for (var btn in btncontroller.buttons!) ...{
                            FormButtonWrapper(
                              btnText: btn["name"],
                              callback: ((Utils.btnAccessHandler(btn['name'],
                                          controller.formPermissions!) ==
                                      null))
                                  ? null
                                  : () => controller.formHandler(btn['name']),
                            )
                          },
                        ],
                      );
                    }
                    return Container();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
