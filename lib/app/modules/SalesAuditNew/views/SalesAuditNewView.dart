import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../../widgets/DateTime/DateWithThreeTextField.dart';
import '../../../../widgets/FormButton.dart';
import '../../../../widgets/dropdown.dart';
import '../../../controller/HomeController.dart';
import '../../../controller/MainController.dart';
import '../../../data/PermissionModel.dart';
import '../../../providers/SizeDefine.dart';
import '../../../providers/Utils.dart';
import '../controllers/SalesAuditNewController.dart';

class SalesAuditNewView extends GetView<SalesAuditNewController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SalesAuditNewView'),
        centerTitle: true,
      ),
      body: SizedBox(
        height: double.maxFinite,
        width: double.maxFinite,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                children: [
                  GetBuilder<SalesAuditNewController>(
                    init: controller,
                    id: "updateView",
                    builder: (control) {
                      return Padding(
                        padding:
                            const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                        child: SizedBox(
                          width: double.maxFinite,
                          child: Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            runSpacing: 5,
                            spacing: 5,
                            children: [
                              Obx(
                                () => DropDownField.formDropDown1WidthMap(
                                  [],
                                  (value) {
                                    // controller.selectLocation = value;
                                    // controller.getChannels(
                                    //     controller.selectLocation?.key ?? "");
                                  },
                                  "Location",
                                  0.12,
                                  // isEnable: controller.isEnable.value,
                                  // selected: controller.selectLocation,
                                  autoFocus: true,
                                  dialogWidth: 330,
                                  dialogHeight: Get.height * .7,
                                ),
                              ),

                              /// channel
                              Obx(
                                () => DropDownField.formDropDown1WidthMap(
                                  [],
                                  (value) {
                                    // controller.selectChannel = value;
                                    // controller.getChannelFocusOut();
                                  },
                                  "Channel",
                                  0.12,
                                  // isEnable: controller.isEnable.value,
                                  // selected: controller.selectChannel,
                                  autoFocus: true,
                                  dialogWidth: 330,
                                  dialogHeight: Get.height * .7,
                                ),
                              ),

                              Obx(
                                () => DateWithThreeTextField(
                                  title: "Schedule Date",
                                  splitType: "-",
                                  widthRation: 0.12,
                                  // isEnable: controller.isEnable.value,
                                  onFocusChange: (data) {
                                    // controller.selectedDate.text =
                                    //     DateFormat('dd/MM/yyyy').format(
                                    //         DateFormat("dd-MM-yyyy").parse(data));
                                    // DateFormat("dd-MM-yyyy").parse(data);
                                    print("Called when focus changed");
                                    /*controller.getDailyFPCDetailsList(
                                        controller.selectedLocationId.text,
                                        controller.selectedChannelId.text,
                                        controller.convertToAPIDateType(),
                                      );*/

                                    // controller.isTableDisplayed.value = true;
                                  },
                                  mainTextController: TextEditingController(),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 14.0, left: 10, right: 10),
                                child: FormButtonWrapper(
                                  btnText: "Retrieve",
                                  callback: () {
                                    // controller.callRetrieve();
                                    // controller.getColorList();
                                  },
                                  showIcon: false,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  Row(
                    children: [
                    Expanded(child: Row(
                      mainAxisAlignment:MainAxisAlignment.spaceEvenly,
                      children: [
                        Text("Not Telacast Spots"),
                        SizedBox(
                          width: Get.width * 0.077,
                          child: Row(
                            children: [
                              SizedBox(width: 5),
                              Obx(() =>
                                  Padding(
                                    padding: const EdgeInsets.only(top: 15.0),
                                    child: Checkbox(
                                      value: controller.isStandby.value,
                                      onChanged: controller.isEnable.value
                                          ? (val) {
                                        controller.isStandby.value =
                                        val!;
                                      }
                                          : null,
                                      materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                    ),
                                  )),
                              Obx(
                                    () =>
                                    Padding(
                                        padding: const EdgeInsets.only(
                                            top: 15.0, left: 5),
                                        child: Text(
                                          "Show Error",
                                          style: TextStyle(
                                              fontSize: SizeDefine.labelSize1,
                                              color: controller.isEnable.value
                                                  ? Colors.black
                                                  : Colors.grey),
                                        )),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: Get.width * 0.077,
                          child: Row(
                            children: [
                              SizedBox(width: 5),
                              Obx(() =>
                                  Padding(
                                    padding: const EdgeInsets.only(top: 15.0),
                                    child: Checkbox(
                                      value: controller.isStandby.value,
                                      onChanged: controller.isEnable.value
                                          ? (val) {
                                        controller.isStandby.value =
                                        val!;
                                      }
                                          : null,
                                      materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                    ),
                                  )),
                              Obx(
                                    () =>
                                    Padding(
                                        padding: const EdgeInsets.only(
                                            top: 15.0, left: 5),
                                        child: Text(
                                          "Show Cancel",
                                          style: TextStyle(
                                              fontSize: SizeDefine.labelSize1,
                                              color: controller.isEnable.value
                                                  ? Colors.black
                                                  : Colors.grey),
                                        )),
                              ),
                            ],
                          ),
                        ),
                        Text("Missiing Asrun SA Not Saved"),
                      ],
                    ),),
                    Expanded(child: Container(),),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black)))),
                      Expanded(
                          child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black)))),
                    ],
                  ),
                  Row(
                    children: [
                      FormButtonWrapper(
                        btnText: "Un Cancel",
                        showIcon: false,
                        // isEnabled: btn['isDisabled'],
                        callback: (){},
                      ),
                      FormButtonWrapper(
                        btnText: "Error",
                        showIcon: false,
                        // isEnabled: btn['isDisabled'],
                        callback: (){},
                      ),FormButtonWrapper(
                        btnText: "Auto",
                        showIcon: false,
                        // isEnabled: btn['isDisabled'],
                        callback: (){},
                      ),FormButtonWrapper(
                        btnText: "Un Match",
                        showIcon: false,
                        // isEnabled: btn['isDisabled'],
                        callback: (){},
                      ),FormButtonWrapper(
                        btnText: "Tapes",
                        showIcon: false,
                        // isEnabled: btn['isDisabled'],
                        callback: (){},
                      ),FormButtonWrapper(
                        btnText: "Show All",
                        showIcon: false,
                        // isEnabled: btn['isDisabled'],
                        callback: (){},
                      ),FormButtonWrapper(
                        btnText: "Map",
                        showIcon: false,
                        // isEnabled: btn['isDisabled'],
                        callback: (){},
                      ),FormButtonWrapper(
                        btnText: "Telecast",
                        showIcon: false,
                        // isEnabled: btn['isDisabled'],
                        callback: (){},
                      ),FormButtonWrapper(
                        btnText: "Clear",
                        showIcon: false,
                        // isEnabled: btn['isDisabled'],
                        callback: (){},
                      ),FormButtonWrapper(
                        btnText: "B2E",
                        showIcon: false,
                        // isEnabled: btn['isDisabled'],
                        callback: (){},
                      ),
                    ],
                  ),
                ],
              ),
            ),
            GetBuilder<HomeController>(
                id: "buttons",
                init: Get.find<HomeController>(),
                builder: (controller) {
                  PermissionModel formPermissions =
                  Get
                      .find<MainController>()
                      .permissionList!
                      .lastWhere((element) =>
                  element.appFormName == "frmProgramMaster");
                  print("Log>> Permission>>" +
                      jsonEncode(formPermissions.toJson()));
                  if (controller.buttons != null) {
                    return ButtonBar(
                      alignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        for (var btn in controller.buttons!)
                          FormButtonWrapper(
                              btnText: btn["name"],
                              callback: Utils.btnAccessHandler2(
                                  btn['name'], controller,
                                  formPermissions) == null
                                  ? null
                                  : () =>
                                  formHandler(
                                    btn['name'],
                                  ))
                      ],
                    );
                  }
                  return Container();
                })
          ],
        ),
      ),
    );
  }

  formHandler(v){

  }
}
