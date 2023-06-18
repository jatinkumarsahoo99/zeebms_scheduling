import 'package:bms_scheduling/widgets/DataGridShowOnly.dart';
import 'package:bms_scheduling/widgets/DateTime/DateWithThreeTextField.dart';
import 'package:bms_scheduling/widgets/FormButton.dart';
import 'package:bms_scheduling/widgets/dropdown.dart';
import 'package:bms_scheduling/widgets/input_fields.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:bms_scheduling/widgets/PlutoGrid/pluto_grid.dart';

import '../../../controller/HomeController.dart';
import '../controllers/ro_cancellation_controller.dart';

class RoCancellationView extends StatelessWidget {
  RoCancellationView({Key? key}) : super(key: key);
  var controller = Get.put<RoCancellationController>(
    RoCancellationController(),
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            margin: EdgeInsets.all(8),
            // decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
            child: Container(
              width: Get.width,
              padding: const EdgeInsets.all(8.0),
              child: Wrap(
                alignment: WrapAlignment.start,
                spacing: Get.width * 0.01,
                runSpacing: 5,
                crossAxisAlignment: WrapCrossAlignment.end,
                children: [
                  Obx(
                    () => DropDownField.formDropDown1WidthMap(
                        controller.locations.value, (value) {
                      controller.selectedLocation = value;
                      controller.getChannel(value.key);
                    }, "Location", 0.24),
                  ),
                  Obx(
                    () => DropDownField.formDropDown1WidthMap(
                        controller.channels.value, (value) {
                      controller.selectedChannel = value;
                    }, "Channel", 0.24),
                  ),
                  SizedBox(
                      width: Get.width * 0.45,
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Obx(
                            () => DateWithThreeTextField(
                                widthRation: 0.20,
                                isEnable: controller.enableCancelDate.value,
                                title: "Cancel Date",
                                mainTextController: controller.cancelDatectrl),
                          ),
                          Obx(
                            () => DateWithThreeTextField(
                                widthRation: 0.20,
                                isEnable: controller.enableEffDate.value,
                                title: "Eff. Date",
                                onFocusChange: (value) {
                                  controller.cancelMonthctrl.text =
                                      value.split("-")[2] + value.split("-")[1];
                                  controller.enableCancelMonth.value = false;
                                },
                                mainTextController: controller.effDatectrl),
                          )
                        ],
                      )),
                  InputFields.formField1(
                      hintTxt: "Reference",
                      width: 0.24,
                      controller: controller.refNumberctrl),
                  InputFields.formField1(
                      hintTxt: "Booking No",
                      width: 0.24,
                      focusNode: controller.bookingNumberFocus,
                      controller: controller.bookingNumberctrl),
                  SizedBox(
                      width: Get.width * 0.45,
                      child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Obx(
                              () => InputFields.formField1(
                                  isEnable: controller.enableCancelMonth.value,
                                  width: 0.18,
                                  hintTxt: "Cancel No",
                                  controller: controller.cancelMonthctrl),
                            ),
                            Obx(
                              () => InputFields.formField1(
                                  isEnable: controller.enableCancelNumber.value,
                                  width: 0.27,
                                  focusNode: controller.cancelNumberFocus,
                                  hintTxt: "",
                                  controller: controller.cancelNumberctrl),
                            )
                          ])),
                  Obx(
                    () => InputFields.formField1(
                        width: 0.24,
                        isEnable: controller.enableBrandClientAgent.value,
                        hintTxt: "Client",
                        controller: controller.clientctrl),
                  ),
                  Obx(
                    () => InputFields.formField1(
                        width: 0.24,
                        isEnable: controller.enableBrandClientAgent.value,
                        hintTxt: "Agency",
                        controller: controller.agencyctrl),
                  ),
                  Obx(
                    () => InputFields.formField1(
                        width: 0.24,
                        isEnable: controller.enableBrandClientAgent.value,
                        hintTxt: "Brand",
                        controller: controller.brandctrl),
                  ),
                  Obx(() => InkWell(
                        onTap: () {
                          controller.selectAll.value =
                              !controller.selectAll.value;
                          controller.roCancellationGridManager!
                              .toggleAllRowChecked(controller.selectAll.value);
                        },
                        focusNode: controller.selectAllFocus,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(controller.selectAll.value
                                ? Icons.check_box_outlined
                                : Icons.check_box_outline_blank_outlined),
                            Text("Select All Spots"),
                          ],
                        ),
                      ))
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
            child: Container(
              width: Get.width,
              height: 40,
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: BorderDirectional(
                      start: BorderSide(color: Colors.grey[400]!),
                      end: BorderSide(color: Colors.grey[400]!),
                      top: BorderSide(color: Colors.grey[400]!),
                      bottom: BorderSide.none)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Obx(() => Text(
                      "Total Spots: ${controller.intTotalCount.value ?? "--"}")),
                  Obx(() => Text(
                      "Total Duration: ${controller.intTotalDuration.value ?? "--"}")),
                  Obx(() => Text(
                      "Total Amount: ${controller.intTotalAmount.value ?? "--"}")),
                  Obx(() => Text(
                      "Total Val. Amount: ${controller.intTotalValuationAmount.value ?? "--"}")),
                ],
              ),
            ),
          ),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: BorderDirectional(
                    start: BorderSide(color: Colors.grey[400]!),
                    end: BorderSide(color: Colors.grey[400]!),
                    top: BorderSide.none,
                    bottom: BorderSide(color: Colors.grey[400]!),
                  )),
              child: Row(
                children: [
                  GetBuilder<RoCancellationController>(
                      init: controller,
                      id: "cancelData",
                      builder: (cancelDatactrl) {
                        if (cancelDatactrl.roCancellationData == null ||
                            cancelDatactrl
                                    .roCancellationData!.cancellationData ==
                                null ||
                            cancelDatactrl.roCancellationData!.cancellationData!
                                    .lstBookingNoStatusData ==
                                null ||
                            cancelDatactrl.roCancellationData!.cancellationData!
                                .lstBookingNoStatusData!.isEmpty) {
                          return Container(
                            width: Get.width * .9,
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey[300]!)),
                          );
                        } else {
                          return Container(
                            width: Get.width * .9,
                            child: DataGridShowOnlyKeys(
                                onRowChecked: (rowcheckEvent) {
                                  controller
                                      .roCancellationData!
                                      .cancellationData!
                                      .lstBookingNoStatusData![
                                          rowcheckEvent.rowIdx!]
                                      .requested = rowcheckEvent.isChecked;
                                  rowcheckEvent.row!.cells["requested"]!.value =
                                      "${rowcheckEvent.isChecked}";
                                },
                                rowCheckColor: Colors.white,
                                checkRow: true,
                                onload: (loadEvent) {
                                  controller.roCancellationGridManager =
                                      loadEvent.stateManager;
                                  for (var i = 0;
                                      i < loadEvent.stateManager.rows.length;
                                      i++) {
                                    PlutoRow row =
                                        loadEvent.stateManager.rows[i];
                                    if (row.cells["requested"]!.value == true ||
                                        row.cells["requested"]!.value ==
                                            "true") {
                                      loadEvent.stateManager
                                          .setRowChecked(row, true);
                                    }
                                  }
                                },
                                hideCheckKeysValue: true,
                                checkRowKey: "requested",
                                mapData: cancelDatactrl.roCancellationData!
                                    .cancellationData!.lstBookingNoStatusData!
                                    .map((e) => e.toJson(fromSave: false))
                                    .toList()),
                          );
                        }
                      }),
                  SizedBox(
                    width: 3,
                  ),
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        FormButtonWrapper(
                          width: Get.width * 0.07,
                          btnText: "Import",
                          callback: () {
                            controller.pickFile();
                          },
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        FormButtonWrapper(
                          width: Get.width * 0.07,
                          btnText: "OK",
                          callback: () {
                            controller.calculate();
                          },
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          )),
          GetBuilder<HomeController>(
            id: "buttons",
            init: Get.find<HomeController>(),
            builder: (btncontroller) {
              return Container(
                height: 40,
                child: ButtonBar(
                  alignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (var btn in btncontroller.buttons!)
                      btn["name"] == "Save"
                          ? FormButtonWrapper(
                              btnText: btn["name"],
                              callback: () {
                                controller.save();
                              },
                            )
                          : btn["name"] == "Clear"
                              ? FormButtonWrapper(
                                  btnText: btn["name"],
                                  callback: () {
                                    Get.delete<RoCancellationController>();
                                    Get.find<HomeController>().clearPage1();
                                  },
                                )
                              : btn["name"] == "Docs"
                                  ? FormButtonWrapper(
                                      btnText: btn["name"],
                                      callback: () {
                                        controller.docs();
                                      },
                                    )
                                  : btn["name"] == "Refresh"
                                      ? FormButtonWrapper(
                                          btnText: btn["name"],
                                          callback: () {
                                            print("Refresh");
                                          },
                                        )
                                      : FormButtonWrapper(
                                          btnText: btn["name"],
                                          callback: null,
                                        ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
