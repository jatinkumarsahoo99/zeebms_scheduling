import 'package:bms_scheduling/app/controller/HomeController.dart';
import 'package:bms_scheduling/app/providers/Const.dart';
import 'package:bms_scheduling/app/providers/SizeDefine.dart';
import 'package:bms_scheduling/widgets/FormButton.dart';
import 'package:bms_scheduling/widgets/input_fields.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/promo_type_master_controller.dart';

class PromoTypeMasterView extends GetView<PromoTypeMasterController> {
  const PromoTypeMasterView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[200],
        body: Center(
            child: SizedBox(
                width: Get.width * .64,
                child: Dialog(
                    backgroundColor: Colors.grey[100],
                    child: Column(crossAxisAlignment: CrossAxisAlignment.center, mainAxisSize: MainAxisSize.min, children: [
                      AppBar(
                        title: Text('Promo Type Master'),
                        centerTitle: true,
                        backgroundColor: Colors.deepPurple,
                      ),
                      SizedBox(height: 20),
                      InputFields.formField1(
                        hintTxt: "Program Name",
                        controller: controller.promTypeNameCtrl,
                        focusNode: controller.promoFocusNode,
                        width: 0.48,
                      ),
                      SizedBox(height: 20),
                      SizedBox(
                        width: Get.width * 0.48,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  "Trai Promo",
                                  style: TextStyle(fontSize: SizeDefine.labelSize1 + 1),
                                ),
                                Obx(() => Checkbox(
                                    value: controller.trailPromo.value,
                                    onChanged: (value) {
                                      controller.trailPromo.value = value!;
                                    }))
                              ],
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  "Channel Specfic",
                                  style: TextStyle(fontSize: SizeDefine.labelSize1 + 1),
                                ),
                                Obx(() => Checkbox(
                                    value: controller.channelSpec.value,
                                    onChanged: (value) {
                                      controller.channelSpec.value = value!;
                                    }))
                              ],
                            ),
                            InputFields.formField1(
                              hintTxt: "SAP Category",
                              controller: controller.sapCategory,
                              width: 0.09,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
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
                                              callback: () => btnHandler(btn["name"]),
                                            )
                                        ],
                                      ),
                                    ),
                                  );
                          })
                    ])))));
  }

  btnHandler(btnName) {
    switch (btnName) {
      case "Delete":
        null;
        break;
      case "Clear":
        Get.delete<PromoTypeMasterController>();
        Get.find<HomeController>().clearPage1();
        break;
      case "Save":
        controller.saveData();
        break;
      default:
    }
  }
}
