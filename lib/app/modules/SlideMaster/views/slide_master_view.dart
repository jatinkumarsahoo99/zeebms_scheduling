import 'package:bms_scheduling/widgets/CheckBoxWidget.dart';
import 'package:bms_scheduling/widgets/DateTime/DateWithThreeTextField.dart';
import 'package:bms_scheduling/widgets/dropdown.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../../widgets/FormButton.dart';
import '../../../../widgets/input_fields.dart';
import '../../../controller/HomeController.dart';
import '../controllers/slide_master_controller.dart';

class SlideMasterView extends GetView<SlideMasterController> {
  const SlideMasterView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: size.width * .6,
          child: Dialog(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppBar(
                  title: Text('Slide Master'),
                  centerTitle: true,
                  backgroundColor: Colors.deepPurple,
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    DropDownField.formDropDown1WidthMap([], (p0) => null, "Location", .23),
                    SizedBox(width: 20),
                    DropDownField.formDropDown1WidthMap([], (p0) => null, "Channel", .23),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InputFields.formField1(
                      hintTxt: "Tape ID",
                      controller: TextEditingController(),
                      width: 0.1,
                    ),
                    InputFields.formField1(
                      hintTxt: "Seg No.",
                      controller: TextEditingController(),
                      width: 0.1,
                    ),
                    InputFields.formField1(
                      hintTxt: "House ID",
                      controller: TextEditingController(),
                      width: 0.1,
                    ),
                    InputFields.formField1(
                      hintTxt: "TX Caption",
                      controller: TextEditingController(),
                      width: 0.1,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InputFields.formField1(
                      hintTxt: "Caption",
                      controller: TextEditingController(),
                      width: 0.23,
                    ),
                    SizedBox(width: 20),
                    DropDownField.formDropDown1WidthMap([], (p0) => null, "Slide type", .23),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    DropDownField.formDropDown1WidthMap([], (p0) => null, "Tape Type", .1),
                    InputFields.formField1(
                      hintTxt: "SOM",
                      controller: TextEditingController(),
                      width: 0.1,
                    ),
                    InputFields.formField1(
                      hintTxt: "EOM",
                      controller: TextEditingController(),
                      width: 0.1,
                    ),
                    InputFields.formField1(
                      hintTxt: "Duration",
                      controller: TextEditingController(),
                      width: 0.1,
                    ),
                  ],
                ),
                Row(
                  children: [
                    CheckBoxWidget1(title: "Non-Dated"),
                    CheckBoxWidget1(title: "Dateed"),
                    DateWithThreeTextField(
                      title: "Upto Date",
                      mainTextController: TextEditingController(),
                    )
                  ],
                ),
                SizedBox(height: 20),

                /// bottom common buttons
                Align(
                  alignment: Alignment.topCenter,
                  child: GetBuilder<HomeController>(
                      id: "buttons",
                      init: Get.find<HomeController>(),
                      builder: (btncontroller) {
                        if (btncontroller.buttons != null) {
                          return SizedBox(
                            height: 40,
                            child: ButtonBar(
                              alignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                for (var btn in btncontroller.buttons!)
                                  FormButtonWrapper(
                                    btnText: btn["name"],
                                    callback: btn["name"] == "Save" ? null : () => controller.formHandler(btn['name'].toString()),
                                  ),
                              ],
                            ),
                          );
                        }
                        return Container();
                      }),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
