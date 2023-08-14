import 'package:bms_scheduling/widgets/DateTime/DateWithThreeTextField.dart';
import 'package:bms_scheduling/widgets/LoadingDialog.dart';
import 'package:bms_scheduling/widgets/NumericStepButton.dart';
import 'package:bms_scheduling/widgets/Snack.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';

import '../../../../widgets/DateTime/TimeWithThreeTextField.dart';
import '../../../../widgets/FormButton.dart';
import '../../../../widgets/NumericStepButton1.dart';
import '../../../../widgets/PlutoGrid/src/pluto_grid.dart';
import '../../../../widgets/dropdown.dart';
import '../../../../widgets/gridFromMap.dart';
import '../../../../widgets/input_fields.dart';
import '../../../controller/HomeController.dart';
import '../../../controller/MainController.dart';
import '../../../data/DropDownValue.dart';
import '../../../data/PermissionModel.dart';
import '../../../providers/ApiFactory.dart';
import '../../../providers/SizeDefine.dart';
import '../../../providers/Utils.dart';
import '../controllers/commercial_master_controller.dart';

class CommercialMasterView extends StatelessWidget {
  CommercialMasterView({Key? key}) : super(key: key);

  // CommercialMasterController controllerX = Get.find<CommercialMasterController>();
  CommercialMasterController controllerX =
      Get.put<CommercialMasterController>(CommercialMasterController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: FocusTraversalGroup(
                policy: OrderedTraversalPolicy(),
                child: Row(
                  children: [
                    GetBuilder<CommercialMasterController>(
                        init: controllerX,
                        id: "updateLeft",
                        builder: (control) {
                          return FocusTraversalGroup(
                            policy: OrderedTraversalPolicy(),
                            child: Expanded(
                              flex: 12,
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey)),
                                padding: const EdgeInsets.all(16),
                                child: ListView(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        InputFields.formField1(
                                          hintTxt: "Caption",
                                          controller:
                                              controllerX.captionController,
                                          width: 0.17,
                                          autoFocus: true,
                                          capital: true,
                                          focusNode: controllerX.captionFocus,
                                          isEnable: controllerX.isEnable,
                                        ),
                                        SizedBox(
                                          width: MediaQuery.of(context).size.width*0.371,
                                          child: Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                            children: [
                                              InputFields.formField1(
                                                hintTxt: "Tx Caption",
                                                controller:
                                                controllerX.txCaptionController,
                                                width: 0.17,
                                                capital: true,
                                                autoFocus: true,
                                                isEnable: controllerX.isEnable,
                                                prefixText: "C/",
                                              ),
                                              Obx(() =>
                                                  DropDownField.formDropDown1WidthMap(
                                                      controllerX.language.value,
                                                          (value) {
                                                        controllerX.selectedLanguage =
                                                            value;
                                                      },
                                                      "Langauge",
                                                      .17,
                                                      autoFocus: true,
                                                      isEnable: controllerX.isEnable,
                                                      selected:
                                                      controllerX.selectedLanguage,
                                                      inkWellFocusNode: controllerX.languageFocus

                                                  )),
                                            ],
                                          ),
                                        ),

                                      ],
                                    ),
                                    SizedBox(height: 4),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Obx(() =>
                                            DropDownField.formDropDown1WidthMap(
                                                controllerX.revenueType.value,
                                                (value) {
                                              controllerX.selectedRevenueType =
                                                  value;
                                              controllerX.getSecType(controllerX
                                                      .selectedRevenueType
                                                      ?.key ??
                                                  "");
                                            }, "Revenue Type", .17,
                                                autoFocus: true,
                                                isEnable: controllerX.isEnable,
                                                selected: controllerX
                                                    .selectedRevenueType,
                                                inkWellFocusNode: controllerX.revenueFocus
                                                // selected: DropDownValue(key: "0",value: "jks"),
                                                )),

                                        SizedBox(
                                          width: MediaQuery.of(context).size.width*0.371,
                                          child: Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                            children: [
                                              Obx(() =>
                                                  DropDownField.formDropDown1WidthMap(
                                                      controllerX.secType.value,
                                                          (value) {
                                                        controllerX.selectedSecType =
                                                            value;

                                                        controllerX.getTapeId();
                                                        // controllerX.isListenerActive = true;
                                                      },
                                                      "Sec Type",
                                                      isEnable: controllerX.isEnable,
                                                      .17,
                                                      selected:
                                                      controllerX.selectedSecType,
                                                      autoFocus: true,
                                                      inkWellFocusNode: controllerX.secTypeFocus
                                                  )),
                                              RawKeyboardListener(
                                                focusNode: FocusNode(),
                                                onKey: (RawKeyEvent event) {
                                                  // Check if the event key is "v" (paste) and Ctrl (or Command) is pressed
                                                  if ((event.isControlPressed || event.isMetaPressed) &&
                                                      event.logicalKey == LogicalKeyboardKey.keyV &&
                                                      event is! RawKeyUpEvent) {
                                                    print("Ctrl + V pressed");
                                                    controllerX
                                                        .tapeIdController.value.text = "";
                                                    controllerX.txNoController.text = "";
                                                    controllerX.isListenerActive = false;
                                                    LoadingDialog.callInfoMessage("Ctrl + V not permitted.",callback: (){
                                                      controllerX
                                                          .tapeIdController.value.text = "";
                                                      controllerX.txNoController.text = "";
                                                    });
                                                  }
                                                },
                                                child: InputFields.formField3(
                                                  hintTxt: "Tape ID",
                                                  controller: controllerX
                                                      .tapeIdController.value,
                                                  width: 0.17,
                                                  isEnable: controllerX.isEnable,
                                                  autoFocus: true,
                                                  focusNode: controllerX.tapeIdFocus,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),


                                      ],
                                    ),
                                    SizedBox(height: 4),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        /* SizedBox(
                                          width: Get.width * .17,
                                          child: NumericStepButton1(
                                            onChanged: (val) {
                                              controllerX.segController.text = val.toString();

                                              controllerX.validateTxNo1("",controllerX.tapeIdController.value.text, controllerX.segController.text);

                                            },

                                            count: int.parse((controllerX
                                                            .segController
                                                            .text !=
                                                        null &&
                                                    controllerX.segController
                                                            .text !=
                                                        "")
                                                ? controllerX.segController.text
                                                : "1"),
                                            hint: "Seg #",
                                          ),

                                        ),*/
                                        SizedBox(
                                            // width: Get.width * .17,
                                            child: InputFields.numbers3(
                                          hintTxt: "Seg #",
                                          padLeft: 0,
                                          onchanged: (val) {
                                            print("onchanged call");
                                            // controllerX.segController.text = val.toString();
                                            controllerX.txNoController
                                                .text = controllerX
                                                    .tapeIdController
                                                    .value
                                                    .text +
                                                "-" +
                                                controllerX.segController.text;

                                            // controllerX.validateTxNo1("",controllerX.tapeIdController.value.text, controllerX.segController.text);
                                          },
                                          controller: controllerX.segController,
                                          isNegativeReq: false,
                                          width: 0.17,
                                          fN: controllerX.segNoFocus,
                                          // isEnabled: true,
                                        )),

                                        SizedBox(
                                          width: MediaQuery.of(context).size.width*0.371,
                                          child: Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                            children: [
                                              InputFields.formField1(
                                                  hintTxt: "TX No",
                                                  controller:
                                                  controllerX.txNoController,
                                                  width: 0.17,
                                                  isEnable: controllerX.isEnable,
                                                  autoFocus: true,
                                                  focusNode: controllerX.txNoFocus,
                                                  onchanged: (val) {
                                                    controllerX.validateTxNo(
                                                        val, "", "");
                                                  }),
                                              InputFields.formField1(
                                                hintTxt: "Agency Id",
                                                controller:
                                                controllerX.agencyIdController,
                                                width: 0.17,
                                                isEnable: controllerX.isEnable,
                                                autoFocus: true,
                                              ),
                                            ],
                                          ),
                                        ),


                                      ],
                                    ),
                                    SizedBox(height: 4),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Obx(() =>
                                            DropDownField.formDropDown1WidthMap(
                                                controllerX.tapeType.value,
                                                (value) {
                                              controllerX.selectedTapeType =
                                                  value;
                                            }, "Tape Type", .17,
                                                inkWellFocusNode: controllerX.tapeTypeFocus,
                                                isEnable: controllerX.isEnable,
                                                autoFocus: true,
                                                selected: controllerX
                                                    .selectedTapeType)),
                                        SizedBox(
                                          width: MediaQuery.of(context).size.width*0.371,
                                          child: Obx(() =>
                                              DropDownField.formDropDown1WidthMap(
                                                  controllerX.censorShipType
                                                      .value, (value) {
                                                controllerX
                                                    .selectedCensorShipType =
                                                    value;
                                              }, "Censhorship", .371,
                                                  isEnable: controllerX.isEnable,
                                                  autoFocus: true,
                                                  inkWellFocusNode: controllerX.censhorShipFocus,
                                                  selected: controllerX
                                                      .selectedCensorShipType)),
                                        ),

                                      ],
                                    ),
                                    SizedBox(height: 4),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        /*TimeWithThreeTextField(
                                          title: "SOM",
                                          mainTextController:
                                              controllerX.somController,
                                          widthRation: 0.17,
                                          isTime: false,
                                          onFocusChange: (time) {
                                            print("time" + time);
                                            controllerX.calculateDuration();
                                          },
                                        ),*/
                                        InputFields.formFieldNumberMask(
                                            hintTxt: "SOM",
                                            controller:
                                                controllerX.somController,
                                            widthRatio: 0.17,
                                            isEnable: controllerX.isEnable,
                                            /*onEditComplete: (val){
                                        controllerX.calculateDuration();
                                      },*/
                                            // isTime: true,
                                            // isEnable: controller.isEnable.value,
                                            paddingLeft: 0),


