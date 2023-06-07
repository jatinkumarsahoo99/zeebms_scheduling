import 'package:bms_scheduling/app/modules/RoBooking/views/dummydata.dart';
import 'package:bms_scheduling/app/providers/ApiFactory.dart';
import 'package:bms_scheduling/widgets/CheckBoxWidget.dart';
import 'package:bms_scheduling/widgets/DateTime/DateWithThreeTextField.dart';
import 'package:bms_scheduling/widgets/FormButton.dart';
import 'package:bms_scheduling/widgets/dropdown.dart';
import 'package:bms_scheduling/widgets/gridFromMap.dart';
import 'package:bms_scheduling/widgets/input_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../controllers/mam_work_orders_controller.dart';
import 'package:bms_scheduling/widgets/PlutoGrid/pluto_grid.dart' show PlutoGridMode;

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
              Obx(() {
                return DropDownField.formDropDown1WidthMap(
                  controller.woHChannelList.value,
                  (value) => controller.woHSelectedChannel = value,
                  "Channel",
                  0.12,
                  selected: controller.woHSelectedChannel,
                );
              }),
              DropDownField.formDropDownSearchAPI2(
                GlobalKey(),
                context,
                width: Get.width * 0.2,
                selectedValue: controller.woHSelectedProgram,
                onchanged: (value) => controller.woHSelectedProgram = value,
                title: 'Program',
                url: ApiFactory.MAM_WORK_ORDER_WO_HISTORY_PROGRAM_SEARCH,
                customInData: 'cboProgramsList',
                parseKeyForKey: 'programcode',
                parseKeyForValue: 'programname',
              ),
              InputFields.formField1(
                hintTxt: "From Epi#",
                controller: controller.woHFromEpi,
                width: 0.0375,
                inputformatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                maxLen: 4,
              ),
              InputFields.formField1(
                hintTxt: "To Epi#",
                controller: controller.woHToEpi,
                width: 0.0375,
                inputformatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                maxLen: 4,
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
                callback: controller.showDataInWOHistory,
              )
            ],
          );
        }),
        Divider(
          height: 10,
        ),
        Expanded(
          child: Obx(
            () {
              return (controller.wHDTList.isEmpty)
                  ? Container(
                      decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
                    )
                  : DataGridFromMap(
                      mapData: controller.wHDTList.map((e) => e.toJson()).toList(),
                      mode: PlutoGridMode.selectWithOneTap,
                      formatDate: false,
                    );
            },
          ),
        ),
      ],
    );
  }
}
