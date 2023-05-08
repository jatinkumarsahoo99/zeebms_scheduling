import 'package:bms_scheduling/app/controller/HomeController.dart';
import 'package:bms_scheduling/app/modules/RoBooking/views/dummydata.dart';
import 'package:bms_scheduling/widgets/DataGridShowOnly.dart';
import 'package:bms_scheduling/widgets/DateTime/DateWithThreeTextField.dart';
import 'package:bms_scheduling/widgets/FormButton.dart';
import 'package:bms_scheduling/widgets/dropdown.dart';
import 'package:bms_scheduling/widgets/input_fields.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/ro_reschedule_controller.dart';

class RoRescheduleView extends GetView<RoRescheduleController> {
  const RoRescheduleView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[200],
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              margin: EdgeInsets.all(Get.width * 0.005),
              clipBehavior: Clip.hardEdge,
              child: Container(
                width: Get.width,
                padding: EdgeInsets.all(Get.width * 0.005),
                child: Wrap(
                  spacing: Get.width * 0.005,
                  runSpacing: 5,
                  children: [
                    DropDownField.formDropDown1WidthMap(
                        [], (data) {}, "Location", 0.24),
                    DropDownField.formDropDown1WidthMap(
                        [], (data) {}, "Channel", 0.24),
                    InputFields.formField1(
                        hintTxt: "T.O. No",
                        controller: TextEditingController(),
                        width: 0.24),
                    InputFields.formField1(
                        hintTxt: "Client",
                        controller: TextEditingController(),
                        width: 0.24),
                    InputFields.formField1(
                        hintTxt: "Agency",
                        controller: TextEditingController(),
                        width: 0.24),
                    DateWithThreeTextField(
                        title: "Eff Date.",
                        widthRation: 0.24,
                        mainTextController: TextEditingController()),
                    InputFields.formField1(
                        hintTxt: "Reference",
                        controller: TextEditingController(),
                        width: 0.24),
                    InputFields.formField1(
                        hintTxt: "Brand",
                        controller: TextEditingController(),
                        width: 0.24),
                    DateWithThreeTextField(
                        title: "Ref Date.",
                        widthRation: 0.24,
                        mainTextController: TextEditingController()),
                    InputFields.formField1(
                        hintTxt: "Deal No",
                        controller: TextEditingController(),
                        width: 0.24),
                    InputFields.formField1(
                        hintTxt: "Pay Route",
                        controller: TextEditingController(),
                        width: 0.24),
                    DateWithThreeTextField(
                        title: "B/K Date.",
                        widthRation: 0.24,
                        mainTextController: TextEditingController()),
                    InputFields.formField1(
                        hintTxt: "Zone",
                        controller: TextEditingController(),
                        width: 0.24),
                    InputFields.formField1(
                        hintTxt: "Re-Sch No.",
                        controller: TextEditingController(),
                        width: 0.24),
                  ],
                ),
              ),
            ),
            Expanded(
                child: Container(
              child: Row(children: [
                Container(
                  width: Get.width * 0.50,
                  padding: EdgeInsets.only(
                    left: Get.width * 0.005,
                  ),
                  child: DataGridShowOnlyKeys(
                    mapData: dummyProgram,
                  ),
                ),
                Container(
                  width: Get.width * 0.50,
                  padding: EdgeInsets.only(
                    right: Get.width * 0.005,
                  ),
                  child: DataGridShowOnlyKeys(
                    mapData: dummyProgram,
                  ),
                ),
              ]),
            )),
            Padding(
              padding: EdgeInsets.only(
                left: Get.width * 0.005,
              ),
              child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.check_box_outline_blank_outlined),
                    Text("Change Tape ID")
                  ]),
            ),
            GetBuilder<HomeController>(
                id: "buttons",
                init: Get.find<HomeController>(),
                builder: (btncontroller) {
                  /* PermissionModel formPermissions = Get.find<MainController>()
                      .permissionList!
                      .lastWhere((element) {
                    return element.appFormName == "frmSegmentsDetails";
                  });*/

                  return Card(
                    margin: EdgeInsets.fromLTRB(4, 4, 4, 0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10)),
                    ),
                    child: Container(
                      width: Get.width,
                      padding: const EdgeInsets.all(8.0),
                      child: Wrap(
                        spacing: 10,
                        // buttonHeight: 20,
                        alignment: WrapAlignment.start,
                        // mainAxisSize: MainAxisSize.max,
                        // pa
                        children: [
                          for (var btn in btncontroller.buttons!)
                            btn["name"] == "Save"
                                ? FormButtonWrapper(
                                    btnText: btn["name"],

                                    // isEnabled: btn['isDisabled'],
                                    callback: () {},
                                  )
                                : btn["name"] == "Clear"
                                    ? FormButtonWrapper(
                                        btnText: btn["name"],

                                        // isEnabled: btn['isDisabled'],
                                        callback: () {
                                          btncontroller.clearPage1();
                                        },
                                      )
                                    : FormButtonWrapper(
                                        btnText: btn["name"],
                                        // isEnabled: btn['isDisabled'],
                                        callback: null,
                                      ),
                        ],
                      ),
                    ),
                  );
                }),
          ],
        ));
  }
}
