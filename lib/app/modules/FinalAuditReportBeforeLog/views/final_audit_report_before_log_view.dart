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

import '../../../../widgets/CheckBoxWidget.dart';
import '../../../data/user_data_settings_model.dart';
import '../../../providers/Utils.dart';
import '../controllers/final_audit_report_before_log_controller.dart';

class FinalAuditReportBeforeLogView
    extends GetView<FinalAuditReportBeforeLogController> {
  const FinalAuditReportBeforeLogView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: ColorData.scaffoldBg,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
                  Obx(
                    () => CheckBoxWidget1(
                      title: 'Standby Log',
                      value: controller.standByLog.value,
                      onChanged: (p0) {
                        controller.standByLog.value = p0 ?? false;
                      },
                    ),
                  ),
                  DateWithThreeTextField(
                    title: "Eff Date.",
                    widthRation: 0.12,
                    mainTextController: controller.efficitveDateTC,
                    onFocusChange: (date) => controller.handleReportTap(),
                  ),
                  InputFields.formFieldNumberMask(
                    hintTxt: "Start Time",
                    controller: controller.startTimeTC,
                    widthRatio: 0.12,
                    isTime: true,
                    paddingLeft: 0,
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Obx(
              () {
                return Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
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
                          keysWidths: (controller.userDataSettings?.userSetting
                              ?.firstWhere(
                                  (element) =>
                                      element.controlName == "stateManager",
                                  orElse: () => UserSetting())
                              .userSettings),
                          onload: (sm) {
                            controller.stateManager = sm.stateManager;
                          },
                          mapData: controller.dataTBList.value,
                          formatDate: false,
                          exportFileName:
                              "Final Audit Report (Before Telecast)",
                        ),
                );
              },
            ),
          ),

          /// bottom common buttons
          Padding(
            padding: const EdgeInsets.only(top: 10, left: 10),
            child: GetBuilder<HomeController>(
                id: "buttons",
                init: Get.find<HomeController>(),
                builder: (btncontroller) {
                  if (btncontroller.buttons != null) {
                    return Wrap(
                      spacing: 5,
                      runSpacing: 15,
                      alignment: WrapAlignment.center,
                      children: [
                        for (var btn in btncontroller.buttons!) ...{
                          FormButtonWrapper(
                            btnText: btn["name"],
                            callback: ((Utils.btnAccessHandler(btn['name'],
                                        controller.formPermissions!) ==
                                    null))
                                ? null
                                : () => controller.formHandler(btn['name']),
                          )
                        },
                      ],
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
