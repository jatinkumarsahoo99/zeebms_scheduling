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
                        controller: TextEditingController(),
                        width: 0.24,
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          ...[
                            "Trai Promo",
                            "Channel Specfic",
                          ]
                              .map((e) => Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        e,
                                        style: TextStyle(fontSize: SizeDefine.labelSize1 + 1),
                                      ),
                                      Checkbox(value: false, onChanged: (value) {})
                                    ],
                                  ))
                              .toList(),
                          InputFields.formField1(
                            hintTxt: "SAP Category",
                            controller: TextEditingController(),
                            width: 0.09,
                          ),
                        ],
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
                    ])))));
  }
}
