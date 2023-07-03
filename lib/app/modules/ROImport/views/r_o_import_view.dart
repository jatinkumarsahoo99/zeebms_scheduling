import 'package:bms_scheduling/widgets/gridFromMap.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../../widgets/FormButton.dart';
import '../../../../widgets/dropdown.dart';
import '../../../controller/HomeController.dart';
import '../../../providers/Utils.dart';
import '../controllers/r_o_import_controller.dart';

class ROImportView extends GetView<ROImportController> {
  const ROImportView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: context.width,
        height: context.height,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Obx(() {
                    return DropDownField.formDropDown1WidthMap(
                      controller.locationList.value,
                      controller.handleOnChangedLocation,
                      "Location",
                      .235,
                      autoFocus: true,
                      selected: controller.selectedLocation,
                      inkWellFocusNode: controller.locationFn,
                    );
                  }),
                  SizedBox(width: 25),
                  Obx(() {
                    return DropDownField.formDropDown1WidthMap(
                      controller.channelList.value,
                      (v) => controller.selectedChannel = v,
                      "Channel",
                      .235,
                      selected: controller.selectedChannel,
                    );
                  }),
                  SizedBox(width: 20),
                  FormButton(
                    btnText: "Import",
                    callback: controller.handleImportTap,
                  )
                ],
              ),
              SizedBox(height: 10),

              Expanded(
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    /// left-datagrid
                    Obx(() {
                      return SizedBox(
                        width: (context.width / 2) - 20,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Text(
                              controller.leftMsg.value,
                              style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Expanded(
                              child: Container(
                                decoration: controller.topLeftDataTable.isEmpty
                                    ? BoxDecoration(
                                        border: Border.all(
                                          color: Colors.grey,
                                        ),
                                      )
                                    : null,
                                child: controller.topLeftDataTable.isNotEmpty ? DataGridFromMap(mapData: controller.topLeftDataTable.value) : null,
                              ),
                            )
                          ],
                        ),
                      );
                    }),

                    SizedBox(width: 10),

                    /// right-datagrid
                    Obx(() {
                      return SizedBox(
                        width: (context.width / 2) - 20,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Text(
                              controller.rightMsg.value,
                              style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Expanded(
                              child: Container(
                                decoration: controller.topRightDataTable.isEmpty
                                    ? BoxDecoration(
                                        border: Border.all(
                                          color: Colors.grey,
                                        ),
                                      )
                                    : null,
                                child: controller.topRightDataTable.isNotEmpty ? DataGridFromMap(mapData: controller.topRightDataTable.value) : null,
                              ),
                            )
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),
              SizedBox(height: 10),

              /// bottom-datagrid
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),

              /// bottom common buttons
              GetBuilder<HomeController>(
                  id: "buttons",
                  init: Get.find<HomeController>(),
                  builder: (btncontroller) {
                    if (btncontroller.buttons != null) {
                      return Wrap(
                        spacing: 5,
                        runSpacing: 5,
                        alignment: WrapAlignment.start,
                        children: [
                          for (var btn in btncontroller.buttons!) ...{
                            FormButtonWrapper(
                              btnText: btn["name"],
                              callback: ((Utils.btnAccessHandler(btn['name'], controller.formPermissions!) == null))
                                  ? (btn["name"] == "Clear")
                                      ? () => controller.formHandler(btn['name'])
                                      : null
                                  : () => controller.formHandler(btn['name']),
                            )
                          },
                        ],
                      );
                    }
                    return SizedBox();
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
