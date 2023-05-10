import 'package:bms_scheduling/app/providers/ApiFactory.dart';
import 'package:bms_scheduling/widgets/CheckBoxWidget.dart';
import 'package:bms_scheduling/widgets/DateTime/DateWithThreeTextField.dart';
import 'package:bms_scheduling/widgets/DateTime/TimeWithThreeTextField.dart';
import 'package:bms_scheduling/widgets/FormButton.dart';
import 'package:bms_scheduling/widgets/dropdown.dart';
import 'package:bms_scheduling/widgets/gridFromMap.dart';
import 'package:bms_scheduling/widgets/input_fields.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../RoBooking/views/dummydata.dart';
import '../controllers/mam_work_orders_controller.dart';

class ReleaseWoNonFpcView extends GetView {
  const ReleaseWoNonFpcView(this.controller, {Key? key}) : super(key: key);
  @override
  final MamWorkOrdersController controller;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Obx(() {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              DropDownField.formDropDown1WidthMap(
                controller.onloadData.value.lstcboWorkOrderType ?? [],
                (value) => controller.nonFPCSelectedWorkOrderType = value,
                "Work Order Type",
                0.24,
                autoFocus: true,
                inkWellFocusNode: controller.nonFPCWOTypeFN,
                selected: controller.nonFPCSelectedWorkOrderType,
              ),
              CheckBoxWidget1(
                title: "WO Release with TX Id",
                value: controller.nonFPCWOReleaseTXID,
                onChanged: (val) {
                  controller.nonFPCWOReleaseTXID = val ?? false;
                  controller.onloadData.refresh();
                },
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Text(
                      controller.nonFPCWOReleaseTXID
                          ? "Msg: Work order will be released for single episodes and not for range. Please ensure segment entry is done in order to get time code update."
                          : "Msg: Work order can can be release for range of episodes.",
                      style: TextStyle(color: Colors.blue)),
                ),
              )
            ],
          );
        }),
        Divider(height: 10),
        Obx(() {
          return Wrap(
            alignment: WrapAlignment.start,
            runAlignment: WrapAlignment.start,
            crossAxisAlignment: WrapCrossAlignment.start,
            spacing: Get.width * 0.005,
            runSpacing: 5,
            children: [
              DropDownField.formDropDown1WidthMap(
                controller.onloadData.value.lstcboLocation ?? [],
                controller.handleNONFPCLocationChanged,
                "Location",
                0.12,
                selected: controller.nonFPCSelectedLoc,
              ),
              Obx(() {
                return DropDownField.formDropDown1WidthMap(
                  controller.nonFPCChannelList.value,
                  (val) => controller.nonFPCSelectedChannel = val,
                  "Channel",
                  0.24,
                  selected: controller.nonFPCSelectedChannel,
                );
              }),
              DropDownField.formDropDownSearchAPI2(
                GlobalKey(),
                context,
                title: "BMS Program / BMS Caption",
                url: ApiFactory.MAM_WORK_ORDER_NON_FPC_BMS_SEARCH,
                onchanged: controller.handleNONFPCBMSOnChanged,
                width: Get.width * .3,
                customInData: "cboProgramsList",
                parseKeyForKey: "programcode",
                parseKeyForValue: "programname",
                selectedValue: controller.nonFPCSelectedBMSProgram,
              ),
              DropDownField.formDropDownSearchAPI2(
                GlobalKey(),
                context,
                title: "RMS Program",
                url: ApiFactory.MAM_WORK_ORDER_NON_FPC_RMS_SEARCH,
                onchanged: (val) => controller.nonFPCSelectedRMSProgram = val,
                width: Get.width * .3,
                customInData: "cboProgramsList",
                parseKeyForKey: "programcode",
                parseKeyForValue: "programname",
                selectedValue: controller.nonFPCSelectedRMSProgram,
              ),
              InputFields.formField1(hintTxt: "From Epi#", controller: controller.nonFPCFromEpi, width: 0.0575),
              InputFields.formField1(hintTxt: "To Epi#", controller: controller.nonFPCToEpi, width: 0.0575),
              InputFields.formField1(hintTxt: "Epi Segs", controller: controller.nonFPCEpiSegments, width: 0.0575),
              DropDownField.formDropDown1WidthMap(
                controller.onloadData.value.lstcboTelecastType ?? [],
                (value) => controller.nonFPCSelectedTelecasteType = value,
                "Telecast Type",
                0.1775,
                selected: controller.nonFPCSelectedTelecasteType,
              ),
              SizedBox(
                width: Get.width * 0.30,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    StatefulBuilder(builder: (context, re) {
                      return CheckBoxWidget1(
                        title: controller.nonFPCQualityHD ? "Quality HD" : "Quality SD",
                        value: controller.nonFPCQualityHD,
                        onChanged: (val) {
                          controller.nonFPCQualityHD = val ?? false;
                          re(() {});
                        },
                      );
                    }),
                    CheckBoxWidget1(
                      title: "Auto TC",
                      value: controller.nonFPCAutoTC,
                      onChanged: (val) {
                        controller.nonFPCAutoTC = val ?? false;
                      },
                    ),
                    InputFields.formField1(
                        hintTxt: "TX Id", isEnable: controller.nonFPCWOReleaseTXID, controller: controller.nonFPCTxID, width: 0.14),
                  ],
                ),
              ),
              DateWithThreeTextField(
                  title: "Tel Date", widthRation: 0.148, mainTextController: controller.nonFPCTelDate, isEnable: controller.nonFPCWOReleaseTXID),
              TimeWithThreeTextField(
                mainTextController: controller.nonFPCTelTime,
                title: "Tel Time",
                widthRation: .148,
                isTime: true,
                isEnable: controller.nonFPCWOReleaseTXID,
              ),
              Row(),
            ],
          );
        }),
        Divider(height: 10),

        /// data table
        Expanded(
            child: Container(
          color: Colors.amber,
          child: DataGridFromMap(
            mapData: dummyProgram,
            formatDate: false,
          ),
        )),
        SizedBox(height: 5),

        /// save btn
        FormButtonWrapper(btnText: "Save WO")
      ],
    );
  }
}
