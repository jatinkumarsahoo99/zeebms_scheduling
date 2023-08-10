import 'package:bms_scheduling/app/providers/extensions/datagrid.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:bms_scheduling/widgets/PlutoGrid/pluto_grid.dart';

import '../providers/SizeDefine.dart';

ThemeData primaryThemeData = ThemeData(
  focusColor: Colors.deepPurple[200],

  elevatedButtonTheme: ElevatedButtonThemeData(style: ButtonStyle(overlayColor: MaterialStatePropertyAll(Colors.deepPurple[900]))),
  buttonTheme: ButtonThemeData(focusColor: Colors.deepPurple[900]),
  // scaffoldBackgroundColor: Colors.grey[300],
  scaffoldBackgroundColor: Colors.white,

  primarySwatch: Colors.deepPurple,
  appBarTheme: const AppBarTheme(
    toolbarHeight: 48,
    elevation: 0,
    centerTitle: true,
    backgroundColor: Colors.white,
  ),

  primaryIconTheme: const IconThemeData(color: Colors.deepPurple),
  inputDecorationTheme: InputDecorationTheme(
    labelStyle: const TextStyle(fontSize: 12),
    contentPadding: const EdgeInsets.only(left: 30),
    focusColor: Colors.deepPurple[200],
    enabledBorder: const OutlineInputBorder(
      borderSide: BorderSide(color: Colors.deepPurpleAccent),
    ),
    floatingLabelBehavior: FloatingLabelBehavior.auto,
    errorBorder: const OutlineInputBorder(
      borderSide: BorderSide(color: Colors.red),
    ),
    focusedBorder: const OutlineInputBorder(
      borderSide: BorderSide(color: Colors.deepPurpleAccent),
    ),
  ),
);

PlutoGridConfiguration plutoGridConfiguration({
  Function? actionOnPress,
  String? actionKey,
  double rowHeight = 35,
  bool autoScale = true,
  Color? checkColor = const Color(0xFFD1C4E9),
  required FocusNode focusNode,
  FocusNode? previousWidgetFN,
}) =>
    PlutoGridConfiguration.dark(
        shortcut: PlutoGridShortcut(
          actions: {
            // This is a Map with basic shortcut keys and actions set.
            ...PlutoGridShortcut.defaultActions,

            LogicalKeySet(LogicalKeyboardKey.tab): CustomTabKeyAction(focusNode, previousWidgetFN),
            LogicalKeySet(LogicalKeyboardKey.shift, LogicalKeyboardKey.tab): CustomTabKeyAction(focusNode, previousWidgetFN),
            LogicalKeySet(LogicalKeyboardKey.space): CustomSpaceKeyAction(),
            // You can override the enter key behavior as below.
            LogicalKeySet(LogicalKeyboardKey.enter): CustomEnterKeyAction(actionOnPress: actionOnPress, actionKey: actionKey),
          },
        ),
        style: PlutoGridStyleConfig(
            rowHeight: rowHeight,
            columnHeight: 30,
            defaultCellPadding: const EdgeInsets.all(2),
            enableCellBorderHorizontal: true,
            gridBorderColor: Colors.deepPurpleAccent,
            activatedBorderColor: Colors.deepPurple,
            inactivatedBorderColor: Colors.deepPurple[100]!,
            cellColorInEditState: Colors.deepPurple[100]!,
            activatedColor: Colors.deepPurple[100]!,
            checkedColor: checkColor!,
            gridBorderRadius: BorderRadius.circular(0),
            enableColumnBorderHorizontal: false,
            enableCellBorderVertical: true,
            enableGridBorderShadow: false,
            cellTextStyle: TextStyle(
              fontSize: SizeDefine.columnTitleFontSize,
            ),
            columnTextStyle: TextStyle(fontSize: SizeDefine.columnTitleFontSize, fontWeight: FontWeight.bold)),
        enterKeyAction: PlutoGridEnterKeyAction.none,
        tabKeyAction: PlutoGridTabKeyAction.moveToNextOnEdge,
        scrollbar: const PlutoGridScrollbarConfig(draggableScrollbar: true, isAlwaysShown: true, hoverWidth: 15));

