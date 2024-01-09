import 'dart:developer';
import 'package:bms_scheduling/app/providers/extensions/string_extensions.dart';
// import 'package:bms_programming/app/providers/extensions/string_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:bms_scheduling/widgets/PlutoGrid/pluto_grid.dart';

import '../app/providers/DataGridMenu.dart';
import '../app/providers/SizeDefine.dart';
import '../app/providers/Utils.dart';
import '../app/styles/theme.dart';

class ListDataGridFromMap extends StatelessWidget {
  ListDataGridFromMap(
      {Key? key,
      required this.mapData,
      this.colorCallback,
      this.showSrNo = false,
      this.hideCode = true,
      this.onload,
      this.hideKeys,
      this.showcheckBox = false,
      this.cellwidth = 180,
      this.mode})
      : super(key: key);
  final List mapData;
  final bool? showcheckBox;

  final bool? showSrNo;
  final List<String>? hideKeys;
  final PlutoGridMode? mode;
  final bool? hideCode;
  final double? cellwidth;
  Color Function(PlutoRowColorContext)? colorCallback;
  Function(PlutoGridOnLoadedEvent)? onload;
  @override
  Widget build(BuildContext context) {
    List<PlutoColumn> segColumn = [];
    List<PlutoRow> segRows = [];
    FocusNode _focusNode = FocusNode();
    if (showSrNo!) {
      segColumn.add(PlutoColumn(
          title: "No.",
          enableRowChecked: showcheckBox!,
          readOnly: true,
          renderer: ((rendererContext) => GestureDetector(
                onSecondaryTapDown: (detail) {
                  DataGridMenu().showGridMenu(rendererContext.stateManager, detail, context,data: mapData);
                },
                child: Text(
                  rendererContext.cell.value.toString(),
                  style: TextStyle(
                    fontSize: SizeDefine.columnTitleFontSize,
                  ),
                ),
              )),
          enableSorting: true,
          enableRowDrag: false,
          enableEditingMode: false,
          enableDropToResize: true,
          enableContextMenu: false,
          width: 30,
          enableAutoEditing: false,
          hide: hideKeys == null ? false : (hideKeys!.contains(key.toString()) ? true : false),
          enableColumnDrag: false,
          field: "no",
          type: PlutoColumnType.text()));
    }
    for (var key in mapData[0].keys) {
      segColumn.add(PlutoColumn(
          title: key.toString().pascalCaseToNormal(),
          enableRowChecked: showSrNo! ? false : showcheckBox!,
          readOnly: true,
          renderer: ((rendererContext) => GestureDetector(
                onSecondaryTapDown: (detail) {
                  DataGridMenu().showGridMenu(rendererContext.stateManager, detail, context,data: mapData);
                },
                child: Text(
                  rendererContext.cell.value.toString(),
                  style: TextStyle(
                    fontSize: SizeDefine.columnTitleFontSize,
                  ),
                ),
              )),
          enableSorting: true,
          enableRowDrag: false,
          enableEditingMode: false,
          enableDropToResize: true,
          enableContextMenu: false,
          width: Utils.getColumnSize(key: key, value: mapData[0][key]),
          enableAutoEditing: false,
          hide: hideCode! && key.toString().toLowerCase() != "hourcode" && key.toString().toLowerCase().contains("code"),
          enableColumnDrag: false,
          field: key,
          type: PlutoColumnType.text()));
    }
    for (var i = 0; i < mapData.length; i++) {
      Map row = mapData[i];
      Map<String, PlutoCell> cells = {};

      try {
        cells["no"] = PlutoCell(
          value: i.toString(),
        );
        for (var element in row.entries) {
          cells[element.key] = PlutoCell(
            value: element.key == "selected" || element.value == null ? "" : element.value.toString(),
          );
        }
        segRows.add(PlutoRow(
          cells: cells,
        ));
      } catch (e) {
        log("problem in adding rows");
      }
    }

    return PlutoGrid(
        configuration: plutoGridConfiguration(focusNode: _focusNode),
        rowColorCallback: colorCallback,
        onLoaded: onload,
        columns: segColumn,
        mode: mode ?? PlutoGridMode.normal,
        rows: segRows);
  }
}
