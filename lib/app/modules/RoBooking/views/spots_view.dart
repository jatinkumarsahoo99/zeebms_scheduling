// import 'package:bms_scheduling/widgets/cutom_dropdown.dart';
import 'package:bms_scheduling/app/modules/RoBooking/controllers/ro_booking_controller.dart';
import 'package:bms_scheduling/app/modules/RoBooking/views/dummydata.dart';
import 'package:bms_scheduling/widgets/DataGridShowOnly.dart';
import 'package:bms_scheduling/widgets/DateTime/DateWithThreeTextField.dart';
import 'package:bms_scheduling/widgets/FormButton.dart';
import 'package:bms_scheduling/widgets/cutom_dropdown.dart';
import 'package:bms_scheduling/widgets/dropdown.dart';
import 'package:bms_scheduling/widgets/input_fields.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

class SpotsView extends GetView<RoBookingController> {
  const SpotsView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
            child: Container(
          child: controller.bookingNoLeaveData != null
              ? DataGridShowOnlyKeys(mapData: controller.bookingNoLeaveData!.lstMakeGood!.map((e) => e.toJson()).toList(), formatDate: false)
              : SizedBox(),
        )),
        SizedBox(
          height: 5,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Wrap(
              spacing: 5,
              children: [
                DropDownField.formDropDown1WidthMap([], (value) => {}, "PDC", 0.12),
                InputFields.formField1(hintTxt: "Amt", controller: TextEditingController()),
                InputFields.formField1(hintTxt: "Bank", width: 0.24, controller: controller.refNoCtrl),
                InputFields.formField1(hintTxt: "Bal Amt", controller: TextEditingController()),
              ],
            ),
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.end,
              spacing: 5,
              children: [
                FormButtonWrapper(
                  btnText: "Refresh PDC",
                  callback: () {},
                ),
                FormButtonWrapper(
                  btnText: "Del Spot Row",
                  callback: () {},
                ),
                FormButtonWrapper(
                  btnText: "PDC Cheques",
                  callback: () {
                    Get.defaultDialog(
                        title: "Client PDC",
                        content: SizedBox(
                          height: Get.height * 0.80,
                          width: Get.width * .60,
                          child: Column(
                            children: [
                              Wrap(
                                children: [
                                  InputFields.formField1(hintTxt: "Location", width: 0.24, controller: TextEditingController()),
                                  InputFields.formField1(hintTxt: "Channel", width: 0.24, controller: TextEditingController()),
                                  InputFields.formField1(hintTxt: "Client", width: 0.24, controller: TextEditingController()),
                                  InputFields.formField1(hintTxt: "Agency", width: 0.24, controller: TextEditingController()),
                                  InputFields.formField1(hintTxt: "Activity Period", width: 0.24, controller: TextEditingController()),
                                  Text("[YYYYMM]")
                                ],
                              ),
                              Divider(
                                thickness: 1,
                              ),
                              Wrap(
                                children: [
                                  InputFields.formField1(hintTxt: "Cheque", width: 0.24, controller: TextEditingController()),
                                  DateWithThreeTextField(
                                    title: "Chq Dt",
                                    widthRation: 0.12,
                                    mainTextController: controller.fpcEffectiveDateCtrl,
                                    isEnable: controller.bookingNoLeaveData == null,
                                  ),
                                  InputFields.formField1(hintTxt: "Chq Dt", width: 0.12, controller: TextEditingController()),
                                  InputFields.formField1(hintTxt: "Bank", width: 0.48, controller: TextEditingController()),
                                  InputFields.formField1(hintTxt: "Chq Recd By", width: 0.36, controller: TextEditingController()),
                                  DateWithThreeTextField(
                                    title: "Recd On",
                                    widthRation: 0.12,
                                    mainTextController: controller.fpcEffectiveDateCtrl,
                                    isEnable: controller.bookingNoLeaveData == null,
                                  ),
                                  InputFields.formField1(hintTxt: "Remarks", width: 0.48, controller: TextEditingController()),
                                ],
                              ),
                            ],
                          ),
                        ));
                  },
                ),
              ],
            )
          ],
        )
      ],
    );
  }
}
