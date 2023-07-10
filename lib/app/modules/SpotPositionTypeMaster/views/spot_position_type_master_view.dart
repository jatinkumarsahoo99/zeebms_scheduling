import 'package:bms_scheduling/app/controller/HomeController.dart';
import 'package:bms_scheduling/widgets/FormButton.dart';
import 'package:bms_scheduling/widgets/dropdown.dart';
import 'package:bms_scheduling/widgets/input_fields.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/spot_position_type_master_controller.dart';

class SpotPositionTypeMasterView extends GetView<SpotPositionTypeMasterController> {
  const SpotPositionTypeMasterView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SponserTypeMasterView'),
        centerTitle: true,
      ),
      body: Center(
          child: SizedBox(
              width: Get.width * .64,
              child: Dialog(
                  backgroundColor: Colors.grey[100],
                  child: Column(crossAxisAlignment: CrossAxisAlignment.center, mainAxisSize: MainAxisSize.min, children: [
                    AppBar(
                      title: Text('Spot Position Type Master'),
                      centerTitle: true,
                      backgroundColor: Colors.deepPurple,
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.end,
                      spacing: Get.width * 0.01,
                      runSpacing: 10,
                      children: [
                        InputFields.formField1(
                          hintTxt: "Spot Type Pos. Name",
                          controller: TextEditingController(),
                          width: 0.36,
                        ),
                        InputFields.formField1(
                          hintTxt: "Spot Type Short Name",
                          controller: TextEditingController(),
                          width: 0.175,
                        ),
                        InputFields.formField1(
                          hintTxt: "Log Position",
                          controller: TextEditingController(),
                          width: 0.175,
                        ),
                        DropDownField.formDropDown1WidthMap([], (value) => {}, "Spot In Log", 0.175),
                        InputFields.formField1(
                          hintTxt: "Program Name",
                          controller: TextEditingController(),
                          width: 0.175,
                        ),
                        InputFields.formField1(
                          hintTxt: "Spot Position Premium ",
                          controller: TextEditingController(),
                          width: 0.175,
                        ),
                        SizedBox(
                          width: Get.width * 0.175,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [Text("Break No Applicable"), Icon(Icons.check_box_outlined)],
                          ),
                        ),
                        SizedBox(
                          width: Get.width * 0.175,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [Text("Position No Applicable"), Icon(Icons.check_box_outlined)],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15,
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

                          return btncontroller.buttons == null
                              ? Container()
                              : Card(
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
                                          btn["name"] == "Docs"
                                              ? FormButtonWrapper(
                                                  btnText: btn["name"],
                                                  // isEnabled: btn['isDisabled'],
                                                  callback: () {
                                                    // Get.defaultDialog(
                                                    //   title: "Documents",
                                                    //   content: CommonDocsView(
                                                    //       documentKey:
                                                    //           "RObooking${controller.selectedLocation!.key}${controller.selectedChannel!.key}${controller.bookingMonthCtrl.text}${controller.bookingNoCtrl.text}"),
                                                    // ).then((value) {
                                                    //   Get.delete<CommonDocsController>(tag: "commonDocs");
                                                    // });
                                                  },
                                                )
                                              : btn["name"] == "Save"
                                                  ? FormButtonWrapper(
                                                      btnText: btn["name"],
                                                      // isEnabled: btn['isDisabled'],
                                                      callback: () {
                                                        // controller.saveCheck();
                                                      },
                                                    )
                                                  : btn["name"] == "Clear"
                                                      ? FormButtonWrapper(
                                                          btnText: btn["name"],

                                                          // isEnabled: btn['isDisabled'],
                                                          callback: () {},
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
                        })
                  ])))),
    );
  }
}
