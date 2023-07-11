import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../../widgets/FormButton.dart';
import '../../../../widgets/dropdown.dart';
import '../../../../widgets/gridFromMap.dart';
import '../../../controller/HomeController.dart';
import '../../../providers/Utils.dart';
import '../controllers/language_master_controller.dart';

class LanguageMasterView extends GetView<LanguageMasterController> {
  const LanguageMasterView({Key? key}) : super(key: key);
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
              /// controllers
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
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
                  SizedBox(width: 10),
                  Obx(() {
                    return DropDownField.formDropDown1WidthMap(
                      controller.channelList.value,
                      (v) => controller.selectedChannel = v,
                      "Chaneel",
                      .16,
                      selected: controller.selectedChannel,
                    );
                  }),
                  SizedBox(width: 10),
                  FormButton(btnText: "Generate"),
                ],
              ),
              SizedBox(height: 10),
              Expanded(
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
