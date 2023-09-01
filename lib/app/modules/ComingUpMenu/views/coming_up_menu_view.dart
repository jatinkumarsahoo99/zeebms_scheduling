import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../../widgets/DateTime/DateWithThreeTextField.dart';
import '../../../../widgets/DateTime/TimeWithThreeTextField.dart';
import '../../../../widgets/FormButton.dart';
import '../../../../widgets/dropdown.dart';
import '../../../../widgets/input_fields.dart';
import '../../../controller/HomeController.dart';
import '../../../controller/MainController.dart';
import '../../../data/PermissionModel.dart';
import '../../../providers/Utils.dart';
import '../controllers/coming_up_menu_controller.dart';

class ComingUpMenuView extends StatelessWidget {
  ComingUpMenuView({Key? key}) : super(key: key);

  ComingUpMenuController controllerX =
      Get.put<ComingUpMenuController>(ComingUpMenuController());

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: size.width * .73,
          child: Dialog(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppBar(
                  title: Text('Coming Up Menu Master'),
                  centerTitle: true,
                  backgroundColor: Colors.deepPurple,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Obx(() => DropDownField.formDropDown1WidthMap(
                                  controllerX.locationList.value, (value) {
                                controllerX.selectedLocation?.value = value;
                                controllerX.fetchListOfChannel(
                                    controllerX.selectedLocation?.value?.key ??
                                        "");
                              }, "Location", 0.23,
                                  isEnable: controllerX.isEnable,
                                  selected: controllerX.selectedLocation?.value,
                                  autoFocus: true,
                                  inkWellFocusNode: controllerX.locationFocus)),
                          SizedBox(
                            width: size.width * 0.38,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Obx(
                                  () => DropDownField.formDropDown1WidthMap(
                                      controllerX.channelList.value, (value) {
                                    controllerX.selectedChannel?.value = value;
                                  }, "Channel", 0.23,
                                      isEnable: controllerX.isEnable,
                                      selected:
                                          controllerX.selectedChannel?.value,
                                      autoFocus: false,
                                      inkWellFocusNode:
                                          controllerX.channelFocus),
                                ),
                                InputFields.formField1(
                                  hintTxt: "Tape Id",
                                  controller: controllerX.tapeIdController,
                                  width: 0.11,
                                  focusNode: controllerX.tapeIdFocus,
                                  isEnable: controllerX.isEnable,
                                  autoFocus: false,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InputFields.numbers3(
                            hintTxt: "Seg No.",
                            padLeft: 0,
                            controller: controllerX.segNoController,
                            width: 0.23,
                            fN: controllerX.segNoFocus,
                            isNegativeReq: false,
                          ),
                          SizedBox(
                            width: size.width * 0.38,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                InputFields.formField1(
                                  hintTxt: "House Id",
                                  controller: controllerX.houseIdController,
                                  width: 0.11,
                                  isEnable: controllerX.isEnable,
                                  focusNode: controllerX.houseIdFocus,
                                  autoFocus: false,
                                ),
                                InputFields.formField1(
                                    hintTxt: "Tx Caption",
                                    controller: controllerX.txCaptionController,
                                    width: 0.25,
                                    capital: true,
                                    autoFocus: false,
                                    isEnable: controllerX.isEnable,
                                    prefixText: "M/",
                                    focusNode: controllerX.txFocus),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InputFields.formFieldNumberMask(
                              hintTxt: "Start Time",
                              controller: controllerX.startTimeController,
                              widthRatio: 0.23,
                              isEnable: controllerX.isEnable,
                              /*onEditComplete: (val){
                                        controllerX.calculateDuration();
                                      },*/
                              // isTime: true,
                              // isEnable: controller.isEnable.value,
                              paddingLeft: 0),
                          SizedBox(
                            width: size.width * 0.38,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                InputFields.formFieldNumberMask(
                                    hintTxt: "End Time",
                                    controller: controllerX.endTimeController,
                                    widthRatio: 0.11,
                                    isEnable: controllerX.isEnable,
                                    onEditComplete: (val) {},
                                    // isTime: true,
                                    // isEnable: controller.isEnable.value,
                                    paddingLeft: 0),
                                SizedBox(
                                  width: size.width * 0.25,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      InputFields.formFieldNumberMask(
                                          hintTxt: "SOM",
                                          controller: controllerX.somController,
                                          widthRatio: 0.068,
                                          isEnable: controllerX.isEnable,
                                          onEditComplete: (val) {
                                            // controllerX.calculateDuration();
                                          },
                                          // isTime: true,
                                          // isEnable: controller.isEnable.value,
                                          paddingLeft: 0),
                                      InputFields.formFieldNumberMask(
                                          hintTxt: "EOM",
                                          controller: controllerX.eomController,
                                          widthRatio: 0.068,
                                          isEnable: controllerX.isEnable,
                                          onEditComplete: (val) {
                                            controllerX.calculateDuration();
                                          },
                                          // isTime: true,
                                          // isEnable: controller.isEnable.value,
                                          paddingLeft: 0),
                                      /*TimeWithThreeTextField(
                        title: "Duration",
                        mainTextController:
                            controllerX.durationController.value,
                        widthRation: 0.068,
                        isTime: false,
                        isEnable: false,
                    ),*/
                                      Obx(() => InputFields.formFieldDisable(
                                            hintTxt: "Duration",
                                            value: controllerX.duration.value,
                                            widthRatio: 0.07,
                                          ))
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: SizedBox(
                          width: size.width * 0.23,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              DateWithThreeTextField(
                                title: "Menu Date",
                                mainTextController:
                                    controllerX.menuDateController,
                                widthRation: .1,
                                isEnable: controllerX.isEnable,
                              ),
                              DateWithThreeTextField(
                                title: "Upto Date",
                                mainTextController:
                                    controllerX.uptoDateController,
                                widthRation: .1,
                                isEnable: controllerX.isEnable,
                                startDate: DateTime.now(),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 6),

                /// bottom common buttons
                Align(
                  alignment: Alignment.topCenter,
                  child: GetBuilder<HomeController>(
                      id: "buttons",
                      init: Get.find<HomeController>(),
                      builder: (controller) {
                        try{
                          PermissionModel formPermissions =
                          Get.find<MainController>()
                              .permissionList!
                              .lastWhere((element) =>
                          element.appFormName ==
                              "frmComingUpMenuMaster");
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
                                        : () => controllerX.formHandler(
                                      btn['name'],
                                    ),
                                  )
                              ],
                            );
                          }else{
                            return Container();
                          }
                        }catch(e){
                          return const Text("No Access");
                        }
                      }),
                ),
                SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
      key: GlobalKey(),
    );
  }
}
