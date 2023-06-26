import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../../widgets/DateTime/DateWithThreeTextField.dart';
import '../../../../widgets/FormButton.dart';
import '../../../../widgets/LoadingDialog.dart';
import '../../../../widgets/PlutoGrid/src/pluto_grid.dart';
import '../../../../widgets/Snack.dart';
import '../../../../widgets/dropdown.dart';
import '../../../../widgets/gridFromMap.dart';
import '../../../controller/HomeController.dart';
import '../../../controller/MainController.dart';
import '../../../data/PermissionModel.dart';
import '../../../providers/SizeDefine.dart';
import '../../../providers/Utils.dart';
import '../controllers/SalesAuditNewController.dart';

class SalesAuditNewView  extends StatelessWidget  {

  SalesAuditNewController controller = Get.put<SalesAuditNewController>(SalesAuditNewController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RawKeyboardListener(

        focusNode: new FocusNode(),
        onKey: (RawKeyEvent raw) {
          // print("RAw is.>>>" + raw.toString());
          switch (raw.logicalKey.keyLabel) {
            case "F5":
              if(controller.listAsrunLog2[controller.selectedIndex!].bookingStatus != "E"){
                if(controller.listAsrunLog2[controller.selectedIndex!].telecastTime == null ||
                    controller.listAsrunLog2[controller.selectedIndex!].telecastTime == "" ||
                    controller.listAsrunLog2[controller.selectedIndex!].telecastTime == "null" ){

                  LoadingDialog.recordExists(
                      "Do you want to mark as Error?",
                          (){
                        controller.markError(controller.selectedIndex!);
                      },
                      cancel: (){
                        Get.back();
                      });

                }
                else{
                  Snack.callError("Telecast Spot!\nUnable To mark as error!");
                }
              }
              else{
                LoadingDialog.recordExists(
                    "Do you want to clear Error making?",
                        (){
                      controller.markError(controller.selectedIndex!);
                    },
                    cancel: (){
                      Get.back();
                    });
              }
              break;
          }
        },

        child: SizedBox(
          height: double.maxFinite,
          width: double.maxFinite,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: FocusTraversalGroup(
                  policy: OrderedTraversalPolicy(),
                  child: Column(
                    children: [
                      GetBuilder<SalesAuditNewController>(
                        init: controller,
                        id: "updateView",
                        builder: (control) {
                          return Padding(
                            padding:
                                const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                            child: SizedBox(
                              width: double.maxFinite,
                              child: Wrap(
                                crossAxisAlignment: WrapCrossAlignment.center,
                                runSpacing: 5,
                                spacing: 5,
                                children: [
                                  Obx(
                                    () => DropDownField.formDropDown1WidthMap(
                                      controller.locationList.value??[],
                                      (value) {
                                        controller.selectedLocation = value;
                                        controller.fetchListOfChannel(value.key??"");
                                        // controller.selectLocation = value;
                                        // controller.getChannels(
                                        //     controller.selectLocation?.key ?? "");
                                      },
                                      "Location",
                                       0.12,
                                      // isEnable: controller.isEnable.value,
                                      // selected: controller.selectLocation,
                                      autoFocus: true,
                                      dialogWidth: 330,
                                      dialogHeight: Get.height * .7,
                                    ),
                                  ),

                                  /// channel
                                  Obx(
                                    () => DropDownField.formDropDown1WidthMap(
                                      controller.channelList.value??[],
                                      (value) {
                                        controller.selectedChannel = value;
                                        // controller.selectChannel = value;
                                        // controller.getChannelFocusOut();
                                      },
                                      "Channel",
                                      0.12,
                                      // isEnable: controller.isEnable.value,
                                      // selected: controller.selectChannel,
                                      autoFocus: true,
                                      dialogWidth: 330,
                                      dialogHeight: Get.height * .7,
                                    ),
                                  ),

                                  Obx(
                                    () => DateWithThreeTextField(
                                      title: "Schedule Date",
                                      splitType: "-",
                                      widthRation: 0.12,
                                      isEnable: controller.isEnable.value,
                                      onFocusChange: (data) {

                                      },
                                      mainTextController: controller.scheduledController,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 14.0, left: 10, right: 10),
                                    child: FormButtonWrapper(
                                      btnText: "Retrieve",
                                      callback: () {
                                         controller.callGetRetrieve();
                                      },
                                      showIcon: false,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                      Row(
                        children: [
                        Expanded(child: Row(
                          mainAxisAlignment:MainAxisAlignment.spaceEvenly,
                          children: [
                            Text("Not Telacast Spots"),
                            SizedBox(
                              width: Get.width * 0.079,
                              child: Row(
                                children: [
                                  SizedBox(width: 5),
                                  Obx(() =>
                                      Padding(
                                        padding: const EdgeInsets.only(top: 1.0),
                                        child: Checkbox(
                                          value: controller.showError.value,
                                          onChanged: (val) {
                                            controller.showError.value = val!;
                                            controller.filterSearchAndCancel();
                                          },
                                          materialTapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                        ),
                                      )),
                                  Obx(
                                        () =>
                                        Padding(
                                            padding: const EdgeInsets.only(
                                                top: 1.0, left: 5),
                                            child: Text(
                                              "Show Error",
                                              style: TextStyle(
                                                  fontSize: SizeDefine.labelSize1,
                                                  color: controller.isEnable.value
                                                      ? Colors.black
                                                      : Colors.grey),
                                            )),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: Get.width * 0.079,
                              child: Row(
                                children: [
                                  SizedBox(width: 5),
                                  Obx(() =>
                                      Padding(
                                        padding: const EdgeInsets.only(top: 1.0),
                                        child: Checkbox(
                                          value: controller.showCancel.value,
                                          onChanged: (val) {
                                            controller.showCancel.value = val!;
                                            controller.filterSearchAndCancel();
                                          },
                                          materialTapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                        ),
                                      )),
                                  Obx(
                                        () =>
                                        Padding(
                                            padding: const EdgeInsets.only(
                                                top: 1.0, left: 5),
                                            child: Text(
                                              "Show Cancel",
                                              style: TextStyle(
                                                  fontSize: SizeDefine.labelSize1,
                                                  color: controller.isEnable.value
                                                      ? Colors.black
                                                      : Colors.grey),
                                            )),
                                  ),
                                ],
                              ),
                            ),
                            GetBuilder<SalesAuditNewController>(
                              id:"text",
                              builder: (controller) {
                                return (controller.salesAuditGetRetrieveModel != null &&
                                    controller.salesAuditGetRetrieveModel!.gettables!.asrunStatus != null)?
                                Text( controller.salesAuditGetRetrieveModel!.gettables!.asrunStatus ??""):Text("");
                              }
                            ),
                          ],
                        ),),
                        Expanded(child:
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                child: Text("Telecast Spots"),
                              ),
                            ],
                          ),
                        ),),
                        ],
                      ),
                      Expanded(
                        // padding: const EdgeInsets.all(8.0),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Expanded(
                                  child: GetBuilder<SalesAuditNewController>(
                                    id:"leftOne",
                                    builder: (controller) {
                                      return
                                      Container(
                                          // height: Get.height*0.6,
                                          decoration: BoxDecoration(
                                              border: Border.all(color: Colors.black)),
                                        child:(controller.salesAuditGetRetrieveModel != null)?
                                        (controller.listAsrunLog2.length >0 )?
                                        DataGridFromMap(
                                            hideCode: false,
                                            formatDate: false,
                                            onRowDoubleTap: (PlutoGridOnRowDoubleTapEvent? val){
                                                  print(">>>>>>>>"+val!.row.toString());
                                               },
                                            colorCallback: (PlutoRowColorContext colorData){
                                              Color color = Colors.white;
                                              if(colorData.row.cells['telecastTime']!.value != "" &&
                                                  colorData.row.cells['telecastTime']!.value != null &&
                                                  colorData.row.cells['telecastTime']!.value != "null"
                                              ){
                                                color = Colors.greenAccent;
                                              }
                                              else if(colorData.row.cells['bookingStatus']!.value == "E"){
                                                color = Colors.redAccent;
                                              }else{
                                                color = Colors.white;
                                              }
                                              return color;
                                            },

                                            // checkRow: true,
                                            // checkRowKey: "no",
                                            mode: PlutoGridMode.selectWithOneTap,
                                            onSelected: (PlutoGridOnSelectedEvent? val ){
                                                 // print("singlr click"+val!.row!.toJson().toString());
                                                 print("singlr click"+val!.rowIdx.toString());
                                                 controller.selectedIndex = val.rowIdx;
                                             },

                                            onload:
                                                (PlutoGridOnLoadedEvent
                                            load) {
                                              controller.gridStateManager = load.stateManager;
                                              /*controller.tblFastInsert =
                                                                load.stateManager;*/
                                            },
                                            // colorCallback: (renderC) => Colors.red[200]!,
                                            mapData:controller.listAsrunLog2.map((e) =>
                                                e.toJson()).toList() ):Container():Container(),
                                      );
                                    }
                                  )),
                              SizedBox(
                                width: 5,
                              ),
                              Expanded(
                                  child: GetBuilder<SalesAuditNewController>(
                                      id:"rightOne",
                                      builder: (controller) {
                                        return
                                          Container(
                                            // height: Get.height*0.6,
                                            decoration: BoxDecoration(
                                                border: Border.all(color: Colors.black)),
                                            child:(controller.salesAuditGetRetrieveModel != null)?
                                            (controller.listAsrunLog1.length >0 )?
                                            DataGridFromMap(
                                                hideCode: false,
                                                formatDate: false,
                                                onRowDoubleTap: (PlutoGridOnRowDoubleTapEvent? val){
                                                  print(">>>>>>>>"+val!.row.toString());
                                                },
                                                colorCallback: (PlutoRowColorContext colorData){
                                                  Color color = Colors.white;
                                                  return color;
                                                },

                                                // checkRow: true,
                                                // checkRowKey: "no",
                                                mode: PlutoGridMode.selectWithOneTap,
                                                onSelected: (PlutoGridOnSelectedEvent? val ){
                                                  // print("singlr click"+val!.row!.toJson().toString());
                                                  print("singlr click"+val!.rowIdx.toString());
                                                  controller.selectedRightIndex = val.rowIdx;
                                                },

                                                onload:
                                                    (PlutoGridOnLoadedEvent
                                                load) {
                                                  controller.gridStateManagerRight = load.stateManager;
                                                  /*controller.tblFastInsert =
                                                                load.stateManager;*/
                                                },
                                                // colorCallback: (renderC) => Colors.red[200]!,
                                                mapData:controller.listAsrunLog1.map((e) =>
                                                    e.toJson()).toList() ):Container():Container(),
                                          );
                                      }
                                  )),
                            ],
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          FormButtonWrapper(
                            btnText: "Un Cancel",
                            showIcon: false,
                            // isEnabled: btn['isDisabled'],
                            callback: (){
                              // controller.unCancel(controller.selectedIndex!);
                            },
                          ),
                          FormButtonWrapper(
                            btnText: "Error",
                            showIcon: false,
                            // isEnabled: btn['isDisabled'],
                            callback: (){
                              if(controller.listAsrunLog2[controller.selectedIndex!].bookingStatus != "E"){
                                if(controller.listAsrunLog2[controller.selectedIndex!].telecastTime == null ||
                                    controller.listAsrunLog2[controller.selectedIndex!].telecastTime == "" ||
                                    controller.listAsrunLog2[controller.selectedIndex!].telecastTime == "null" ){

                                  LoadingDialog.recordExists(
                                      "Do you want to mark as Error?",
                                          (){
                                        controller.markError(controller.selectedIndex!);
                                      },
                                      cancel: (){
                                        Get.back();
                                      });

                                }
                                else{
                                  Snack.callError("Telecast Spot!\nUnable To mark as error!");
                                }
                              }
                              else{
                                LoadingDialog.recordExists(
                                    "Do you want to clear Error making?",
                                        (){
                                      controller.markError(controller.selectedIndex!);
                                    },
                                    cancel: (){
                                      Get.back();
                                    });
                              }
                            },
                          ),FormButtonWrapper(
                            btnText: "Auto",
                            showIcon: false,
                            // isEnabled: btn['isDisabled'],
                            callback: (){},
                          ),FormButtonWrapper(
                            btnText: "Un Match",
                            showIcon: false,
                            // isEnabled: btn['isDisabled'],
                            callback: (){},
                          ),FormButtonWrapper(
                            btnText: "Tapes",
                            showIcon: false,
                            // isEnabled: btn['isDisabled'],
                            callback: (){},
                          ),FormButtonWrapper(
                            btnText: "Show All",
                            showIcon: false,
                            // isEnabled: btn['isDisabled'],
                            callback: (){},
                          ),FormButtonWrapper(
                            btnText: "Map",
                            showIcon: false,
                            // isEnabled: btn['isDisabled'],
                            callback: (){},
                          ),FormButtonWrapper(
                            btnText: "Telecast",
                            showIcon: false,
                            // isEnabled: btn['isDisabled'],
                            callback: (){
                             for(int i=0;i<controller.listAsrunLog2.length;i++){
                               if(i == controller.selectedIndex){
                                 controller.listAsrunLog2[i].telecastTime =
                                     controller.listAsrunLog2[i].scheduleTime;
                                 controller.update(['leftOne']);
                                 break;
                               }
                             }
                            },
                          ),FormButtonWrapper(
                            btnText: "Clear",
                            showIcon: false,
                            // isEnabled: btn['isDisabled'],
                            callback: (){},
                          ),FormButtonWrapper(
                            btnText: "B2E",
                            showIcon: false,
                            // isEnabled: btn['isDisabled'],
                            callback: (){
                              LoadingDialog.recordExists("Will mark all booked spots as error!\n"
                                  " Do you want tp proceed", (){
                                controller.allBToE();
                              },cancel: (){
                                Get.back();
                              });


                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              GetBuilder<HomeController>(
                  id: "buttons",
                  init: Get.find<HomeController>(),
                  builder: (controller1) {
                    PermissionModel formPermissions =
                    Get
                        .find<MainController>()
                        .permissionList!
                        .lastWhere((element) =>
                    element.appFormName == "frmProgramMaster");
                    print("Log>> Permission>>" +
                        jsonEncode(formPermissions.toJson()));
                    if (controller1.buttons != null) {
                      return ButtonBar(
                        alignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          for (var btn in controller1.buttons!)
                            FormButtonWrapper(
                                btnText: btn["name"],
                                callback: Utils.btnAccessHandler2(
                                    btn['name'], controller1,
                                    formPermissions) == null
                                    ? null
                                    : () =>
                                    controller.formHandler(
                                      btn['name'],),)
                        ],
                      );
                    }
                    return Container();
                  })
            ],
          ),
        ),
      ),
    );
  }


}
