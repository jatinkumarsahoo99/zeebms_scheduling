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
import '../controllers/coming_up_next_menu_controller.dart';

class ComingUpNextMenuView extends StatelessWidget {
   ComingUpNextMenuView({Key? key}) : super(key: key);

   ComingUpNextMenuController controllerX =
   Get.put<ComingUpNextMenuController>(ComingUpNextMenuController());

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
                    title: Text('Coming Up Next Master'),
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
                        [],
                            (value) {

                        }, "Location", .26,
                        isEnable: controllerX.isEnable,
                        // selected: controllerX.selectedClientDetails,
                        autoFocus: true,),
                      DropDownField.formDropDown1WidthMap(
                        [],
                            (value) {

                        }, "Channel", .26,
                        isEnable: controllerX.isEnable,
                        // selected: controllerX.selectedClientDetails,
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
                        controller: TextEditingController(),
                        width: 0.1,
                        // isEnable: controllerX.isEnable,
                        onchanged: (value) {

                        },
                        autoFocus: true,
                      ),
                      InputFields.numbers3(
                          hintTxt: "Seg No.",
                          padLeft: 0,
                          controller: TextEditingController(),
                          width:0.1

                      ),
                      InputFields.formField1(
                        hintTxt: "House Id",
                        controller: TextEditingController(text: "AUTO"),
                        width: 0.1,
                        // isEnable: controllerX.isEnable,
                        onchanged: (value) {

                        },
                        autoFocus: true,
                      ),
                      Container(
                        width: size.width*0.104,
                      )
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InputFields.formField1(
                        hintTxt: "Program",
                        controller: TextEditingController(),
                        width: 0.1,
                        // isEnable: controllerX.isEnable,
                        onchanged: (value) {

                        },
                        autoFocus: true,
                      ),
                      DropDownField.formDropDown1WidthMap(
                        [],
                            (value) {

                        }, "Program", .415,
                        isEnable: controllerX.isEnable,
                        // selected: controllerX.selectedClientDetails,
                        autoFocus: true,),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  InputFields.formField1(
                    hintTxt: "Tx Caption",
                    controller:TextEditingController(),
                    width: 0.6,
                    capital: true,
                    autoFocus: true,
                    isEnable: controllerX.isEnable,
                    prefixText: "NEXT/",
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
                          controller:   TextEditingController(),
                          widthRatio: 0.07,
                          isEnable: controllerX.isEnable,
                          onEditComplete: (val){

                          },
                          // isTime: true,
                          // isEnable: controller.isEnable.value,
                          paddingLeft: 0),
                      InputFields.formFieldNumberMask(
                          hintTxt: "EOM",
                          controller:   TextEditingController(),
                          widthRatio: 0.07,
                          isEnable: controllerX.isEnable,
                          onEditComplete: (val){

                          },
                          // isTime: true,
                          // isEnable: controller.isEnable.value,
                          paddingLeft: 0),
                      TimeWithThreeTextField(
                        title: "Duration",
                        mainTextController: TextEditingController(),
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
