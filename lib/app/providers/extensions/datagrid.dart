import 'package:intl/intl.dart';
import 'package:pluto_grid/pluto_grid.dart';

import '../../../app/data/data_grid_props.dart';

extension GridManagerExtension on PlutoGridStateManager {
  toJson() {
    List data = [];
    for (var row in rows) {
      var rowData = {};

      for (MapEntry<String, PlutoCell> rowValue in row.cells.entries) {
        rowData[rowValue.key] = rowValue.value.value;
      }
      data.add(rowData);
    }
    return data;
  }

  updateRowData(List<Map> listData, {DataGridProps? dataGridProps}) {
    dataGridProps ??= DataGridProps();
    List<PlutoRow> initRows = [];
    //extension give you stateManager without refernce
    // stateManager.removeAllRows() is original function
    var _columns = columns;
    removeColumns(columns);

    removeAllRows();
    insertColumns(0, _columns);
    print("Removed Old Rows");
    try {
      for (var i = 0; i < listData.length; i++) {
        Map row = listData[i];
        Map<String, PlutoCell> cells = {};

        cells["no"] = PlutoCell(
          value: i + 1,
        );

        for (var element in row.entries) {
          cells[element.key] = PlutoCell(
            value: element.key == "selected" || element.value == null
                ? ""
                : element.key.toString().toLowerCase().contains("date") &&
                        dataGridProps.formatDate!
                    ? DateFormat(dataGridProps.dateFormat).format(
                        DateTime.parse(
                            element.value.toString().replaceAll("T", " ")))
                    : element.value.toString(),
          );
        }
        initRows.add(PlutoRow(
          cells: cells,
        ));
      }

      appendRows(initRows);
      print("added new rows");
    } catch (e) {
      print("problem in adding rows");
    }
  }

  moveCellPrevious() {
    if (willMoveToPreviousRow(
      currentCellPosition,
    )) {
      moveCellToPreviousRow();
    } else {
      moveCurrentCell(PlutoMoveDirection.left, force: true);
    }
  }

  moveCellNext() {
    if (willMoveToNextRow(
      currentCellPosition,
    )) {
      moveCellToNextRow();
    } else {
      moveCurrentCell(PlutoMoveDirection.right, force: true);
    }
  }

  bool willMoveToPreviousRow(
    PlutoGridCellPosition? position,
  ) {
    if (!configuration.tabKeyAction.isMoveToNextOnEdge ||
        position == null ||
        !position.hasPosition) {
      return false;
    }

    return position.rowIdx! > 0 && position.columnIdx == 0;
  }

  bool willMoveToNextRow(
    PlutoGridCellPosition? position,
  ) {
    if (!configuration.tabKeyAction.isMoveToNextOnEdge ||
        position == null ||
        !position.hasPosition) {
      return false;
    }

    return position.rowIdx! < refRows.length - 1 &&
        position.columnIdx == refColumns.length - 1;
  }

  moveCellToPreviousRow() {
    moveCurrentCell(
      PlutoMoveDirection.up,
      force: true,
      notify: false,
    );

    moveCurrentCellToEdgeOfColumns(
      PlutoMoveDirection.right,
      force: true,
    );
  }

  moveCellToNextRow() {
    moveCurrentCell(
      PlutoMoveDirection.down,
      force: true,
      notify: false,
    );

    moveCurrentCellToEdgeOfColumns(
      PlutoMoveDirection.left,
      force: true,
    );
  }
}
