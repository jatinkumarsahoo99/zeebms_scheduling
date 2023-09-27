import 'package:bms_scheduling/app/controller/ConnectorControl.dart';
import 'package:bms_scheduling/app/providers/ApiFactory.dart';
import 'package:bms_scheduling/widgets/NumericStepButton.dart';
import 'package:bms_scheduling/widgets/input_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../widgets/CheckBoxWidget.dart';
import '../../../../widgets/DateTime/DateWithThreeTextField.dart';
import '../../../../widgets/FormButton.dart';
import '../../../../widgets/LoadingDialog.dart';
import '../../../../widgets/PlutoGrid/src/manager/pluto_grid_state_manager.dart';
import '../../../../widgets/PlutoGrid/src/pluto_grid.dart';
import '../../../../widgets/dropdown.dart';
import '../../../../widgets/gridFromMap.dart';
import '../../../../widgets/gridFromMap1.dart';
import '../../../../widgets/radio_row.dart';
import '../../../controller/HomeController.dart';
import '../../../data/user_data_settings_model.dart';
import '../../../providers/Utils.dart';
import '../controllers/manage_channel_inventory_controller.dart';

class ManageChannelInvemtoryView
    extends GetView<ManageChannelInvemtoryController> {
  const ManageChannelInvemtoryView({Key? key}) : super(key: key);
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
              ///Controllers
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Obx(() {
                    return DropDownField.formDropDown1WidthMap(
                      controller.locationList.value,
                      controller.handleOnChangedLocation,
                      "Location",
                      .2,
                      autoFocus: true,
                      selected: controller.selectedLocation,
                      inkWellFocusNode: controller.locationFN,
                      isEnable: controller.bottomControllsEnable.value,
                    );
                  }),
                  const SizedBox(width: 10),
                  Obx(() {
                    return DropDownField.formDropDown1WidthMap(
                      controller.channelList.value,
                      (v) => controller.selectedChannel = v,
                      "Channel",
                      .2,
                      selected: controller.selectedChannel,
                      isEnable: controller.bottomControllsEnable.value,
                    );
                  }),
                  const SizedBox(width: 10),
                  Obx(() {
                    return DateWithThreeTextField(
                      title: "Effective Date",
                      mainTextController: controller.effectiveDateTC,
                      widthRation: 0.15,
                      onFocusChange: (date) {
                        controller.weekDaysTC.text = DateFormat('EEEE')
                            .format(DateFormat("dd-MM-yyyy").parse(date));
                      },
                      isEnable: controller.bottomControllsEnable.value,
                      startDate: DateTime.now(),
                    );
                  }),
                  const SizedBox(width: 10),
                  InputFields.formField1(
                      hintTxt: "Weekday",
                      controller: controller.weekDaysTC,
                      isEnable: false),
                  const SizedBox(width: 10),
                  FormButton(
                      btnText: "Display",
                      callback: controller.handleGenerateButton)
                ],
              ),

              ///Data table
              Expanded(
                child: Obx(
                  () {
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      decoration: controller.dataTableList.value.isEmpty
                          ? BoxDecoration(
                              border: Border.all(
                                color: Colors.grey,
                              ),
                            )
                          : null,
                      child: controller.dataTableList.value.isEmpty
                          ? null
                          : DataGridFromMap(
                              enableAutoEditing: true,
                              mapData: controller.dataTableList.value
                                  .map((e) => e.toJson())
                                  .toList(),
                              editKeys: ["commDuration"],
                              onEdit: (row) {
                                controller.lastSelectedIdx = row.rowIdx;
                                if (RegExp(r'^[0-9]+$').hasMatch(row.value)) {
                                  controller.dataTableList[row.rowIdx]
                                          .commDuration =
                                      num.tryParse(row.value.toString());
                                  // controller.madeChanges = true;
                                  controller.dataTableList[row.rowIdx]
                                      .madeChanges = true;
                                  if (controller.dataTableList[row.rowIdx]
                                          .commDuration ==
                                      controller.dataTableList[row.rowIdx]
                                          .realCommDuration) {
                                    controller.dataTableList[row.rowIdx]
                                        .madeChanges = false;
                                  }
                                } else {
                                  controller.stateManager?.changeCellValue(
                                    controller.stateManager!
                                        .getRowByIdx(row.rowIdx)!
                                        .cells['commDuration']!,
                                    controller
                                        .dataTableList[row.rowIdx].commDuration
                                        .toString(),
                                  );
                                  controller.dataTableList[row.rowIdx]
                                      .madeChanges = false;
                                }
                              },
                              mode: PlutoGridMode.normal,
                              // colorCallback: (row) {
                              //   return Colors.white;
                              // },
                              witdthSpecificColumn: (controller
                                  .userDataSettings?.userSetting
                                  ?.firstWhere(
                                      (element) =>
                                          element.controlName == "stateManager",
                                      orElse: () => UserSetting())
                                  .userSettings),
                              onload: (event) {
                                controller.stateManager = event.stateManager;
                                event.stateManager.setSelectingMode(
                                    PlutoGridSelectingMode.row);
                                event.stateManager.setSelecting(true);
                                event.stateManager.setCurrentCell(
                                    event.stateManager
                                        .getRowByIdx(0)
                                        ?.cells['telecastDate'],
                                    controller.lastSelectedIdx);
                              },
                            ),
                    );
                  },
                ),
              ),

              ///bottom controlls buttons
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InputFields.numbers(
                      hintTxt: "Common.Dur.Sec For 30 Mins Prog.",
                      inputformatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                      ],
                      controller: controller.counterTC,
                      padLeft: 5,
                      isNegativeReq: false,
                      width: .17,
                    ),
                    // SizedBox(
                    //   width: context.width * .17,
                    //   child: Obx(() {
                    //     return NumericStepButton(
                    //       counter: controller.count.value,
                    //       onChanged: (val) {
                    //         controller.count.value = val;
                    //       },
                    //       hint: "Common.Dur.Sec For 30 Mins Prog.",
                    //       isEnable: controller.bottomControllsEnable.value,
                    //     );
                    //   }),
                    // ),
                    // const SizedBox(width: 10),
                    Obx(() {
                      return Row(
                        children: List.generate(
                          controller.buttonsList.length,
                          (index) => Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: FormButton(
                              btnText: controller.buttonsList[index],
                              callback: controller.bottomControllsEnable.value
                                  ? () => handleBottonButtonsTap(
                                      controller.buttonsList[index], context)
                                  : null,
                            ),
                          ),
                        ).toList(),
                      );
                    }),
                  ],
                ),
              ),

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
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  handleBottonButtonsTap(String btnName, BuildContext context) {
    if (btnName == "Special") {
      if (controller.selectedLocation == null ||
          controller.selectedChannel == null) {
        LoadingDialog.showErrorDialog("Please select Location,Channel.");
      } else {
        controller.bottomControllsEnable.value = false;
        var fromDateCtr = TextEditingController(),
            toDateCtr = TextEditingController(),
            fromTimeCtr = TextEditingController(),
            toTimeCtr = TextEditingController();
        var selectedRadio = "".obs;
        var selectedWeekDays = List.generate(8, (index) => false).toList();
        // var counter = 0;
        controller.selectedProgram = null;
        controller.programs.clear();
        Get.defaultDialog(
          title: "Special",
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropDownField.formDropDownDisableWidth(null, "Location", .31,
                  selected: controller.selectedLocation?.value ?? ""),
              const SizedBox(height: 2),
              DropDownField.formDropDownDisableWidth(null, "Channel", .31,
                  selected: controller.selectedChannel?.value ?? ""),
              const SizedBox(height: 5),
              Row(
                children: [
                  CheckBoxWidget1(
                      title: "Sun",
                      value: selectedWeekDays[1],
                      onChanged: (a) => selectedWeekDays[1] = a ?? false),
                  CheckBoxWidget1(
                      title: "Mon",
                      value: selectedWeekDays[2],
                      onChanged: (a) => selectedWeekDays[2] = a ?? false),
                  CheckBoxWidget1(
                      title: "Tue",
                      value: selectedWeekDays[3],
                      onChanged: (a) => selectedWeekDays[3] = a ?? false),
                  CheckBoxWidget1(
                      title: "Wed",
                      value: selectedWeekDays[4],
                      onChanged: (a) => selectedWeekDays[4] = a ?? false),
                  CheckBoxWidget1(
                      title: "Thu",
                      value: selectedWeekDays[5],
                      onChanged: (a) => selectedWeekDays[5] = a ?? false),
                  CheckBoxWidget1(
                      title: "Fri",
                      value: selectedWeekDays[6],
                      onChanged: (a) => selectedWeekDays[6] = a ?? false),
                  CheckBoxWidget1(
                      title: "Sat",
                      value: selectedWeekDays[7],
                      onChanged: (a) => selectedWeekDays[7] = a ?? false),
                ],
              ),
              const SizedBox(height: 5),
              Row(
                children: [
                  const SizedBox(width: 10),
                  DateWithThreeTextField(
                    title: "From Date",
                    mainTextController: fromDateCtr,
                    widthRation: 0.15,
                    startDate: DateTime.now(),
                  ),
                  const SizedBox(width: 20),
                  DateWithThreeTextField(
                    title: "To Date",
                    mainTextController: toDateCtr,
                    widthRation: 0.15,
                    startDate: DateTime.now(),
                    onFocusChange: (date) {
                      String weekDays = "";
                      for (var i = 0; i < selectedWeekDays.length; i++) {
                        if (selectedWeekDays[i]) {
                          weekDays = weekDays.isEmpty ? "$i" : "$weekDays,$i";
                        }
                      }
                      weekDays = weekDays.isEmpty ? "0" : "0,$weekDays";
                      controller.getPrograms(
                          fromDateCtr.text, toDateCtr.text, weekDays);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Row(
                children: [
                  InputFields.formFieldNumberMask(
                    hintTxt: "From Time",
                    controller: fromTimeCtr,
                    widthRatio: .15,
                    isTime: true,
                  ),
                  const SizedBox(width: 10),
                  InputFields.formFieldNumberMask(
                    hintTxt: "To Time",
                    controller: toTimeCtr,
                    widthRatio: .15,
                    isTime: true,
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Obx(
                () {
                  return DropDownField.formDropDown1WidthMap(
                    controller.programs.value,
                    (v) => controller.selectedProgram = v,
                    "Program",
                    .31,
                  );
                },
              ),
              const SizedBox(height: 5),
              Obx(() {
                return RadioRow(
                  items: const ["Default", "Add", "Fixed"],
                  groupValue: selectedRadio.value,
                  onchange: (val) => selectedRadio.value = val,
                );
              }),
              const SizedBox(height: 5),
              InputFields.numbers(
                hintTxt: "Common.Dur.Sec",
                inputformatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                ],
                controller: controller.dialogCounter,
                padLeft: 5,
                isNegativeReq: false,
                width: .15,
              ),
              // Padding(
              //   padding: const EdgeInsets.only(left: 20),
              //   child: Align(
              //     alignment: Alignment.topLeft,
              //     child: SizedBox(
              //       width: context.width * .15,
              //       child: NumericStepButton(
              //         onChanged: (val) => counter = val,
              //         hint: "Common.Dur.Sec",
              //         counter: counter,
              //         minValue: 0,
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
          cancel: FormButton(
              btnText: "Save Spl",
              callback: () {
                controller.saveSpecial(
                  fromDateCtr.text,
                  toDateCtr.text,
                  fromTimeCtr.text,
                  toTimeCtr.text,
                  selectedWeekDays,
                  selectedRadio.value,
                );
              }),
          confirm: FormButton(
            btnText: "Done",
            callback: () {
              Get.back();
            },
          ),
        ).then((value) {
          controller.bottomControllsEnable.value = true;
        }).whenComplete(() {
          controller.bottomControllsEnable.value = true;
        });
      }
    } else if (btnName == "Default") {
      controller.handleOnDefaultClick();
    } else if (btnName == "Save Today") {
      controller.saveTodayAndAllData(true);
    } else if (btnName == "Save All Days") {
      controller.saveTodayAndAllData(false);
    }
  }
}
