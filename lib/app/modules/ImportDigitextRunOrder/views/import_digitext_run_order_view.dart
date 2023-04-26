import 'package:bms_scheduling/app/modules/RoBooking/views/dummydata.dart';
import 'package:bms_scheduling/widgets/DateTime/DateWithThreeTextField.dart';
import 'package:bms_scheduling/widgets/FormButton.dart';
import 'package:bms_scheduling/widgets/dropdown.dart';
import 'package:bms_scheduling/widgets/gridFromMap.dart';
import 'package:bms_scheduling/widgets/input_fields.dart';
import 'package:bms_scheduling/widgets/radio_row.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/import_digitext_run_order_controller.dart';

class ImportDigitextRunOrderView
    extends GetView<ImportDigitextRunOrderController> {
  const ImportDigitextRunOrderView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[50],
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: Get.width * 0.72,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          DropDownField.formDropDown1WidthMap(
                              [], (value) => {}, "Location", 0.24),
                          DropDownField.formDropDown1WidthMap(
                              [], (value) => {}, "Channel", 0.24),
                          DateWithThreeTextField(
                              title: "Schedule Date.",
                              widthRation: 0.12,
                              mainTextController: TextEditingController()),
                          FormButtonWrapper(
                            btnText: "Load",
                            callback: () {},
                          )
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InputFields.formField1(
                        hintTxt: "File",
                        isEnable: false,
                        width: 0.72,
                        controller: TextEditingController()),
                  ),
                  RadioRow(
                      items: controller.radiofilters,
                      groupValue: controller.selectedradiofilter)
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: Get.height * .75,
                child: DataGridFromMap(
                  mapData: dummyProgram,
                  formatDate: false,
                ),
              ),
            ),
            Container(
              height: 25,
            )
          ],
        ));
  }
}
