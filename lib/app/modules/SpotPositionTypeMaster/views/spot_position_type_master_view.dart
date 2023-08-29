import 'package:bms_scheduling/app/controller/HomeController.dart';
import 'package:bms_scheduling/app/data/DropDownValue.dart';
import 'package:bms_scheduling/app/modules/CommonSearch/views/common_search_view.dart';
import 'package:bms_scheduling/widgets/FormButton.dart';
import 'package:bms_scheduling/widgets/dropdown.dart';
import 'package:bms_scheduling/widgets/input_fields.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../controller/MainController.dart';
import '../../../data/PermissionModel.dart';
import '../../../providers/Utils.dart';
import '../controllers/spot_position_type_master_controller.dart';

class SpotPositionTypeMasterView extends StatelessWidget {
  SpotPositionTypeMasterView({Key? key}) : super(key: key);
  final controller = Get.put<SpotPositionTypeMasterController>(
      SpotPositionTypeMasterController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Spot Position Type Master'),
        centerTitle: true,
      ),
      body: Center(
          child: SizedBox(
              width: Get.width * .64,
              child: Dialog(
                  backgroundColor: Colors.grey[100],
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AppBar(
                          title: Text('Spot Position Type Master'),
                          centerTitle: true,
                          backgroundColor: Colors.deepPurple,
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Wrap(
                          crossAxisAlignment: WrapCrossAlignment.end,
                          spacing: Get.width * 0.01,
                          runSpacing: 10,
                          children: [
                            InputFields.formField1(
                              hintTxt: "Spot Type Pos. Name",
                              controller: controller.spotPostionName,
                              focusNode: controller.positionNameFocus,
                              width: 0.36,
                                capital: true
                            ),
                            InputFields.formField1(
                              hintTxt: "Spot Type Short Name",
                              controller: controller.spotShortName,
                              focusNode: controller.typeShortNameFocus,
                              width: 0.175,
                               capital: true,
                            ),
                            InputFields.numbers(
                              hintTxt: "Log Position",
                              padLeft: 0,
                              controller: controller.logPosition,
                              width: 0.175,
                                isNegativeReq: false
                            ),
                            Obx(() => DropDownField.formDropDown1WidthMap(
                                controller.spots.value,
                                (value) => {
                                  controller.selectedSpotInLog.value = value
                                },
                                "Spot In Log",
                                0.175,
                                dialogHeight: 170,
                                selected: controller.selectedSpotInLog.value)),
                            InputFields.numbers(
                              hintTxt: "Spot Position Premium",
                              padLeft: 0,
                              controller: controller.positionPremium,
                              width: 0.175,
                              isNegativeReq: false
                            ),
                            SizedBox(
                              width: Get.width * 0.175,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Break No Applicable"),
                                  Obx(
                                    () => InkWell(
                                      onTap: () {
                                        controller.breakNo.value =
                                            !controller.breakNo.value;
                                      },
                                      child: controller.breakNo.value
                                          ? Icon(Icons.check_box_outlined)
                                          : Icon(Icons
                                              .check_box_outline_blank_rounded),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              width: Get.width * 0.175,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Position No Applicable"),
                                  Obx(() => InkWell(
                                        onTap: () {
                                          controller.positionNo.value =
                                              !controller.positionNo.value;
                                        },
                                        child: controller.positionNo.value
                                            ? Icon(Icons.check_box_outlined)
                                            : Icon(Icons
                                                .check_box_outline_blank_rounded),
                                      ))
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 15,
                        ),
                      /*  GetBuilder<HomeController>(
                            id: "buttons",
                            init: Get.find<HomeController>(),
                            builder: (btncontroller) {
                              return btncontroller.buttons == null
                                  ? Container()
                                  : Card(
                                      margin: EdgeInsets.fromLTRB(4, 4, 4, 0),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(10),
                                            topRight: Radius.circular(10)),
                                      ),
                                      child: Container(
                                        width: Get.width,
                                        padding: const EdgeInsets.all(8.0),
                                        child: Wrap(
                                          spacing: 10,
                                          // buttonHeight: 20,
                                          alignment: WrapAlignment.start,
                                          // mainAxisSize: MainAxisSize.max,
                                          // pa
                                          children: [
                                            for (var btn
                                                in btncontroller.buttons!)
                                              FormButtonWrapper(
                                                btnText: btn["name"],
                                                // isEnabled: btn['isDisabled'],
                                                callback: () =>
                                                    btnhandler(btn["name"]),
                                              )
                                          ],
                                        ),
                                      ),
                                    );
                            }),*/
                        Align(
                          alignment: Alignment.topCenter,
                          child: GetBuilder<HomeController>(
                              id: "buttons",
                              init: Get.find<HomeController>(),
                              builder: (controller) {
                                PermissionModel formPermissions =
                                Get.find<MainController>()
                                    .permissionList!
                                    .lastWhere((element) =>
                                element.appFormName ==
                                    "frmSpotPositionTypeMaster");
                                if (controller.buttons != null) {
                                  return Wrap(
                                    spacing: 5,
                                    runSpacing: 15,
                                    alignment: WrapAlignment.center,
                                    children: [
                                      for (var btn in controller.buttons!)
                                        FormButtonWrapper(
                                          btnText: btn["name"],
                                          callback: Utils.btnAccessHandler2(btn['name'],
                                              controller, formPermissions) ==
                                              null
                                              ? null
                                              : () => btnhandler(
                                            btn['name'],
                                          ),
                                        )
                                    ],
                                  );
                                }
                                return Container();
                              }),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                      ])))),
    );
  }

  btnhandler(btnName) {
    switch (btnName) {
      case "Save":
        controller.validateSave();
        break;
      case "Delete":
        null;
        break;
      case "Clear":
        Get.delete<SpotPositionTypeMasterController>();
        Get.find<HomeController>().clearPage1();
        break;
      case "Search":
        Get.to(SearchPage(
          key: Key("Spot Position Type Master"),
          screenName: "Spot Position Type Master",
          appBarName: "Spot Position Type Master",
          strViewName: "vTesting",
          isAppBarReq: true,
        ));
        break;

      default:
    }
  }
}
