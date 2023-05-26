import 'dart:developer';
import 'package:bms_scheduling/app/modules/TransmissionLog/ColorDataModel.dart';
import 'package:bms_scheduling/app/modules/TransmissionLog/controllers/TransmissionLogController.dart';
import 'package:bms_scheduling/app/providers/extensions/string_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pluto_grid/pluto_grid.dart';
import '../app/providers/DataGridMenu.dart';
import '../app/providers/SizeDefine.dart';
import '../app/providers/Utils.dart';
import '../app/styles/theme.dart';

class DataGridFromMap1 extends StatelessWidget {
  DataGridFromMap1(
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
      this.actionIconKey,
      this.actionOnPress,
      this.onSelected,
      this.onRowsMoved,
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

  final List? hideKeys;
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
          enableDropToResize: true,
          enableContextMenu: false,
          width: Utils.getColumnSize(
            key: "no",
          ),
          enableAutoEditing: false,
          hide: hideCode! && key.toString().toLowerCase() != "hourcode" && key.toString().toLowerCase().contains("code"),
          enableColumnDrag: false,
          field: "no",
          type: PlutoColumnType.text()));
    }
    if (showonly != null && showonly!.isNotEmpty) {
      for (var key in showonly!) {
        if ((mapData[0] as Map).containsKey(key)) {
          segColumn.add(PlutoColumn(
              title: key == "fpcCaption" ? "FPC Caption" : key.toString().pascalCaseToNormal(),
              enableRowChecked: false,
              readOnly: true,
              renderer: ((rendererContext) {
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
                        DataGridMenu().showGridMenu(rendererContext.stateManager, detail, context);
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
                      DataGridMenu().showGridMenu(rendererContext.stateManager, detail, context);
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
              enableRowDrag: true,
              enableEditingMode: false,
              enableDropToResize: true,
              enableContextMenu: false,
              width: Utils.getColumnSize(key: key, value: mapData[0][key]),
              enableAutoEditing: false,
              hide: showonly == null
                  ? (hideKeys != null && hideKeys!.contains(key)) ||
                      hideCode! && key.toString().toLowerCase() != "hourcode" && key.toString().toLowerCase().contains("code")
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
            title: key == "fpcCaption" ? "FPC Caption" : key.toString().pascalCaseToNormal(),
            enableRowChecked: false,
            readOnly: true,
            // backgroundColor: Colors.red,
            renderer: ((rendererContext) {
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
                      DataGridMenu().showGridMenu(rendererContext.stateManager, detail, context);
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
                // print("Data is>>>"+(rendererContext.row.cells["color"]?.value.toString()??""));
                return Container(
                  height: 25,
                  padding: EdgeInsets.only(
                    left: 6,
                  ),
                  alignment: Alignment.centerLeft,
                  // color: (key == "epsNo" || key == "tapeid" || key == "status") ? ColorData.cellColor(rendererContext.row.cells[key]?.value, key) : null,
                  child: GestureDetector(
                    onSecondaryTapDown: (detail) {
                      DataGridMenu().showGridMenu(rendererContext.stateManager, detail, context);
                    },
                    child: Text(
                      rendererContext.cell.value.toString(),
                      style: TextStyle(
                          fontSize: SizeDefine.columnTitleFontSize,
                          fontWeight:
                              rendererContext.row.cells["modifed"]?.value.toString().toLowerCase() == "y" ? FontWeight.bold : FontWeight.normal),
                    ),
                  ),
                );
              }
            }),
            enableSorting: enableSort,
            enableRowDrag: true,
            enableEditingMode: false,
            enableDropToResize: true,
            enableContextMenu: false,
            width: Utils.getColumnSize(key: key, value: mapData[0][key]),
            enableAutoEditing: false,
            hide: showonly == null
                ? (hideKeys != null && hideKeys!.contains(key)) ||
                    hideCode! && key.toString().toLowerCase() != "hourcode" && key.toString().toLowerCase().contains("code")
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
                : element.key.toString().toLowerCase().contains("date") && formatDate!
                    ? DateFormat(dateFromat).format(DateTime.parse(element.value.toString().replaceAll("T", " ")))
                    : element.value.toString(),
          );
        }
        segRows.add(PlutoRow(cells: cells, sortIdx: i));
      } catch (e) {
        log("problem in adding rows");
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
            onSelected: onSelected,
            rows: segRows),
      ),
    );
  }
}