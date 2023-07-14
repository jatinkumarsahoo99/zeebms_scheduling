import 'package:bms_scheduling/widgets/dropdown.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';


import '../../../../widgets/FormButton.dart';
import '../../../../widgets/PlutoGrid/src/pluto_grid.dart';
import '../../../../widgets/gridFromMap.dart';
import '../../../../widgets/input_fields.dart';
import '../../../controller/HomeController.dart';
import '../../../controller/MainController.dart';
import '../../../data/PermissionModel.dart';
import '../../../providers/Aes.dart';
import '../../../providers/Utils.dart';
import '../controllers/brand_master_controller.dart';

class BrandMasterView extends StatelessWidget {
   BrandMasterView({Key? key}) : super(key: key);

   BrandMasterController controllerX = Get.put<BrandMasterController>(BrandMasterController());

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: size.width * .72,
          height: size.height * .84,
          child: Dialog(
            child: FocusTraversalGroup(
              policy: OrderedTraversalPolicy(),
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
                    child: FocusTraversalGroup(
                      policy: OrderedTraversalPolicy(),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Expanded(
                            flex:11,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GetBuilder<BrandMasterController>(
                                id: "top",
                                builder: (controllerX) {
                                  return FocusTraversalGroup(
                                    policy: OrderedTraversalPolicy(),
                                    child: ListView(
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            InputFields.formField1(
                                              hintTxt: "Client",
                                              controller: controllerX.clientController,
                                              width: 0.1,
                                              focusNode: controllerX.clientFocus,
                                              // isEnable: controllerX.isEnable,
                                              onchanged: (value) {
                                                 // controllerX.fetchClient(value);
                                              },
                                              // autoFocus: true,
                                            ),

                                          Obx(()=>DropDownField.formDropDown1WidthMap(
                                            controllerX.clientList.value??[],
                                                (value) {
                                                  controllerX.selectedClient = value;
                                                  controllerX.fetchClientDetails((value.value ??"")??"");
                                                  // controllerX.
                                            },
                                            "Client", .2,
                                            isEnable: controllerX.isEnable,
                                            selected: controllerX.selectedClient,
                                            // autoFocus: true,
                                          )),
                                          ],
                                        ),
                                        InputFields.formField1(
                                          hintTxt: "Brand Name",
                                          controller: controllerX.brandController,
                                          width: 0.36,
                                          focusNode: controllerX.brandName,
                                          // isEnable: controllerX.isEnable,
                                          onchanged: (value) {

                                          },
                                          // autoFocus: true,
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            InputFields.formField1(
                                              hintTxt: "Brand Short Name",
                                              controller: controllerX.brandShortNameController,
                                              width: 0.2,
                                              // isEnable: controllerX.isEnable,
                                              onchanged: (value) {

                                              },
                                              // autoFocus: true,
                                            ),
                                            SizedBox(
                                              // width: Get.width * .17,
                                                child: InputFields.numbers3(
                                                  hintTxt: "Separation Time",
                                                  padLeft: 0,
                                                  onchanged: (val) {},
                                                  controller:controllerX.separationTimeController,
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
                                              controller:controllerX.productController,
                                              width: 0.1,
                                              focusNode: controllerX.productFocus,
                                              // isEnable: controllerX.isEnable,
                                              onchanged: (value) {
                                                // controllerX.fetchProduct(value);
                                              },
                                              // autoFocus: true,
                                            ),
                                          Obx(()=>DropDownField.formDropDown1WidthMap(
                                            controllerX.productList.value,
                                                (value) {
                                                  controllerX.selectedProduct = value;
                                                  controllerX.getProductDetails(value.key??"");

                                            }, "Product", .2,
                                            isEnable: controllerX.isEnable,
                                            selected: controllerX.selectedProduct,
                                            // autoFocus: true,
                                          )),
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
                                          controller: controllerX.productLevel1Controller,
                                          width: 0.36,
                                          // isEnable: controllerX.isEnable,
                                          onchanged: (value) {

                                          },
                                          // autoFocus: true,
                                        ),
                                        InputFields.formField1(
                                          hintTxt: "Product Level 2",
                                          controller: controllerX.productLevel2Controller,
                                          width: 0.36,
                                          // isEnable: controllerX.isEnable,
                                          onchanged: (value) {

                                          },
                                          // autoFocus: true,
                                        ),
                                        InputFields.formField1(
                                          hintTxt: "Product Level 3",
                                          controller:  controllerX.productLevel3Controller,
                                          width: 0.36,
                                          // isEnable: controllerX.isEnable,
                                          onchanged: (value) {

                                          },
                                          // autoFocus: true,
                                        ),
                                        InputFields.formField1(
                                          hintTxt: "Product Level 4",
                                          controller: controllerX.productLevel4Controller,
                                          width: 0.36,
                                          // isEnable: controllerX.isEnable,
                                          onchanged: (value) {

                                          },
                                          // autoFocus: true,
                                        ),

                                      ],
                                    ),
                                  );
                                }
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
                                      child: GetBuilder<BrandMasterController>(
                                          id: "grid",
                                          builder: (controllerX) {
                                            return Container(
                                                decoration: BoxDecoration(
                                                    border: Border.all(color: Colors.black)),
                                                child:
                                                (controllerX.clientDetailsAndBrandModel != null)?
                                                (controllerX.clientDetailsAndBrandModel!.clientdtails != null &&
                                                    controllerX.clientDetailsAndBrandModel!.clientdtails!.isNotEmpty
                                                )?
                                                DataGridFromMap(
                                                    hideCode: false,
                                                    formatDate: false,
                                                    focusNode: controllerX.gridFocus,
                                                    onRowDoubleTap: (PlutoGridOnRowDoubleTapEvent val){

                                                    },

                                                    // checkRow: true,
                                                    // checkRowKey: "no",
                                                    mode: PlutoGridMode.selectWithOneTap,
                                                    onSelected: (PlutoGridOnSelectedEvent? val ){
                                                        controllerX.selectedIndex = val?.rowIdx;
                                                    },

                                                    onload: (PlutoGridOnLoadedEvent load) {
                                                      controllerX.gridStateManager = load.stateManager;
                                                    },
                                                    // colorCallback: (renderC) => Colors.red[200]!,
                                                    mapData:controllerX.clientDetailsAndBrandModel!.clientdtails!.map((e) =>
                                                        e.toJson()).toList() ):Container():Container()
                                            );
                                          }
                                      ),
                              ),
                            ),
                          )
                        ],
                      ),
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
      ),
    );
  }
}
