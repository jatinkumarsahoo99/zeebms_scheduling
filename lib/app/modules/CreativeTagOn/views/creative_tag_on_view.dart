import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../../widgets/DateTime/DateWithThreeTextField.dart';
import '../../../../widgets/FormButton.dart';
import '../../../../widgets/dropdown.dart';
import '../../../../widgets/input_fields.dart';
import '../../../controller/HomeController.dart';
import '../../../controller/MainController.dart';
import '../../../data/PermissionModel.dart';
import '../../../providers/Utils.dart';
import '../controllers/creative_tag_on_controller.dart';

class CreativeTagOnView extends GetView<CreativeTagOnController> {
   CreativeTagOnView({Key? key}) : super(key: key);

   CreativeTagOnController controllerX =
   Get.put<CreativeTagOnController>(CreativeTagOnController());

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: size.width * 0.94,
          child: Dialog(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppBar(
                    title: Text('Creative Tag On Link'),
                    centerTitle: true,
                    backgroundColor: Colors.deepPurple,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      DropDownField.formDropDown1WidthMap(
                        [],
                            (value) {

                        }, "Location", .1,
                        isEnable: controllerX.isEnable,
                        // selected: controllerX.selectedClientDetails,
                        autoFocus: true,),
                      DropDownField.formDropDown1WidthMap(
                        [],
                            (value) {

                        }, "Channel", .34,
                        isEnable: controllerX.isEnable,
                        // selected: controllerX.selectedClientDetails,
                        autoFocus: true,),
                      DateWithThreeTextField(
                        title: "From Date",
                        mainTextController: TextEditingController(),
                        widthRation: .1,
                        isEnable: controllerX.isEnable,
                      ),
                      DateWithThreeTextField(
                        title: "To Date",
                        mainTextController: TextEditingController(),
                        widthRation: .1,
                        isEnable: controllerX.isEnable,
                      ),
                      /*Padding(
                        padding: const EdgeInsets.only(
                            top: 14.0, left: 10, right: 10),
                        child: FormButtonWrapper(
                          btnText: "Genrate",
                          callback: () {
                            // controller.callGetRetrieve();
                          },
                          showIcon: false,
                        ),
                      ),*/
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      InputFields.formField1(
                        hintTxt: "Promo Id",
                        controller: TextEditingController(),
                        width: 0.1,
                        // isEnable: controllerX.isEnable,
                        onchanged: (value) {

                        },
                        autoFocus: true,
                      ),
                      InputFields.formField1(
                        hintTxt: "Promo Caption",
                        controller: TextEditingController(),
                        width: 0.34,
                        // isEnable: controllerX.isEnable,
                        onchanged: (value) {

                        },
                        autoFocus: true,
                      ),
                      InputFields.formField1(
                        hintTxt: "Promo Dur",
                        controller: TextEditingController(),
                        width: 0.1,
                        // isEnable: controllerX.isEnable,
                        onchanged: (value) {

                        },
                        autoFocus: true,
                      ),
                      Container(
                        width: size.width*0.1,
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      InputFields.formField1(
                        hintTxt: "Tag Id",
                        controller: TextEditingController(),
                        width: 0.1,
                        // isEnable: controllerX.isEnable,
                        onchanged: (value) {

                        },
                        autoFocus: true,
                      ),
                      InputFields.formField1(
                        hintTxt: "Tag Caption",
                        controller: TextEditingController(),
                        width: 0.34,
                        // isEnable: controllerX.isEnable,
                        onchanged: (value) {

                        },
                        autoFocus: true,
                      ),
                      InputFields.formField1(
                        hintTxt: "Tag Dur",
                        controller: TextEditingController(),
                        width: 0.1,
                        // isEnable: controllerX.isEnable,
                        onchanged: (value) {

                        },
                        autoFocus: true,
                      ),
                      Container(
                        width: size.width*0.1,
                      )
                    ],
                  ),
                  Expanded(
                    flex: 9,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black)),

                      ),
                    ),
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
