import 'package:bms_scheduling/app/providers/DataGridMenu.dart';
import 'package:bms_scheduling/app/providers/SizeDefine.dart';
import 'package:bms_scheduling/app/providers/Utils.dart';
import 'package:bms_scheduling/app/providers/extensions/string_extensions.dart';
import 'package:bms_scheduling/app/styles/theme.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:bms_scheduling/widgets/PlutoGrid/pluto_grid.dart';

class DataGridMultiCheckBox extends StatelessWidget {
  DataGridMultiCheckBox({
    Key? key,
    required this.mapData,
    this.colorCallback,
    this.showSrNo = true,
    this.hideCode = true,
    this.widthRatio,
    this.showonly,
    this.enableSort = false,
    this.onload,
    this.hideCheckKeysValue = false,
    this.hideKeys,
    this.mode,
    this.editKeys,
    this.onEdit,
    this.actionIcon,
    this.keyMapping,
    this.columnAutoResize = true,
    this.rowCheckColor = const Color(0xFFD1C4E9),
    this.onSelected,
    this.keysWidths,
    this.checkRowKey = "selected",
    this.onRowDoubleTap,
    this.formatDate = true,
    this.dateFromat = "dd-MM-yyyy",
    this.onFocusChange,
    this.checkRow,
    this.extraList,
    this.doPasccal = true,
    this.exportFileName,
    this.focusNode,
    this.onRowChecked,
    this.previousWidgetFN,
    this.checkBoxes,
    this.onCheckBoxPress,
  }) : super(key: key);
  final List mapData;
  bool enableSort;
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
  final List? hideKeys;
  final Function(PlutoGridOnRowCheckedEvent)? onRowChecked;
  final Function(PlutoGridOnSelectedEvent)? onSelected;
  final double? widthRatio;
  final IconData? actionIcon;
  final Map<String, double>? keysWidths;
  final List<String>? checkBoxes;
  final bool columnAutoResize;
  final List<String>? editKeys;
  final Function(String key, int rowId)? onCheckBoxPress;
  final bool hideCheckKeysValue;
  final Color? rowCheckColor;
  final bool doPasccal;
  final List<SecondaryShowDialogModel>? extraList;
  Color Function(PlutoRowColorContext)? colorCallback;
  Function(PlutoGridOnLoadedEvent)? onload;
  final GlobalKey rebuildKey = GlobalKey();
  FocusNode? focusNode;
  FocusNode? previousWidgetFN;

  @override
  Widget build(BuildContext context) {
    if (mapData.isNotEmpty) {
      List<PlutoColumn> segColumn = [];

      focusNode ??= FocusNode();
      List<PlutoRow> segRows = [];
      if (showSrNo!) {
        segColumn.add(PlutoColumn(
            title: "No.",
            enableRowChecked: false,
            readOnly: true,
            enableSorting: enableSort,
            enableRowDrag: false,
            enableDropToResize: true,
            enableContextMenu: false,
            width: (keysWidths != null && keysWidths!.containsKey(key)) ? keysWidths![key]! : Utils.getColumnSize(key: "no", value: mapData[0][key]),
            enableAutoEditing: false,
            enableColumnDrag: false,
            field: "no",
            type: PlutoColumnType.text()));
      }
      for (var key in mapData[0].keys) {
        segColumn.add(PlutoColumn(
            titlePadding: EdgeInsets.only(),
            title: doPasccal ? key.toString().pascalCaseToNormal() : key,
            renderer: ((rendererContext) {
              if ((checkBoxes ?? []).contains(key)) {
                return Checkbox(
                    value: rendererContext.cell.value.toString().toLowerCase() == "true",
                    onChanged: (value) {
                      onCheckBoxPress!(key, rendererContext.row.sortIdx);
                    });
              } else {
                return GestureDetector(
                  onSecondaryTapDown: (detail) {
                    rendererContext.stateManager.setCurrentCell(rendererContext.cell, rendererContext.rowIdx);

                    DataGridMenu().showGridMenu(rendererContext.stateManager, detail, context, exportFileName: exportFileName, extraList: extraList);
                  },
                  child: Text(
                    (checkRow == true && key == checkRowKey && hideCheckKeysValue) ? "" : rendererContext.cell.value.toString(),
                    style: TextStyle(
                      fontSize: SizeDefine.columnTitleFontSize,
                    ),
                  ),
                );
              }
            }),
            enableSorting: enableSort,
            enableRowDrag: false,
            enableEditingMode: editKeys != null && editKeys!.contains(key),
            enableDropToResize: true,
            enableContextMenu: false,
            width: (keysWidths != null && keysWidths!.containsKey(key)) ? keysWidths![key]! : Utils.getColumnSize(key: key, value: mapData[0][key]),
            enableAutoEditing: false,
            hide: showonly == null
                ? (hideKeys != null && hideKeys!.contains(key)) ||
                    hideCode! && key.toString().toLowerCase() != "hourcode" && key.toString().toLowerCase().contains("code")
                : !showonly!.contains(key),
            enableColumnDrag: false,
            field: key,
            type: PlutoColumnType.text()));
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
          print("problem in adding rows");
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
                checkColor: rowCheckColor,
                previousWidgetFN: previousWidgetFN,
              ),
              onRowChecked: onRowChecked,
              rowColorCallback: colorCallback,
              onLoaded: (load) {
                load.stateManager
                    .setColumnSizeConfig(PlutoGridColumnSizeConfig(autoSizeMode: PlutoAutoSizeMode.none, resizeMode: PlutoResizeMode.normal));
                load.stateManager.setKeepFocus(false);
                if (onload != null) {
                  onload!(load);
                }
              },
              columns: segColumn,
              onRowDoubleTap: onRowDoubleTap,
              onSelected: onSelected,
              rows: segRows),
        ),
      );
    } else {
      return Container(
        decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
      );
    }
  }
}
