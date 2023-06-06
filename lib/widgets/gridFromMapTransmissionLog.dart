import 'dart:developer';
import 'dart:math';
import 'package:bms_scheduling/app/modules/TransmissionLog/ColorDataModel.dart';
import 'package:bms_scheduling/app/modules/TransmissionLog/controllers/TransmissionLogController.dart';
import 'package:bms_scheduling/app/providers/extensions/string_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:bms_scheduling/widgets/PlutoGrid/pluto_grid.dart';
import '../app/providers/DataGridMenu.dart';
import '../app/providers/SizeDefine.dart';
import '../app/providers/Utils.dart';
import '../app/styles/theme.dart';

class DataGridFromMapTransmissionLog extends StatelessWidget {
  DataGridFromMapTransmissionLog(
      {Key? key,
      required this.mapData,
      this.colorCallback,
      this.showSrNo = false,
      this.hideCode = true,
      this.widthRatio,
      this.showonly,
      this.enableSort = false,
      this.onload,
      this.hideKeys,
      this.mode,
      this.actionIcon,
      this.exportFileName,
      this.actionIconKey,
      this.actionOnPress,
      this.onSelected,
      this.onRowsMoved,
      this.onChanged,
      this.onContextMenuClick,
      this.onRowDoubleTap,
      this.formatDate = true,
      this.dateFromat = "dd-MM-yyyy",
      this.onFocusChange})
      : super(key: key);
  final List mapData;
  bool enableSort;
  final bool? showSrNo;
  final bool? hideCode;
  final PlutoGridMode? mode;
  final Function(bool)? onFocusChange;
  final bool? formatDate;
  final String? dateFromat;
  final List<String>? showonly;
  final Function(PlutoGridOnRowDoubleTapEvent)? onRowDoubleTap;
  final Function(PlutoGridOnRowsMovedEvent)? onRowsMoved;
  final Function(PlutoGridOnChangedEvent)? onChanged;
  final Function(DataGridMenuItem, int, PlutoColumnRendererContext)?onContextMenuClick;
  final List? hideKeys;
  final String? exportFileName;
  final Function(PlutoGridOnSelectedEvent)? onSelected;
  final double? widthRatio;
  final IconData? actionIcon;
  final String? actionIconKey;
  final Function? actionOnPress;
  Color Function(PlutoRowColorContext)? colorCallback;
  Function(PlutoGridOnLoadedEvent)? onload;