PlutoGridConfiguration plutoGridConfigurationTransmisionLog({
  Function? actionOnPress,
  String? actionKey,
  bool autoScale = true,
  Color? checkColor = const Color(0xFFD1C4E9),
  required FocusNode focusNode,
  FocusNode? previousWidgetFN,
}) =>
    PlutoGridConfiguration.dark(
        shortcut: PlutoGridShortcut(
          actions: {
            // This is a Map with basic shortcut keys and actions set.
            ...PlutoGridShortcut.defaultActions,

            LogicalKeySet(LogicalKeyboardKey.tab): CustomTabKeyAction(focusNode, previousWidgetFN),
            LogicalKeySet(LogicalKeyboardKey.shift, LogicalKeyboardKey.tab): CustomTabKeyAction(focusNode, previousWidgetFN),
            LogicalKeySet(LogicalKeyboardKey.space): CustomSpaceKeyAction(),
            // You can override the enter key behavior as below.
            LogicalKeySet(LogicalKeyboardKey.enter): CustomEnterKeyAction(actionOnPress: actionOnPress, actionKey: actionKey),
          },
        ),
        columnSize: PlutoGridColumnSizeConfig(
          resizeMode: PlutoResizeMode.normal,
          autoSizeMode: autoScale ? PlutoAutoSizeMode.scale : PlutoAutoSizeMode.none,
        ),
        style: PlutoGridStyleConfig(
            rowHeight: 20,
            columnHeight: 25,
            defaultCellPadding: const EdgeInsets.all(2),
            enableCellBorderHorizontal: true,
            gridBorderColor: Colors.deepPurpleAccent,
            activatedBorderColor: Colors.deepPurple,
            inactivatedBorderColor: Colors.deepPurple[100]!,
            cellColorInEditState: Colors.deepPurple[100]!,
            activatedColor: Colors.deepPurple[100]!,
            checkedColor: checkColor!,
            gridBorderRadius: BorderRadius.circular(0),
            enableColumnBorderHorizontal: false,
            enableCellBorderVertical: true,
            enableGridBorderShadow: false,
            cellTextStyle: TextStyle(
              fontSize: SizeDefine.columnTitleFontSize,
            ),
            columnTextStyle: TextStyle(fontSize: SizeDefine.columnTitleFontSize, fontWeight: FontWeight.bold)),
        enterKeyAction: PlutoGridEnterKeyAction.none,
        tabKeyAction: PlutoGridTabKeyAction.moveToNextOnEdge,
        scrollbar: const PlutoGridScrollbarConfig(draggableScrollbar: true, isAlwaysShown: true, hoverWidth: 15));

PlutoGridConfiguration plutoGridConfiguration2({
  Function(PlutoGridCellPosition index, bool isSpace)? actionOnPress,
  required List<String?> actionKey,
  bool autoScale = true,
  required FocusNode focusNode,
  FocusNode? previousWidgetFN,
}) =>
    PlutoGridConfiguration(
        shortcut: PlutoGridShortcut(
          actions: {
            // This is a Map with basic shortcut keys and actions set.
            ...PlutoGridShortcut.defaultActions,
            LogicalKeySet(LogicalKeyboardKey.shift, LogicalKeyboardKey.tab): CustomTabKeyAction(focusNode, previousWidgetFN),
            LogicalKeySet(LogicalKeyboardKey.tab): CustomTabKeyAction(focusNode, previousWidgetFN),

            LogicalKeySet(LogicalKeyboardKey.space): CustomKeyAction2(
              actionOnPress: actionOnPress,
              actionKey: actionKey,
              isSpace: true,
            ),
            // You can override the enter key behavior as below.
            LogicalKeySet(LogicalKeyboardKey.enter): CustomKeyAction2(
              actionOnPress: actionOnPress,
              actionKey: actionKey,
              isSpace: false,
            ),
          },
        ),
        columnSize: PlutoGridColumnSizeConfig(
          resizeMode: PlutoResizeMode.normal,
          autoSizeMode: autoScale ? PlutoAutoSizeMode.scale : PlutoAutoSizeMode.none,
        ),
        style: PlutoGridStyleConfig(
            rowHeight: 35,
            columnHeight: 30,
            defaultCellPadding: const EdgeInsets.all(2),
            enableCellBorderHorizontal: true,
            gridBorderColor: Colors.deepPurpleAccent,
            activatedBorderColor: Colors.deepPurple,
            inactivatedBorderColor: Colors.deepPurple[100]!,
            cellColorInEditState: Colors.deepPurple[100]!,
            activatedColor: Colors.deepPurple[100]!,
            gridBorderRadius: BorderRadius.circular(0),
            enableColumnBorderHorizontal: false,
            enableCellBorderVertical: true,
            enableGridBorderShadow: false,
            cellTextStyle: TextStyle(
              fontSize: SizeDefine.columnTitleFontSize,
            ),
            columnTextStyle: TextStyle(fontSize: SizeDefine.columnTitleFontSize, fontWeight: FontWeight.bold)),
        enterKeyAction: PlutoGridEnterKeyAction.none,
        tabKeyAction: PlutoGridTabKeyAction.moveToNextOnEdge,
        scrollbar: const PlutoGridScrollbarConfig(draggableScrollbar: true, isAlwaysShown: true, hoverWidth: 15));

