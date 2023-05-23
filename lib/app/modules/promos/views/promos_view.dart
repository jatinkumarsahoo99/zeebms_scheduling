import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pluto_grid/pluto_grid.dart';
import '../../../../widgets/DateTime/DateWithThreeTextField.dart';
import '../../../../widgets/FormButton.dart';
import '../../../../widgets/dropdown.dart';
import '../../../../widgets/gridFromMap.dart';
import '../../../../widgets/input_fields.dart';
import '../../../controller/HomeController.dart';
import '../../../providers/SizeDefine.dart';
import '../../filler/controllers/filler_controller.dart';
import '../controllers/promos_controller.dart';

class PromosView extends GetView<PromosController> {
  PromosView({Key? key}) : super(key: key);

  late PlutoGridStateManager stateManager;
  var formName = 'Scheduling Promo';

  void handleOnRowChecked(PlutoGridOnRowCheckedEvent event) {}
  //PromosController controllerX = Get.put(PromosController());
  FillerController controllerX = Get.put(FillerController());

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    return GetBuilder<PromosController>(
        init: PromosController(),
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
              child: SizedBox(
                height: double.maxFinite,
                width: double.maxFinite,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          /// Two Table
                          Expanded(
                            flex: 2,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                    child: GetBuilder<FillerController>(
                                      id: "initialData",
                                      builder: (control) {
                                        return Row(
                                          children: [
                                            Obx(
                                              () => DropDownField
                                                  .formDropDown1WidthMap(
                                                      controller.locations
                                                          .value, (value) {
                                                // controller.selectedLocation = value;
                                                // controller.getChannel(value.key);
                                              }, "Location", 0.15),
                                            ),
                                            const SizedBox(width: 15),
                                            Obx(
                                              () => DropDownField
                                                  .formDropDown1WidthMap(
                                                controller.channels.value,
                                                (value) {
                                                  //controller.selectedChannel = value;
                                                },
                                                "Channel",
                                                0.15,
                                                dialogHeight: Get.height * .7,
                                              ),
                                            ),
                                            const SizedBox(width: 15),
                                            Obx(
                                                  () => DateWithThreeTextField(
                                                title: "From Date",
                                                splitType: "-",
                                                widthRation: controllerX.widthSize,
                                                isEnable: controller.isEnable.value,
                                                onFocusChange: (data) {
                                                  print('Selected Date $data');

                                                },
                                                mainTextController: controllerX.date_,
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10, top: 17.0),
                                              child: FormButton(
                                                btnText: "Show Details",
                                                callback: () {},
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 17.0),
                                              child: FormButton(
                                                btnText: "Import",
                                                callback: () {},
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10, top: 17.0),
                                              child: FormButton(
                                                btnText: "Delete",
                                                callback: () {},
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                  ),
                                  // Padding(
                                  //   padding:
                                  //       const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                  //   child: GetBuilder<PromosController>(
                                  //     id: "initialData",
                                  //     builder: (control) {
                                  //       return Expanded(
                                  //         child: Row(
                                  //           children: [
                                  //             Obx(
                                  //               () => DropDownField
                                  //                   .formDropDown1WidthMap(
                                  //                 controllerX.locations.value,
                                  //                 (value) {
                                  //                   controllerX.selectLocation =
                                  //                       value;
                                  //                   // controllerX.selectedLocationId.text = value.key!;
                                  //                   // controllerX.selectedLocationName.text = value.value!;
                                  //                   // controller.getChannelsBasedOnLocation(value.key!);
                                  //                 },
                                  //                 "Location",
                                  //                 0.14,
                                  //                 isEnable: controllerX
                                  //                     .isEnable.value,
                                  //                 selected: controllerX
                                  //                     .selectLocation,
                                  //                 autoFocus: true,
                                  //                 dialogWidth: 330,
                                  //                 dialogHeight: Get.height * .7,
                                  //               ),
                                  //             ),
                                  //             const SizedBox(width: 10),
                                  //             Obx(() {
                                  //               return DropDownField
                                  //                   .formDropDown1Width(
                                  //                 Get.context!,
                                  //                 controllerX.channelList ?? [],
                                  //                 (value) {
                                  //                   controllerX
                                  //                           .selectedChannel =
                                  //                       value;
                                  //                 },
                                  //                 "Channel",
                                  //                 controllerX.widthSize + 0.02,
                                  //                 paddingLeft: 5,
                                  //                 searchReq: true,
                                  //                 isEnable: control
                                  //                     .channelEnable.value,
                                  //                 selected: controllerX
                                  //                     .selectedChannelEnv,
                                  //                 dialogHeight: Get.height * .7,
                                  //               );
                                  //             }),
                                  //             const SizedBox(width: 10),
                                  //             DateWithThreeTextField(
                                  //               title: "From Date",
                                  //               mainTextController:
                                  //                   controllerX.date_,
                                  //               widthRation: 0.10,
                                  //             ),
                                  //             Padding(
                                  //               padding: const EdgeInsets.only(
                                  //                   left: 10, top: 17.0),
                                  //               child: FormButton(
                                  //                 btnText: "Show Details",
                                  //                 callback: () {},
                                  //               ),
                                  //             ),
                                  //             const SizedBox(width: 10),
                                  //             Padding(
                                  //               padding: const EdgeInsets.only(
                                  //                   top: 17.0),
                                  //               child: FormButton(
                                  //                 btnText: "Import",
                                  //                 callback: () {},
                                  //               ),
                                  //             ),
                                  //             Padding(
                                  //               padding: const EdgeInsets.only(
                                  //                   left: 10, top: 17.0),
                                  //               child: FormButton(
                                  //                 btnText: "Delete",
                                  //                 callback: () {},
                                  //               ),
                                  //             ),
                                  //           ],
                                  //         ),
                                  //       );
                                  //     },
                                  //   ),
                                  // ),
                                  Expanded(
                                    //flex: 1,
                                    child: GetBuilder<FillerController>(
                                        init: FillerController(),
                                        id: "eventTable",
                                        builder: (controller) {
                                          if (controller
                                                  .conflictReport.isEmpty ||
                                              controller.beams.isEmpty) {
                                            return Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                fillerTable(context),
                                              ],
                                            );
                                          } else {
                                            return Container();
                                          }
                                        }),
                                  ),
                                  Expanded(
                                    //flex: 1,
                                    child: GetBuilder<FillerController>(
                                        init: FillerController(),
                                        id: "eventCaptionTable",
                                        builder: (controller) {
                                          if (controller
                                                  .conflictReport.isEmpty ||
                                              controller.beams.isEmpty) {
                                            return Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                fillerSegmentTable(context),
                                              ],
                                            );
                                          } else {
                                            return Container();
                                          }
                                        }),
                                  ),
                                  const Padding(
                                      padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                                      child: Text("Time Band : 00:00:00")),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 0, 0, 10),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        const Text("Program : PrgName"),
                                        const Spacer(),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 5.0),
                                          child: InputFields.formField1Width(
                                              widthRatio: 0.09,
                                              paddingLeft: 5,
                                              hintTxt: "Available",
                                              controller: controllerX.segNo_,
                                              maxLen: 10),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 5.0),
                                          child: InputFields.formField1Width(
                                              widthRatio: 0.09,
                                              paddingLeft: 5,
                                              hintTxt: "Scheduled",
                                              controller: controllerX.segNo_,
                                              maxLen: 10),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 5.0),
                                          child: InputFields.formField1Width(
                                              widthRatio: 0.09,
                                              paddingLeft: 5,
                                              hintTxt: "Count",
                                              controller: controllerX.segNo_,
                                              maxLen: 10),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          /// Program Table
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(0, 10, 15, 0),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(top: 5.0),
                                          child: InputFields.formField1Width(
                                              widthRatio: .15,
                                              paddingLeft: 5,
                                              hintTxt: "Promo Caption",
                                              controller: controllerX.tapeId_,
                                              maxLen: 10),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(top: 5.0),
                                          child: InputFields.formField1Width(
                                              widthRatio:
                                                  (Get.width * 0.2) / 2 + 7,
                                              paddingLeft: 5,
                                              isEnable: false,
                                              hintTxt: "",
                                              controller: controllerX.segNo_,
                                              maxLen: 10),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(top: 5.0),
                                          child: InputFields.formField1Width(
                                              widthRatio:
                                                  (Get.width * 0.2) / 2 + 7,
                                              paddingLeft: 5,
                                              hintTxt: "Promo Id",
                                              controller: controllerX.tapeId_,
                                              maxLen: 10),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            bottom: 8.0, top: 8.0),
                                        child: Row(children: [
                                          Radio(
                                            value: 0,
                                            groupValue:
                                                controllerX.selectedAfter,
                                            onChanged: (int? value) {},
                                          ),
                                          const Text('My')
                                        ]),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10, bottom: 5.0, top: 5.0),
                                        child: FormButton(
                                          btnText: "Search",
                                          callback: () {},
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10, bottom: 5.0, top: 5.0),
                                        child: FormButton(
                                          btnText: "Add",
                                          callback: () {},
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10, bottom: 5.0, top: 5.0),
                                        child: FormButton(
                                          btnText: "Auto Add",
                                          callback: () {},
                                        ),
                                      ),
                                    ],
                                  ),
                                  programTable(context)
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
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
          );
        });
  }

  Widget fillerTable(context) {
    return GetBuilder<FillerController>(
        id: "fillerTable",
        // init: CreateBreakPatternController(),
        builder: (controller) {
          if (controllerX.fillerDailyFpcList != null &&
              (controllerX.fillerDailyFpcList?.isNotEmpty)!) {
            // final key = GlobalKey();
            return DataGridFromMap(
              mapData: (controllerX.fillerDailyFpcList
                  ?.map((e) => e.toJson())
                  .toList())!,
              widthRatio: (Get.width * 0.2) / 2 + 7,
              // mode: PlutoGridMode.select,
              onSelected: (plutoGrid) {
                controllerX.selectedDailyFPC =
                    controllerX.fillerDailyFpcList![plutoGrid.rowIdx!];
                print(jsonEncode(controllerX.selectedDailyFPC?.toJson()));
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
                  height: Get.height - (4 * kToolbarHeight),
                ),
              ),
            );
          }
        });
  }

  Widget fillerSegmentTable(context) {
    return GetBuilder<FillerController>(
        id: "fillerSegmentTable",
        // init: CreateBreakPatternController(),
        builder: (controller) {
          if (controllerX.fillerSegmentList != null &&
              (controllerX.fillerSegmentList?.isNotEmpty)!) {
            // final key = GlobalKey();
            return Expanded(
              // height: 400,
              child: DataGridFromMap(
                mapData: (controllerX.fillerSegmentList
                    ?.map((e) => e.toJson())
                    .toList())!,
                widthRatio: (Get.width * 0.2) / 2 + 7,
                // mode: PlutoGridMode.select,
                onSelected: (plutoGrid) {
                  controllerX.selectedSegment =
                      controllerX.fillerSegmentList![plutoGrid.rowIdx!];
                  print(jsonEncode(controllerX.selectedSegment?.toJson()));
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

  Widget programTable(context) {
    return GetBuilder<PromosController>(
        id: "programTable",
        // init: CreateBreakPatternController(),
        builder: (controller) {
          if (controllerX.fillerDailyFpcList != null &&
              (controllerX.fillerDailyFpcList?.isNotEmpty)!) {
            // final key = GlobalKey();
            return Expanded(
              // height: 400,
              child: DataGridFromMap(
                mapData: (controllerX.fillerDailyFpcList
                    ?.map((e) => e.toJson())
                    .toList())!,
                widthRatio: (Get.width * 0.2) / 2 + 7,
                // mode: PlutoGridMode.select,
                onSelected: (plutoGrid) {
                  controllerX.selectedDailyFPC =
                      controllerX.fillerDailyFpcList![plutoGrid.rowIdx!];
                  print(jsonEncode(controllerX.selectedDailyFPC?.toJson()));
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
}
