import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../../widgets/DateTime/DateWithThreeTextField.dart';
import '../../../../widgets/FormButton.dart';
import '../../../../widgets/dropdown.dart';
import '../../../../widgets/gridFromMap.dart';
import '../../../controller/HomeController.dart';
import '../../../providers/Utils.dart';
import '../controllers/sales_audit_extra_spots_report_controller.dart';

class SalesAuditExtraSpotsReportView extends GetView<SalesAuditExtraSpotsReportController> {
  const SalesAuditExtraSpotsReportView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: context.width,
        height: context.height,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                        child: Column(
                      // crossAxisAlignment: CrossAxisAlignment.center,
                      // mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Obx(() {
                          return DropDownField.formDropDown1WidthMap(
                            controller.locationList.value,
                            controller.handleOnChangedLocation,
                            "Location",
                            .23,
                            autoFocus: true,
                            selected: controller.selectedLocation,
                            inkWellFocusNode: controller.locationFn,
                          );
                        }),
                        SizedBox(height: 20),
                        Obx(() {
                          return DropDownField.formDropDown1WidthMap(
                            controller.channelList.value,
                            (v) => controller.selectedChannel = v,
                            "Channel",
                            .23,
                            selected: controller.selectedChannel,
                          );
                        }),
                        SizedBox(height: 20),
                        DateWithThreeTextField(
                          title: "From Date",
                          mainTextController: controller.fromDateIDCtr,
                          widthRation: .225,
                        ),
                        SizedBox(height: 20),
                        DateWithThreeTextField(
                          title: "To Date",
                          mainTextController: controller.toDateCtr,
                          widthRation: .225,
                        ),
                        SizedBox(height: 30),
                        SizedBox(
                          width: context.width * .225,
                          child: FormButton(
                            btnText: "Generate",
                            callback: controller.generateData,
                          ),
                        )
                      ],
                    )),
                    SizedBox(width: 10),
                    Expanded(
                      flex: 3,
                      child: Obx(
                        () {
                          return controller.dataTBList.value.isEmpty
                              ? Container(
                                  decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
                                )
                              : DataGridFromMap(
                                  mapData: controller.dataTBList.value.map((e) => e.toJson()).toList(),
                                  formatDate: false,
                                );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),

              /// Commom Buttons
              Align(
                alignment: Alignment.bottomLeft,
                child: GetBuilder<HomeController>(
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
                                callback: ((Utils.btnAccessHandler(btn['name'], controller.formPermissions!) == null))
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
        ),
      ),
    );
  }
}
