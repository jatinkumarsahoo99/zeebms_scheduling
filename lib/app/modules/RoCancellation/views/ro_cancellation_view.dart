import 'package:bms_scheduling/app/providers/Utils.dart';
import 'package:bms_scheduling/widgets/DateTime/DateWithThreeTextField.dart';
import 'package:bms_scheduling/widgets/FormButton.dart';
import 'package:bms_scheduling/widgets/dropdown.dart';
import 'package:bms_scheduling/widgets/input_fields.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../widgets/CheckBoxWidget.dart';
import '../../../../widgets/PlutoGrid/src/pluto_grid.dart';
import '../../../../widgets/gridFromMap.dart';
import '../../../controller/HomeController.dart';
import '../../../controller/MainController.dart';
import '../../../data/PermissionModel.dart';
import '../../../data/user_data_settings_model.dart';
import '../../../routes/app_pages.dart';
import '../controllers/ro_cancellation_controller.dart';

class RoCancellationView extends StatelessWidget {
  RoCancellationView({Key? key}) : super(key: key);
  final controller =
      Get.put<RoCancellationController>(RoCancellationController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// controlls
            Card(
              margin: const EdgeInsets.all(8),
              child: SizedBox(
                width: double.infinity,
                child: Wrap(
                  alignment: WrapAlignment.start,
                  spacing: 10,
                  runSpacing: 10,
                  crossAxisAlignment: WrapCrossAlignment.end,
                  children: [
                    Obx(
                      () => DropDownField.formDropDown1WidthMap(
                        controller.locations.value,
                        (value) {
                          controller.selectedLocation = value;
                          controller.selectedChannel = null;
                          controller.getChannel(value.key);
                        },
                        "Location",
                        controller.widthratio,
                        autoFocus: true,
                        inkWellFocusNode: controller.locFN,
                        selected: controller.selectedLocation,
                      ),
                    ),
                    Obx(
                      () => DropDownField.formDropDown1WidthMap(
                        controller.channels.value,
                        (value) {
                          controller.selectedChannel = value;
                        },
                        "Channel",
                        controller.widthratio,
                        selected: controller.selectedChannel,
                      ),
                    ),
                    Obx(
                      () => DateWithThreeTextField(
                          widthRation: controller.widthratio,
                          isEnable: controller.enableCancelDate.value,
                          title: "Cancel Date",
                          mainTextController: controller.cancelDatectrl),
                    ),
                    Obx(
                      () => DateWithThreeTextField(
                        widthRation: controller.widthratio,
                        isEnable: controller.enableEffDate.value,
                        title: "Eff. Date",
                        onFocusChange: (value) {
                          controller.cancelMonthctrl.text =
                              value.split("-")[2] + value.split("-")[1];
                          controller.enableCancelMonth.value = false;
                        },
                        mainTextController: controller.effDatectrl,
                      ),
                    ),
                    InputFields.formField1(
                      hintTxt: "Reference", //23082001w,23082004w
                      width: controller.widthratio,
                      controller: controller.refNumberctrl,
                    ),
                    InputFields.formField1(
                      hintTxt: "Booking No",
                      width: controller.widthratio,
                      focusNode: controller.bookingNumberFocus,
                      controller: controller.bookingNumberctrl,
                    ),
                    InputFields.formField1(
                      isEnable: false,
                      width: controller.widthratio,
                      hintTxt: "Cancel No",
                      controller: controller.cancelMonthctrl,
                      padLeft: 0,
                    ),
                    Obx(
                      () => InputFields.formField1(
                        isEnable: controller.enableCancelNumber.value,
                        width: controller.widthratio,
                        focusNode: controller.cancelNumberFocus,
                        hintTxt: "",
                        controller: controller.cancelNumberctrl,
                        padLeft: 0,
                      ),
                    ),
                    Obx(
                      () => InputFields.formField1(
                        width: controller.widthratio,
                        isEnable: controller.enableBrandClientAgent.value,
                        hintTxt: "Client",
                        controller: controller.clientctrl,
                      ),
                    ),
                    Obx(
                      () => InputFields.formField1(
                        width: controller.widthratio,
                        isEnable: controller.enableBrandClientAgent.value,
                        hintTxt: "Agency",
                        controller: controller.agencyctrl,
                      ),
                    ),
                    Obx(
                      () => InputFields.formField1(
                        width: controller.widthratio,
                        isEnable: controller.enableBrandClientAgent.value,
                        hintTxt: "Brand",
                        controller: controller.brandctrl,
                      ),
                    ),
                    Obx(
                      () {
                        return CheckBoxWidget1(
                          title: "Select All Spots",
                          fn: controller.selectAllFocus,
                          value: controller.selectAll.value,
                          onChanged: (newVal) {
                            if (controller.roCancellationGridManager != null &&
                                controller.roCancellationData?.cancellationData
                                        ?.lstBookingNoStatusData !=
                                    null) {
                              controller.selectAll.value =
                                  !controller.selectAll.value;
                              for (var i = 0;
                                  i <
                                      (controller
                                          .roCancellationData!
                                          .cancellationData!
                                          .lstBookingNoStatusData!
                                          .length);
                                  i++) {
                                controller
                                    .roCancellationData!
                                    .cancellationData!
                                    .lstBookingNoStatusData?[i]
                                    .requested = controller.selectAll.value;
                                controller.roCancellationGridManager!
                                    .changeCellValue(
                                  controller.roCancellationGridManager!
                                      .getRowByIdx(i)!
                                      .cells['requested']!,
                                  controller.selectAll.value.toString(),
                                  callOnChangedEvent: false,
                                  force: true,
                                  notify: true,
                                );
                              }
                            }
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),

            /// calculation import button ok button
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
              child: Container(
                width: Get.width,
                height: 40,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                ),
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
                    FormButtonWrapper(
                      width: Get.width * 0.07,
                      btnText: "Import",
                      callback: controller.pickFile,
                    ),
                    // SizedBox(height: 30),
                    FormButtonWrapper(
                      width: Get.width * 0.07,
                      btnText: "OK",
                      callback: controller.calculate,
                    ),
                  ],
                ),
              ),
            ),

            /// data tabele widget
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: GetBuilder<RoCancellationController>(
                  init: controller,
                  id: "cancelData",
                  builder: (cancelDatactrl) {
                    if (cancelDatactrl.roCancellationData == null ||
                        cancelDatactrl.roCancellationData!.cancellationData ==
                            null ||
                        cancelDatactrl.roCancellationData!.cancellationData!
                                .lstBookingNoStatusData ==
                            null ||
                        cancelDatactrl.roCancellationData!.cancellationData!
                            .lstBookingNoStatusData!.isEmpty) {
                      return SizedBox(width: double.infinity);
                    } else {
                      return DataGridFromMap3(
                        witdthSpecificColumn: (controller
                            .userDataSettings?.userSetting
                            ?.firstWhere(
                                (element) =>
                                    element.controlName ==
                                    "roCancellationGridManager",
                                orElse: () => UserSetting())
                            .userSettings),
                        checkBoxColumnKey: const ['requested'],
                        checkBoxStrComparison: "true",
                        uncheckCheckBoxStr: "false",
                        mode: PlutoGridMode.normal,
                        onload: (loadEvent) {
                          controller.roCancellationGridManager =
                              loadEvent.stateManager;
                        },
                        onEdit: (event) {
                          // print(event.oldValue);
                          // print(event.value);
                          if ((cancelDatactrl
                                  .roCancellationData
                                  ?.cancellationData
                                  ?.lstBookingNoStatusData?[event.rowIdx]
                                  .requested1 ??
                              false)) {
                            controller.roCancellationGridManager!
                                .changeCellValue(
                              controller.roCancellationGridManager!
                                  .getRowByIdx(event.rowIdx)!
                                  .cells['requested']!,
                              'true',
                              callOnChangedEvent: false,
                              force: true,
                              notify: true,
                            );
                          } else {
                            controller.roCancellationGridManager!
                                .changeCellValue(
                              controller.roCancellationGridManager!
                                  .getRowByIdx(event.rowIdx)!
                                  .cells['requested']!,
                              !(event.oldValue == "true") ? 'true' : 'false',
                              callOnChangedEvent: false,
                              force: true,
                              notify: true,
                            );
                            cancelDatactrl
                                .roCancellationData!
                                .cancellationData!
                                .lstBookingNoStatusData![event.rowIdx]
                                .requested = event.value == "true";
                          }
                          // debugPrint(cancelDatactrl.roCancellationData!.cancellationData!.lstBookingNoStatusData![event.rowIdx].requested.toString());
                        },
                        mapData: cancelDatactrl.roCancellationData!
                            .cancellationData!.lstBookingNoStatusData!
                            .map((e) => e.toJson(fromSave: false))
                            .toList(),
                      );
                    }
                  },
                ),
              ),
            ),

            /// common button widgets
            GetBuilder<HomeController>(
              id: "buttons",
              init: Get.find<HomeController>(),
              builder: (btncontroller) {
                PermissionModel? formPermissions;
                try {
                  formPermissions = Get.find<MainController>()
                      .permissionList
                      ?.lastWhere((element) {
                    return element.appFormName ==
                        Routes.RO_CANCELLATION.replaceAll("/", "");
                  });
                } catch (e) {
                  print(e.toString());
                }

                return SizedBox(
                  height: 40,
                  child: ButtonBar(
                    alignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      for (var btn in btncontroller.buttons!)
                        FormButtonWrapper(
                          btnText: btn["name"],
                          callback: (formPermissions != null &&
                                  Utils.btnAccessHandler2(btn['name'],
                                          btncontroller, formPermissions!) ==
                                      null)
                              ? null
                              : () => formHandler(btn['name']),
                        ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  formHandler(String btnName) {
    if (btnName == "Save") {
      controller.save();
    } else if (btnName == "Clear") {
      Get.delete<RoCancellationController>();
      Get.find<HomeController>().clearPage1();
    } else if (btnName == "Docs") {
      controller.docs();
    } else if (btnName == "Exit") {
      Get.find<HomeController>().postUserGridSetting2(listStateManager: [
        {"roCancellationGridManager": controller.roCancellationGridManager},
      ]);
    }
  }
}
