import 'package:bms_scheduling/widgets/DateTime/TimeWithThreeTextField.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../../widgets/DateTime/DateWithThreeTextField.dart';
import '../../../../widgets/FormButton.dart';
import '../../../../widgets/dropdown.dart';
import '../../../../widgets/input_fields.dart';
import '../../../../widgets/radio_row.dart';
import '../../../controller/HomeController.dart';
import '../controllers/secondary_event_master_controller.dart';

class SecondaryEventMasterView extends GetView<SecondaryEventMasterController> {
  const SecondaryEventMasterView({Key? key}) : super(key: key);
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
                  title: Text('Non Commercial Secondary Events'),
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
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: context.width * .23,
                        child: RadioRow(items: ['Bug', 'Aston'], groupValue: "Bug"),
                      ),
                      SizedBox(width: 20),
                      InputFields.formField1(
                        hintTxt: "Event Name",
                        controller: TextEditingController(),
                        width: 0.225,
                      ),
                    ],
                  ),
                ),
                InputFields.formField1(
                  hintTxt: "Event Name",
                  controller: TextEditingController(),
                  width: 0.475,
                ),
                SizedBox(height: 4),
                InputFields.formField1(
                  hintTxt: "TX Caption",
                  controller: TextEditingController(),
                  width: 0.475,
                ),
                // Padding(
                //   padding: EdgeInsets.symmetric(vertical: 4),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.center,
                //     children: [
                //       Row(
                //         children: [
                //           InputFields.formField1(
                //             hintTxt: "Tape ID",
                //             controller: TextEditingController(),
                //             width: 0.112,
                //           ),
                //           SizedBox(width: 10),
                //           InputFields.formField1(
                //             hintTxt: "Seg No.",
                //             controller: TextEditingController(),
                //             width: 0.11,
                //           ),
                //         ],
                //       ),
                //       SizedBox(width: 20),
                //       Row(
                //         children: [
                //           InputFields.formField1(
                //             hintTxt: "House ID",
                //             controller: TextEditingController(),
                //             width: 0.11,
                //           ),
                //           SizedBox(width: 10),
                //           InputFields.formField1(
                //             hintTxt: "TX Caption",
                //             controller: TextEditingController(),
                //             width: 0.11,
                //           ),
                //         ],
                //       ),
                //     ],
                //   ),
                // ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     InputFields.formField1(
                //       hintTxt: "Caption",
                //       controller: TextEditingController(),
                //       width: 0.23,
                //     ),
                //     SizedBox(width: 20),
                //     DropDownField.formDropDown1WidthMap([], (p0) => null, "Slide type", .23),
                //   ],
                // ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TimeWithThreeTextField(
                        title: "SOM",
                        mainTextController: TextEditingController(),
                        widthRation: 0.15,
                        isTime: false,
                      ),
                      SizedBox(width: 16),
                      TimeWithThreeTextField(
                        title: "EOM",
                        mainTextController: TextEditingController(),
                        widthRation: 0.15,
                        isTime: false,
                      ),
                      SizedBox(width: 16),
                      TimeWithThreeTextField(
                        title: "Duration",
                        mainTextController: TextEditingController(),
                        widthRation: 0.15,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      DateWithThreeTextField(
                        title: "Start Date",
                        mainTextController: TextEditingController(),
                        widthRation: .230,
                      ),
                      SizedBox(width: 20),
                      DateWithThreeTextField(
                        title: "End Date",
                        mainTextController: TextEditingController(),
                        widthRation: .230,
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
