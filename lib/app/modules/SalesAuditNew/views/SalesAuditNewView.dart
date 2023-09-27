import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';

import '../../../../widgets/DateTime/DateWithThreeTextField.dart';
import '../../../../widgets/FormButton.dart';
import '../../../../widgets/LoadingDialog.dart';
import '../../../../widgets/PlutoGrid/src/helper/pluto_move_direction.dart';
import '../../../../widgets/PlutoGrid/src/pluto_grid.dart';
import '../../../../widgets/Snack.dart';
import '../../../../widgets/dropdown.dart';
import '../../../../widgets/gridFromMap.dart';
import '../../../controller/HomeController.dart';
import '../../../controller/MainController.dart';
import '../../../data/PermissionModel.dart';
import '../../../data/user_data_settings_model.dart';
import '../../../providers/SizeDefine.dart';
import '../../../providers/Utils.dart';
import '../controllers/SalesAuditNewController.dart';

class SalesAuditNewView  extends StatelessWidget  {

  SalesAuditNewController controller = Get.put<SalesAuditNewController>(SalesAuditNewController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RawKeyboardListener(

        focusNode: FocusNode(),
        onKey: (RawKeyEvent raw) async {
          // print("RAw is.>>>" + raw.toString());
         /* if(raw is RawKeyDownEvent && raw.isControlPressed && raw.character?.toLowerCase() =="c"){
            if(controller.gridStateManagerLeft?.hasFocus == true){
              print(">>>>>>>>>>>>>>>gridStateManagerLeft"+
                  (controller.gridStateManagerLeft?.currentSelectingPosition?.columnIdx).toString());
              print(">>>>>>>>>>>>>>>gridStateManagerLeft"+
                  ( controller.gridStateManagerLeft?.currentSelectingRows).toString());
            }if(controller.gridStateManagerRight?.hasFocus == true){
              print(">>>>>>>>>>>>>>>gridStateManagerRight"+
                  (controller.gridStateManagerRight?.currentSelectingPosition).toString());
              print(">>>>>>>>>>>>>>>gridStateManagerRight"+
                  ( controller.gridStateManagerRight?.currentSelectingRows).toString());
            }

          }*/
          switch (raw.logicalKey.keyLabel) {
            case "F5":
              controller.markError(controller.gridStateManagerLeft?.currentRowIdx??0);
              break;
            case "F3":
              if(controller.gridStateManagerLeft?.hasFocus == true &&
                  ((controller.gridStateManagerLeft?.currentColumn?.title??"").toString().trim().toLowerCase() == "remarks")){
                print(">>>>>>>>>>>>currentCell data"+(controller.gridStateManagerLeft?.currentColumn?.title).toString());
                Clipboard.setData( ClipboardData(
                    text: controller.gridStateManagerLeft?.currentCell?.value));
                // Utils.copyToClipboardHack(text)
              }
              break;
            case "F4":
              if(controller.gridStateManagerLeft?.hasFocus == true &&
                  ((controller.gridStateManagerLeft?.currentColumn?.title??"").toString().trim().toLowerCase() == "remarks")){
                print(">>>>>>>>>>>>currentCell data"+(controller.gridStateManagerLeft?.currentColumn?.title).toString());
                ClipboardData? data = await Clipboard.getData('text/plain');
                print(">>>>>>>>>>Clipboard"+(data?.text).toString());

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
                                      inkWellFocusNode: controller.locationNode,
                                      // isEnable: controller.isEnable.value,
                                      // selected: controller.selectLocation,
                                      autoFocus: true,
                                      dialogWidth: 330,
                                      dialogHeight: Get.height * .35,
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
                                      inkWellFocusNode: controller.channelNode,
                                      // isEnable: controller.isEnable.value,
                                      // selected: controller.selectChannel,
                                      autoFocus: true,
                                      dialogWidth: 330,
                                      dialogHeight: Get.height * .45,
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
                                        DataGridFromMap4(
                                            hideCode: false,
                                            formatDate: false,
                                            exportFileName: "Sales Audit New",
                                            csvFormat: true,
                                            removeKeysFromFile: ['Booking Status','bookingStatus'],
                                            onRowDoubleTap: (PlutoGridOnRowDoubleTapEvent? val){
                                                  print(">>>>>>>>"+val!.rowIdx .toString());
                                                  controller.tapeBtn(leftIndex: val.rowIdx,rightIndex: controller.gridStateManagerRight?.currentRowIdx);

                                               },
                                            colorCallback: (PlutoRowColorContext colorData){
                                              Color color = Colors.white;
                                              if(controller.gridStateManagerLeft?.currentRowIdx == colorData.rowIdx){
                                                color = Color(0xFFD1C4E9);
                                              }
                                              else if(colorData.row.cells['telecastTime']!.value != "" &&
                                                  colorData.row.cells['telecastTime']!.value != null &&
                                                  colorData.row.cells['telecastTime']!.value != "null" &&
                                                  colorData.row.cells['telecastTime']!.value != " "
                                              ){
                                                color = Colors.greenAccent;
                                              }
                                              else if(colorData.row.cells['bookingStatus']!.value.toString().toLowerCase().trim() == "e"){
                                                color = Colors.redAccent;
                                              }else{
                                                color = Colors.white;
                                              }
                                              return color;
                                            },

                                            // checkRow: true,
                                            // checkRowKey: "no",
                                            mode: PlutoGridMode.normal,
                                            editKeys: const ["remarks"],
                                            onEdit: (PlutoGridOnChangedEvent ev){


                                            },

                                            onSelected: (PlutoGridOnSelectedEvent? val ){
                                                 // print("singlr click"+val!.row!.toJson().toString());
                                                 print("singlr click"+val!.rowIdx.toString());
                                                 controller.selectedIndex = val.rowIdx;
                                                //  controller.gridStateManagerRight?.setCurrentCell(controller.gridStateManagerRight?.rows[2].cells["no"], 2) ;
                                             },
                                            hideKeys: const ['locationcode','channelcode',
                                              'recordnumber','rowNumber',
                                              'programCode','previousBookingStatus','scheduleProgramCode'],
                                            witdthSpecificColumn: (controller
                                                        .userDataSettings?.userSetting
                                                        ?.firstWhere(
                                                            (element) =>
                                                                element.controlName == "gridStateManagerLeft",
                                                            orElse: () => UserSetting())
                                                        .userSettings),
                                            onload:
                                                (PlutoGridOnLoadedEvent load) {

                                              if(controller.showError.value == true && controller.showCancel.value != true){
                                                load.stateManager.setFilter((e)=>e.cells['bookingStatus']?.value.toString().trim().toLowerCase() != "c");
                                              }else if(controller.showError.value != true && controller.showCancel.value == true){
                                                load.stateManager.setFilter((e)=>e.cells['bookingStatus']?.value.toString().trim().toLowerCase() != "e");
                                              }else if(controller.showError.value != true && controller.showCancel.value != true){
                                                load.stateManager.setFilter((e)=>( e.cells['bookingStatus']?.value.toString().trim().toLowerCase() != "e" &&
                                                    e.cells['bookingStatus']?.value.toString().trim().toLowerCase() != "c" ));
                                              }else{
                                                load.stateManager.setFilter((element) => true);
                                              }
                                              controller.gridStateManagerLeft = load.stateManager;
                                              controller.gridStateManagerLeft?.setCurrentCell(controller.gridStateManagerLeft?.
                                              getRowByIdx(controller.selectedIndex)?.cells['exportTapeCode'],
                                                  controller.selectedIndex);
                                              controller.gridStateManagerLeft?.moveCurrentCellByRowIdx(controller.selectedIndex??0, PlutoMoveDirection.down);
                                              load.stateManager.notifyListeners();
                                            },
                                            enableSort: true,
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
                                            DataGridFromMap4(
                                                hideCode: false,
                                                formatDate: true,
                                                enableSort: true,
                                                dateFromat: "dd/MM/yyyy",
                                                focusNode: controller.rightFocusNode,
                                                csvFormat: true,
                                                exportFileName: "Sales Audit New",
                                                onRowDoubleTap: (PlutoGridOnRowDoubleTapEvent? val){
                                                  print(">>>>>>>>"+val!.row.toString());
                                                  controller.tapeBtn(leftIndex: controller.gridStateManagerLeft?.currentRowIdx,rightIndex: val.rowIdx);
                                                },
                                                colorCallback: (PlutoRowColorContext colorData){
                                                  Color color = Colors.white;
                                                  if(controller.gridStateManagerRight?.currentRowIdx == colorData.rowIdx ){
                                                    color = Color(0xFFD1C4E9);
                                                  }else if(colorData.row.cells['bookingNumber']!.value != "" &&
                                                      colorData.row.cells['bookingNumber']!.value != null &&
                                                      colorData.row.cells['bookingNumber']!.value != "null" &&
                                                      colorData.row.cells['bookingNumber']!.value != " "
                                                  ){
                                                    color = Colors.greenAccent;
                                                  }else{
                                                    color = Colors.white;
                                                  }
                                                  return color;
                                                },
                                                // checkRow: true,
                                                // checkRowKey: "no",
                                                mode: PlutoGridMode.normal,
                                                hideKeys: ['programCode','rownumber','bookingDetailCode'],
                                                onSelected: (PlutoGridOnSelectedEvent? val ){
                                                  // print("singlr click"+val!.row!.toJson().toString());
                                                  print("singlr click"+val!.rowIdx.toString());
                                                  controller.selectedRightIndex = val.rowIdx;
                                                },
                                                 witdthSpecificColumn: (controller
                                                        .userDataSettings?.userSetting
                                                        ?.firstWhere(
                                                            (element) =>
                                                                element.controlName == "gridStateManagerRight",
                                                            orElse: () => UserSetting())
                                                        .userSettings),
                                                onload:
                                                    (PlutoGridOnLoadedEvent
                                                load) {
                                                  controller.gridStateManagerRight = load.stateManager;
                                                  controller.gridStateManagerRight?.setCurrentCell(controller.gridStateManagerRight?.
                                                  getRowByIdx(controller.selectedRightIndex)?.cells['exportTapeCode'],
                                                      controller.selectedRightIndex);
                                                  controller.gridStateManagerRight?.moveCurrentCellByRowIdx(controller.selectedRightIndex??0,
                                                      PlutoMoveDirection.down);

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
                      Container(
                        width: MediaQuery.of(context).size.width*0.7,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            FormButtonWrapper(
                              btnText: "Un Cancel",
                              showIcon: false,
                              // isEnabled: btn['isDisabled'],
                              callback: (){
                                // controller.gridStateManagerLeft?.setFilter((element) => true);
                                // controller.gridStateManagerLeft?.notifyListeners();
                              },
                            ),
                            FormButtonWrapper(
                              btnText: "Error (F5)",
                              showIcon: false,
                              // isEnabled: btn['isDisabled'],
                              callback: (){
                                controller.markError(controller.gridStateManagerLeft?.currentRowIdx??0);
                              },
                            ),
                            FormButtonWrapper(
                              btnText: "Auto",
                              showIcon: false,
                              // isEnabled: btn['isDisabled'],
                              callback: (){
                                controller.btnAutoClick();
                              },
                            ),
                            FormButtonWrapper(
                              btnText: "Un Match",
                              showIcon: false,
                              // isEnabled: btn['isDisabled'],
                              callback: (){
                                controller.unMatchBtn();
                              },
                            ),
                            FormButtonWrapper(
                              btnText: "Tapes",
                              showIcon: false,
                              // isEnabled: btn['isDisabled'],
                              callback: (){
                                if(controller.gridStateManagerLeft != null &&
                                    controller.gridStateManagerRight != null ){
                                  controller.tapeBtn(leftIndex: controller.gridStateManagerLeft?.currentRowIdx,
                                     rightIndex:  controller.gridStateManagerRight?.currentRowIdx);
                                }else if(controller.gridStateManagerLeft != null){
                                  controller.tapeBtn(leftIndex: controller.gridStateManagerLeft?.currentRowIdx);
                                }else if(controller.gridStateManagerRight != null){
                                  controller.tapeBtn(rightIndex: controller.gridStateManagerRight?.currentRowIdx);
                                }

                              },
                            ),
                            FormButtonWrapper(
                              btnText: "Show All",
                              showIcon: false,
                              // isEnabled: btn['isDisabled'],
                              callback: (){
                                controller.showAll();
                              },
                            ),
                            FormButtonWrapper(
                              btnText: "Map",
                              showIcon: false,
                              // isEnabled: btn['isDisabled'],
                              callback: (){
                                controller.btnMapClick(controller.gridStateManagerRight?.currentRowIdx,controller.gridStateManagerLeft?.currentRowIdx);
                              },
                            ),
                            FormButtonWrapper(
                              btnText: "Telecast",
                              showIcon: false,
                              // isEnabled: btn['isDisabled'],
                              callback: (){
                               controller.gridStateManagerLeft?.rows[controller.gridStateManagerLeft?.
                               currentRowIdx??0].cells['telecastTime']?.value = controller.gridStateManagerLeft?.rows[controller.gridStateManagerLeft?.
                               currentRowIdx??0].cells['scheduleTime']?.value;
                               controller.gridStateManagerLeft?.rows[controller.gridStateManagerLeft?.
                               currentRowIdx??0].cells['programCode']?.value =  controller.gridStateManagerLeft?.rows[controller.gridStateManagerLeft?.
                               currentRowIdx??0].cells['scheduleProgramCode']?.value;
                               controller.gridStateManagerLeft?.rows[controller.gridStateManagerLeft?.
                               currentRowIdx??0].cells['rowNumber']?.value = 0;
                               controller.gridStateManagerLeft?.notifyListeners();
                              },
                            ),
                            FormButtonWrapper(
                              btnText: "Clear",
                              showIcon: false,
                              // isEnabled: btn['isDisabled'],
                              callback: (){
                                // controller.clearBtn(controller.gridStateManager!.currentRowIdx??0,controller.gridStateManagerRight!.currentRowIdx??0);
                                controller.btnMapClear_Click();
                              },
                            ),
                            FormButtonWrapper(
                              btnText: "B 2 E",
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
                    element.appFormName == "TransmissionLog");
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
