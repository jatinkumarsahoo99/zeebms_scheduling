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
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: size.width * .64,
          child: Dialog(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppBar(
                    title: Text('Coming Up Tomorrow Master'),
                    centerTitle: true,
                    backgroundColor: Colors.deepPurple,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      DropDownField.formDropDown1WidthMap(
                        controllerX.locationList.value,
                            (value) {
                              controllerX.selectedLocation = value;
                              controllerX.fetchListOfChannel(controllerX.selectedLocation?.key??"");
                        }, "Location", .26,
                        isEnable: controllerX.isEnable,
                        selected: controllerX.selectedLocation,
                        autoFocus: true,),
                      DropDownField.formDropDown1WidthMap(
                        controllerX.channelList.value,
                            (value) {
                              controllerX.selectedChannel = value;
                        }, "Channel", .26,
                        isEnable: controllerX.isEnable,
                        selected: controllerX.selectedChannel,
                        autoFocus: true,),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InputFields.formField1(
                        hintTxt: "Tape Id",
                        controller: controllerX.tapeIdController,
                        width: 0.1,
                        focusNode: controllerX.tapeIdFocus,
                        isEnable: controllerX.isEnable,
                        onchanged: (value) {

                        },
                        autoFocus: true,
                      ),
                      InputFields.numbers3(
                          hintTxt: "Seg No.",
                          padLeft: 0,
                          controller: controllerX.segNoController,
                          width:0.1,
                          fN: controllerX.segNoFocus,

                      ),
                      InputFields.formField1(
                        hintTxt: "House Id",
                        controller: controllerX.houseIdController,
                        width: 0.1,
                        // isEnable: controllerX.isEnable,
                        isEnable: controllerX.isEnable,
                        onchanged: (value) {

                        },
                        focusNode: controllerX.houseIdFocus,
                        autoFocus: true,
                      ),
                      InputFields.formField1(
                        hintTxt: "Tx Caption",
                        controller:controllerX.txCaptionController,
                        width: 0.15,
                        capital: true,
                        autoFocus: true,
                        isEnable: controllerX.isEnable,
                        prefixText: "TOM/",
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      DropDownField.formDropDown1WidthMap(
                        [],
                            (value) {

                        }, "Program Type", .26,
                        isEnable: controllerX.isEnable,
                        // selected: controllerX.selectedClientDetails,
                        autoFocus: true,),
                      DropDownField.formDropDown1WidthMap(
                        [],
                            (value) {

                        }, "Program", .26,
                        isEnable: controllerX.isEnable,
                        selected: controllerX.selectedProgram,
                        autoFocus: true,),
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
                          controller:   controllerX.somController,
                          widthRatio: 0.07,
                          isEnable: controllerX.isEnable,
                          onEditComplete: (val){
                            controllerX.calculateDuration();
                          },
                          // isTime: true,
                          // isEnable: controller.isEnable.value,
                          paddingLeft: 0),
                      InputFields.formFieldNumberMask(
                          hintTxt: "EOM",
                          controller: controllerX.eomController,
                          widthRatio: 0.07,
                          isEnable: controllerX.isEnable,
                          onEditComplete: (val){
                            controllerX.calculateDuration();
                          },
                          // isTime: true,
                          // isEnable: controller.isEnable.value,
                          paddingLeft: 0),
                      TimeWithThreeTextField(
                        title: "Duration",
                        mainTextController: controllerX.durationController.value,
                        widthRation: 0.07,
                        isTime: false,
                        isEnable: false,
                      ),

                    ],
                  ),

                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: context.width * .23,
                        child: Obx(() {
                          return RadioRow1(
                            items: ['Non-Dated', 'Dated'],
                            groupValue: controllerX.selectedRadio.value,
                            disabledRadios: !(controllerX.controllsEnabled.value) ? ['Non-Dated', 'Dated'] : null,
                            onchange: (va) => controllerX.selectedRadio.value = va,
                          );
                        }),
                      ),
                      DateWithThreeTextField(
                        title: "Upto Date",
                        mainTextController: TextEditingController(),
                        widthRation: .1,
                        isEnable: controllerX.isEnable,
                      ),
                      Container(
                        width: size.width*0.2011,
                      )
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),

                  /// bottom common buttons
                  Align(
                    alignment: Alignment.topLeft,
                    child: GetBuilder<HomeController>(
                        id: "buttons",
                        init: Get.find<HomeController>(),
                        builder: (controller) {
                          PermissionModel formPermissions = Get.find<MainController>()
                              .permissionList!
                              .lastWhere((element) =>
                          element.appFormName == "frmCommercialMaster");
                          if (controller.buttons != null) {
                            return ButtonBar(
                              alignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
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
                          }
                          return Container();
                        }),
                  ),
                  SizedBox(height: 2),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