                                        SizedBox(
                                          width: MediaQuery.of(context).size.width*0.371,
                                          child: Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                            children: [
                                              InputFields.formFieldNumberMask(
                                                  hintTxt: "EOM",
                                                  controller:
                                                  controllerX.eomController,
                                                  widthRatio: 0.17,
                                                  isEnable: controllerX.isEnable,
                                                  onEditComplete: (val) {
                                                    controllerX.calculateDuration();
                                                  },
                                                  // isTime: true,
                                                  // isEnable: controller.isEnable.value,
                                                  paddingLeft: 0),
                                              /* TimeWithThreeTextField(
                                          title: "EOM",
                                          mainTextController:
                                              controllerX.eomController,
                                          widthRation: 0.17,
                                          isTime: false,
                                          onFocusChange: (time) {
                                            controllerX.calculateDuration();
                                          },
                                        ),*/
                                              Obx(() => TimeWithThreeTextField(
                                                title: "Duration",
                                                mainTextController:
                                                controllerX.duration.value,
                                                widthRation: 0.17,
                                                isTime: false,
                                                isEnable: false,
                                              )),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 4),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        InputFields.formField1(
                                          hintTxt: "Client",
                                          controller:
                                              controllerX.clientController,
                                          width: 0.17,
                                          isEnable: controllerX.isEnable,

                                          onchanged: (value) {
                                            if (value != null && value != "") {
                                              controllerX
                                                  .getClientDetails(value);
                                            } else {
                                              controllerX.clientDetails.clear();
                                            }
                                          },
                                          autoFocus: true,
                                        ),
                                        /* DropDownField.formDropDownSearchAPI2(
                                        GlobalKey(),
                                        context,
                                        width: context.width * .3712,
                                        onchanged: (val) {
                                          if(val != null && val != ""){
                                            controllerX.selectedClientDetails = val;
                                            controllerX. getAgencyBrandType(val.key??"");
                                          }

                                        },
                                        title: 'Client',
                                        url: ApiFactory.COMMERCIAL_MASTER_GETAGENCYBRAND,
                                      ),*/
                                        SizedBox(
                                          width: MediaQuery.of(context).size.width*0.371,
                                          child:    Obx(() =>
                                              DropDownField.formDropDown1WidthMap(
                                                  controllerX.clientDetails.value,
                                                      (value) {
                                                    controllerX
                                                        .selectedClientDetails =
                                                        value;
                                                    controllerX.getAgencyBrandType(
                                                        value.key ?? "");
                                                  }, "Client", .371,
                                                  isEnable: controllerX.isEnable,
                                                  autoFocus: true,
                                                  inkWellFocusNode: controllerX.clientFocus,
                                                  selected: controllerX
                                                      .selectedClientDetails)),
                                        ),

                                      ],
                                    ),
                                    SizedBox(height: 4),
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Obx(() => DropDownField
                                                  .formDropDown1WidthMap(
                                                      controllerX.brandType
                                                          .value, (value) {
                                                controllerX.selectedBrandType =
                                                    value;
                                                controllerX.getLevelDetails(
                                                    value.key ?? "");
                                              }, "Brand", .371,
                                                      isEnable:
                                                          controllerX.isEnable,
                                                      autoFocus: true,
                                                      selected: controllerX
                                                          .selectedBrandType)),
                                          InputFields.formField1(
                                            hintTxt: "Product Name",
                                            controller: controllerX
                                                .productNameController,
                                            width: 0.17,
                                            autoFocus: true,
                                            isEnable: controllerX.isEnable,
                                          ),
                                        ]),
                                    SizedBox(height: 4),
                                    GetBuilder<CommercialMasterController>(
                                        id: "level",
                                        builder: (controllerX) {
                                          return Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [


                                              SizedBox(
                                                width: MediaQuery.of(context).size.width*0.371,
                                                child: Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    InputFields.formField1(
                                                      hintTxt: "Level 1",
                                                      controller: controllerX
                                                          .level1Controller,
                                                      width: 0.17,
                                                      autoFocus: true,
                                                      isEnable: false,
                                                    ),
                                                    InputFields.formField1(
                                                      hintTxt: "Level 2",
                                                      controller: controllerX
                                                          .level2Controller,
                                                      width: 0.17,
                                                      autoFocus: true,
                                                      isEnable: false,
                                                    ),

                                                  ],
                                                ),
                                              ),
                                              InputFields.formField1(
                                                hintTxt: "Level 3",
                                                controller: controllerX
                                                    .level3Controller,
                                                width: 0.17,
                                                autoFocus: true,
                                                isEnable: false,
                                              ),

                                            ],
                                          );
                                        }),
                                    SizedBox(height: 4),
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          InputFields.formField1(
                                            hintTxt: "Agency",
                                            controller: controllerX
                                                .agencyNameController,
                                            width: 0.17,
                                            isEnable: controllerX.isEnable,
                                            onchanged: (val) {
                                              controllerX.getAgencyDetails(val);
                                              // controllerX.isListenerActive = true;
                                            },
                                            autoFocus: true,
                                          ),

                                          SizedBox(
                                            width: MediaQuery.of(context).size.width*0.371,
                                            child:   Obx(() =>
                                                DropDownField.formDropDown1WidthMap(
                                                    controllerX.agencyDetails
                                                        .value, (value) {
                                                  controllerX
                                                      .selectedAgencyDetails =
                                                      value;
                                                }, "Agency", .371,
                                                    inkWellFocusNode: controllerX.agencyFocus,
                                                    isEnable:
                                                    controllerX.isEnable,
                                                    autoFocus: true,
                                                    selected: controllerX
                                                        .selectedAgencyDetails)),
                                          ),
                                        ]),
                                    /* SizedBox(height: 14),
                                  DropDownField.formDropDownSearchAPI2(
                                    GlobalKey(),
                                    context,
                                    width: context.width * 0.6,
                                    onchanged: (val) {
                                      // print("val"+val.toString());
                                    },
                                    title: 'Agency',
                                    url: '',
                                  ),*/

                                    SizedBox(height: 4),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        DateWithThreeTextField(
                                          title: "End Date",
                                          mainTextController:
                                              controllerX.endDateController,
                                          widthRation: .17,
                                          isEnable: controllerX.isEnable,
                                        ),


                                        SizedBox(
                                          width: MediaQuery.of(context).size.width*0.371,
                                          child: Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                            children: [
                                              DateWithThreeTextField(
                                                title: "Dispatch",
                                                mainTextController: controllerX
                                                    .dispatchDateController,
                                                widthRation: .17,
                                                isEnable: controllerX.isEnable,
                                              ),
                                              InputFields.formField1(
                                                hintTxt: "Clock ID",
                                                focusNode: controllerX.clockIdFocus,
                                                controller:
                                                controllerX.clockIdController,
                                                width: 0.17,
                                                isEnable: controllerX.isEnable,
                                                /*  onchanged: (val){
                                            controllerX.fetchCommercialTapeMasterData(
                                                "",
                                                "",
                                                0,
                                                controllerX.clockIdController.text);
                                          }*/
                                              ),
                                            ],
                                          ),
                                        ),

                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                    SizedBox(width: 14),
                    FocusTraversalGroup(
                      policy: OrderedTraversalPolicy(),
                      child: Expanded(
                        flex: 8,
                        child: GetBuilder<CommercialMasterController>(
                          builder: (controllerX) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Text("Annotation Details"),
                                SizedBox(height: 5),
                                Expanded(
                                  child: Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                        border: Border.all(color: Colors.grey)),
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      children: [
                                        GetBuilder<CommercialMasterController>(
                                          builder: (controllerX) {
                                            return DropDownField
                                                .formDropDownSearchAPI2(
                                              GlobalKey(),
                                              context,
                                              width: context.width * 0.37,
                                              onchanged: (DropDownValue? val) {
                                                print(">>>" + val.toString());
                                                controllerX.selectedEvent = val;
                                              },
                                              title: 'Event',
                                              url: ApiFactory
                                                  .COMMERCIAL_MASTER_GETLEVENT,
                                              parseKeyForKey: "eventid",
                                              parseKeyForValue: 'eventname',
                                              selectedValue:
                                                  controllerX.selectedEvent,
                                              autoFocus: true,
                                              // maxLength: 1
                                            );
                                          },
                                          id: "event",
                                        ),
                                        SizedBox(height: 14),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            /*   TimeWithThreeTextField(
                                              title: "TC In",
                                              mainTextController:
                                                  controllerX.tcInController,
                                              widthRation: 0.11,
                                              isTime: false,
                                            ),*/
                                            InputFields.formFieldNumberMask(
                                                hintTxt: "TC In",
                                                controller:
                                                    controllerX.tcInController,
                                                widthRatio: 0.11,
                                                isEnable: controllerX.isEnable,
                                                // isTime: true,
                                                // isEnable: controller.isEnable.value,
                                                paddingLeft: 0),
                                            InputFields.formFieldNumberMask(
                                                hintTxt: "TC Out",
                                                controller:
                                                    controllerX.tcOutController,
                                                widthRatio: 0.11,
                                                // isTime: true,
                                                // isEnable: controller.isEnable.value,
                                                paddingLeft: 0),
                                            /*   TimeWithThreeTextField(
                                              title: "TC Out",
                                              mainTextController:
                                                  controllerX.tcOutController,
                                              widthRation: 0.11,
                                              isTime: false,
                                            ),*/
                                          ],
                                        ),
                                        SizedBox(height: 14),
                                        Row(
                                          children: [
                                            FormButton(
                                                btnText: "Add",
                                                callback: () {
                                                  controllerX.addEvent();
                                                }),
                                            Spacer(),
                                            Text(
                                              'Press "DEL" to delete Annotation Detail',
                                              style: TextStyle(
                                                color: Colors.deepPurple,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 14),
                                        Expanded(
                                          child: Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: Colors.grey,
                                              ),
                                            ),
                                            child: (controllerX
                                                    .eventList.isNotEmpty)
                                                ? DataGridFromMap(
                                                    hideCode: false,
                                                    formatDate: false,
                                                    checkRow: true,
                                                    checkRowKey: "no",
                                                    onload:
                                                        (PlutoGridOnLoadedEvent
                                                            load) {
                                                      /*controller.tblFastInsert =
                                                          load.stateManager;*/
                                                    },
                                                    // colorCallback: (renderC) => Colors.red[200]!,
                                                    mapData: (controllerX
                                                            .eventList
                                                            .map((e) =>
                                                                e.toJson()))
                                                        .toList())
                                                : Container(),
                                          ),
                                        ),
                                        SizedBox(height: 14),
                                        Align(
                                          alignment: Alignment.topRight,
                                          child: FormButton(
                                            btnText: "Print Bar Code",
                                            callback: () {
                                              Snack.callError(
                                                  "Still Under Development");
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            );
                          },
                          init: controllerX,
                          id: "eventTable",
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 8),
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
    );
  }
}
