import 'package:bms_scheduling/widgets/NumericStepButton.dart';
import 'package:bms_scheduling/widgets/input_fields.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../../widgets/CheckBoxWidget.dart';
import '../../../../widgets/DateTime/DateWithThreeTextField.dart';
import '../../../../widgets/FormButton.dart';
import '../../../../widgets/dropdown.dart';
import '../../../../widgets/gridFromMap.dart';
import '../../../../widgets/radio_row.dart';
import '../../../controller/HomeController.dart';
import '../../../providers/Utils.dart';
import '../controllers/manage_channel_inventory_controller.dart';

class ManageChannelInvemtoryView extends GetView<ManageChannelInvemtoryController> {
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
                      (v) => controller.selectedLocation = v,
                      "Location",
                      .2,
                      autoFocus: true,
                      selected: controller.selectedLocation,
                      inkWellFocusNode: controller.locationFN,
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
                    );
                  }),
                  const SizedBox(width: 10),
                  DateWithThreeTextField(
                    title: "Effective Date",
                    mainTextController: controller.effectiveDateTC,
                    widthRation: 0.15,
                  ),
                  const SizedBox(width: 10),
                  InputFields.formField1(
                    hintTxt: "Weekday",
                    controller: controller.weekDaysTC,
                  ),
                  const SizedBox(width: 10),
                  FormButton(btnText: "Display", callback: controller.handleGenerateButton)
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
                      child: controller.dataTableList.value.isEmpty ? null : DataGridFromMap(mapData: controller.dataTableList.value),
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
                    SizedBox(
                      width: context.width * .17,
                      child: NumericStepButton(
                        onChanged: (val) {},
                        hint: "Common.Dur.Sec For 30 Mins Prog.",
                        isEnable: false,
                        maxValue: 100000,
                      ),
                    ),
                    // const SizedBox(width: 10),
                    Row(
                      children: List.generate(
                        controller.buttonsList.length,
                        (index) => Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: FormButton(
                              btnText: controller.buttonsList[index], callback: () => handleBottonButtonsTap(controller.buttonsList[index], context)),
                        ),
                      ).toList(),
                    ),
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
                                callback: ((Utils.btnAccessHandler(btn['name'], controller.formPermissions!) == null))
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
      Get.defaultDialog(
        title: "Special",
        textCancel: "Save Spl",
        textConfirm: "Done",
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropDownField.formDropDownDisableWidth(null, "Location", .31, selected: "Asia"),
            SizedBox(height: 2),
            DropDownField.formDropDownDisableWidth(null, "Channel", .31, selected: "Zee TV"),
            SizedBox(height: 5),
            Row(
              children: [
                CheckBoxWidget1(title: "Sun"),
                CheckBoxWidget1(title: "Mon"),
                CheckBoxWidget1(title: "Tue"),
                CheckBoxWidget1(title: "Wed"),
                CheckBoxWidget1(title: "Thu"),
                CheckBoxWidget1(title: "Fri"),
                CheckBoxWidget1(title: "Sat"),
              ],
            ),
            SizedBox(height: 5),
            Row(
              children: [
                SizedBox(width: 10),
                DateWithThreeTextField(
                  title: "From Date",
                  mainTextController: TextEditingController(),
                  widthRation: 0.15,
                ),
                SizedBox(width: 20),
                DateWithThreeTextField(
                  title: "To Date",
                  mainTextController: TextEditingController(),
                  widthRation: 0.15,
                ),
              ],
            ),
            SizedBox(height: 5),
            Row(
              children: [
                InputFields.formFieldNumberMask(
                  hintTxt: "From Time",
                  controller: TextEditingController(),
                  widthRatio: .15,
                ),
                SizedBox(width: 10),
                InputFields.formFieldNumberMask(
                  hintTxt: "To Time",
                  controller: TextEditingController(),
                  widthRatio: .15,
                ),
              ],
            ),
            SizedBox(height: 5),
            DropDownField.formDropDown1WidthMap(
              [],
              (p0) => null,
              "Program",
              .31,
            ),
            SizedBox(height: 5),
            RadioRow(items: ["Default", "Add", "Fixed"], groupValue: "Add"),
            SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Align(
                alignment: Alignment.topLeft,
                child: SizedBox(
                  width: context.width * .15,
                  child: NumericStepButton(
                    onChanged: (val) {},
                    hint: "Common.Dur.Sec",
                    isEnable: false,
                    maxValue: 100000,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }
  }
}