// Create a new class that inherits from PlutoGridShortcutAction
// If the execute method is implemented,
// the implemented method is executed when the enter key is pressed.
class CustomEnterKeyAction extends PlutoGridShortcutAction {
  CustomEnterKeyAction({
    this.actionOnPress,
    this.actionKey,
  });
  final Function? actionOnPress;
  final String? actionKey;
  @override
  void execute({
    required PlutoKeyManagerEvent keyEvent,
    required PlutoGridStateManager stateManager,
  }) {
    if (stateManager.currentCell != null && stateManager.currentCell!.column.field == actionKey) {
      actionOnPress!(stateManager.currentCell!.row.sortIdx);
    }
  }
}

class CustomKeyAction2 extends PlutoGridShortcutAction {
  CustomKeyAction2({
    this.actionOnPress,
    this.actionKey,
    required this.isSpace,
  });
  final Function(PlutoGridCellPosition index, bool isSpace)? actionOnPress;
  final List<String?>? actionKey;
  final bool isSpace;
  @override
  void execute({
    required PlutoKeyManagerEvent keyEvent,
    required PlutoGridStateManager stateManager,
  }) {
    if (stateManager.currentCell != null &&
        actionKey != null &&
        actionOnPress != null &&
        actionKey!.contains(stateManager.currentCell!.column.field)) {
      actionOnPress!(stateManager.currentCellPosition!, isSpace);
    }
  }
}

class CustomSpaceKeyAction extends PlutoGridShortcutAction {
  @override
  void execute({
    required PlutoKeyManagerEvent keyEvent,
    required PlutoGridStateManager stateManager,
  }) {
    if (stateManager.currentCell!.column.enableRowChecked == true) {
      stateManager.setRowChecked(stateManager.currentCell!.row, !stateManager.currentCell!.row.checked!, notify: true);
    }
  }
}

class CustomTabKeyAction extends PlutoGridShortcutAction {
  final FocusNode focusNode;
  FocusNode? previousWidgetFN;
  CustomTabKeyAction(this.focusNode, this.previousWidgetFN);
  @override
  void execute({
    required PlutoKeyManagerEvent keyEvent,
    required PlutoGridStateManager stateManager,
  }) {
    final saveIsEditing = stateManager.isEditing;
    if (stateManager.currentCell == null) {
      stateManager.setCurrentCell(stateManager.firstCell, 0);
      return;
    }
    if (keyEvent.isShiftPressed) {
      if (stateManager.currentRowIdx == 0 && stateManager.currentCellPosition?.columnIdx == 0) {
        try {
          // stateManager.setKeepFocus(false);
          // print("Go previous focus Widget");
          stateManager.gridFocusNode.nearestScope!.requestFocus();
          // FocusScope.of(previousWidgetFN!.context!).previousFocus();
        } catch (e) {
          print(e.toString());
        }
        // if (previousWidgetFN != null) {}
      } else {
        // print("Not First Cell");
        // stateManager.setKeepFocus(true);
        stateManager.moveCellPrevious();
      }
    } else {
      if (stateManager.currentCell!.row == stateManager.refRows.last && stateManager.currentCell!.column == stateManager.refColumns.last) {
        FocusScope.of(focusNode.context!).previousFocus();
        focusNode.nextFocus();
      } else {
        // print("Not  Last Cell");
        stateManager.moveCellNext();
      }
    }

    stateManager.setEditing(stateManager.autoEditing || saveIsEditing);
  }
}
