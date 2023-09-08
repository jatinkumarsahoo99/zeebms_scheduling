import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../../widgets/DateTime/DateWithThreeTextField.dart';
import '../../../../widgets/DateTime/TimeWithThreeTextField.dart';
import '../../../../widgets/FormButton.dart';
import '../../../../widgets/dropdown.dart';
import '../../../../widgets/input_fields.dart';
import '../../../../widgets/radio_row1.dart';
import '../../../controller/HomeController.dart';
import '../../../controller/MainController.dart';
import '../../../data/PermissionModel.dart';
import '../../../providers/Utils.dart';
import '../controllers/coming_up_tomorrow_menu_controller.dart';

class ComingUpTomorrowMenuView extends StatelessWidget {
  ComingUpTomorrowMenuView({Key? key}) : super(key: key);

  ComingUpTomorrowMenuController controllerX =
  Get.put<ComingUpTomorrowMenuController>(ComingUpTomorrowMenuController());

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery
        .of(context)
        .size;
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: size.width * .64,
          child: Dialog(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppBar(
                  title: Text('Coming Up Tomorrow Master'),
                  centerTitle: true,
                  backgroundColor: Colors.deepPurple,
                ),
                GetBuilder<ComingUpTomorrowMenuController>(
                    id: "top",
                    builder: (controllerX) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FocusTraversalGroup(
                          policy: OrderedTraversalPolicy(),
                          child: Column(children: [
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Obx(() =>
                                    DropDownField.formDropDown1WidthMap(
                                      controllerX.locationList.value,
                                          (value) {
                                        controllerX.selectedLocation?.value =
                                            value;
                                        controllerX.fetchListOfChannel(
                                            controllerX.selectedLocation?.value
                                                ?.key ?? "");
                                      }, "Location", .26,
                                      isEnable: controllerX.isEnable,
                                      inkWellFocusNode: controllerX
                                          .locationFocus,
                                      selected: controllerX.selectedLocation
                                          ?.value,
                                      autoFocus: true,),),
                                Obx(() =>
                                    DropDownField.formDropDown1WidthMap(
                                      controllerX.channelList.value,
                                          (value) {
                                        controllerX.selectedChannel?.value =
                                            value;
                                      }, "Channel", .26,
                                      isEnable: controllerX.isEnable,
                                      selected: controllerX.selectedChannel
                                          ?.value,
                                      inkWellFocusNode: controllerX
                                          .channelFocus,
                                      autoFocus: false,),),
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: size.width * 0.26,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment
                                        .spaceBetween,
                                    children: [
                                      Obx(() {
                                        return InputFields.formField1(
                                          hintTxt: "Tape Id",
                                          controller: controllerX
                                              .tapeIdController,
                                          width: 0.103,
                                          padLeft: 0,
                                          focusNode: controllerX.tapeIdFocus,
                                          isEnable: controllerX.isEnable1.value,
                                          onchanged: (value) {

                                          },
                                          autoFocus: false,
                                        );
                                      }),
                                      Obx(() {
                                        return InputFields.numbers4(
                                          hintTxt: "Seg No.",
                                          padLeft: 0,
                                          controller: controllerX
                                              .segNoController,
                                          width: 0.103,
                                          isNegativeReq: false,
                                          fN: controllerX.segNoFocus,
                                          onchanged: (val) {

                                          },
                                          isEnabled: controllerX.isEnable1
                                              .value,

                                        );
                                      })
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: size.width * 0.26,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment
                                        .spaceBetween,
                                    children: [
                                      Obx(() {
                                        return InputFields.formField1(
                                          hintTxt: "House Id",
                                          controller: controllerX
                                              .houseIdController,
                                          width: 0.103,
                                          padLeft: 0,
                                          // isEnable: controllerX.isEnable,
                                          isEnable: controllerX.isEnable1.value,
                                          onchanged: (value) {

                                          },
                                          focusNode: controllerX.houseIdFocus,
                                          autoFocus: false,
                                        );
                                      }),
                                      InputFields.formField1(
                                        hintTxt: "Tx Caption",
                                        controller: controllerX
                                            .txCaptionController,
                                        width: 0.103,
                                        padLeft: 0,
                                        capital: true,
                                        autoFocus: false,
                                        isEnable: controllerX.isEnable,
                                        prefixText: "TOM/",
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
                                Obx(() =>
                                    DropDownField.formDropDown1WidthMap(
                                      controllerX.programTypeList.value,
                                          (value) {
                                        controllerX.selectedProgramType?.value =
                                            value;
                                        controllerX.fetchProgram(
                                            value.key ?? "");
                                      }, "Program Type", .26,
                                      isEnable: controllerX.isEnable,
                                      selected: controllerX.selectedProgramType
                                          ?.value,
                                      inkWellFocusNode: controllerX
                                          .programTypeFocus,
                                      autoFocus: false,)),
                                Obx(() =>
                                    DropDownField.formDropDown1WidthMap(
                                      controllerX.programList.value,
                                          (value) {
                                        controllerX.selectedProgram?.value =
                                            value;
                                      }, "Program", .26,
                                      isEnable: controllerX.isEnable,
                                      inkWellFocusNode: controllerX
                                          .programFocus,
                                      selected: controllerX.selectedProgram
                                          ?.value,
                                      autoFocus: false,)),
                              ],
                            ),

                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                InputFields.formFieldNumberMask(
                                    hintTxt: "SOM",
                                    controller: controllerX.somController,
                                    widthRatio: 0.1,
                                    isEnable: controllerX.isEnable,
                                    /*onEditComplete: (val){
                                    controllerX.calculateDuration();
                                  },*/
                                    // isTime: true,
                                    // isEnable: controller.isEnable.value,
                                    paddingLeft: 0),
                                InputFields.formFieldNumberMask(
                                    hintTxt: "EOM",
                                    controller: controllerX.eomController,
                                    widthRatio: 0.1,
                                    isEnable: controllerX.isEnable,
                                    onEditComplete: (val) {
                                      controllerX.calculateDuration();
                                    },
                                    // isTime: true,
                                    // isEnable: controller.isEnable.value,
                                    paddingLeft: 0),
                                Obx(() =>
                                    InputFields.formFieldDisable(
                                      hintTxt: 'Duration',
                                      value: controllerX.duration.value,
                                      widthRatio: 0.1,
                                    )),
                                Obx(() {
                                  return RadioRow1(
                                    items: const ['Non-Dated', 'Dated'],
                                    groupValue: controllerX.selectedRadio.value,
                                    disabledRadios: ['Non-Dated', 'Dated']
                                        .where((element) =>
                                    element != controllerX.selectedRadio.value)
                                        .toList(),
                                    onchange: (va) =>
                                    controllerX.selectedRadio.value = va,
                                  );
                                }),
                                DateWithThreeTextField(
                                  title: "Upto Date",
                                  mainTextController: controllerX
                                      .uptoDateController,
                                  widthRation: .1,
                                  isEnable: controllerX.isEnable,
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                          ],),
                        ),
                      );
                    }
                ),

                /// bottom common buttons
                Align(
                  alignment: Alignment.topCenter,
                  child: GetBuilder<HomeController>(
                      id: "buttons",
                      init: Get.find<HomeController>(),
                      builder: (controller) {
                        try {
                          PermissionModel formPermissions = Get
                              .find<MainController>()
                              .permissionList!
                              .lastWhere((element) =>
                          element.appFormName == "frmComingUpTomorrowMaster");
                          if (controller.buttons != null) {
                            return Wrap(
                              spacing: 5,
                              runSpacing: 15,
                              alignment: WrapAlignment.center,
                              children: [
                                for (var btn in controller.buttons!)
                                  FormButtonWrapper(
                                    btnText: btn["name"],
                                    callback: Utils.btnAccessHandler2(
                                        btn['name'],
                                        controller, formPermissions) ==
                                        null
                                        ? null
                                        : () =>
                                        controllerX.formHandler(
                                          btn['name'],
                                        ),
                                  )
                              ],
                            );
                          }
                          return Container();
                        } catch (e) {
                          return Container();
                        }
                      }),
                ),
                SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
