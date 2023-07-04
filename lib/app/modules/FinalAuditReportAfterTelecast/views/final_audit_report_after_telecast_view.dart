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

import '../../../providers/Utils.dart';
import '../controllers/final_audit_report_after_telecast_controller.dart';

class FinalAuditReportAfterTelecastView extends GetView<FinalAuditReportAfterTelecastController> {
  const FinalAuditReportAfterTelecastView({Key? key}) : super(key: key);
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
                  Obx(() {
                    return DropDownField.formDropDown1WidthMap(
                      controller.locationList.value,
                      controller.getChannels,
                      "Location",
                      0.24,
                      selected: controller.selectedLocation,
                      inkWellFocusNode: controller.locationFN,
                      autoFocus: true,
                    );
                  }),
                  Obx(() {
                    return DropDownField.formDropDown1WidthMap(
                      controller.channelList.value,
                      (data) => controller.selectedChannel = data,
                      "Channel",
                      0.24,
                      selected: controller.selectedChannel,
                    );
                  }),
                  DateWithThreeTextField(
                    title: "From Date.",
                    widthRation: 0.12,
                    mainTextController: controller.fromTC,
                  ),
                  DateWithThreeTextField(
                    title: "To Date.",
                    widthRation: 0.12,
                    mainTextController: controller.toTC,
                  ),
                  FormButtonWrapper(
                    btnText: "Report",
                    callback: controller.handleReportTap,
                  )
                ],
              ),
            ),
          ),
          Expanded(
            child: Obx(
              () {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  decoration: controller.dataTBList.isEmpty
                      ? BoxDecoration(
                          border: Border.all(
                            color: Colors.grey,
                          ),
                        )
                      : null,
                  child: controller.dataTBList.isEmpty
                      ? null
                      : DataGridShowOnlyKeys(
                          mapData: controller.dataTBList.value,
                          formatDate: false,
                          exportFileName: "Final Audit Report (After Telecast)",
                        ),
                );
              },
            ),
          ),
          // GetBuilder<HomeController>(
          //     id: "buttons",
          //     init: Get.find<HomeController>(),
          //     builder: (btncontroller) {
          //       if (btncontroller.buttons == null) {
          //         return Container();
          //       }
          //       return Card(
          //         margin: EdgeInsets.fromLTRB(4, 4, 4, 0),
          //         shape: RoundedRectangleBorder(
          //           borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
          //         ),
          //         child: Container(
          //           width: Get.width,
          //           padding: const EdgeInsets.all(8.0),
          //           child: Wrap(
          //             spacing: 10,
          //             // buttonHeight: 20,
          //             alignment: WrapAlignment.start,
          //             // mainAxisSize: MainAxisSize.max,
          //             // pa
          //             children: [
          //               for (var btn in btncontroller.buttons!)
          //                 btn["name"] == "Save"
          //                     ? FormButtonWrapper(
          //                         btnText: btn["name"],

          //                         // isEnabled: btn['isDisabled'],
          //                         callback: () {},
          //                       )
          //                     : btn["name"] == "Clear"
          //                         ? FormButtonWrapper(
          //                             btnText: btn["name"],

          //                             // isEnabled: btn['isDisabled'],
          //                             callback: controller.clearPage,
          //                           )
          //                         : FormButtonWrapper(
          //                             btnText: btn["name"],
          //                             // isEnabled: btn['isDisabled'],
          //                             callback: null,
          //                           ),
          //             ],
          //           ),
          //         ),
          //       );
          //     }),
          /// bottom common buttons
          Align(
            alignment: Alignment.topLeft,
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
                          for (var btn in btncontroller.buttons!) ...{
                            FormButtonWrapper(
                              btnText: btn["name"],
                              callback: ((Utils.btnAccessHandler(btn['name'], controller.formPermissions!) == null))
                                  ? null
                                  : () => controller.formHandler(btn['name']),
                            )
                          },
                          // for (var btn in btncontroller.buttons!)
                          //   FormButtonWrapper(
                          //     btnText: btn["name"],
                          //     callback: () => controller.formHandler(btn['name'].toString()),
                          //   ),
                        ],
                      ),
                    );
                  }
                  return Container();
                }),
          ),
        ],
      ),
    );
  }
}
