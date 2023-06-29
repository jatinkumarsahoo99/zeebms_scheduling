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
                    callback: () {},
                  )
                ],
              ),
              SizedBox(height: 10),

              Expanded(
                child: Row(
                  children: [
                    /// left-datagrid
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),

                    /// right-datagrid
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
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
                                  ? null
                                  : () => controller.formHandler(btn['name']),
                            )
                          },
                        ],
                      );
                    }
                    return Container();
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
