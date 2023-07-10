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
          width: size.width * .64,
          child: Dialog(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppBar(
                    title: Text('Coming Up Menu Master'),
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

                        }, "Location", .21,
                        isEnable: controllerX.isEnable,
                        // selected: controllerX.selectedClientDetails,
                        autoFocus: true,),
                      DropDownField.formDropDown1WidthMap(
                        [],
                            (value) {

                        }, "Channel", .21,
                        isEnable: controllerX.isEnable,
                        // selected: controllerX.selectedClientDetails,
                        autoFocus: true,),
                      InputFields.formField1(
                        hintTxt: "Tape Id",
                        controller: TextEditingController(),
                        width: 0.1,
                        // isEnable: controllerX.isEnable,
                        onchanged: (value) {

                        },
                        autoFocus: true,
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
                          controller: TextEditingController(),
                          width:0.21

                      ),
                      InputFields.formField1(
                        hintTxt: "House Id",
                        controller: TextEditingController(),
                        width: 0.1,
                        // isEnable: controllerX.isEnable,
                        onchanged: (value) {

                        },
                        autoFocus: true,
                      ),
                      InputFields.formField1(
                        hintTxt: "Tx Caption",
                        controller:TextEditingController(),
                        width: 0.21,
                        capital: true,
                        autoFocus: true,
                        isEnable: controllerX.isEnable,
                        prefixText: "M/",
                      ),
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
                          hintTxt: "Start Time",
                          controller: TextEditingController(),
                          widthRatio: 0.21,
                          isEnable: controllerX.isEnable,
                          /*onEditComplete: (val){
                                        controllerX.calculateDuration();
                                      },*/
                          // isTime: true,
                          // isEnable: controller.isEnable.value,
                          paddingLeft: 0),
                      InputFields.formFieldNumberMask(
                          hintTxt: "End Time",
                          controller:   TextEditingController(),
                          widthRatio: 0.07,
                          isEnable: controllerX.isEnable,
                          onEditComplete: (val){

                          },
                          // isTime: true,
                          // isEnable: controller.isEnable.value,
                          paddingLeft: 0),
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
                      DateWithThreeTextField(
                        title: "Menu Date",
                        mainTextController: TextEditingController(),
                        widthRation: .21,
                        isEnable: controllerX.isEnable,
                      ),
                      DateWithThreeTextField(
                        title: "Upto Date",
                        mainTextController: TextEditingController(),
                        widthRation: .21,
                        isEnable: controllerX.isEnable,
                      ),
                      Container(
                        width: size.width*0.1,
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
