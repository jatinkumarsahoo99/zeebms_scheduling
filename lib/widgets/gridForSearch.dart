import 'package:bms_scheduling/app/providers/extensions/string_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

// import 'package:flutter/src/foundation/key.dart';
// import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';
import 'package:bms_scheduling/widgets/PlutoGrid/pluto_grid.dart';

import '../app/modules/TransmissionLog/controllers/TransmissionLogController.dart';
import '../app/providers/DataGridMenu.dart';
import '../app/providers/SizeDefine.dart';
import '../app/providers/Utils.dart';
import '../app/styles/theme.dart';

class DataGridForSearch extends StatelessWidget {
  final Map<String, double>? witdthSpecificColumn;
  final bool canShowFilter;
  DataGridForSearch(
      {Key? key,
        required this.mapData,
        this.canShowFilter = true,
        this.colorCallback,
        this.showSrNo = true,
        this.hideCode = true,
        this.widthRatio,
        this.showonly,
        this.enableSort = false,
        this.onload,
        this.hideKeys,
        this.mode,
        this.editKeys,
        this.onEdit,
        this.actionIcon,
        this.keyMapping,
        this.actionIconKey,
        this.columnAutoResize = false,
        this.actionOnPress,
        this.spaceOnPress,
        this.onSelected,
        this.onRowCheck,
        this.onContextMenuClick,
        this.checkRowKey = "selected",
        this.onRowDoubleTap,
        this.formatDate = true,
        this.dateFromat = "dd-MM-yyyy",
        this.onFocusChange,
        this.checkRow,
        this.doPasccal = true,
        this.exportFileName,
        this.focusNode,
        this.previousWidgetFN,
        this.witdthSpecificColumn,
        this.enableAutoEditing = false,
        this.csvFormat = false})
      : super(key: key);
  final List mapData;
  bool enableSort;
  final bool enableAutoEditing;
  final bool? showSrNo;
  final bool? hideCode;
  final PlutoGridMode? mode;
  final bool? formatDate;
  final bool? checkRow;
  final String? checkRowKey;
  final Map? keyMapping;
  final String? dateFromat;
  final String? exportFileName;
  final List<String>? showonly;
  final Function(PlutoGridOnRowDoubleTapEvent)? onRowDoubleTap;
  final Function(PlutoGridOnChangedEvent)? onEdit;
  final Function(bool)? onFocusChange;
  final Function(DataGridMenuItem, int)? onContextMenuClick;
  final List? hideKeys;
  final Function(PlutoGridOnSelectedEvent)? onSelected;
  final Function(PlutoGridOnRowCheckedEvent)? onRowCheck;
  final double? widthRatio;
  final IconData? actionIcon;
  final String? actionIconKey;
  final bool columnAutoResize;
  final List<String>? editKeys;
  final Function? actionOnPress;
  final Function(int, bool)? spaceOnPress;
  final bool doPasccal;
  final bool? csvFormat;
  Color Function(PlutoRowColorContext)? colorCallback;
  Function(PlutoGridOnLoadedEvent)? onload;
  final GlobalKey rebuildKey = GlobalKey();
  FocusNode? focusNode;
  FocusNode? previousWidgetFN;

