import 'package:bms_scheduling/widgets/CheckBoxWidget.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../../widgets/DateTime/DateWithThreeTextField.dart';
import '../../../../widgets/FormButton.dart';
import '../../../../widgets/dropdown.dart';
import '../../../../widgets/gridFromMap.dart';
import '../../../../widgets/radio_row.dart';
import '../../../controller/HomeController.dart';
import '../../../providers/Utils.dart';
import '../controllers/inventory_status_report_controller.dart';

class InventoryStatusReportView extends GetView<InventoryStatusReportController> {
  const InventoryStatusReportView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: context.width,
        height: context.height,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Expanded(
                child: Row(
                  children: [
                    ///
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Obx(() {
                            return DropDownField.formDropDown1WidthMap(
                              controller.locationList.value,
                              (v) => controller.selectedLocation = v,
                              "Location",
                              .16,
                              autoFocus: true,
                              selected: controller.selectedLocation,
                              inkWellFocusNode: controller.locationFN,
                            );
                          }),
                          SizedBox(height: 10),
                          CheckBoxWidget1(
                            title: "Channel",
                            value: true,
                          ),
                          SizedBox(height: 10),
                          Container(
                            height: context.height * .3,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey,
                              ),
                            ),
                            child: ListView.builder(
                              itemCount: controller.channelList.value.length,
                              itemBuilder: (context, index) {
                                return CheckBoxWidget1(
                                  title: controller.channelList.value[index].channelName ?? "",
                                  value: controller.channelList.value[index].ischecked ?? false,
                                );
                              },
                            ),
                          ),
                          SizedBox(height: 10),
                          RadioRow(
                            items: ['Old Format', 'Detail (KAM-NON CAM)', 'Summary (KAM-NON KAM)'],
                            groupValue: 'items1',
                            isVertical: true,
                          ),
                          SizedBox(height: 10),
                          DateWithThreeTextField(
                            title: "From Date",
                            mainTextController: controller.fromDateTC,
                            widthRation: 0.17,
                          ),
                          const SizedBox(height: 10),
                          DateWithThreeTextField(
                            title: "To Date",
                            mainTextController: controller.toDateTC,
                            widthRation: 0.17,
                          ),
                          const Spacer(),
                          Row(
                            children: [
                              Expanded(child: FormButton(btnText: "Clear")),
                              SizedBox(width: 10),
                              Expanded(child: FormButton(btnText: "Exit")),
                            ],
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            width: context.width * 0.17,
                            child: FormButton(btnText: "Generate"),
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      flex: 5,
                      child: Obx(
                        () {
                          return Container(
                            decoration: controller.dataTableList.isEmpty
                                ? BoxDecoration(
                                    border: Border.all(
                                      color: Colors.grey,
                                    ),
                                  )
                                : null,
                            child: controller.dataTableList.isEmpty ? null : DataGridFromMap(mapData: controller.dataTableList.value),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),

              ///Common Buttons
              Align(
                alignment: Alignment.topLeft,
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
                              callback: ((Utils.btnAccessHandler(btn['name'], controller.formPermissions!) == null))
                                  ? null
                                  : () => controller.formHandler(btn['name']),
                            )
                          },
                        ],
                      );
                    }
                    return Container();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
