import 'package:bms_scheduling/app/providers/extensions/string_extensions.dart';
import 'package:flutter/material.dart';
import 'package:bms_scheduling/widgets/PlutoGrid/pluto_grid.dart';

import '../DataGridMenu.dart';
import '../SizeDefine.dart';
import '../Utils.dart';

extension MapExtension on Map {
  List<PlutoColumn> toGridColumns(context, hideCode) {
    List<PlutoColumn> _columns = [];
    for (var key in keys) {
      for (var key in keys) {
        _columns.add(PlutoColumn(
            title: key.toString().pascalCaseToNormal(),
            enableRowChecked: false,
            readOnly: true,
            renderer: ((rendererContext) => GestureDetector(
                  onSecondaryTapDown: (detail) {
                    DataGridMenu().showGridMenu(rendererContext.stateManager, detail, context,data: []);
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
            width: Utils.getColumnSize(
              key: key,
            ),
            enableAutoEditing: false,
            hide: hideCode && key.toString().toLowerCase() != "hourcode" && key.toString().toLowerCase().contains("code"),
            enableColumnDrag: false,
            field: key,
            type: PlutoColumnType.text()));
      }
    }
    return _columns;
  }
}
