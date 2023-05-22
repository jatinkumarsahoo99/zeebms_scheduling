import 'package:bms_scheduling/app/modules/RoBooking/views/dummydata.dart';
import 'package:bms_scheduling/widgets/DataGridShowOnly.dart';
import 'package:bms_scheduling/widgets/DateTime/DateWithThreeTextField.dart';
import 'package:bms_scheduling/widgets/FormButton.dart';
import 'package:bms_scheduling/widgets/dropdown.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../controller/HomeController.dart';
import '../controllers/ros_distribution_controller.dart';

class RosDistributionView extends GetView<RosDistributionController> {
  const RosDistributionView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[200],
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Container(
                padding: const EdgeInsets.all(8),
                width: Get.width,
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.end,
                  alignment: WrapAlignment.spaceBetween,
                  spacing: 10,
                  children: [
                    DropDownField.formDropDown1WidthMap(
                        [], (data) {}, "Location", 0.12),
                    DropDownField.formDropDown1WidthMap(
                        [], (data) {}, "Channel", 0.18),
                    DateWithThreeTextField(
                        widthRation: 0.12,
                        title: "Cancel Date",
                        mainTextController: TextEditingController()),
                    for (var btn in controller.topButtons)
                      FormButtonWrapper(
                        btnText: btn["name"],
                        callback: btn["callback"],
                      )
                  ],
                ),
              ),
            ),
            Expanded(
                child: Container(
              padding: const EdgeInsets.all(4),
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

                  return Card(
                    margin: const EdgeInsets.fromLTRB(4, 4, 4, 0),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10)),
                    ),
                    clipBehavior: Clip.hardEdge,
                    child: Container(
                      width: Get.width,
                      padding: EdgeInsets.all(Get.width * 0.005),
                      child: Obx(
                        () => Wrap(
                          // buttonHeight: 20,
                          alignment: WrapAlignment.start,
                          spacing: 10,
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
                            for (var checkBox in controller.checkBoxes)
                              InkWell(
                                onTap: () {
                                  controller.checkBoxes[controller.checkBoxes
                                          .indexOf(checkBox)]["value"] =
                                      !(controller.checkBoxes[controller
                                              .checkBoxes
                                              .indexOf(checkBox)]["value"]!
                                          as bool);

                                  controller.checkBoxes.refresh();
                                },
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(checkBox["value"] as bool
                                        ? Icons.check_box_rounded
                                        : Icons.check_box_outline_blank),
                                    Text(checkBox["name"].toString())
                                  ],
                                ),
                              )
                          ],
                        ),
                      ),
                    ),
                  );
                }),
          ],
        ));
  }
}
