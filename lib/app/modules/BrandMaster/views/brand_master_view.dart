import 'package:bms_scheduling/app/data/DropDownValue.dart';
import 'package:bms_scheduling/widgets/dropdown.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';


import '../../../../widgets/FormButton.dart';
import '../../../../widgets/PlutoGrid/src/helper/pluto_move_direction.dart';
import '../../../../widgets/PlutoGrid/src/pluto_grid.dart';
import '../../../../widgets/gridFromMap.dart';
import '../../../../widgets/input_fields.dart';
import '../../../controller/HomeController.dart';
import '../../../controller/MainController.dart';
import '../../../data/PermissionModel.dart';
import '../../../providers/Aes.dart';
import '../../../providers/ApiFactory.dart';
import '../../../providers/Utils.dart';
import '../../CommonSearch/views/common_search_view.dart';
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
          width: size.width * .82,
          // height: size.height * .95,
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
                      FocusTraversalGroup(
                        policy:OrderedTraversalPolicy(),
                        child: Expanded(
                          flex:9,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GetBuilder<BrandMasterController>(
                              id: "top",
                              builder: (controllerX) {
                                return ListView(
                                  children: [
                                    DropDownField
                                        .formDropDownSearchAPI2(
                                    GlobalKey(),
                                    context,
                                    width: context.width * 0.35,
                                    onchanged: (DropDownValue? val) {
                                    print(">>>" + val.toString());
                                    controllerX.selectedClient = val;
                                    controllerX.fetchClientDetails((val?.value ??"")??"");
                                    },
                                    title: 'Client',
                                    url:ApiFactory.BRANDMASTER_GETCLIENT,
                                    parseKeyForKey: "ClientCode",
                                    parseKeyForValue: 'ClientName',
                                    selectedValue: controllerX.selectedClient,
                                    autoFocus: true,
                                      inkwellFocus: controllerX.clientFocus
                                    // maxLength: 1
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    InputFields.formField1(
                                      hintTxt: "Brand Name",
                                      controller: controllerX.brandController,
                                      width: 0.36,
                                      autoFocus: false,
                                      // autoFocus: true,
                                      focusNode: controllerX.brandNameFocus,
                                      // isEnable: controllerX.isEnable,
                                      onchanged: (value) {

                                      },
                                      // autoFocus: true,
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        InputFields.formField1(
                                          hintTxt: "Brand Short Name",
                                          controller: controllerX.brandShortNameController,
                                          width: 0.2,

                                          // autoFocus: true,
                                          // isEnable: controllerX.isEnable,
                                          onchanged: (value) {

                                          },autoFocus: true
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
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        DropDownField
                                            .formDropDownSearchAPI2(
                                          GlobalKey(),
                                          context,

                                          width: context.width * 0.3,
                                          onchanged: (DropDownValue? val) {
                                            print(">>>" + val.toString());
                                            controllerX.selectedProduct = val;
                                            controllerX.getProductDetails(val?.key??"");
                                            // controllerX.fetchClientDetails((val?.value ??"")??"");
                                          },
                                          title: 'Product',
                                          url:ApiFactory.BRANDMASTER_GETPRODUCT,
                                          parseKeyForKey: "productcode",
                                          parseKeyForValue: 'Productname',
                                          selectedValue: controllerX.selectedProduct,
                                          autoFocus: false,
                                          // maxLength: 1
                                        ),
                                        InkWell(
                                          onTap: (){
                                            Get.to(
                                              SearchPage(
                                                key: Key("Product Levels - Search"),
                                                screenName: "Product Levels - Search",
                                                appBarName: "Product Levels - Search",
                                                strViewName: "Productlevels",
                                                isAppBarReq: true,
                                              ),
                                            );
                                          },
                                          child: InputFields.formField1(
                                            hintTxt: "",
                                            controller: TextEditingController(text: "..."),
                                            width: 0.022,
                                            // isEnable: controllerX.isEnable,
                                            onchanged: (value) {

                                            },
                                            // autoFocus: true,
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
                                    SizedBox(
                                      height: 5,
                                    ),
                                    InputFields.formField1(
                                      hintTxt: "Product Level 1",
                                      // autoFocus: true,
                                      controller: controllerX.productLevel1Controller,
                                      width: 0.36,
                                      // isEnable: controllerX.isEnable,
                                      onchanged: (value) {

                                      },autoFocus: false,
                                      focusNode: controllerX.productLevel1Focus

                                      // autoFocus: true,
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    InputFields.formField1(
                                      hintTxt: "Product Level 2",
                                      // autoFocus: true,
                                      controller: controllerX.productLevel2Controller,
                                      width: 0.36,
                                      // isEnable: controllerX.isEnable,
                                      onchanged: (value) {

                                      },
                                        focusNode: controllerX.productLevel2Focus
                                      // autoFocus: true,
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    InputFields.formField1(
                                      hintTxt: "Product Level 3",
                                      // autoFocus: true,
                                      controller:  controllerX.productLevel3Controller,
                                      width: 0.36,
                                      // isEnable: controllerX.isEnable,
                                      onchanged: (value) {

                                      },
                                        focusNode: controllerX.productLevel3Focus
                                      // autoFocus: true,
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    InputFields.formField1(
                                      hintTxt: "Product Level 4",
                                      // autoFocus: true,
                                      controller: controllerX.productLevel4Controller,
                                      width: 0.36,
                                      // isEnable: controllerX.isEnable,
                                      onchanged: (value) {

                                      },
                                        focusNode: controllerX.productLevel4Focus
                                      // autoFocus: true,
                                    ),

                                  ],
                                );
                              }
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 11,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey)),
                                  child: GetBuilder<BrandMasterController>(
                                      id: "grid",
                                      builder: (controllerX) {
                                        return Container(
                                            child:
                                            (controllerX.clientDetailsAndBrandModel != null)?
                                            (controllerX.clientDetailsAndBrandModel!.clientdtails != null &&
                                                controllerX.clientDetailsAndBrandModel!.clientdtails!.isNotEmpty
                                            )?
                                            DataGridFromMap(
                                                hideCode: false,
                                                formatDate: false,
                                                focusNode: controllerX.gridFocus,
                                                exportFileName: "Brand Master",
                                                hideKeys: ['clientName'],
                                                onRowDoubleTap: (PlutoGridOnRowDoubleTapEvent val){
                                                  controllerX.fetchDataFromGrid(val.rowIdx);
                                                  controllerX.selectedIndex = val.rowIdx;
                                                  controllerX.gridStateManager!.setCurrentCell(controllerX.gridStateManager!.getRowByIdx(controllerX.selectedIndex)!.cells['brandName'],
                                                      controllerX.selectedIndex);
                                                  controllerX.gridStateManager!.moveCurrentCellByRowIdx(controllerX.selectedIndex??0, PlutoMoveDirection.down);
                                                },
                                                // checkRow: true,
                                                // checkRowKey: "no",
                                                mode: PlutoGridMode.selectWithOneTap,
                                                onSelected: (PlutoGridOnSelectedEvent? val ){
                                                    controllerX.selectedIndex = val?.rowIdx;
                                                },

                                                onload: (PlutoGridOnLoadedEvent load) {
                                                  controllerX.gridStateManager = load.stateManager;
                                                  controllerX.gridStateManager!.setCurrentCell(controllerX.gridStateManager!.getRowByIdx(controllerX.selectedIndex)!.cells['brandName'],
                                                      controllerX.selectedIndex);
                                                  controllerX.gridStateManager!.moveCurrentCellByRowIdx(controllerX.selectedIndex??0, PlutoMoveDirection.down);
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
                SizedBox(height: 7),
                GetBuilder<HomeController>(
                    id: "buttons",
                    init: Get.find<HomeController>(),
                    builder: (controller) {
                      PermissionModel formPermissions = Get.find<MainController>()
                          .permissionList!
                          .lastWhere((element) =>
                      element.appFormName == "frmBrandMaster");
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
