import 'dart:convert';
import 'package:bms_scheduling/app/modules/commercial/CommercialShowOnTabModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:bms_scheduling/app/data/DropDownValue.dart';
import 'package:bms_scheduling/app/providers/extensions/string_extensions.dart';
import 'package:bms_scheduling/widgets/LoadingScreen.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pluto_grid/pluto_grid.dart';

import '../../../../widgets/DateTime/DateWithThreeTextField.dart';
import '../../../../widgets/FormButton.dart';
import '../../../../widgets/dropdown.dart';
import '../../../../widgets/gridFromMap.dart';
import '../../../../widgets/gridFromMap1.dart';
import '../../../../widgets/input_fields.dart';
import '../../../controller/ConnectorControl.dart';
import '../../../controller/HomeController.dart';
import '../../../providers/ApiFactory.dart';
import '../../../providers/DataGridMenu.dart';
import '../../../providers/SizeDefine.dart';
import '../../../providers/Utils.dart';
import '../../../styles/theme.dart';
import '../controllers/commercial_controller.dart';

class CommercialView extends GetView<CommercialController> {
  CommercialView({Key? key}) : super(key: key);

  late PlutoGridStateManager stateManager;
  var formName = 'Schedule Commercials';

  void handleOnRowChecked(PlutoGridOnRowCheckedEvent event) {}
  CommercialController controllerX = Get.put(CommercialController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CommercialController>(
        init: CommercialController(),
        id: "initData",
        builder: (controller) {
          FocusNode _channelsFocus = FocusNode();

          // if (controller.initData == null) {
          //   return PleaseWaitCard();
          // } else {
          //   FocusNode _channelsFocus = FocusNode();
          //   log(controller.initData!["channels"]![0].keys.toString());
          //   return Scaffold(
          //     floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
          //     extendBody: false,
          //     floatingActionButton: GetBuilder<HomeController>(
          //         id: "buttons",
          //         init: Get.find<HomeController>(),
          //         builder: (btcontroller) {
          //           if (btcontroller.buttons != null) {
          //             return Container(
          //               padding: EdgeInsets.zero,
          //               margin: EdgeInsets.zero,
          //               width: double.infinity,
          //               decoration: BoxDecoration(color: Colors.white, border: Border(top: BorderSide(width: 1.0, color: Colors.grey))),
          //               child: ButtonBar(
          //                 alignment: MainAxisAlignment.start,
          //                 mainAxisSize: MainAxisSize.min,
          //                 children: [
          //                   for (var btn in btcontroller.buttons!)
          //                     if (Utils.btnAccessHandler(btn['name'], controller.formPermissions!) != null)
          //                       FormButtonWrapper(
          //                         btnText: btn["name"],
          //                         callback: () => controller.formHandler(
          //                           btn['name'],
          //                         ),
          //                       )
          //                 ],
          //               ),
          //             );
          //           }
          //           return Container();
          //         }),
          //     body: FocusTraversalGroup(
          //       policy: OrderedTraversalPolicy(),
          //       child: Padding(
          //         padding: const EdgeInsets.symmetric(vertical: 8),
          //         child: Row(
          //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //           crossAxisAlignment: CrossAxisAlignment.start,
          //           children: [
          //             /// input forms
          //             SizedBox(
          //               width: w * 0.35,
          //               child: Column(
          //                 crossAxisAlignment: CrossAxisAlignment.start,
          //                 children: [
          //                   /// program type
          //                   DropDownField.formDropDown1WidthMap(
          //                     (controller.initData!["lmsProgramTypes"] as List)
          //                         .map((e) => DropDownValue(key: e["programTypeCode"].toString(), value: e["programTypeName"]))
          //                         .toList(),
          //                         (value) => () {},
          //                     "Program Type",
          //                     0.35,
          //                     searchReq: true,
          //                     autoFocus: true,
          //                     dialogHeight: h * .75,
          //                   ),
          //
          //                   /// channel
          //                   const Padding(
          //                     padding: EdgeInsets.only(top: 7, bottom: 4),
          //                     child: Text(
          //                       "Channels",
          //                       style: TextStyle(fontSize: 12),
          //                     ),
          //                   ),
          //
          //                   /// channel box
          //                   SizedBox(
          //                       width: w * .35,
          //                       height: (h * .6) - (kToolbarHeight / 2),
          //                       child: Focus(
          //                         autofocus: false,
          //                         focusNode: _channelsFocus,
          //                         child: PlutoGrid(
          //                           mode: PlutoGridMode.normal,
          //                           configuration: plutoGridConfiguration(focusNode: _channelsFocus),
          //                           columns: controller.initColumn,
          //                           onLoaded: (event) {
          //                             controller.locChanStateManager = event.stateManager;
          //                             // event.stateManager.setColumnSizeConfig(
          //                             //     PlutoGridColumnSizeConfig(
          //                             //   autoSizeMode: PlutoAutoSizeMode.equal,
          //                             //   resizeMode: PlutoResizeMode.none,
          //                             // ));
          //                           },
          //                           rows: controller.initRows,
          //                           onRowChecked: (event) {
          //                             /* if (controller.locationsForReport
          //                                 .contains({
          //                               "locationCode": controller
          //                                       .channels[event.row!.sortIdx]
          //                                   ["locationCode"],
          //                               "channelCode": controller
          //                                       .channels[event.row!.sortIdx]
          //                                   ["channelCode"]
          //                             })) {
          //                               controller.locationsForReport.remove({
          //                                 "locationCode": controller
          //                                         .channels[event.row!.sortIdx]
          //                                     ["locationCode"],
          //                                 "channelCode": controller
          //                                         .channels[event.row!.sortIdx]
          //                                     ["channelCode"]
          //                               });
          //                             } else {
          //                               controller.locationsForReport.add({
          //                                 "locationCode": controller
          //                                         .channels[event.row!.sortIdx]
          //                                     ["locationCode"],
          //                                 "channelCode": controller
          //                                         .channels[event.row!.sortIdx]
          //                                     ["channelCode"]
          //                               });
          //                             }*/
          //                             ChannelModel data = ChannelModel(
          //                                 locationCode: controller.channels[event.row!.sortIdx]["locationCode"],
          //                                 channelCode: controller.channels[event.row!.sortIdx]["channelCode"]);
          //                             bool isDataAvail = controller.locationsForReport1.any((element) => element.channelCode == data.channelCode);
          //                             if (isDataAvail) {
          //                               controller.locationsForReport1.removeWhere((element) => element.channelCode == data.channelCode);
          //                             } else {
          //                               controller.locationsForReport1.add(data);
          //                             }
          //                           },
          //                         ),
          //                       )),
          //
          //                   /// date and Ignore Single Telecast
          //                   FocusTraversalGroup(
          //                     policy: OrderedTraversalPolicy(),
          //                     child: SizedBox(
          //                       height: h * .23,
          //                       child: ListView(
          //                         children: [
          //                           Padding(
          //                             padding: const EdgeInsets.only(top: 5, bottom: 5),
          //                             child: Row(
          //                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //                               crossAxisAlignment: CrossAxisAlignment.start,
          //                               children: [
          //                                 // Date
          //                                 DateWithThreeTextField(
          //                                     widthRation: 0.15,
          //                                     splitType: "-",
          //                                     onFocusChange: ((date) {
          //                                       controller.reportBody["ReferenceDate"] =
          //                                           DateFormat('yyyy-MM-dd').format(DateFormat("dd-MM-yyyy").parse(date)).toString();
          //                                     }),
          //                                     title: "Date",
          //                                     mainTextController: controller.refDateContrl),
          //                                 // Ignore Single Telecast
          //                                 Container(
          //                                   width: w * .15,
          //                                   padding: const EdgeInsets.only(top: 16.0),
          //                                   alignment: Alignment.topLeft,
          //                                   child: Obx(() => InkWell(
          //                                     onTap: () {
          //                                       controller.ignoreSingleTelecast.value = !controller.ignoreSingleTelecast.value;
          //                                     },
          //                                     child: Row(
          //                                       crossAxisAlignment: CrossAxisAlignment.center,
          //                                       children: [
          //                                         Icon(
          //                                           controller.ignoreSingleTelecast.value
          //                                               ? Icons.check_box_outlined
          //                                               : Icons.check_box_outline_blank,
          //                                           color: Colors.deepPurple,
          //                                         ),
          //                                         const Text(
          //                                           "Ignore Single Telecast",
          //                                           style: TextStyle(fontSize: 12),
          //                                         ),
          //                                       ],
          //                                     ),
          //                                   )),
          //                                 )
          //                               ],
          //                             ),
          //                           ),
          //
          //                           /// conflicts and display
          //                           Row(
          //                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //                             children: [
          //                               /// conflict
          //                               InputFields.numbers(
          //                                 padLeft: 0,
          //                                 hintTxt: "Conflict",
          //                                 isNegativeReq: false,
          //                                 controller: TextEditingController(text: controller.conflictDays.toString()),
          //                                 onchanged: (value) {
          //                                   controller.conflictDays = int.tryParse(value);
          //                                 },
          //                                 width: 0.15,
          //                               ),
          //
          //                               /// Display
          //                               DropDownField.formDropDown1WidthMap(
          //                                 ["Min Date", "Max Date", "Telecast Count"].map((e) => DropDownValue(key: e, value: e)).toList(),
          //                                     (value) {
          //                                   // log(value!.value!);
          //                                   controller.reportBody["Display"] = value.value;
          //                                 },
          //                                 "Display",
          //                                 0.15,
          //                                 // context,
          //                                 // leftpad: 0,
          //                               ),
          //                             ],
          //                           ),
          //                           const SizedBox(height: 10),
          //
          //                           /// genearte and clear buttons
          //                           Row(
          //                             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //                             children: [
          //                               Expanded(
          //                                 child: FormButtonWrapper(
          //                                     btnText: "Generate",
          //                                     callback: () {
          //                                       controller.generateData();
          //                                     }),
          //                               ),
          //                               SizedBox(width: w * .05),
          //                               Expanded(
          //                                 child: FormButtonWrapper(
          //                                     btnText: "Clear",
          //                                     callback: () {
          //                                       controller.formHandler("Clear");
          //                                     }),
          //                               ),
          //                             ],
          //                           )
          //                         ],
          //                       ),
          //                     ),
          //                   )
          //                 ],
          //               ),
          //             ),
          //
          //             /// output forms
          //             GetBuilder<CommercialController>(
          //                 init: CommercialController(),
          //                 id: "reports",
          //                 builder: (controller) {
          //                   if (controller.conflictReport.isEmpty || controller.beams.isEmpty) {
          //                     return Column(
          //                       children: [
          //                         Container(
          //                           height: (h * .75) - kToolbarHeight,
          //                           width: w * 0.6,
          //                           decoration: BoxDecoration(
          //                               border: Border.all(
          //                                 color: Colors.grey,
          //                               )),
          //                         ),
          //                         const SizedBox(height: 10),
          //                         Container(
          //                           height: (h * .30) - kToolbarHeight,
          //                           width: w * 0.6,
          //                           decoration: BoxDecoration(
          //                               border: Border.all(
          //                                 color: Colors.grey,
          //                               )),
          //                         ),
          //                       ],
          //                     );
          //                   } else {
          //                     FocusNode _focusNode = FocusNode();
          //                     List<PlutoRow> rows = [];
          //                     List<PlutoColumn> columns = [];
          //
          //                     bool canFormateDate = false;
          //                     for (Map row in controller.conflictReport) {
          //                       Map<String, PlutoCell> cells = {};
          //                       try {
          //                         for (var element in row.entries) {
          //                           cells[element.key] = PlutoCell(
          //                             value: element.key == "selected" || element.value == null || element.value == ""
          //                                 ? ""
          //                                 : !(element.key.toString().toLowerCase().contains("program"))
          //                                 ? element.value.toString().contains('00:00:00')
          //                                 ? DateFormat("dd/MM/yyyy").format(DateFormat('MM/dd/yyyy HH:mm:ss').parse(element.value.toString()))
          //                                 : DateFormat("dd/MM/yyyy HH:mm:ss")
          //                                 .format(DateFormat('MM/dd/yyyy HH:mm:ss').parse(element.value.toString()))
          //                                 : element.value.toString(),
          //                           );
          //                         }
          //                         rows.add(PlutoRow(
          //                           cells: cells,
          //                         ));
          //                       } catch (e) {
          //                         log("problem in adding rows$e");
          //                       }
          //                     }
          //
          //                     return Builder(builder: (context) {
          //                       return Column(
          //                         mainAxisAlignment: MainAxisAlignment.start,
          //                         mainAxisSize: MainAxisSize.max,
          //                         children: [
          //                           // 1st grid
          //                           SizedBox(
          //                             height: (h * .75) - kToolbarHeight,
          //                             width: w * 0.6,
          //                             child: Focus(
          //                               autofocus: false,
          //                               focusNode: _focusNode,
          //                               child: PlutoGrid(
          //                                 onSorted: (event) {
          //                                   controller.conflictReportStateManager.columns;
          //                                   event.column.sort = event.oldSort;
          //                                   log("sorting event");
          //                                   controller.loadColumnBeams(event.column.field.toString());
          //                                 },
          //                                 rowColorCallback: (rowColorContext) {
          //                                   if (controller.conflictPrograms.contains(rowColorContext.row.cells["Program"]!.value)) {
          //                                     return Colors.pink[400]!;
          //                                   }
          //
          //                                   return Colors.white;
          //                                 },
          //                                 configuration: plutoGridConfiguration(focusNode: _focusNode),
          //                                 columns: [
          //                                   for (var key in controller.conflictReport[0].keys)
          //                                     PlutoColumn(
          //                                         title: key.toString(),
          //                                         readOnly: true,
          //                                         enableSorting: true,
          //                                         enableRowDrag: false,
          //                                         renderer: ((rendererContext) => GestureDetector(
          //                                           onSecondaryTapDown: (detail) {
          //                                             DataGridMenu().showGridMenu(rendererContext.stateManager, detail, context);
          //                                           },
          //                                           child: Text(
          //                                             rendererContext.cell.value.toString(),
          //                                             style: TextStyle(
          //                                               fontSize: SizeDefine.columnTitleFontSize,
          //                                             ),
          //                                           ),
          //                                         )),
          //                                         enableEditingMode: false,
          //                                         enableDropToResize: true,
          //                                         enableContextMenu: false,
          //                                         width: Utils.getColumnSize(key: key, value: controller.conflictReport[0][key]),
          //                                         sort: PlutoColumnSort.none,
          //                                         enableAutoEditing: false,
          //                                         hide: key == "territoryCode" ? false : key.toString().toLowerCase().contains("code"),
          //                                         enableColumnDrag: false,
          //                                         field: key,
          //                                         type: PlutoColumnType.text())
          //                                 ],
          //                                 rows: rows,
          //                                 onChanged: (PlutoGridOnChangedEvent event) {
          //                                   print(event);
          //                                 },
          //                                 onRowChecked: (event) {
          //                                   print('Grid B : $event');
          //                                 },
          //                                 onLoaded: (PlutoGridOnLoadedEvent event) {
          //                                   event.stateManager.setKeepFocus(false);
          //                                   controller.conflictReportStateManager = event.stateManager;
          //
          //                                   event.stateManager.addListener(controller.loadBeams);
          //                                 },
          //
          //                                 // configuration: PlutoConfiguration.dark(),
          //                               ),
          //                             ),
          //                           ),
          //                           SizedBox(height: 10),
          //                           // 2 grid
          //                           GetBuilder<CommercialController>(
          //                             init: CommercialController(),
          //                             id: "beams",
          //                             builder: (controller) {
          //                               FocusNode _focusNode = FocusNode();
          //                               return controller.beamRows.isEmpty
          //                                   ? SizedBox()
          //                                   : SizedBox(
          //                                 height: (h * .30) - kToolbarHeight,
          //                                 width: w * 0.6,
          //                                 child: Focus(
          //                                   autofocus: false,
          //                                   focusNode: _focusNode,
          //                                   child: PlutoGrid(
          //                                     onSorted: (event) {
          //                                       log(event.column.key.toString());
          //                                     },
          //                                     configuration: plutoGridConfiguration(focusNode: _focusNode),
          //                                     columns: [
          //                                       for (var key in controller.beams[0].keys)
          //                                         PlutoColumn(
          //                                             title: key.toString().pascalCaseToNormal(),
          //                                             readOnly: true,
          //                                             renderer: ((rendererContext) => GestureDetector(
          //                                               onSecondaryTapDown: (detail) {
          //                                                 DataGridMenu().showGridMenu(rendererContext.stateManager, detail, context);
          //                                               },
          //                                               child: Text(
          //                                                 rendererContext.cell.value.toString(),
          //                                                 style: TextStyle(
          //                                                   fontSize: SizeDefine.columnTitleFontSize,
          //                                                 ),
          //                                               ),
          //                                             )),
          //                                             enableSorting: true,
          //                                             enableRowDrag: false,
          //                                             enableEditingMode: false,
          //                                             enableDropToResize: true,
          //                                             enableContextMenu: false,
          //                                             width: Utils.getColumnSize(key: key, value: controller.beams[0][key]),
          //                                             enableAutoEditing: false,
          //                                             hide: key.toString().toLowerCase().contains("code"),
          //                                             enableColumnDrag: false,
          //                                             field: key,
          //                                             type: PlutoColumnType.text())
          //                                     ],
          //                                     rows: controller.beamRows,
          //                                     onChanged: (PlutoGridOnChangedEvent event) {
          //                                       print(event);
          //                                     },
          //
          //                                     onRowChecked: (PlutoGridOnRowCheckedEvent event) {
          //                                       print('Grid B : $event');
          //                                     },
          //                                     onLoaded: (PlutoGridOnLoadedEvent event) {
          //                                       controller.bmsReportStateManager = event.stateManager;
          //                                     },
          //
          //                                     // configuration: PlutoConfiguration.dark(),
          //                                   ),
          //                                 ),
          //                               );
          //                             },
          //                           )
          //                         ],
          //                       );
          //                     });
          //                   }
          //                 })
          //           ],
          //         ),
          //       ),
          //     ),
          //   );
          // }

          return Scaffold(
            body: FocusTraversalGroup(
              policy: OrderedTraversalPolicy(),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: SizedBox(
                  height: double.maxFinite,
                  width: double.maxFinite,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      GetBuilder<CommercialController>(
                        id: "initialData",
                        builder: (control) {
                          return Padding(
                            padding: const EdgeInsets.only(left: 18.0, top: 10),
                            child: Row(
                              children: [
                                Obx(
                                  () => DropDownField.formDropDown1WidthMap(
                                    controllerX.locations.value,
                                    (value) {
                                      controller.selectedLocation = value;
                                      controllerX.getChannel(value.key);
                                    },
                                    "Location",
                                    0.12,
                                    isEnable: controllerX.isEnable.value,
                                    selected: controllerX.selectedLocation,
                                    autoFocus: true,
                                    dialogWidth: 330,
                                    dialogHeight: Get.height * .7,
                                  ),
                                ),
                                const SizedBox(width: 15),
                                Obx(
                                  () => DropDownField.formDropDown1WidthMap(
                                    controller.channels.value,
                                    (value) {
                                      controller.selectedChannel = value;
                                    },
                                    "Channel",
                                    0.15,
                                    dialogHeight: Get.height * .7,
                                  ),
                                ),
                                const SizedBox(width: 15),
                                DateWithThreeTextField(
                                  title: "From Date",
                                  mainTextController: controllerX.date_,
                                  widthRation: controllerX.widthSize,
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 17.0),
                                  child: FormButton(
                                    btnText: "show details",
                                    callback: () {
                                      controllerX.selectedIndex.value = 0;
                                      controllerX.fetchProgramSchedulingDetails();
                                    },
                                  ),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 17.0),
                                  child: FormButton(
                                    btnText: "verify",
                                    callback: () {},
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 16.0, left: 15),
                                  child: Row(
                                    children: [
                                      Radio(
                                        value: 0,
                                        groupValue: controllerX.selectedGroup,
                                        onChanged: (int? value) {},
                                      ),
                                      const Text('Insert After'),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Radio(
                                        value: 1,
                                        groupValue: controllerX.selectedGroup,
                                        onChanged: (int? value) {},
                                      ),
                                      const Text('Auto Shuffle'),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      Expanded(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            /// input forms
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(15, 15, 7, 0),
                                child: programTable(context),
                              ),
                            ),

                            /// output forms
                            Expanded(
                              flex: 2,
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(15, 15, 7, 0),
                                child: GetBuilder<CommercialController>(
                                    init: CommercialController(),
                                    id: "reports",
                                    builder: (controller) {
                                      return Padding(
                                        padding: const EdgeInsets.all(2.0),
                                        child: tabView(context),
                                      );
                                    }),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
                        child: GetBuilder<HomeController>(
                            id: "buttons",
                            init: Get.find<HomeController>(),
                            builder: (btcontroller) {
                              if (btcontroller.buttons != null) {
                                return ButtonBar(
                                  alignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    for (var btn in btcontroller.buttons!)
                                      //if (Utils.btnAccessHandler(btn['name'], controller.formPermissions!) != null)
                                      FormButtonWrapper(
                                        btnText: btn["name"],
                                        callback: () => controller.formHandler(
                                          btn['name'],
                                        ),
                                      )
                                  ],
                                );
                              }
                              return Container();
                            }),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  Widget tabView(BuildContext context) {
    return Obx(() => Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 10, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CupertinoSlidingSegmentedControl(
                    groupValue: controllerX.selectedIndex.value,
                    //backgroundColor: Colors.blue.shade200,
                    children: <int, Widget>{
                      0: Text(
                        'Schedulling',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: SizeDefine.fontSizeTab,
                        ),
                      ),
                      1: Text(
                        'FPC Mismatch',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: SizeDefine.fontSizeTab,
                        ),
                      ),
                      2: Text(
                        'Marked as Error ',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: SizeDefine.fontSizeTab,
                        ),
                      ),
                    },
                    onValueChanged: (int? value) {
                      print("Index1 is>>" + value.toString());
                      controllerX.selectedIndex.value = value!;
                      controllerX.fetchSchedulingShowOnTabDetails();
                    },
                  ),
                  const Spacer(),
                  if (controllerX.selectedIndex.value == 0)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Obx(() => Text('Commercial Spots : ${controllerX.commercialSpots.value}')),
                        const SizedBox(
                          width: 20,
                        ),
                        Obx(() => Text('Commercial Duration : ${controllerX.commercialDuration.value}')),
                      ],
                    )
                  else if (controllerX.selectedIndex.value == 1)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      //mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        FormButton(
                          btnText: "Change FPC",
                          callback: () {},
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        FormButton(
                          btnText: "Mis-Match",
                          callback: () {},
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        FormButton(
                          btnText: "Mark-as-Error",
                          callback: () {},
                        ),
                      ],
                    )
                  else if (controllerX.selectedIndex.value == 2)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        FormButton(
                          btnText: "Mark-as-Error",
                          callback: () {},
                        ),
                      ],
                    ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  if (controllerX.selectedIndex.value == 0)
                    Expanded(child: schedulingView(context))
                  else if (controllerX.selectedIndex.value == 1)
                    Expanded(child: fpcMismatchView(context))
                  else if (controllerX.selectedIndex.value == 2)
                    Expanded(child: markedAsErrorView(context))
                ],
              ),
            ),
          ],
        ));
  }

  Widget programTable(context) {
    return GetBuilder<CommercialController>(
        id: "fillerFPCTable",
        // init: CreateBreakPatternController(),
        builder: (controller) {
          if (controllerX.commercialProgramList != null && (controllerX.commercialProgramList?.isNotEmpty)!) {
            // final key = GlobalKey();
            return DataGridFromMap(
              mapData: (controllerX.commercialProgramList?.map((e) => e.toJson()).toList())!,
              showonly: [
                "fpcTime",
                "programname",
              ],
              //widthRatio: (Get.width * 0.1),
              mode: PlutoGridMode.select,
              onSelected: (plutoGrid) {
                print(jsonEncode(controllerX.selectedProgram?.toJson()));
                controllerX.selectedProgram = controllerX.commercialProgramList![plutoGrid.rowIdx!];

                controllerX.fpcTimeSelected = controllerX.commercialProgramList![plutoGrid.rowIdx!].fpcTime;

                controllerX.fetchSchedulingShowOnTabDetails();
              },
            );
          } else {
            return Expanded(
              child: Card(
                clipBehavior: Clip.hardEdge,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0), // if you need this
                  side: BorderSide(
                    color: Colors.grey.shade300,
                    width: 1,
                  ),
                ),
                child: Container(
                    //height: Get.height - (4 * kToolbarHeight),
                    ),
              ),
            );
          }
        });
  }

  /// tab 0 ( A ) selected date is 22 March 2023
  Widget schedulingView(BuildContext context) {
    return Column(
      children: [
        GetBuilder<CommercialController>(
            id: "fillerShowOnTabTable",
            // init: CreateBreakPatternController(),
            builder: (controller) {
              if (controllerX.commercialShufflingList != null && (controllerX.commercialShufflingList?.isNotEmpty)!) {
                // final key = GlobalKey();
                return Expanded(
                    // child: DataGridFromMap(
                    //   colorCallback: (row) {
                    //     return row.row.cells.containsValue(
                    //             controller.stateManager?.currentCell)
                    //         ? Colors.blueAccent
                    //         : controller.redBreaks.contains(row.rowIdx -
                    //                 1)
                    //             ? Colors.white
                    //             : Colors.orange.shade700;
                    //   },
                    //   mapData: (controllerX.commercialShowDetailsList
                    //       ?.map((e) => e.toJson())
                    //       .toList())!,
                    //   showonly: [
                    //     "fpcTime",
                    //     "breakNumber",
                    //     "eventType",
                    //     "exportTapeCode",
                    //     "segmentCaption",
                    //     "client",
                    //     "brand",
                    //     "duration",
                    //     "product",
                    //     "bookingNumber",
                    //     "bookingDetailcode",
                    //     "rostimeBand",
                    //     "randid",
                    //     "programName",
                    //     "rownumber",
                    //     "bStatus",
                    //     "pDailyFPC",
                    //     "pProgramMaster"
                    //   ],
                    //   onload: (loadEvent) {
                    //     loadEvent.stateManager.gridFocusNode.addListener(() {
                    //       if (loadEvent.stateManager.gridFocusNode.hasFocus) {
                    //         loadEvent.stateManager
                    //             .setGridMode(PlutoGridMode.select);
                    //       } else {
                    //         loadEvent.stateManager
                    //             .setGridMode(PlutoGridMode.normal);
                    //       }
                    //     });
                    //   },
                    //   mode: PlutoGridMode.select,
                    //   onSelected: (plutoGrid) {
                    //     controllerX.selectedShowOnTab =
                    //         controllerX.commercialShowDetailsList![plutoGrid.rowIdx!];
                    //     print(">>>>>>Commercial Data>>>>>>" +
                    //         jsonEncode(controllerX.selectedShowOnTab?.toJson()));
                    //   },
                    // ),
                    ///
                    child: DataGridFromMap1(
                        onFocusChange: (value) {
                          controllerX.gridStateManager!.setGridMode(PlutoGridMode.selectWithOneTap);
                          controllerX.selectedPlutoGridMode = PlutoGridMode.selectWithOneTap;
                        },
                        onload: (loadevent) {
                          controllerX.gridStateManager = loadevent.stateManager;
                          if (controller.selectedDDIndex != null) {
                            loadevent.stateManager.moveScrollByRow(PlutoMoveDirection.down, controller.selectedDDIndex);
                            loadevent.stateManager.setCurrentCell(
                                loadevent.stateManager.rows[controller.selectedDDIndex!].cells.entries.first.value, controller.selectedDDIndex);
                          }
                        },
                        showSrNo: true,
                        showonly: [
                          "fpcTime",
                          "breakNumber",
                          "eventType",
                          "exportTapeCode",
                          "segmentCaption",
                          "client",
                          "brand",
                          "duration",
                          "product",
                          "bookingNumber",
                          "bookingDetailcode",
                          "rostimeBand",
                          "randid",
                          "programName",
                          "rownumber",
                          "bStatus",
                          "pDailyFPC",
                          "pProgramMaster"
                        ],
                        colorCallback: (PlutoRowColorContext plutoContext) {
                          return Color(int.parse('0x${controllerX.commercialShufflingList![plutoContext.rowIdx].backColor}'));
                        },
                        // colorCallback: (row) {
                        //   return row.row.cells.containsValue(
                        //           controller.stateManager?.currentCell)
                        //       ? Colors.blueAccent
                        //       : controller.redBreaks.contains(row.rowIdx -
                        //               1)
                        //           ? Colors.white
                        //           : Colors.orange.shade700;
                        // },
                        onSelected: (PlutoGridOnSelectedEvent event) {
                          controllerX.selectedShowOnTab = controllerX.commercialShufflingList![event.rowIdx!];
                          print(">>>>>>Commercial Data>>>>>>" + jsonEncode(controllerX.selectedShowOnTab?.toJson()));
                        },
                        onRowsMoved: (PlutoGridOnRowsMovedEvent onRowMoved) {
                          print("Index is>>" + onRowMoved.idx.toString());
                          Map map = onRowMoved.rows[0].cells;
                          print("On Print moved" + jsonEncode(onRowMoved.rows[0].cells.toString()));
                          controllerX.gridStateManager?.notifyListeners();
                        },
                        mode: controllerX.selectedPlutoGridMode,
                        mapData: controllerX.commercialShufflingList!.map((e) => e.toJson()).toList()));
              } else {
                return Expanded(
                  child: Card(
                    clipBehavior: Clip.hardEdge,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0), // if you need this
                      side: BorderSide(
                        color: Colors.grey.shade300,
                        width: 1,
                      ),
                    ),
                    child: Container(
                      height: Get.height - (4 * kToolbarHeight),
                    ),
                  ),
                );
              }
            }),
      ],
    );
  }

  /// tab 1 ( B )
  Widget fpcMismatchView(BuildContext context) {
    return Column(
      children: [
        GetBuilder<CommercialController>(
            id: "fillerShowOnTabTable",
            // init: CreateBreakPatternController(),
            builder: (controller) {
              if (controllerX.commercialShowFPCList != null && (controllerX.commercialShowFPCList?.isNotEmpty)!) {
                // final key = GlobalKey();
                return Expanded(
                  // height: 400,
                  child: DataGridFromMap(
                    mapData: (controllerX.commercialShowFPCList?.map((e) => e.toJson()).toList())!,
                    showonly: [
                      "fpcTime",
                      "breakNumber",
                      "eventType",
                      "exportTapeCode",
                      "segmentCaption",
                      "client",
                      "brand",
                      "duration",
                      "product",
                      "bookingNumber",
                      "bookingDetailcode",
                      "rostimeBand",
                      "randid",
                      "programName",
                      "rownumber",
                      "bStatus",
                      "pDailyFPC",
                      "pProgramMaster"
                    ],
                    //widthRatio: (Get.width * 0.2) / 2 + 7,
                    //mode: PlutoGridMode.select,
                    onSelected: (plutoGrid) {
                      controllerX.selectedShowOnTab = controllerX.commercialShowFPCList![plutoGrid.rowIdx!];
                      print(">>>>>>FPC Data>>>>>>" + jsonEncode(controllerX.selectedShowOnTab?.toJson()));
                    },
                  ),
                );
              } else {
                return Expanded(
                  child: Card(
                    clipBehavior: Clip.hardEdge,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0), // if you need this
                      side: BorderSide(
                        color: Colors.grey.shade300,
                        width: 1,
                      ),
                    ),
                    child: Container(
                      height: Get.height - (4 * kToolbarHeight),
                    ),
                  ),
                );
              }
            }),
        // SizedBox(
        //   height: (Get.height * .65) - kToolbarHeight / 2,
        //   width: MediaQuery.of(context).size.width * 0.65,
        //   child:
        // ),
      ],
    );
  }

  /// tab 2 ( C )
  Widget markedAsErrorView(BuildContext context) {
    return Column(
      children: [
        GetBuilder<CommercialController>(
            id: "fillerShowOnTabTable",
            // init: CreateBreakPatternController(),
            builder: (controller) {
              if (controllerX.commercialShowMarkedList != null && (controllerX.commercialShowMarkedList?.isNotEmpty)!) {
                // final key = GlobalKey();
                return Expanded(
                  // height: 400,
                  child: DataGridFromMap(
                    mapData: (controllerX.commercialShowMarkedList?.map((e) => e.toJson()).toList())!,
                    showonly: [
                      "fpcTime",
                      "breakNumber",
                      "eventType",
                      "exportTapeCode",
                      "segmentCaption",
                      "client",
                      "brand",
                      "duration",
                      "product",
                      "bookingNumber",
                      "bookingDetailcode",
                      "rostimeBand",
                      "randid",
                      "programName",
                      "rownumber",
                      "bStatus",
                      "pDailyFPC",
                      "pProgramMaster"
                    ],
                    //widthRatio: (Get.width * 0.2) / 2 + 7,
                    //mode: PlutoGridMode.select,
                    onSelected: (plutoGrid) {
                      controllerX.selectedShowOnTab = controllerX.commercialShowMarkedList![plutoGrid.rowIdx!];
                      print(">>>>>>Error Data>>>>>>" + jsonEncode(controllerX.selectedShowOnTab?.toJson()));
                    },
                  ),
                );
              } else {
                return Expanded(
                  child: Card(
                    clipBehavior: Clip.hardEdge,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0), // if you need this
                      side: BorderSide(
                        color: Colors.grey.shade300,
                        width: 1,
                      ),
                    ),
                    child: Container(
                      height: Get.height - (4 * kToolbarHeight),
                    ),
                  ),
                );
              }
            }),
        // SizedBox(
        //   height: (Get.height * .65) - kToolbarHeight / 2,
        //   width: MediaQuery.of(context).size.width * 0.65,
        //   child:
        // ),
      ],
    );
  }
}