  @override
  Widget build(BuildContext context) {
    List<PlutoColumn> segColumn = [];

    focusNode ??= FocusNode();
    List<PlutoRow> segRows = [];
    if (showSrNo!) {
      segColumn.add(PlutoColumn(
          title: "No.",
          // titleSpan: TextSpan(
          //   text: "No.",
          //   recognizer: DoubleTapGestureRecognizer()
          //     ..onDoubleTap = () {
          //       if (onContextMenuClick == null) {
          //         DataGridMenu().showGridMenu(rendererContext.stateManager, detail, context, exportFileName: exportFileName);
          //       } else {
          //         DataGridMenu().showGridCustomMenu(rendererContext.stateManager, detail, context,
          //             exportFileName: exportFileName, onPressedClick: onContextMenuClick, plutoContext: rendererContext);
          //       }
          //     },
          // ),
          enableRowChecked: false,
          readOnly: true,
          enableSorting: enableSort,
          enableRowDrag: false,
          enableDropToResize: true,
          enableContextMenu: false,
          minWidth: (checkRow == true && key == checkRowKey) ? 50 : 5,
          width: (witdthSpecificColumn != null &&
              witdthSpecificColumn!.keys.toList().contains('no'))
              ? witdthSpecificColumn!['no']!
              : Utils.getColumnSize(key: 'no', value: mapData[0][key]),
          enableAutoEditing: false,
          hide: hideCode! &&
              key.toString().toLowerCase() != "hourcode" &&
              key.toString().toLowerCase().contains("code"),
          enableColumnDrag: false,
          field: "no",
          cellPadding: const EdgeInsets.all(0),
          renderer: ((rendererContext) {
            // print("On rendererContext called");
            return GestureDetector(
              onSecondaryTapDown: canShowFilter
                  ? (detail) {
                DataGridMenu().showGridMenuForSearchForm(
                    rendererContext.stateManager, detail, context,
                    exportFileName: exportFileName,
                    data: mapData,
                    csvFormat: csvFormat ?? false);
              }
                  : null,
              child: Container(
                // height: 25,
                  height: double.infinity,
                  // width: Utils.getColumnSize1(key: key, value: mapData[0][key]),
                  // padding: EdgeInsets.only(
                  //   left:
                  // ),
                  decoration: BoxDecoration(
                      border:
                      Border.all(color: Colors.transparent, width: 0.01),
                      borderRadius: BorderRadius.circular(1),
                      color: Colors.white),
                  alignment: Alignment.center,
                  // color: (key == "epsNo" || key == "tapeid" || key == "status") ? ColorData.cellColor(rendererContext.row.cells[key]?.value, key) : null,
                  child: Text(
                    (rendererContext.rowIdx + 1).toString(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: SizeDefine.columnTitleFontSize,
                    ),
                  )),
            );
          }),
          // renderer: (rendererContext) {
          //   return GestureDetector(
          //     onSecondaryTapDown: canShowFilter
          //         ? (detail) {
          //             if (onContextMenuClick == null) {
          //               DataGridMenu().showGridMenu(
          //                   rendererContext.stateManager, detail, context,
          //                   exportFileName: exportFileName);
          //             } else {
          //               DataGridMenu().showGridCustomMenu(
          //                   rendererContext.stateManager, detail, context,
          //                   exportFileName: exportFileName,
          //                   onPressedClick: onContextMenuClick,
          //                   plutoContext: rendererContext);
          //             }
          //           }
          //         : null,
          //     child: Text(
          //       (rendererContext.cell.value ?? "").toString(),
          //       style: TextStyle(
          //         fontSize: SizeDefine.columnTitleFontSize,
          //       ),
          //       maxLines: 1,
          //       overflow: TextOverflow.ellipsis,
          //     ),
          //   );
          // },
          type: PlutoColumnType.text()));
    }
    if (showonly != null && showonly!.isNotEmpty) {
      for (var key in showonly!) {
        if ((mapData[0] as Map).containsKey(key)) {
          segColumn.add(PlutoColumn(
              minWidth: (checkRow == true && key == checkRowKey) ? 50 : 5,
              title: doPasccal
                  ? keyMapping != null
                  ? keyMapping!.containsKey(key)
                  ? keyMapping![key]
                  : key == "fpcCaption"
                  ? "FPC Caption"
                  : key.toString().pascalCaseToNormal()
                  : key.toString().pascalCaseToNormal()
                  : key.toString(),
              enableRowChecked:
              (checkRow == true && key == checkRowKey) ? true : false,
              renderer: ((rendererContext) {
                if (actionIconKey != null && key == actionIconKey) {
                  return GestureDetector(
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
                    onSecondaryTapDown: canShowFilter
                        ? (detail) {
                        DataGridMenu().showGridMenuForSearchForm(
                            rendererContext.stateManager, detail, context,
                            exportFileName: exportFileName,
                            data: mapData,
                            csvFormat: csvFormat ?? false);
                    }
                        : null,
                    child: Text(
                      (rendererContext.cell.value ?? "").toString(),
                      style: TextStyle(
                        fontSize: SizeDefine.columnTitleFontSize,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                }
              }),
              enableSorting: enableSort,
              enableRowDrag: false,
              enableEditingMode: editKeys != null && editKeys!.contains(key),
              enableDropToResize: true,
              enableContextMenu: false,
              width: (witdthSpecificColumn != null &&
                  witdthSpecificColumn!.keys.toList().contains(key))
                  ? witdthSpecificColumn![key]!
                  : Utils.getColumnSize(key: key, value: mapData[0][key]),
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
            titlePadding: EdgeInsets.only(),
            title: doPasccal
                ? keyMapping != null
                ? keyMapping!.containsKey(key)
                ? keyMapping![key]
                : key == "fpcCaption"
                ? "FPC Caption"
                : key.toString().pascalCaseToNormal()
                : key.toString().pascalCaseToNormal()
                : key.toString(),
            enableRowChecked:
            (checkRow == true && key == checkRowKey) ? true : false,
            renderer: ((rendererContext) {
              if (actionIconKey != null) {
                if (key == actionIconKey) {
                  return GestureDetector(
                    child: Icon(
                      actionIcon,
                      size: 19,
                      color: Theme.of(context).primaryColor,
                    ),
                    onTap: () {
                      actionOnPress!(rendererContext.rowIdx);
                    },
                  );
                } else {
                  return GestureDetector(
                    onSecondaryTapDown: canShowFilter
                        ? (detail) {
                      DataGridMenu().showGridMenuForSearchForm(
                          rendererContext.stateManager, detail, context,
                          exportFileName: exportFileName,
                          data: mapData,
                          csvFormat: csvFormat ?? false);
                    }
                        : null,
                    child: Text(
                      (rendererContext.cell.value ?? '').toString(),
                      style: TextStyle(
                        fontSize: SizeDefine.columnTitleFontSize,
                        overflow: TextOverflow.ellipsis,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                }
              } else if (GetInstance()
                  .isRegistered<TransmissionLogController>() &&
                  Get.find<TransmissionLogController>().tsListData != null &&
                  ((Get.find<TransmissionLogController>().tsListData?.length ??
                      0) >
                      0)) {
                bool isColorRed = false;
                int intPromoCap =
                    Get.find<TransmissionLogController>().tsPromoCap.value;
                int intCommercialCap =
                    Get.find<TransmissionLogController>().tsCommercialCap.value;
                if (key == "promoDuration") {
                  if (num.tryParse(rendererContext
                      .row.cells["promoDuration"]?.value
                      .toString() ??
                      "0")! >
                      intPromoCap / 60.0) {
                    isColorRed = true;
                  }
                }
                if (key == "commercialduration") {
                  if (num.tryParse(rendererContext
                      .row.cells["commercialduration"]?.value
                      .toString() ??
                      "0")! >
                      intCommercialCap / 60.0) {
                    isColorRed = true;
                  }
                }
                if (key == "totaladd") {
                  if (num.tryParse(rendererContext.row.cells["totaladd"]?.value
                      .toString() ??
                      "0")! >
                      (intCommercialCap + intPromoCap) / 60.0) {
                    isColorRed = true;
                  }
                }
                if (key == "Commercial & Promo") {
                  if (num.tryParse(rendererContext
                      .row.cells["Commercial & Promo"]?.value
                      .toString() ??
                      "0")! >
                      (intCommercialCap + intPromoCap) / 60.0) {
                    isColorRed = true;
                  }
                }
                return GestureDetector(
                  onSecondaryTapDown: canShowFilter
                      ? (detail) {
                    DataGridMenu().showGridMenuForSearchForm(
                        rendererContext.stateManager, detail, context,
                        exportFileName: exportFileName,
                        data: mapData,
                        csvFormat: csvFormat ?? false);
                  }
                      : null,
                  child: Container(
                    height: 25,
                    padding: EdgeInsets.only(
                      left: 6,
                    ),
                    decoration: BoxDecoration(
                      border:
                      Border.all(color: Colors.transparent, width: 0.01),
                      borderRadius: BorderRadius.circular(1),
                      color: isColorRed ? Colors.red : null,
                    ),
                    alignment: Alignment.centerLeft,
                    // color: (key == "epsNo" || key == "tapeid" || key == "status") ? ColorData.cellColor(rendererContext.row.cells[key]?.value, key) : null,
                    child: Text(
                      rendererContext.cell.value.toString(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: SizeDefine.columnTitleFontSize,
                          fontWeight: rendererContext
                              .row.cells["modifed"]?.value
                              .toString()
                              .toLowerCase() ==
                              "y"
                              ? FontWeight.bold
                              : FontWeight.normal),
                    ),
                  ),
                );
              } else {
                return GestureDetector(
                  onSecondaryTapDown: canShowFilter
                      ? (detail) {
                    DataGridMenu().showGridMenuForSearchForm(
                        rendererContext.stateManager, detail, context,
                        exportFileName: exportFileName,
                        data: mapData,
                        csvFormat: csvFormat ?? false);
                  }
                      : null,
                  child: Text(
                    (rendererContext.cell.value ?? '').toString(),
                    style: TextStyle(
                      fontSize: SizeDefine.columnTitleFontSize,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              }
            }),
            enableSorting: enableSort,
            enableRowDrag: false,
            enableEditingMode: editKeys != null && editKeys!.contains(key),
            enableDropToResize: true,
            enableContextMenu: false,
            minWidth: (checkRow == true && key == checkRowKey) ? 50 : 5,
            width: (witdthSpecificColumn != null &&
                witdthSpecificColumn!.keys.toList().contains(key))
                ? witdthSpecificColumn![key]!
                : Utils.getColumnSize(key: key, value: mapData[0][key]),
            enableAutoEditing: enableAutoEditing,
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
        print("problem in adding rows" + e.toString());
      }
    }

    return Scaffold(
      key: rebuildKey,
      body: Focus(
        onFocusChange: onFocusChange,
        focusNode: focusNode,
        autofocus: false,
        child: PlutoGrid(
            onChanged: onEdit,
            mode: mode ?? PlutoGridMode.normal,
            configuration: plutoGridConfiguration(
              focusNode: focusNode!,
              autoScale: columnAutoResize,
              spaceOnPress: spaceOnPress,
              actionOnPress: actionOnPress,
              actionKey: actionIconKey,
              previousWidgetFN: previousWidgetFN,
              rowHeight: 25,
            ),
            rowColorCallback: colorCallback,
            onLoaded: (load) {
              // load.stateManager.setColumnSizeConfig(PlutoGridColumnSizeConfig(
              //     autoSizeMode: columnAutoResize
              //         ? PlutoAutoSizeMode.none
              //         : PlutoAutoSizeMode.scale,
              //     resizeMode: PlutoResizeMode.normal));
              load.stateManager.setKeepFocus(false);
              if (onload != null) {
                onload!(load);
              }
            },
            columns: segColumn,
            onRowDoubleTap: onRowDoubleTap,
            onSelected: onSelected,
            onRowChecked: onRowCheck,
            rows: segRows),
      ),
    );
  }
}