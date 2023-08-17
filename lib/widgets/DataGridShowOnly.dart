import 'package:bms_scheduling/app/providers/DataGridMenu.dart';
import 'package:bms_scheduling/app/providers/SizeDefine.dart';
import 'package:bms_scheduling/app/providers/Utils.dart';
import 'package:bms_scheduling/app/providers/extensions/string_extensions.dart';
import 'package:bms_scheduling/app/styles/theme.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:bms_scheduling/widgets/PlutoGrid/pluto_grid.dart';

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
    this.hideCheckKeysValue = false,
    this.hideKeys,
    this.mode,
    this.editKeys,
    this.onEdit,
    this.actionIcon,
    this.keyMapping,
    this.actionIconKey,
    this.columnAutoResize = true,
    this.actionOnPress,
    this.rowCheckColor = const Color(0xFFD1C4E9),
    this.onSelected,
    this.keysWidths,
    this.checkRowKey = "selected",
    this.onRowDoubleTap,
    this.formatDate = true,
    this.dateFormatKeys,
    this.dateFromat = "dd-MM-yyyy",
    this.onFocusChange,
    this.checkRow,
    this.extraList,
    this.doPasccal = true,
    this.exportFileName,
    this.focusNode,
    this.onRowChecked,
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
  final List<String>? dateFormatKeys;
  final Function(PlutoGridOnRowDoubleTapEvent)? onRowDoubleTap;
  final Function(PlutoGridOnChangedEvent)? onEdit;
  final Function(bool)? onFocusChange;
  final List? hideKeys;
  final Function(PlutoGridOnRowCheckedEvent)? onRowChecked;
  final Function(PlutoGridOnSelectedEvent)? onSelected;
  final double? widthRatio;
  final IconData? actionIcon;
  final Map<String, double>? keysWidths;
  final Map<String, IconData>? actionIconKey;
  final bool columnAutoResize;
  final List<String>? editKeys;
  final Function(String, int)? actionOnPress;
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
            minWidth: 0,
            width: 25,
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
                title: doPasccal
                    ? keyMapping != null
                        ? keyMapping!.containsKey(key)
                            ? keyMapping![key]
                            : key == "fpcCaption"
                                ? "FPC Caption"
                                : key.toString().pascalCaseToNormal()
                        : key.toString().pascalCaseToNormal()
                    : key.toString(),
                enableRowChecked: (checkRow == true && key == checkRowKey) ? true : false,
                renderer: ((rendererContext) {
                  if (actionIconKey?.containsKey(key) ?? false) {
                    return GestureDetector(
                      child: Icon(
                        actionIconKey![key],
                        size: 19,
                      ),
                      onTap: () {
                        actionOnPress!(key, rendererContext.rowIdx);
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
                        rendererContext.stateManager.setCurrentCell(rendererContext.cell, rendererContext.rowIdx);
                        DataGridMenu()
                            .showGridMenu(rendererContext.stateManager, detail, context, exportFileName: exportFileName, extraList: extraList);
                      },
                      child: Text(
                        (rendererContext.cell.value ?? "").toString(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
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
                minWidth: 0,
                width: (keysWidths != null && keysWidths!.containsKey(key))
                    ? keysWidths![key]!
                    : Utils.getColumnSize(key: key, value: mapData[0][key].toString(), widthRatio: widthRatio),
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
              titlePadding: EdgeInsets.only(),
              title: doPasccal
                  ? key == "fpcCaption"
                      ? "FPC Caption"
                      : key.toString().pascalCaseToNormal()
                  : key,
              enableRowChecked: (checkRow == true && key == checkRowKey) ? true : false,
              renderer: ((rendererContext) {
                if (actionIconKey?.containsKey(key) ?? false) {
                  if (actionIconKey?.containsKey(key) ?? false) {
                    return GestureDetector(
                      child: Icon(
                        actionIconKey![key],
                        size: 19,
                        color: Theme.of(context).primaryColor,
                      ),
                      onTap: () {
                        actionOnPress!(key, rendererContext.rowIdx);
                      },
                    );
                  } else {
                    return GestureDetector(
                      onSecondaryTapDown: (detail) {
                        rendererContext.stateManager.setCurrentCell(rendererContext.cell, rendererContext.rowIdx);

                        DataGridMenu()
                            .showGridMenu(rendererContext.stateManager, detail, context, exportFileName: exportFileName, extraList: extraList);
                      },
                      child: Text(
                        (checkRow == true && key == checkRowKey && hideCheckKeysValue) ? "" : rendererContext.cell.value.toString(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: SizeDefine.columnTitleFontSize,
                        ),
                      ),
                    );
                  }
                } else {
                  return GestureDetector(
                    onSecondaryTapDown: (detail) {
                      rendererContext.stateManager.setCurrentCell(rendererContext.cell, rendererContext.rowIdx);

                      DataGridMenu()
                          .showGridMenu(rendererContext.stateManager, detail, context, exportFileName: exportFileName, extraList: extraList);
                    },
                    child: Text(
                      (checkRow == true && key == checkRowKey && hideCheckKeysValue) ? "" : rendererContext.cell.value.toString(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
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
              minWidth: 0,
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
                  : element.key.toString().toLowerCase().contains("date") && (dateFormatKeys ?? []).contains(element.key) && formatDate!
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
                rowHeight: 25,
                autoScale: columnAutoResize,
                actionOnPress: actionOnPress,
                checkColor: rowCheckColor,
                actionKey: actionIconKey?.keys.first,
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
        decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade100)),
      );
    }
  }
}
