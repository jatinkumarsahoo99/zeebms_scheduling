import 'package:bms_scheduling/app/modules/RoBooking/views/dummydata.dart';
import 'package:bms_scheduling/widgets/DataGridShowOnly.dart';
import 'package:bms_scheduling/widgets/DateTime/DateWithThreeTextField.dart';
import 'package:bms_scheduling/widgets/FormButton.dart';
import 'package:bms_scheduling/widgets/dropdown.dart';
import 'package:bms_scheduling/widgets/input_fields.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../controller/HomeController.dart';
import '../controllers/ro_cancellation_controller.dart';

class RoCancellationView extends GetView<RoCancellationController> {
  const RoCancellationView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            margin: EdgeInsets.all(8),
            // decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
            child: Container(
              width: Get.width,
              padding: const EdgeInsets.all(8.0),
              child: Wrap(
                alignment: WrapAlignment.start,
                spacing: Get.width * 0.01,
                runSpacing: 5,
                crossAxisAlignment: WrapCrossAlignment.end,
                children: [
                  Obx(
                    () => DropDownField.formDropDown1WidthMap(
                        controller.locations.value, (value) {
                      controller.selectedLocation = value;
                      controller.getChannel(value.key);
                    }, "Location", 0.12),
                  ),
                  Obx(
                    () => DropDownField.formDropDown1WidthMap(
                        controller.channels.value, (value) {
                      controller.selectedChannel = value;
                    }, "Channel", 0.24),
                  ),
                  DateWithThreeTextField(
                      widthRation: 0.12,
                      title: "Cancel Date",
                      mainTextController: TextEditingController()),
                  DateWithThreeTextField(
                      widthRation: 0.12,
                      title: "Eff. Date",
                      mainTextController: TextEditingController()),
                  InputFields.formField1(
                      hintTxt: "Reference",
                      controller: TextEditingController()),
                  InputFields.formField1(
                      hintTxt: "Booking No",
                      controller: TextEditingController()),
                  InputFields.formField1(
                      width: 0.24,
                      hintTxt: "Client",
                      controller: TextEditingController()),
                  InputFields.formField1(
                      width: 0.24,
                      hintTxt: "Agency",
                      controller: TextEditingController()),
                  InputFields.formField1(
                      width: 0.24,
                      hintTxt: "Brand",
                      controller: TextEditingController()),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.check_box_outline_blank_outlined),
                      Text("Select All Sports"),
                    ],
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
            child: Container(
              width: Get.width,
              height: 40,
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: BorderDirectional(
                      start: BorderSide(color: Colors.grey[400]!),
                      end: BorderSide(color: Colors.grey[400]!),
                      top: BorderSide(color: Colors.grey[400]!),
                      bottom: BorderSide.none)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text("Total Spots: 13"),
                  Text("Total Duration: 00:09:30:00"),
                  Text("Total Amount: 1200"),
                  Text("Total Val. Amount: 1150"),
                ],
              ),
            ),
          ),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: BorderDirectional(
                    start: BorderSide(color: Colors.grey[400]!),
                    end: BorderSide(color: Colors.grey[400]!),
                    top: BorderSide.none,
                    bottom: BorderSide(color: Colors.grey[400]!),
                  )),
              child: Row(
                children: [
                  Container(
                    width: Get.width * .9,
                    child: DataGridShowOnlyKeys(mapData: dummyProgram),
                  ),
                  SizedBox(
                    width: 3,
                  ),
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        FormButtonWrapper(
                          width: Get.width * 0.07,
                          btnText: "Import",
                          callback: () {},
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        FormButtonWrapper(
                          width: Get.width * 0.07,
                          btnText: "OK",
                          callback: () {},
                        ),
                      ],
                    ),
                  )
                ],
              ),
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

                return Container(
                  height: 40,
                  child: ButtonBar(
                    // buttonHeight: 20,
                    alignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
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
                );
              }),
          // GetBuilder<HomeController>(
          //     id: "buttons",
          //     init: Get.find<HomeController>(),
          //     builder: (btncontroller) {
          //       /* PermissionModel formPermissions = Get.find<MainController>()
          //             .permissionList!
          //             .lastWhere((element) {
          //           return element.appFormName == "frmSegmentsDetails";
          //         });*/

          //       return Container(
          //         height: 40,
          //         child: ButtonBar(
          //           // buttonHeight: 20,
          //           alignment: MainAxisAlignment.start,
          //           mainAxisSize: MainAxisSize.min,
          //           // pa
          //           children: [
          //             for (var btn in btncontroller.buttons!)
          //               btn["name"] == "Save"
          //                   ? Obx(() => FormButtonWrapper(
          //                         btnText: btn["name"],

          //                         // isEnabled: btn['isDisabled'],
          //                         callback: () {},
          //                       ))
          //                   : btn["name"] == "Clear"
          //                       ? FormButtonWrapper(
          //                           btnText: btn["name"],

          //                           // isEnabled: btn['isDisabled'],
          //                           callback: () {
          //                             btncontroller.clearPage1();
          //                           },
          //                         )
          //                       : FormButtonWrapper(
          //                           btnText: btn["name"],

          //                           // isEnabled: btn['isDisabled'],
          //                           callback: null,
          //                         ),
          //           ],
          //         ),
          //       );
          //     }),
        ],
      ),
    );
  }
}
