import 'package:bms_scheduling/app/modules/RoBooking/views/dummydata.dart';
import 'package:bms_scheduling/widgets/CheckBoxWidget.dart';
import 'package:bms_scheduling/widgets/DateTime/DateWithThreeTextField.dart';
import 'package:bms_scheduling/widgets/FormButton.dart';
import 'package:bms_scheduling/widgets/dropdown.dart';
import 'package:bms_scheduling/widgets/gridFromMap.dart';
import 'package:bms_scheduling/widgets/input_fields.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/mam_work_orders_controller.dart';

class WoHistoryView extends GetView {
  const WoHistoryView(this.controller, {Key? key}) : super(key: key);
  @override
  final MamWorkOrdersController controller;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(() {
          return Wrap(
            crossAxisAlignment: WrapCrossAlignment.end,
            spacing: Get.width * 0.005,
            alignment: WrapAlignment.start,
            runSpacing: 5,
            children: [
              DropDownField.formDropDown1WidthMap(
                controller.onloadData.value.lstcboLocationWOHistory,
                controller.handleLocationChangedInWOH,
                "Location",
                0.09,
                selected: controller.woHSelectedLocation,
              ),
              DropDownField.formDropDown1WidthMap(
                [],
                (value) => controller.woHSelectedChannel = value,
                "Channel",
                0.12,
                selected: controller.woHSelectedChannel,
              ),
              DropDownField.formDropDown1WidthMap(
                [],
                (value) => controller.woHSelectedProgram = value,
                "Program",
                0.24,
                selected: controller.woHSelectedProgram,
              ),
              InputFields.formField1(
                hintTxt: "From Epi#",
                controller: controller.woHFromEpi,
                width: 0.0375,
              ),
              InputFields.formField1(
                hintTxt: "To Epi#",
                controller: controller.woHToEpi,
                width: 0.0375,
              ),
              DropDownField.formDropDown1WidthMap(
                controller.onloadData.value.lstcboTelecastTypeWOHistory,
                (value) => controller.woHSelectedTelecastType = value,
                "Telecast Type",
                0.12,
                selected: controller.woHSelectedTelecastType,
              ),
              Obx(() {
                return CheckBoxWidget1(
                  title: "Tel Dt",
                  value: controller.woHtelDate.value,
                  onChanged: (val) => controller.woHtelDate.value = val ?? false,
                );
              }),
              DateWithThreeTextField(
                title: "Tel Dt From",
                widthRation: 0.09,
                mainTextController: controller.woHTelDTFrom,
              ),
              DateWithThreeTextField(
                title: "Tel Dt To",
                widthRation: 0.09,
                mainTextController: controller.woHTelDTTo,
              ),
              FormButtonWrapper(
                btnText: "Show",
                callback: () {},
              )
            ],
          );
        }),
        Divider(
          height: 10,
        ),
        Expanded(
            child: Container(
          color: Colors.amber,
          child: DataGridFromMap(
            mapData: dummyProgram,
            formatDate: false,
          ),
        )),
      ],
    );
  }
}
