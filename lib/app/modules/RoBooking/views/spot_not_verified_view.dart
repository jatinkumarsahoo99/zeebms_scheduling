import 'package:bms_scheduling/app/controller/MainController.dart';
import 'package:bms_scheduling/app/data/DropDownValue.dart';
import 'package:bms_scheduling/app/modules/RoBooking/controllers/ro_booking_controller.dart';
import 'package:bms_scheduling/widgets/DataGridShowOnly.dart';
import 'package:bms_scheduling/widgets/DateTime/DateWithThreeTextField.dart';
import 'package:bms_scheduling/widgets/FormButton.dart';
import 'package:bms_scheduling/widgets/dropdown.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../data/user_data_settings_model.dart';
import 'dummydata.dart';

class SpotNotVerifiedView extends GetView<RoBookingController> {
  SpotNotVerifiedView({Key? key}) : super(key: key);
  //Spot Not Verify is View Only Thats why variable define here instead of controller to aviod confusion with main location, channel and date
  TextEditingController effectdateController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: Get.find<RoBookingController>(),
        builder: (context) {
          return Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  DropDownField.formDropDown1WidthMap(
                    controller.roBookingInitData!.lstVerifiedLoationChannel!
                        .lVerifiedLocations!
                        .map((e) => DropDownValue(
                            key: e.locationcode, value: e.locationname))
                        .toList(),
                    (value) => {
                      controller.selectedLocationSpot = value,
                    },
                    "Location",
                    0.24,
                    dialogHeight: Get.height / 3,
                    selected: controller.selectedLocationSpot,
                  ),
                  DropDownField.formDropDown1WidthMap(
                    controller.roBookingInitData!.lstVerifiedLoationChannel!
                        .lVerifiedChannel!
                        .map((e) => DropDownValue(
                            key: e.channelCode, value: e.channelName))
                        .toList(),
                    dialogHeight: Get.height / 3,
                    (value) => {
                      controller.selectedChannelSpot = value,
                    },
                    "Channel",
                    0.24,
                    selected: controller.selectedChannelSpot,
                  ),
                  DateWithThreeTextField(
                      title: "FPC Eff. Dt.",
                      widthRation: 0.12,
                      mainTextController: effectdateController),
                  FormButtonWrapper(
                    btnText: "Spot Not Verified",
                    iconDataM: Icons.cancel_presentation_outlined,
                    callback: () {
                      controller.getSpotNotVerified(
                          controller.selectedLocationSpot?.key ?? "",
                          controller.selectedChannelSpot?.key ?? "",
                          effectdateController.text.split("-")[2] +
                              effectdateController.text.split("-")[1],
                          Get.find<MainController>().user?.logincode ?? "");
                      // controller.getSpotsNotVerified(
                      //     selectedLocation!.key, selectedChannel!.key, effectdateController.text.split("-")[2] + effectdateController.text.split("-")[1]);
                    },
                  ),
                  SizedBox(width: 5)
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Expanded(
                  child: Container(
                child: Obx(() => controller.spotsNotVerified.value.isNotEmpty
                    ? DataGridShowOnlyKeys(
                        mapData: controller.spotsNotVerified.value
                            .map((e) => e.toJson())
                            .toList(),
                        formatDate: false,
                        onRowDoubleTap: (rowEvent) {
                          controller.spotNotVerifiedGrid
                              ?.setCurrentCell(rowEvent.cell, rowEvent.rowIdx);
                          controller.spotnotverifiedclick(rowEvent.rowIdx);
                        },
                        onload: (sm) {
                          controller.spotNotVerifiedGrid = sm.stateManager;
                        },
                        keysWidths: (controller.userDataSettings?.userSetting
                            ?.firstWhere(
                                (element) =>
                                    element.controlName ==
                                    "spotNotVerifiedGrid",
                                orElse: () => UserSetting())
                            .userSettings),
                      )
                    : Container(
                        decoration: BoxDecoration(
                            border: Border.all(width: 1.0, color: Colors.grey)),
                      )),
              ))
            ],
          );
        });
  }
}
