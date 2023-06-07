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
import 'package:bms_scheduling/widgets/PlutoGrid/pluto_grid.dart';

import '../controllers/mam_work_orders_controller.dart';

class CancelWoView extends GetView {
  const CancelWoView(this.controller, {Key? key}) : super(key: key);
  @override
  final MamWorkOrdersController controller;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Obx(() {
              return DropDownField.formDropDown1WidthMap(
                controller.onloadData.value.lstcboWOTypeCancelWO,
                (value) => controller.cwoSelectedWOT = value,
                "Work Order Type",
                0.24,
                selected: controller.cwoSelectedWOT,
                autoFocus: true,
              );
            }),
          ],
        ),
        Divider(height: 10),
        Obx(() {
          return Wrap(
            crossAxisAlignment: WrapCrossAlignment.end,
            spacing: Get.width * 0.005,
            alignment: WrapAlignment.start,
            runSpacing: 5,
            children: [
              DropDownField.formDropDown1WidthMap(
                controller.onloadData.value.lstcboLocationWOCanc,
                controller.handleOnLocChangedInCWO,
                "Location",
                0.115,
                selected: controller.cWOSelectedWOTLocation,
              ),
              Obx(() {
                return DropDownField.formDropDown1WidthMap(
                  controller.cWOChannelList.value,
                  (value) => controller.cWOSelectedWOTChannel = value,
                  "Channel",
                  0.118,
                  selected: controller.cWOSelectedWOTChannel,
                );
              }),
              DropDownField.formDropDownSearchAPI2(
                GlobalKey(),
                context,
                title: "Program",
                url: ApiFactory.MAM_WORK_ORDER_WO_CANCEL_PROGRAM_SEARCH,
                onchanged: (val) => controller.cWOSelectedWOProgram = val,
                width: Get.width * .2,
                selectedValue: controller.cWOSelectedWOProgram,
                parseKeyForKey: "programcode",
                parseKeyForValue: "programname",
                customInData: 'cboProgramsList',
              ),
              InputFields.formField1(
                hintTxt: "From Epi#",
                controller: controller.cWOfromEpiTC,
                width: 0.0375,
                inputformatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                maxLen: 4,
              ),
              InputFields.formField1(
                hintTxt: "To Epi#",
                controller: controller.cWOToEpiTC,
                width: 0.0375,
                inputformatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                maxLen: 4,
              ),
              DropDownField.formDropDown1WidthMap(
                controller.onloadData.value.lstcboTelecastTypeWOCanc,
                (value) => controller.cWOSelectedWOTTelecasteType = value,
                "Telecast Type",
                0.12,
                selected: controller.cWOSelectedWOTTelecasteType,
              ),
              Obx(() {
                return CheckBoxWidget1(
                  title: "Tel Dt",
                  value: controller.cWOtelDate.value,
                  onChanged: (val) => controller.cWOtelDate.value = val ?? false,
                );
              }),
              DateWithThreeTextField(
                title: "Tel Dt From",
                widthRation: 0.09,
                mainTextController: controller.cwoTelDTFrom,
              ),
              DateWithThreeTextField(
                title: "Tel Dt To",
                widthRation: 0.09,
                mainTextController: controller.cwoTelDTTo,
              ),
              FormButtonWrapper(
                btnText: "Show",
                callback: controller.showCancelWOData,
              )
            ],
          );
        }),
        Divider(height: 10),
        Expanded(
          child: Obx(
            () {
              return (controller.cwoDataTableList.isEmpty)
                  ? Container(
                      decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
                    )
                  : DataGridFromMap3(
                      mapData: controller.cwoDataTableList.map((e) => e.toJson()).toList(),
                      checkBoxStrComparison: true.toString(),
                      uncheckCheckBoxStr: false.toString(),
                      checkBoxColumnKey: ['cancelWO'],
                      onEdit: controller.cancelWOViewDataTableEdit,
                      onColumnHeaderDoubleTap: controller.cancelWOViewDataTableDoubleTap,
                      enableColumnDoubleTap: ['cancelWO'],
                      mode: PlutoGridMode.selectWithOneTap,
                    );
            },
          ),
        ),
        SizedBox(height: 5),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              "Dbl Click cancelWO col to select unselect all work orders",
              style: TextStyle(color: Colors.blue),
            ),
            SizedBox(
              width: 5,
            ),
            FormButtonWrapper(
              btnText: "Cancel WO",
              callback: controller.cancelWOData,
            )
          ],
        )
      ],
    );
  }
}