  @override
  Widget build(BuildContext context) {
    FocusNode _focusNode = FocusNode();
    GlobalKey _globalKey = GlobalKey();
    List<PlutoColumn> segColumn = [];
    List<PlutoRow> segRows = [];
    if (showSrNo!) {
      segColumn.add(PlutoColumn(
          title: "No.",
          enableRowChecked: false,
          readOnly: true,
          enableSorting: enableSort,
          enableEditingMode: false,
          enableDropToResize: false,
          enableContextMenu: false,
          // width: 250,
          minWidth: 50,
          renderer: ((rendererContext) {
            // print("On rendererContext called");

            return GestureDetector(
              onSecondaryTapDown: (detail) {
                if (onContextMenuClick == null) {
                  DataGridMenu().showGridMenu(
                      rendererContext.stateManager, detail, context,
                      exportFileName: exportFileName);
                } else {
                  DataGridMenu().showGridCustomTransmissionLog(
                      rendererContext.stateManager, detail, context,
                      exportFileName: exportFileName,
                      onPressedClick: onContextMenuClick,
                      plutoContext: rendererContext);
                }
              },
              child: Text(
                (rendererContext.rowIdx + 1).toString(),
                style: TextStyle(
                  fontSize: SizeDefine.columnTitleFontSize,
                ),
              ),
            );
          }),
          enableAutoEditing: false,
          enableRowDrag: true,
          hide: hideCode! &&
              key.toString().toLowerCase() != "hourcode" &&
              key.toString().toLowerCase().contains("code"),
          enableColumnDrag: false,
          field: "no",
          type: PlutoColumnType.text()));
    }
    if (showonly != null && showonly!.isNotEmpty) {
      for (var key in showonly!) {
        if ((mapData[0] as Map).containsKey(key)) {
          segColumn.add(PlutoColumn(
              title: key == "fpcCaption"
                  ? "FPC Caption"
                  : key.toString().pascalCaseToNormal(),
              enableRowChecked: false,
              readOnly: true,
              renderer: ((rendererContext) {
                // print("On rendererContext called");
                if (actionIconKey != null) {
                  if (key == actionIconKey) {
                    return InkWell(
                      child: Icon(
                        actionIcon,
                        size: 19,
                      ),
                      onTap: () {
                        actionOnPress!(rendererContext.rowIdx);
                      },
                    );
                  } else {
                    return GestureDetector(
                      onSecondaryTapDown: (detail) {
                        if (onContextMenuClick == null) {
                          DataGridMenu().showGridMenu(
                              rendererContext.stateManager, detail, context,
                              exportFileName: exportFileName);
                        } else {
                          DataGridMenu().showGridCustomTransmissionLog(
                              rendererContext.stateManager, detail, context,
                              exportFileName: exportFileName,
                              onPressedClick: onContextMenuClick,
                              plutoContext: rendererContext);
                        }
                      },
                      child: Text(
                        rendererContext.cell.value.toString(),
                        style: TextStyle(
                          fontSize: SizeDefine.columnTitleFontSize,
                        ),
                      ),
                    );
                  }
                } else {
                  return GestureDetector(
                    onSecondaryTapDown: (detail) {
                      if (onContextMenuClick == null) {
                        DataGridMenu().showGridMenu(
                            rendererContext.stateManager, detail, context,
                            exportFileName: exportFileName);
                      } else {
                        DataGridMenu().showGridCustomTransmissionLog(
                            rendererContext.stateManager, detail, context,
                            exportFileName: exportFileName,
                            onPressedClick: onContextMenuClick,
                            plutoContext: rendererContext);
                      }
                    },
                    child: Text(
                      rendererContext.cell.value.toString(),
                      style: TextStyle(
                        fontSize: SizeDefine.columnTitleFontSize,
                      ),
                    ),
                  );
                }
              }),
              enableSorting: enableSort,
              enableRowDrag: key=="transmissionTime"?true:false,
              enableEditingMode: false,
              enableDropToResize: true,
              enableContextMenu: false,
              width: Utils.getColumnSize1(key: key, value: mapData[0][key]),
              enableAutoEditing: false,
              hide: showonly == null
                  ? (hideKeys != null && hideKeys!.contains(key)) ||
                      hideCode! &&
                          key.toString().toLowerCase() != "hourcode" &&
                          key.toString().toLowerCase().contains("code")
                  : !showonly!.contains(key),
              enableColumnDrag: false,
              field: key,
              type: PlutoColumnType.text()));
        }
      }
    } else {
      for (var key in mapData[0].keys) {
        segColumn.add(PlutoColumn(
            cellPadding: EdgeInsets.zero,
            title: key == "fpcCaption"
                ? "FPC Caption"
                : key.toString().pascalCaseToNormal(),
            enableRowChecked: false,
            readOnly: true,
            // backgroundColor: Colors.red,
            renderer: ((rendererContext) {
              // print(">>>>>>Render called");

              bool isBold = false;
              Map<String, PlutoCell> cells = rendererContext.row.cells;

              if (key == "transmissionTime" &&
                  (cells["eventType"]?.value.toString().trim().toLowerCase() ==
                      "p")) {
                var strFPCTime =
                    (((cells["fpCtime"]?.value) ?? "00:00:00").toString());
                var intFPCTime =
                    Utils.oldBMSConvertToSecondsValue(value: strFPCTime);
                var strTransmissionTime =
                    (((cells["transmissionTime"]?.value) ?? "00:00:00")
                        .toString());
                var intTransmissionTime = Utils.oldBMSConvertToSecondsValue(
                    value: strTransmissionTime);
                if ((((intTransmissionTime - intFPCTime)).abs() >
                    Get.find<TransmissionLogController>()
                        .maxProgramStarttimeDiff.value)) {
                  isBold = true;
                  print("eventType Index is>> " +
                      rendererContext.rowIdx.toString() +
                      " ////" +
                      isBold.toString());
                }
              }

              // Checking Same product back to back
              if (key == "productName" &&
                  (cells["productName"]?.value != null &&
                      cells["productName"]?.value != "")) {
                String currentProduct = cells["productName"]?.value;
                if (rendererContext.rowIdx <
                    ((rendererContext.stateManager.rows.length)! - 2)) {
                  if (((currentProduct ==
                          (rendererContext
                              .stateManager
                              .rows[(rendererContext.rowIdx + 1)]
                              .cells["productName"]
                              ?.value)) ||
                      ((currentProduct ==
                          rendererContext
                              .stateManager
                              .rows[(rendererContext.rowIdx + 2)]
                              .cells["productName"]
                              ?.value)))) {
                    isBold = true;
                    // print("productname Index is>> "+rendererContext.rowIdx.toString()+" ////"+isBold.toString());
                  }
                }
              }

              // Checking Same Tape back to back
              if (key == "exportTapeCode") {
                String? currentTape;
                if (((cells["eventType"]?.value ?? "" + "")
                        .toString()
                        .trim()
                        .toLowerCase() ==
                    "c")) {
                  currentTape = (cells["exportTapeCode"]?.value + "");
                } else {
                  currentTape = "";
                }
                if (currentTape != "") {
                  if (rendererContext.rowIdx <
                      ((rendererContext.stateManager.rows.length)! - 2)) {
                    if ((((currentTape ==
                            (rendererContext
                                    .stateManager
                                    .rows[(rendererContext.rowIdx + 1)]
                                    .cells["exportTapeCode"]
                                    ?.value) +
                                "")) ||
                        ((currentTape ==
                            (rendererContext
                                    .stateManager
                                    .rows[(rendererContext.rowIdx + 2)]
                                    .cells["exportTapeCode"]
                                    ?.value) +
                                "")))) {
                      isBold = true;
                      print("exportTapeCode Index is>> " +
                          rendererContext.rowIdx.toString() +
                          " ////" +
                          isBold.toString());
                    }
                  }
                }
              }

              // Checking PRoduct Group back to back
              if (key == "productGroup" &&
                  (cells["productGroup"]?.value != null &&
                      cells["productGroup"]?.value != "")) {
                String currentProductGrp = cells["productGroup"]?.value;
                if (rendererContext.rowIdx <
                    ((rendererContext.stateManager.rows.length)! - 2)) {
                  if ((((currentProductGrp ==
                          (rendererContext
                                  .stateManager
                                  .rows[(rendererContext.rowIdx + 1)]
                                  .cells["productGroup"]
                                  ?.value) +
                              "")) ||
                      ((currentProductGrp ==
                          (rendererContext
                                  .stateManager
                                  .rows[(rendererContext.rowIdx + 2)]
                                  .cells["productGroup"]
                                  ?.value) +
                              "")))) {
                    isBold = true;
                    print("productGroup Index is>> " +
                        rendererContext.rowIdx.toString() +
                        " ////" +
                        isBold.toString());
                  }
                }
              }

              // Checking PRoduct Group back to back
              if (key == "RosTimeBand" &&
                  (cells["rosTimeBand"]?.value != null &&
                      cells["rosTimeBand"]?.value != "")) {
                List<String>? ros =
                    cells["rosTimeBand"]?.value.toString().split("-");
                String rosStart = (ros![0] + ":00");
                String rosEnd = (ros[1] + ":00");
                String midRosEnd;
                String midRosStart;
                if ((rosStart.compareTo(rosEnd) == 1)) {
                  midRosEnd = "23:59:59";
                  midRosStart = "00:00:00";
                } else {
                  midRosEnd = rosEnd;
                  midRosStart = rosEnd;
                }
                String? txTime =
                    cells["transmissionTime"]?.value.toString().substring(0, 8);

                if ((((txTime?.compareTo(rosStart) == 1) &&
                        (midRosEnd.compareTo(txTime!) == 1)) ||
                    ((txTime?.compareTo(midRosStart) == 1) &&
                        (midRosEnd.compareTo(txTime!) == 1)))) {
                  if ((((txTime.compareTo(rosStart) == 1) &&
                          (midRosEnd.compareTo(txTime) == 1)) ||
                      ((txTime.compareTo(midRosStart) == 1) &&
                          (midRosEnd.compareTo(txTime) == 1)))) {
                  } else {
                    isBold = true;
                    print("RosTimeBand Index is>> " +
                        rendererContext.rowIdx.toString() +
                        " ////" +
                        isBold.toString());
                  }
                }
              }

              //print("Final Index is>> "+rendererContext.rowIdx.toString()+" ////"+isBold.toString());
              return Container(
                height: 25,
                padding: EdgeInsets.only(
                  left: 6,
                ),
                alignment: Alignment.centerLeft,
                // color: (key == "epsNo" || key == "tapeid" || key == "status") ? ColorData.cellColor(rendererContext.row.cells[key]?.value, key) : null,
                child: GestureDetector(
                  onSecondaryTapDown: (detail) {
                    if (onContextMenuClick == null) {
                      DataGridMenu().showGridMenu(
                          rendererContext.stateManager, detail, context,
                          exportFileName: exportFileName);
                    } else {
                      DataGridMenu().showGridCustomTransmissionLog(
                          rendererContext.stateManager, detail, context,
                          exportFileName: exportFileName,
                          onPressedClick: onContextMenuClick,
                          plutoContext: rendererContext);
                    }
                  },
                  child: Text(
                    rendererContext.cell.value.toString(),
                    style: TextStyle(
                        fontSize: SizeDefine.columnTitleFontSize,
                        // color: isBold?Colors.white:Colors.black,
                        fontWeight:
                            isBold ? FontWeight.w800 : FontWeight.normal),
                  ),
                ),
              );
            }),
            enableSorting: enableSort,
            enableRowDrag: key=="transmissionTime"?true:false,
            enableEditingMode: false,
            enableDropToResize: true,
            enableContextMenu: false,
            minWidth: Utils.getColumnSize1(key: key, value: mapData[0][key]),
            enableAutoEditing: false,
            hide: showonly == null
                ? (hideKeys != null && hideKeys!.contains(key)) ||
                    hideCode! &&
                        key.toString().toLowerCase() != "hourcode" &&
                        key.toString().toLowerCase().contains("code")
                : !showonly!.contains(key),
            enableColumnDrag: false,
            field: key,
            type: PlutoColumnType.text()));
      }
    }

    for (var i = 0; i < mapData.length; i++) {
      Map row = mapData[i];

      Map<String, PlutoCell> cells = {};
      if (showSrNo!) {
        cells["no"] = PlutoCell(value: i + 1);
      }
      try {
        for (var element in row.entries) {
          cells[element.key] = PlutoCell(
            value: element.key == "selected" || element.value == null
                ? ""
                : element.key.toString().toLowerCase().contains("date") &&
                        formatDate!
                    ? DateFormat(dateFromat).format(DateTime.parse(
                        element.value.toString().replaceAll("T", " ")))
                    : element.value.toString(),
          );
        }
        segRows.add(PlutoRow(cells: cells, sortIdx: i));
      } catch (e) {
        // log("problem in adding rows");
      }
    }


    return Scaffold(
      key: _globalKey,
      body: Focus(
        autofocus: false,
        focusNode: _focusNode,
        onFocusChange: onFocusChange,
        child: PlutoGrid(
            mode: mode ?? PlutoGridMode.normal,
            configuration: plutoGridConfiguration(focusNode: _focusNode),
            rowColorCallback: colorCallback,
            onLoaded: onload,
            columns: segColumn,
            onRowDoubleTap: onRowDoubleTap,
            onRowsMoved: onRowsMoved,
            onChanged: onChanged,
            onSelected: onSelected,
            /*createFooter: (stateManager) {
              return PlutoLazyPagination(
                // Determine the first page.
                // Default is 1.
                initialPage: 1,

                // First call the fetch function to determine whether to load the page.
                // Default is true.
                initialFetch: true,

                // Decide whether sorting will be handled by the server.
                // If false, handle sorting on the client side.
                // Default is true.
                fetchWithSorting: true,

                // Decide whether filtering is handled by the server.
                // If false, handle filtering on the client side.
                // Default is true.
                fetchWithFiltering: true,

                // Determines the page size to move to the previous and next page buttons.
                // Default value is null. In this case,
                // it moves as many as the number of page buttons visible on the screen.
                pageSizeToMove: null,
                fetch: (contextData){
                  return fetch(contextData,stateManager,segRows);
                },
                stateManager: stateManager,
              );
            },*/
            rows: segRows),
      ),
    );
  }

