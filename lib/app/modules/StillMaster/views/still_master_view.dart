import 'package:bms_scheduling/widgets/radio_row.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../../widgets/CheckBoxWidget.dart';
import '../../../../widgets/DateTime/DateWithThreeTextField.dart';
import '../../../../widgets/FormButton.dart';
import '../../../../widgets/dropdown.dart';
import '../../../../widgets/input_fields.dart';
import '../../../controller/HomeController.dart';
import '../controllers/still_master_controller.dart';

class StillMasterView extends GetView<StillMasterController> {
  const StillMasterView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: size.width * .64,
          child: Dialog(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppBar(
                  title: Text('Still Master'),
                  centerTitle: true,
                  backgroundColor: Colors.deepPurple,
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    DropDownField.formDropDown1WidthMap([], (p0) => null, "Location", .23, autoFocus: true),
                    SizedBox(width: 20),
                    DropDownField.formDropDown1WidthMap([], (p0) => null, "Channel", .23),
                  ],
                ),
                SizedBox(height: 4),
                DropDownField.formDropDownSearchAPI2(
                  GlobalKey(),
                  context,
                  width: context.width * 0.475,
                  onchanged: (DropDownValue) {},
                  title: 'Program',
                  url: '',
                ),
                SizedBox(height: 4),
                InputFields.formField1(
                  hintTxt: "Caption",
                  controller: TextEditingController(),
                  width: 0.475,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          InputFields.formField1(
                            hintTxt: "Tape ID",
                            controller: TextEditingController(),
                            width: 0.112,
                          ),
                          SizedBox(width: 10),
                          InputFields.formField1(
                            hintTxt: "Seg No.",
                            controller: TextEditingController(),
                            width: 0.11,
                          ),
                        ],
                      ),
                      SizedBox(width: 20),
                      Row(
                        children: [
                          InputFields.formField1(
                            hintTxt: "House ID",
                            controller: TextEditingController(),
                            width: 0.11,
                          ),
                          SizedBox(width: 10),
                          InputFields.formField1(
                            hintTxt: "Copy",
                            controller: TextEditingController(),
                            width: 0.11,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: context.width * .23,
                      child: Column(
                        children: [
                          RadioRow(
                            items: ["Bumper", "Opening"],
                            groupValue: "Bumper",
                          ),
                          RadioRow(
                            items: ["Closing", "Generic"],
                            groupValue: "Closing",
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 20),
                    InputFields.formField1(
                      hintTxt: "TX Caption",
                      controller: TextEditingController(),
                      width: .225,
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          DropDownField.formDropDown1WidthMap(
                            [],
                            (p0) => null,
                            "Tape",
                            .112,
                          ),
                          SizedBox(width: 13),
                          InputFields.formField1(
                            hintTxt: "SOM",
                            controller: TextEditingController(),
                            width: 0.11,
                          ),
                        ],
                      ),
                      SizedBox(width: 20),
                      Row(
                        children: [
                          InputFields.formField1(
                            hintTxt: "EOM",
                            controller: TextEditingController(),
                            width: 0.11,
                          ),
                          SizedBox(width: 10),
                          InputFields.formField1(
                            hintTxt: "Dur",
                            controller: TextEditingController(),
                            width: 0.11,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: context.width * .23,
                        child: RadioRow(items: ['Non-Dated', 'Dated'], groupValue: "Non-Dated"),
                      ),
                      SizedBox(width: 20),
                      DateWithThreeTextField(
                        title: "Upto Date",
                        mainTextController: TextEditingController(),
                        widthRation: .225,
                      )
                    ],
                  ),
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
                            child: Wrap(
                              spacing: 5,
                              runSpacing: 15,
                              alignment: WrapAlignment.center,
                              // alignment: MainAxisAlignment.start,
                              // mainAxisSize: MainAxisSize.min,
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
