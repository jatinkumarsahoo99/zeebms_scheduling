import 'package:bms_scheduling/app/controller/HomeController.dart';
import 'package:bms_scheduling/app/providers/SizeDefine.dart';
import 'package:bms_scheduling/widgets/DateTime/DateWithThreeTextField.dart';
import 'package:bms_scheduling/widgets/FormButton.dart';
import 'package:bms_scheduling/widgets/dropdown.dart';
import 'package:bms_scheduling/widgets/input_fields.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/log_convert_controller.dart';

class LogConvertView extends GetView<LogConvertController> {
  const LogConvertView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: SizedBox(
                width: Get.width * .64,
                child: Dialog(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.center, mainAxisSize: MainAxisSize.min, children: [
                  AppBar(
                    title: Text('Log Convert'),
                    centerTitle: true,
                    backgroundColor: Colors.deepPurple,
                  ),
                  SizedBox(height: 20),
                  Wrap(
                    children: [
                      DropDownField.formDropDown1WidthMap([], (value) => {}, "Location", 0.24),
                      DropDownField.formDropDown1WidthMap([], (value) => {}, "Channel", 0.24),
                      DateWithThreeTextField(title: "FPC Eff. Dt.", widthRation: 0.12, mainTextController: TextEditingController()),
                      FormButtonWrapper(btnText: "Import")
                    ],
                  ),
                ])))));
  }
}