 /* Future<PlutoLazyPaginationResponse> fetch(
      PlutoLazyPaginationRequest request,stateManager,segRows
      ) async {
    List<PlutoRow> tempList = segRows;
    if (request.filterRows.isNotEmpty) {
      final filter = FilterHelper.convertRowsToFilter(
        request.filterRows,
        stateManager.refColumns,
      );

      tempList = segRows.where(filter!).toList();
    }
    if (request.sortColumn != null && !request.sortColumn!.sort.isNone) {
      tempList = [...tempList];

      tempList.sort((a, b) {
        final sortA = request.sortColumn!.sort.isAscending ? a : b;
        final sortB = request.sortColumn!.sort.isAscending ? b : a;

        return request.sortColumn!.type.compare(
          sortA.cells[request.sortColumn!.field]!.valueForSorting,
          sortB.cells[request.sortColumn!.field]!.valueForSorting,
        );
      });
    }

    final page = request.page;
    const pageSize = 10;
    final totalPage = (tempList.length / pageSize).ceil();
    final start = (page - 1) * pageSize;
    final end = start + pageSize;

    Iterable<PlutoRow> fetchedRows = tempList.getRange(
      max(0, start),
      min(tempList.length, end),
    );

    await Future.delayed(const Duration(milliseconds: 500));

    return Future.value(PlutoLazyPaginationResponse(
      totalPage: totalPage,
      rows: fetchedRows.toList(),
    ));
  }*/

}
