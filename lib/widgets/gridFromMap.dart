import 'package:bms_scheduling/app/providers/extensions/string_extensions.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// import 'package:flutter/src/foundation/key.dart';
// import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';
import 'package:pluto_grid/pluto_grid.dart';

import '../app/providers/DataGridMenu.dart';
import '../app/providers/SizeDefine.dart';
import '../app/providers/Utils.dart';
import '../app/styles/theme.dart';

class DataGridFromMap extends StatelessWidget {
  DataGridFromMap({
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
  final Function(DataGridMenuItem,int)? onContextMenuClick;
  final List? hideKeys;
  final Function(PlutoGridOnSelectedEvent)? onSelected;
  final Function(PlutoGridOnRowCheckedEvent)? onRowCheck;
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
              enableRowChecked: (checkRow == true && key == checkRowKey) ? true : false,
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
                      if (onContextMenuClick == null) {
                        DataGridMenu().showGridMenu(
                            rendererContext.stateManager, detail, context,
                            exportFileName: exportFileName);
                      } else {
                        DataGridMenu().showGridCustomMenu(
                            rendererContext.stateManager, detail, context,
                            exportFileName: exportFileName,
                            onPressedClick: onContextMenuClick,plutoContext: rendererContext);
                      }
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
                      if (onContextMenuClick == null) {
                        DataGridMenu().showGridMenu(
                            rendererContext.stateManager, detail, context,
                            exportFileName: exportFileName);
                      } else {
                        DataGridMenu().showGridCustomMenu(
                            rendererContext.stateManager, detail, context,
                            exportFileName: exportFileName,
                            onPressedClick: onContextMenuClick,plutoContext: rendererContext);
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
                    if(onContextMenuClick==null) {
                      DataGridMenu().showGridMenu(rendererContext.stateManager, detail, context, exportFileName: exportFileName);
                    }else {
                      DataGridMenu().showGridCustomMenu(
                          rendererContext.stateManager, detail, context,
                          exportFileName: exportFileName,onPressedClick: onContextMenuClick,plutoContext: rendererContext);
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
            enableRowDrag: false,
            enableEditingMode: editKeys != null && editKeys!.contains(key),
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
              actionOnPress: actionOnPress,
              actionKey: actionIconKey,
              previousWidgetFN: previousWidgetFN,
            ),
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
            onRowChecked: onRowCheck,
            rows: segRows),
      ),
    );
  }
}

