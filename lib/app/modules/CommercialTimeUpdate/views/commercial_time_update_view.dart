import 'package:bms_scheduling/widgets/NumericStepButton.dart';
import 'package:bms_scheduling/widgets/input_fields.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../../widgets/CheckBoxWidget.dart';
import '../../../../widgets/DateTime/DateWithThreeTextField.dart';
import '../../../../widgets/FormButton.dart';
import '../../../../widgets/dropdown.dart';
import '../../../../widgets/gridFromMap.dart';
import '../../../controller/HomeController.dart';
import '../../../providers/Utils.dart';
import '../controllers/commercial_time_update_controller.dart';

class CommercialTimeUpdateView extends GetView<CommercialTimeUpdateController> {
  const CommercialTimeUpdateView({Key? key}) : super(key: key);
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

              ///bottom controlls
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
                          child: FormButton(btnText: controller.buttonsList[index]),
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

  showSpecialDialog() {
    Get.defaultDialog(
      title: "Special",
      textCancel: "Save Spl",
      textConfirm: "Done",
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropDownField.formDropDownDisableWidth(null, "Location", .2, selected: "Asia"),
          SizedBox(height: 10),
          DropDownField.formDropDownDisableWidth(null, "Channel", .2, selected: "Zee TV"),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}
