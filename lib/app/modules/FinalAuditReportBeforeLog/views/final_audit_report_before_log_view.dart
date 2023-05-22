import 'package:bms_scheduling/app/controller/HomeController.dart';
import 'package:bms_scheduling/app/modules/RoBooking/views/dummydata.dart';
import 'package:bms_scheduling/app/providers/ColorData.dart';
import 'package:bms_scheduling/widgets/DataGridShowOnly.dart';
import 'package:bms_scheduling/widgets/DateTime/DateWithThreeTextField.dart';
import 'package:bms_scheduling/widgets/FormButton.dart';
import 'package:bms_scheduling/widgets/dropdown.dart';
import 'package:bms_scheduling/widgets/input_fields.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/final_audit_report_before_log_controller.dart';

class FinalAuditReportBeforeLogView extends GetView<FinalAuditReportBeforeLogController> {
  const FinalAuditReportBeforeLogView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorData.scaffoldBg,
      body: Column(
        children: [
          Card(
            child: Container(
              padding: EdgeInsets.all(8),
              width: Get.width,
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.end,
                spacing: 10,
                // buttonHeight: 20,
                alignment: WrapAlignment.start,
                children: [
                  DropDownField.formDropDown1WidthMap([], (data) {}, "Location", 0.24),
                  DropDownField.formDropDown1WidthMap([], (data) {}, "Channel", 0.24),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [Icon(Icons.check_box_outlined), Text("Standby Log")],
                  ),
                  DateWithThreeTextField(title: "Eff Date.", widthRation: 0.12, mainTextController: TextEditingController()),
                  InputFields.formFieldNumberMask(
                      hintTxt: "Start Time", controller: TextEditingController(), widthRatio: 0.12, isTime: true, paddingLeft: 0),
                ],
              ),
            ),
          ),
          Expanded(
              child: Container(
            padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            child: DataGridShowOnlyKeys(
              mapData: dummydata,
              formatDate: false,
            ),
          )),
          GetBuilder<HomeController>(
              id: "buttons",
              init: Get.find<HomeController>(),
              builder: (btncontroller) {
                /* PermissionModel formPermissions = Get.find<MainController>()
                      .permissionList!
                      .lastWhere((element) {
                    return element.appFormName == "frmSegmentsDetails";
                  });*/
                if (btncontroller.buttons == null) {
                  return Container();
                }
                return Card(
                  margin: EdgeInsets.fromLTRB(4, 4, 4, 0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
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
      ),
    );
  }
}
