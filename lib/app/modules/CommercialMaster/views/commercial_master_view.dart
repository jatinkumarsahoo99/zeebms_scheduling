import 'package:bms_scheduling/widgets/DateTime/DateWithThreeTextField.dart';
import 'package:bms_scheduling/widgets/NumericStepButton.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../../widgets/DateTime/TimeWithThreeTextField.dart';
import '../../../../widgets/FormButton.dart';
import '../../../../widgets/dropdown.dart';
import '../../../../widgets/input_fields.dart';
import '../../../controller/HomeController.dart';
import '../../../providers/SizeDefine.dart';
import '../controllers/commercial_master_controller.dart';

class CommercialMasterView extends GetView<CommercialMasterController> {
  const CommercialMasterView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: FocusTraversalGroup(
                policy: WidgetOrderTraversalPolicy(),
                child: Row(
                  children: [
                    FocusTraversalGroup(
                      policy: WidgetOrderTraversalPolicy(),
                      child: Expanded(
                        flex: 12,
                        child: Container(
                          decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
                          padding: EdgeInsets.all(16),
                          child: ListView(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  InputFields.formField1(
                                    hintTxt: "Caption",
                                    controller: TextEditingController(),
                                    width: 0.17,
                                    autoFocus: true,
                                  ),
                                  // SizedBox(width: 20),
                                  InputFields.formField1(
                                    hintTxt: "Tx Caption",
                                    controller: TextEditingController(),
                                    width: 0.17,
                                    prefixText: "C/",
                                  ),
                                  // SizedBox(width: 20),
                                  DropDownField.formDropDown1WidthMap(
                                    [],
                                    (p0) => null,
                                    "Langauge",
                                    .17,
                                  ),
                                ],
                              ),
                              SizedBox(height: 14),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  // DropDownField.formDropDownSearchAPI2(GlobalKey(), context,
                                  //     width: context.width * 0.17, onchanged: (val) {}, title: 'Banner', url: ''),
                                  DropDownField.formDropDown1WidthMap(
                                    [],
                                    (p0) => null,
                                    "Revenue Type",
                                    .17,
                                  ),
                                  // SizedBox(width: 20),
                                  InputFields.formField1(hintTxt: "Sec Type", controller: TextEditingController(), width: 0.17),
                                  // SizedBox(width: 20),
                                  InputFields.formField1(hintTxt: "Tape ID", controller: TextEditingController(), width: 0.17),
                                ],
                              ),
                              SizedBox(height: 14),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  // InputFields.formField1(hintTxt: "Tape ID", controller: TextEditingController(), width: 0.17),
                                  SizedBox(
                                    width: context.width * .17,
                                    child: NumericStepButton(
                                      onChanged: (_) {},
                                      hint: "Seg #",
                                    ),
                                  ),
                                  // SizedBox(width: 20),
                                  // InputFields.formField1(hintTxt: "Seg No", controller: TextEditingController(), width: 0.17),
                                  // SizedBox(width: 20),
                                  InputFields.formField1(hintTxt: "TX No", controller: TextEditingController(), width: 0.17),
                                  InputFields.formField1(hintTxt: "Agency Id", controller: TextEditingController(), width: 0.17),
                                ],
                              ),
                              SizedBox(height: 14),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  DropDownField.formDropDown1WidthMap(
                                    [],
                                    (p0) => null,
                                    "Tape Type",
                                    .17,
                                  ),
                                  DropDownField.formDropDown1WidthMap(
                                    [],
                                    (p0) => null,
                                    "Censhorship",
                                    .17,
                                  ),
                                  DropDownField.formDropDown1WidthMap(
                                    [],
                                    (p0) => null,
                                    "Brand",
                                    .17,
                                  ),
                                ],
                              ),
                              SizedBox(height: 14),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  TimeWithThreeTextField(title: "SOM", mainTextController: TextEditingController(), widthRation: 0.17, isTime: false),
                                  SizedBox(width: 20),
                                  TimeWithThreeTextField(title: "EOM", mainTextController: TextEditingController(), widthRation: 0.17, isTime: false),
                                  SizedBox(width: 20),
                                  TimeWithThreeTextField(
                                      title: "Duration", mainTextController: TextEditingController(), widthRation: 0.17, isTime: false),
                                ],
                              ),
                              SizedBox(height: 14),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  DropDownField.formDropDownSearchAPI2(GlobalKey(), context,
                                      width: context.width * .17, onchanged: (val) {}, title: 'Client', url: ''),
                                  DropDownField.formDropDown1WidthMap(
                                    [],
                                    (p0) => null,
                                    "Brand",
                                    .17,
                                  ),
                                  InputFields.formField1(hintTxt: "Product Name", controller: TextEditingController(), width: 0.17),
                                ],
                              ),
                              SizedBox(height: 14),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  // SizedBox(width: 20),
                                  InputFields.formField1(hintTxt: "Level 1", controller: TextEditingController(), width: 0.17),
                                  // SizedBox(width: 20),
                                  InputFields.formField1(hintTxt: "Level 2", controller: TextEditingController(), width: 0.17),
                                  InputFields.formField1(hintTxt: "Level 3", controller: TextEditingController(), width: 0.17),
                                ],
                              ),
                              SizedBox(height: 14),
                              DropDownField.formDropDownSearchAPI2(GlobalKey(), context,
                                  width: context.width * 0.6, onchanged: (val) {}, title: 'Agency', url: ''),
                              SizedBox(height: 14),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  DateWithThreeTextField(title: "End Date", mainTextController: TextEditingController(), widthRation: .17),
                                  DateWithThreeTextField(title: "Dispatch", mainTextController: TextEditingController(), widthRation: .17),
                                  InputFields.formField1(hintTxt: "Clock ID", controller: TextEditingController(), width: 0.17),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 14),
                    FocusTraversalGroup(
                      policy: WidgetOrderTraversalPolicy(),
                      child: Expanded(
                        flex: 8,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            // Expanded(
                            //   child: Container(
                            //     width: double.infinity,
                            //     decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
                            //     padding: const EdgeInsets.all(16.0),
                            //     child: Column(
                            //       children: [
                            //         Row(
                            //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //           children: [
                            //             DropDownField.formDropDown1WidthMap([], (p0) => null, "Source", .17),
                            //             // SizedBox(width: 20),
                            //             DropDownField.formDropDown1WidthMap([], (p0) => null, "ID No", .17),
                            //           ],
                            //         ),
                            //         SizedBox(height: 14),
                            //         Row(
                            //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //           children: [
                            //             DropDownField.formDropDown1WidthMap(
                            //               [],
                            //               (p0) => null,
                            //               "Start Date",
                            //               .17,
                            //             ),
                            //             // SizedBox(width: 20),
                            //             DropDownField.formDropDown1WidthMap([], (p0) => null, "End Date", .17),
                            //           ],
                            //         ),
                            //         SizedBox(height: 14),
                            //         Expanded(
                            //           child: Column(
                            //             crossAxisAlignment: CrossAxisAlignment.start,
                            //             children: [
                            //               Text(
                            //                 "Synopsis",
                            //                 style: TextStyle(
                            //                   fontSize: SizeDefine.labelSize1,
                            //                   color: Colors.black,
                            //                   fontWeight: FontWeight.w500,
                            //                 ),
                            //               ),
                            //               const SizedBox(height: 5),
                            //               TextFormField(
                            //                 maxLines: 110 ~/ 20,
                            //                 decoration: InputDecoration(
                            //                   filled: true,
                            //                   fillColor: Colors.white,
                            //                   border: OutlineInputBorder(
                            //                     borderRadius: BorderRadius.circular(0),
                            //                     borderSide: BorderSide(
                            //                       color: Colors.deepPurpleAccent,
                            //                     ),
                            //                   ),
                            //                   enabledBorder: OutlineInputBorder(
                            //                     borderRadius: BorderRadius.circular(0),
                            //                     borderSide: BorderSide(
                            //                       color: Colors.deepPurpleAccent,
                            //                     ),
                            //                   ),
                            //                   focusedBorder: OutlineInputBorder(
                            //                     borderRadius: BorderRadius.circular(0),
                            //                     borderSide: BorderSide(
                            //                       color: Colors.deepPurpleAccent,
                            //                     ),
                            //                   ),
                            //                   errorBorder: OutlineInputBorder(
                            //                     borderRadius: BorderRadius.circular(0),
                            //                     borderSide: BorderSide(
                            //                       color: Colors.deepPurpleAccent,
                            //                     ),
                            //                   ),
                            //                 ),
                            //               ),
                            //             ],
                            //           ),
                            //         ),
                            //         SizedBox(height: 14),
                            //       ],
                            //     ),
                            //   ),
                            // ),
                            // SizedBox(height: 14),
                            Text("Annotation Details"),
                            SizedBox(height: 5),
                            Expanded(
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  children: [
                                    DropDownField.formDropDownSearchAPI2(
                                      GlobalKey(),
                                      context,
                                      width: context.width * 0.37,
                                      onchanged: (DropDownValue) {},
                                      title: 'Banner',
                                      url: '',
                                    ),
                                    SizedBox(height: 14),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        TimeWithThreeTextField(
                                            title: "TC In", mainTextController: TextEditingController(), widthRation: 0.11, isTime: false),
                                        // SizedBox(width: 20),
                                        TimeWithThreeTextField(
                                            title: "TC Out", mainTextController: TextEditingController(), widthRation: 0.11, isTime: false),
                                        // SizedBox(width: 20),
                                      ],
                                    ),
                                    SizedBox(height: 14),
                                    Row(
                                      children: [
                                        FormButton(btnText: "Add", callback: () {}),
                                        Spacer(),
                                        Text(
                                          'Press "DEL" to delete Annotation Detail',
                                          style: TextStyle(
                                            color: Colors.deepPurple,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 14),
                                    Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                          color: Colors.grey,
                                        )),
                                      ),
                                    ),
                                    SizedBox(height: 14),
                                    Align(
                                      alignment: Alignment.topRight,
                                      child: FormButton(
                                        btnText: "Print Bar Code",
                                        callback: () {},
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 8),

            /// bottom common buttons
            GetBuilder<HomeController>(
                id: "buttons",
                init: Get.find<HomeController>(),
                builder: (btncontroller) {
                  if (btncontroller.buttons != null) {
                    return SizedBox(
                      height: 40,
                      child: Wrap(
                        spacing: 5,
                        runSpacing: 15,
                        alignment: WrapAlignment.start,
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
          ],
        ),
      ),
    );
  }
}
