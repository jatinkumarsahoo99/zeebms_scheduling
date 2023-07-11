import 'package:bms_scheduling/widgets/dropdown.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';


import '../../../../widgets/FormButton.dart';
import '../../../../widgets/input_fields.dart';
import '../../../controller/HomeController.dart';
import '../../../controller/MainController.dart';
import '../../../data/PermissionModel.dart';
import '../../../providers/Utils.dart';
import '../controllers/brand_master_controller.dart';

class BrandMasterView extends StatelessWidget {
   BrandMasterView({Key? key}) : super(key: key);

   BrandMasterController controllerX =
   Get.put<BrandMasterController>(BrandMasterController());
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: size.width * .72,
          height: size.height * .84,
          child: Dialog(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                AppBar(
                  title: Text('Brand Master'),
                  centerTitle: true,
                  backgroundColor: Colors.deepPurple,
                ),
                SizedBox(height: 2),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        flex:11,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListView(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  InputFields.formField1(
                                    hintTxt: "Client",
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

                                          }, "Client", .2,
                                          isEnable: controllerX.isEnable,
                                          // selected: controllerX.selectedClientDetails,
                                          autoFocus: true,),
                                ],
                              ),
                              InputFields.formField1(
                                hintTxt: "Brand Name",
                                controller: TextEditingController(),
                                width: 0.36,
                                // isEnable: controllerX.isEnable,
                                onchanged: (value) {

                                },
                                autoFocus: true,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  InputFields.formField1(
                                    hintTxt: "Brand Short Name",
                                    controller: TextEditingController(),
                                    width: 0.2,
                                    // isEnable: controllerX.isEnable,
                                    onchanged: (value) {

                                    },
                                    autoFocus: true,
                                  ),
                                  SizedBox(
                                    // width: Get.width * .17,
                                      child: InputFields.numbers3(
                                        hintTxt: "Separation Time",
                                        padLeft: 0,
                                        onchanged: (val) {},
                                        controller:TextEditingController(),
                                        isNegativeReq: false,
                                        width: 0.1,
                                        fN: FocusNode(),
                                        // isEnabled: true,
                                      )

                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  InputFields.formField1(
                                    hintTxt: "Product",
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

                                    }, "Product", .2,
                                    isEnable: controllerX.isEnable,
                                    // selected: controllerX.selectedClientDetails,
                                    autoFocus: true,),
                                  InkWell(
                                    onTap: (){

                                    },
                                    child: InputFields.formField1(
                                      hintTxt: "",
                                      controller: TextEditingController(text: "..."),
                                      width: 0.022,
                                      // isEnable: controllerX.isEnable,
                                      onchanged: (value) {

                                      },
                                      autoFocus: true,
                                      isEnable: false
                                    ),
                                  ),
                                 /* Container(
                                    width: size.width*0.02,
                                    height:  size.width*0.02,
                                    // margin: EdgeInsets.only(left: 10),
                                    decoration: BoxDecoration(
                                        border: Border.all(color: Colors.deepPurple)),
                                    child: Text("..."),
                                  )*/
                                ],
                              ),
                              InputFields.formField1(
                                hintTxt: "Product Level 1",
                                controller: TextEditingController(),
                                width: 0.36,
                                // isEnable: controllerX.isEnable,
                                onchanged: (value) {

                                },
                                autoFocus: true,
                              ),
                              InputFields.formField1(
                                hintTxt: "Product Level 2",
                                controller: TextEditingController(),
                                width: 0.36,
                                // isEnable: controllerX.isEnable,
                                onchanged: (value) {

                                },
                                autoFocus: true,
                              ),
                              InputFields.formField1(
                                hintTxt: "Product Level 3",
                                controller: TextEditingController(),
                                width: 0.36,
                                // isEnable: controllerX.isEnable,
                                onchanged: (value) {

                                },
                                autoFocus: true,
                              ),
                              InputFields.formField1(
                                hintTxt: "Product Level 4",
                                controller: TextEditingController(),
                                width: 0.36,
                                // isEnable: controllerX.isEnable,
                                onchanged: (value) {

                                },
                                autoFocus: true,
                              ),

                            ],
                          ),
                        ),
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
                      )
                    ],
                  ),
                ),
                SizedBox(height: 7),
                GetBuilder<HomeController>(
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
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