class DataGridFromMap3 extends StatelessWidget {
  DataGridFromMap3({
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
    this.actionIcons,
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
    this.checkBoxColumnKey,
    this.showTitleInCheckBox,
    this.checkBoxStrComparison,
    this.uncheckCheckBoxStr,
    this.spaceActionKey,
    this.onActionKeyPress,
    this.enableColumnDoubleTap,
    this.onColumnHeaderDoubleTap,
    this.sort = PlutoColumnSort.none,
    this.previousWidgetFN,
    this.focusNode,
    this.gridStyle,
    this.checkBoxColumnNoEditKey,
  }) : super(key: key);
  final FocusNode? previousWidgetFN;
  PlutoGridStyleConfig? gridStyle;
  final List<String>? enableColumnDoubleTap;
  final Function(int columnInd, int rowIdx)? onActionKeyPress;
  final Function? spaceActionKey;
  final List mapData;
  final List<String>? showTitleInCheckBox;
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
  final List<IconData>? actionIcons;
  final List<String?>? actionIconKey;
  final bool columnAutoResize;
  final List<String>? editKeys;
  final Function(PlutoGridCellPosition position, bool isSpaceCalled)? actionOnPress;
  final bool doPasccal;
  Color Function(PlutoRowColorContext)? colorCallback;
  Function(PlutoGridOnLoadedEvent)? onload;
  final GlobalKey rebuildKey = GlobalKey();
  final List<String>? checkBoxColumnKey;
  final List<String>? checkBoxColumnNoEditKey;
  final String? uncheckCheckBoxStr;
  final String? checkBoxStrComparison;
  final void Function(String columnName)? onColumnHeaderDoubleTap;
  PlutoColumnSort sort;
  FocusNode? focusNode;
  @override
  Widget build(BuildContext context) {
    List<PlutoColumn> segColumn = [];

    focusNode ??= FocusNode();
    List<PlutoRow> segRows = [];

    /// adding NO.
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
          hide: hideCode! && key.toString().toLowerCase() != "hourcode" && key.toString().toLowerCase().contains("code"),
          enableColumnDrag: false,
          field: "no",
          type: PlutoColumnType.text()));
    }

    /// addidng columns
    for (var key in mapData[0].keys) {
      segColumn.add(PlutoColumn(
          titlePadding: const EdgeInsets.only(),
          sort: sort,
          titleSpan: enableColumnDoubleTap != null && enableColumnDoubleTap!.isNotEmpty && enableColumnDoubleTap!.contains(key)
              ? TextSpan(
                  text: doPasccal
                      ? key == "fpcCaption"
                          ? "FPC Caption"
                          : key.toString().pascalCaseToNormal()
                      : key,
                  recognizer: DoubleTapGestureRecognizer()
                    ..onDoubleTap = () {
                      if (onColumnHeaderDoubleTap != null) {
                        onColumnHeaderDoubleTap!(key);
                      }
                    },
                )
              : null,
          title: doPasccal
              ? key == "fpcCaption"
                  ? "FPC Caption"
                  : key.toString().pascalCaseToNormal()
              : key,
          enableRowChecked: false,
          renderer: ((rendererContext) {
            if (checkBoxColumnKey != null && checkBoxColumnKey!.isNotEmpty && checkBoxColumnKey!.contains(key)) {
              return InkWell(
                canRequestFocus: false,
                onTap: !(checkBoxColumnNoEditKey?.contains(key) ?? false)
                    ? () {
                        if (showTitleInCheckBox != null && showTitleInCheckBox!.isNotEmpty) {
                          var temp = mapData[rendererContext.rowIdx][key];
                          temp['key'] = (temp['key'] == checkBoxStrComparison) ? uncheckCheckBoxStr : checkBoxStrComparison;
                          rendererContext.stateManager.changeCellValue(
                            rendererContext.cell,
                            temp,
                            force: true,
                            callOnChangedEvent: true,
                            notify: true,
                          );
                        } else {
                          rendererContext.stateManager.changeCellValue(
                            rendererContext.cell,
                            rendererContext.cell.value == checkBoxStrComparison ? uncheckCheckBoxStr : checkBoxStrComparison,
                            force: true,
                            callOnChangedEvent: true,
                            notify: true,
                          );
                        }
                      }
                    : null,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Icon(
                      ((showTitleInCheckBox != null && showTitleInCheckBox!.isNotEmpty)
                                  ? mapData[rendererContext.rowIdx][key]['key']
                                  : rendererContext.cell.value.toString()) ==
                              checkBoxStrComparison
                          ? Icons.check_box
                          : Icons.check_box_outline_blank,
                      color: ((showTitleInCheckBox != null && showTitleInCheckBox!.isNotEmpty)
                                  ? mapData[rendererContext.rowIdx][key]['key']
                                  : rendererContext.cell.value.toString()) ==
                              checkBoxStrComparison
                          ? Colors.deepPurpleAccent
                          : Colors.grey,
                    ),
                    if (showTitleInCheckBox != null && showTitleInCheckBox!.isNotEmpty && showTitleInCheckBox!.contains(key)) ...{
                      const SizedBox(width: 5),
                      Text(
                        (showTitleInCheckBox != null && showTitleInCheckBox!.isNotEmpty)
                            ? mapData[rendererContext.rowIdx][key]['value']
                            : mapData[rendererContext.rowIdx][key],
                        style: TextStyle(
                          fontSize: SizeDefine.columnTitleFontSize,
                        ),
                      ),
                    }
                  ],
                ),
              );
            } else {
              return GestureDetector(
                onSecondaryTapDown: (detail) {
                  DataGridMenu().showGridMenu(rendererContext.stateManager, detail, context, exportFileName: exportFileName);
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
                  hideCode! && key.toString().toLowerCase() != "hourcode" && key.toString().toLowerCase().contains("code")
              : !showonly!.contains(key),
          enableColumnDrag: false,
          field: key,
          type: PlutoColumnType.text()));
    }

    /// adding rows
    for (var i = 0; i < mapData.length; i++) {
      Map row = mapData[i];

      Map<String, PlutoCell> cells = {};
      if (showSrNo!) {
        cells["no"] = PlutoCell(value: i + 1);
      }
      try {
        for (var element in row.entries) {
          cells[element.key] = PlutoCell(
            value: element.value,
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
            configuration: plutoGridConfiguration2(
              focusNode: focusNode!,
              autoScale: columnAutoResize,
              actionOnPress: actionOnPress,
              actionKey: actionIconKey ?? [],
              previousWidgetFN: previousWidgetFN,
            ).copyWith(style: gridStyle),
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
            // onRowChecked: onRowCheck,
            rows: segRows),
      ),
    );
  }
}
