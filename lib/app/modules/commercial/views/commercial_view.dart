import 'dart:convert';
import 'dart:developer';
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
  var formName = 'Scheduling Commercials';

  void handleOnRowChecked(PlutoGridOnRowCheckedEvent event) {}
  CommercialController controllerX = Get.put(CommercialController());

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

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
                                      controllerX.selectLocation = value;
                                      // controllerX.selectedLocationId.text = value.key!;
                                      // controllerX.selectedLocationName.text = value.value!;
                                      // controller.getChannelsBasedOnLocation(value.key!);
                                    },
                                    "Location",
                                    0.12,
                                    isEnable: controllerX.isEnable.value,
                                    selected: controllerX.selectLocation,
                                    autoFocus: true,
                                    dialogWidth: 330,
                                    dialogHeight: Get.height * .7,
                                  ),
                                ),
                                const SizedBox(width: 15),
                                Obx(() {
                                  return DropDownField.formDropDown1Width(
                                    Get.context!,
                                    controllerX.channelList ?? [],
                                    (value) {
                                      controllerX.selectedChannel = value;
                                    },
                                    "Channel",
                                    controllerX.widthSize,
                                    paddingLeft: 5,
                                    searchReq: true,
                                    isEnable: control.channelEnable.value,
                                    selected: controllerX.selectedChannel,
                                    dialogHeight: Get.height * .7,
                                  );
                                }),
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
                                    callback: () {},
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
                                  padding: const EdgeInsets.only(
                                      top: 16.0, left: 15),
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
                      Row(
                        //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// input forms
                          Padding(
                            padding: const EdgeInsets.fromLTRB(15, 15, 7, 0),
                            child: SizedBox(
                              width: w * .30,
                              height: (h * .7) - (kToolbarHeight / 2),
                              child: programTable(context),
                            ),
                          ),

                          /// output forms
                          GetBuilder<CommercialController>(
                              init: CommercialController(),
                              id: "reports",
                              builder: (controller) {
                                if (controller.conflictReport.isEmpty ||
                                    controller.beams.isEmpty) {
                                  return Column(
                                    children: [
                                      // const Padding(
                                      //   padding: EdgeInsets.only(top: 7, bottom: 4),
                                      // ),
                                      Container(
                                        height: (h * .8) - kToolbarHeight / 2,
                                        width: w * 0.6,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors.grey.shade300,
                                            width: 1,
                                          ),
                                          //color: Colors.deepPurpleAccent
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: SizedBox(
                                              height:
                                                  (h * .6) - kToolbarHeight / 2,
                                              width: w * 0.6,
                                              child: tabView(context)),
                                        ),
                                      ),
                                      //const SizedBox(height: 10),
                                    ],
                                  );
                                } else {
                                  return Container();
                                }
                              })
                        ],
                      ),
                      GetBuilder<HomeController>(
                          id: "buttons",
                          init: Get.find<HomeController>(),
                          builder: (btcontroller) {
                            if (btcontroller.buttons != null) {
                              return Container(
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                ),
                                child: ButtonBar(
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
                                ),
                              );
                            }
                            return Container();
                          }),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
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
                  },
                ),
              ],
            ),
            Column(
              children: [
                if (controllerX.selectedIndex.value == 0)
                  schedulingView(context)
                else if (controllerX.selectedIndex.value == 1)
                  fpcMismatchView(context)
                else if (controllerX.selectedIndex.value == 2)
                  markedAsErrorView(context)
              ],
            )
          ],
        ));
  }

  Widget programTable(context) {
    return GetBuilder<CommercialController>(
        id: "programTable",
        // init: CreateBreakPatternController(),
        builder: (controller) {
          if (controllerX.programList != null &&
              (controllerX.programList?.isNotEmpty)!) {
            // final key = GlobalKey();
            return Expanded(
              // height: 400,
              child: DataGridFromMap(
                mapData: (controllerX.programList
                    ?.map((e) => e.toJson1())
                    .toList())!,
                widthRatio: (Get.width * 0.2) / 2 + 7,
                // mode: PlutoGridMode.select,
                onSelected: (plutoGrid) {
                  controllerX.selectedProgram =
                      controllerX.programList![plutoGrid.rowIdx!];
                  print(jsonEncode(controllerX.selectedProgram?.toJson()));
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
        });
  }

  Widget schedulingView(BuildContext context) {
    return Column(
      children: [
        Container(
          height: (Get.height * .60) - kToolbarHeight / 2,
          width: MediaQuery.of(context).size.width * 0.6,
          child: GetBuilder<CommercialController>(
              id: "schedulingView",
              // init: CreateBreakPatternController(),
              builder: (controller) {
                if (controllerX.programList != null &&
                    (controllerX.programList?.isNotEmpty)!) {
                  // final key = GlobalKey();
                  return Expanded(
                    // height: 400,
                    child: DataGridFromMap(
                      mapData: (controllerX.programList
                          ?.map((e) => e.toJson1())
                          .toList())!,
                      widthRatio: (Get.width * 0.2) / 2 + 7,
                      onload: (loadevnt) {
                        loadevnt.stateManager.gridFocusNode.addListener(() {
                          if (loadevnt.stateManager.gridFocusNode.hasFocus) {
                            loadevnt.stateManager
                                .setGridMode(PlutoGridMode.select);
                          } else {
                            loadevnt.stateManager
                                .setGridMode(PlutoGridMode.normal);
                          }
                        });
                      },
                      // mode: PlutoGridMode.select,
                      onSelected: (plutoGrid) {
                        // controllerX.selectedProgram =
                        // controllerX.programList![plutoGrid.rowIdx!] ;
                        print(">>>>>>Program Data>>>>>>" +
                            jsonEncode(controllerX.selectedProgram?.toJson()));
                      },
                    ),
                  );
                } else {
                  return Expanded(
                    child: Card(
                      clipBehavior: Clip.hardEdge,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(0), // if you need this
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
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Commercial Spots : 0'),
            SizedBox(
              width: 20,
            ),
            Text('Commercial Duration : 00:00:00:00'),
          ],
        ),
      ],
    );
  }

  Widget fpcMismatchView(BuildContext context) {
    return Container(
      height: (Get.height * .60) - kToolbarHeight / 2,
      width: MediaQuery.of(context).size.width * 0.6,
      child: GetBuilder<CommercialController>(
          id: "fpcMismatchView",
          // init: CreateBreakPatternController(),
          builder: (controller) {
            if (controllerX.programList != null &&
                (controllerX.programList?.isNotEmpty)!) {
              // final key = GlobalKey();
              return Expanded(
                // height: 400,
                child: DataGridFromMap(
                  mapData: (controllerX.programList
                      ?.map((e) => e.toJson1())
                      .toList())!,
                  widthRatio: (Get.width * 0.2) / 2 + 7,
                  mode: PlutoGridMode.select,
                  onSelected: (plutoGrid) {
                    // controllerX.selectedProgram =
                    // controllerX.programList![plutoGrid.rowIdx!] ;
                    print(">>>>>>Program Data>>>>>>" +
                        jsonEncode(controllerX.selectedProgram?.toJson()));
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
    );
  }

  Widget markedAsErrorView(BuildContext context) {
    return Container(
      height: (Get.height * .60) - kToolbarHeight / 2,
      width: MediaQuery.of(context).size.width * 0.6,
      child: GetBuilder<CommercialController>(
          id: "markedAsErrorView",
          // init: CreateBreakPatternController(),
          builder: (controller) {
            if (controllerX.programList != null &&
                (controllerX.programList?.isNotEmpty)!) {
              // final key = GlobalKey();
              return Expanded(
                // height: 400,
                child: DataGridFromMap(
                  mapData: (controllerX.programList
                      ?.map((e) => e.toJson1())
                      .toList())!,
                  widthRatio: (Get.width * 0.2) / 2 + 7,
                  mode: PlutoGridMode.select,
                  onSelected: (plutoGrid) {
                    // controllerX.selectedProgram =
                    // controllerX.programList![plutoGrid.rowIdx!] ;
                    print(">>>>>>Program Data>>>>>>" +
                        jsonEncode(controllerX.selectedProgram?.toJson()));
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
    );
  }
}
