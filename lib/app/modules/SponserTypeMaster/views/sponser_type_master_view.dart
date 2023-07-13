import 'package:bms_scheduling/app/controller/HomeController.dart';
import 'package:bms_scheduling/app/data/DropDownValue.dart';
import 'package:bms_scheduling/widgets/FormButton.dart';
import 'package:bms_scheduling/widgets/dropdown.dart';
import 'package:bms_scheduling/widgets/input_fields.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/sponser_type_master_controller.dart';

class SponserTypeMasterView extends GetView<SponserTypeMasterController> {
  SponserTypeMasterView({Key? key}) : super(key: key);
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
                      title: Text('Sposner Type Master'),
                      centerTitle: true,
                      backgroundColor: Colors.deepPurple,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Wrap(
                      spacing: Get.width * 0.01,
                      children: [
                        InputFields.formField1(
                            hintTxt: "Sponser", controller: controller.sponserName, width: 0.36, focusNode: controller.sponserNameFocus),
                        InputFields.formField1(
                          hintTxt: "Short Name",
                          controller: controller.shortName,
                          width: 0.36,
                        ),
                        InputFields.formField1(
                          hintTxt: "Premium",
                          controller: controller.premium,
                          width: 0.175,
                        ),
                        Obx(() => DropDownField.formDropDown1WidthMap([
                              DropDownValue(key: "M", value: "Multiple"),
                              DropDownValue(key: "S", value: "Single")
                            ], (value) => {}, "Sponser Type", 0.175, selected: controller.selectedSponser.value)),
                      ],
                    ),
                    SizedBox(
                      height: 10,
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
                                          FormButtonWrapper(
                                            btnText: btn["name"],
                                            // isEnabled: btn['isDisabled'],
                                            callback: () => btnhandler(btn["name"]),
                                          )
                                      ],
                                    ),
                                  ),
                                );
                        })
                  ])))),
    );
  }

  btnhandler(btnName) {
    switch (btnName) {
      case "Save":
        controller.saveData();
        break;
      default:
    }
  }
}
