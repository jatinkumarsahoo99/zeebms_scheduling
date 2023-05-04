import 'package:bms_scheduling/app/providers/DataGridMenu.dart';
import 'package:bms_scheduling/app/providers/SizeDefine.dart';
import 'package:bms_scheduling/app/providers/Utils.dart';
import 'package:bms_scheduling/app/providers/extensions/string_extensions.dart';
import 'package:bms_scheduling/app/styles/theme.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pluto_grid/pluto_grid.dart';

class DataGridShowOnlyKeys extends StatelessWidget {
  DataGridShowOnlyKeys({
    Key? key,
    required this.mapData,
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
    this.columnAutoResize = true,
    this.actionOnPress,
    this.onSelected,
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
  final Function(PlutoGridOnSelectedEvent)? onSelected;
  final double? widthRatio;
  final IconData? actionIcon;
  final String? actionIconKey;
  final bool columnAutoResize;
  final List<String>? editKeys;
  final Function? actionOnPress;
  final bool doPasccal;
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
            width: 25,
            enableAutoEditing: false,
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
                    // if () {
                    // } else {
                    //   return GestureDetector(
                    //     onSecondaryTapDown: (detail) {
                    //       DataGridMenu().showGridMenu(
                    //           rendererContext.stateManager, detail, context);
                    //     },
                    //     child: Text(
                    //       rendererContext.cell.value.toString(),
                    //       style: TextStyle(
                    //         fontSize: SizeDefine.columnTitleFontSize,
                    //       ),
                    //     ),
                    //   );
                    // }
                  } else {
                    return GestureDetector(
                      onSecondaryTapDown: (detail) {
                        DataGridMenu().showGridMenu(
                            rendererContext.stateManager, detail, context,
                            exportFileName: exportFileName);
                      },
                      child: Text(
                        (rendererContext.cell.value ?? "").toString(),
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
                width: Utils.getColumnSize(
                  key: key,
                  value: mapData[0][key].toString(),
                ),
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
                  ? key == "fpcCaption"
                      ? "FPC Caption"
                      : key.toString().pascalCaseToNormal()
                  : key,
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
                      onSecondaryTapDown: (detail) {
                        DataGridMenu().showGridMenu(
                            rendererContext.stateManager, detail, context,
                            exportFileName: exportFileName);
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
                      DataGridMenu().showGridMenu(
                          rendererContext.stateManager, detail, context,
                          exportFileName: exportFileName);
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
              enableRowDrag: false,
              enableEditingMode: editKeys != null && editKeys!.contains(key),
              enableDropToResize: true,
              enableContextMenu: false,
              width: Utils.getColumnSize(key: key, value: mapData[0][key]),
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
                actionOnPress: actionOnPress,
                actionKey: actionIconKey,
                previousWidgetFN: previousWidgetFN,
              ),
              rowColorCallback: colorCallback,
              onLoaded: (load) {
                load.stateManager.setColumnSizeConfig(PlutoGridColumnSizeConfig(
                    autoSizeMode: PlutoAutoSizeMode.none,
                    resizeMode: PlutoResizeMode.normal));
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
