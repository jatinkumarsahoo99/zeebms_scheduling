import 'package:bms_scheduling/app/providers/extensions/datagrid.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:bms_scheduling/widgets/PlutoGrid/pluto_grid.dart';

import '../providers/SizeDefine.dart';

ThemeData primaryThemeData = ThemeData(
  focusColor: Colors.deepPurple[200],

  elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
          overlayColor: MaterialStatePropertyAll(Colors.deepPurple[900]))),
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
  Function(int, bool)? spaceOnPress,
  String? actionKey,
  double rowHeight = 35,
  bool autoScale = false,
  Color? checkColor = const Color(0xFFD1C4E9),
  required FocusNode focusNode,
  FocusNode? previousWidgetFN,
}) =>
    PlutoGridConfiguration.dark(
        shortcut: PlutoGridShortcut(
          actions: {
            // This is a Map with basic shortcut keys and actions set.
            ...PlutoGridShortcut.defaultActions,

            LogicalKeySet(LogicalKeyboardKey.tab):
                CustomTabKeyAction(focusNode, previousWidgetFN),
            LogicalKeySet(LogicalKeyboardKey.shift, LogicalKeyboardKey.tab):
                CustomTabKeyAction(focusNode, previousWidgetFN),
            LogicalKeySet(LogicalKeyboardKey.space):
                CustomSpaceKeyAction1(spaceOnPress: spaceOnPress),
            // You can override the enter key behavior as below.
            LogicalKeySet(LogicalKeyboardKey.enter): CustomEnterKeyAction(
                actionOnPress: actionOnPress, actionKey: actionKey),
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
            columnTextStyle: TextStyle(
                fontSize: SizeDefine.columnTitleFontSize,
                fontWeight: FontWeight.bold)),
        enterKeyAction: PlutoGridEnterKeyAction.none,
        columnSize: PlutoGridColumnSizeConfig(
          resizeMode: PlutoResizeMode.normal,
          autoSizeMode:
              autoScale ? PlutoAutoSizeMode.scale : PlutoAutoSizeMode.none,
        ),
        tabKeyAction: PlutoGridTabKeyAction.moveToNextOnEdge,
        scrollbar: const PlutoGridScrollbarConfig(
          draggableScrollbar: true,
          isAlwaysShown: true,
          hoverWidth: 15,
          scrollbarThickness: 15,
          scrollbarThicknessWhileDragging: 15,
          scrollbarRadius: Radius.circular(8),
          scrollbarRadiusWhileDragging: Radius.circular(8),
        ));

PlutoGridConfiguration plutoGridConfigurationTransmisionLog({
  Function? actionOnPress,
  String? actionKey,
  bool autoScale = false,
  Color? checkColor = const Color(0xFFD1C4E9),
  required FocusNode focusNode,
  FocusNode? previousWidgetFN,
}) =>
    PlutoGridConfiguration.dark(
      shortcut: PlutoGridShortcut(
        actions: {
          // This is a Map with basic shortcut keys and actions set.
          // ...PlutoGridShortcut.defaultActions,

          LogicalKeySet(LogicalKeyboardKey.arrowLeft):
          const PlutoGridActionMoveCellFocus(PlutoMoveDirection.left),
          LogicalKeySet(LogicalKeyboardKey.arrowRight):
          const PlutoGridActionMoveCellFocus(PlutoMoveDirection.right),
          LogicalKeySet(LogicalKeyboardKey.arrowUp):
          const PlutoGridActionMoveCellFocus(PlutoMoveDirection.up),
          LogicalKeySet(LogicalKeyboardKey.arrowDown):
          const PlutoGridActionMoveCellFocus(PlutoMoveDirection.down),
          // Move selected cell focus
          LogicalKeySet(LogicalKeyboardKey.shift, LogicalKeyboardKey.arrowLeft):
          const PlutoGridActionMoveSelectedCellFocus(PlutoMoveDirection.left),
          LogicalKeySet(LogicalKeyboardKey.shift, LogicalKeyboardKey.arrowRight):
          const PlutoGridActionMoveSelectedCellFocus(PlutoMoveDirection.right),
          LogicalKeySet(LogicalKeyboardKey.shift, LogicalKeyboardKey.arrowUp):
          const PlutoGridActionMoveSelectedCellFocus(PlutoMoveDirection.up),
          LogicalKeySet(LogicalKeyboardKey.shift, LogicalKeyboardKey.arrowDown):
          const PlutoGridActionMoveSelectedCellFocus(PlutoMoveDirection.down),
          // Move cell focus by page vertically
          LogicalKeySet(LogicalKeyboardKey.pageUp):
          const PlutoGridActionMoveCellFocusByPage(PlutoMoveDirection.up),
          LogicalKeySet(LogicalKeyboardKey.pageDown):
          const PlutoGridActionMoveCellFocusByPage(PlutoMoveDirection.down),
          // Move cell focus by page vertically
          LogicalKeySet(LogicalKeyboardKey.shift, LogicalKeyboardKey.pageUp):
          const PlutoGridActionMoveSelectedCellFocusByPage(PlutoMoveDirection.up),
          LogicalKeySet(LogicalKeyboardKey.shift, LogicalKeyboardKey.pageDown):
          const PlutoGridActionMoveSelectedCellFocusByPage(
              PlutoMoveDirection.down),
          // Move page when pagination is enabled
          LogicalKeySet(LogicalKeyboardKey.alt, LogicalKeyboardKey.pageUp):
          const PlutoGridActionMoveCellFocusByPage(PlutoMoveDirection.left),
          LogicalKeySet(LogicalKeyboardKey.alt, LogicalKeyboardKey.pageDown):
          const PlutoGridActionMoveCellFocusByPage(PlutoMoveDirection.right),
          // Default tab key action
          LogicalKeySet(LogicalKeyboardKey.tab): const PlutoGridActionDefaultTab(),
          LogicalKeySet(LogicalKeyboardKey.shift, LogicalKeyboardKey.tab):
          const PlutoGridActionDefaultTab(),
          // Default enter key action
          LogicalKeySet(LogicalKeyboardKey.enter):
          const PlutoGridActionDefaultEnterKey(),
          LogicalKeySet(LogicalKeyboardKey.numpadEnter):
          const PlutoGridActionDefaultEnterKey(),
          LogicalKeySet(LogicalKeyboardKey.shift, LogicalKeyboardKey.enter):
          const PlutoGridActionDefaultEnterKey(),
          // Default escape key action
          LogicalKeySet(LogicalKeyboardKey.escape):
          const PlutoGridActionDefaultEscapeKey(),
          // Move cell focus to edge
          LogicalKeySet(LogicalKeyboardKey.home):
          const PlutoGridActionMoveCellFocusToEdge(PlutoMoveDirection.left),
          LogicalKeySet(LogicalKeyboardKey.end):
          const PlutoGridActionMoveCellFocusToEdge(PlutoMoveDirection.right),
          LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.home):
          const PlutoGridActionMoveCellFocusToEdge(PlutoMoveDirection.up),
          LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.end):
          const PlutoGridActionMoveCellFocusToEdge(PlutoMoveDirection.down),
          // Move selected cell focus to edge
          LogicalKeySet(LogicalKeyboardKey.shift, LogicalKeyboardKey.home):
          const PlutoGridActionMoveSelectedCellFocusToEdge(
              PlutoMoveDirection.left),
          LogicalKeySet(LogicalKeyboardKey.shift, LogicalKeyboardKey.end):
          const PlutoGridActionMoveSelectedCellFocusToEdge(
              PlutoMoveDirection.right),
          LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.shift,
              LogicalKeyboardKey.home):
          const PlutoGridActionMoveSelectedCellFocusToEdge(PlutoMoveDirection.up),
          LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.shift,
              LogicalKeyboardKey.end):
          const PlutoGridActionMoveSelectedCellFocusToEdge(
              PlutoMoveDirection.down),
          // Set editing
          LogicalKeySet(LogicalKeyboardKey.f2): const PlutoGridActionSetEditing(),
          // Focus to column filter
          // LogicalKeySet(LogicalKeyboardKey.f3): const PlutoGridActionFocusToColumnFilter(),
          // Toggle column sort
          // LogicalKeySet(LogicalKeyboardKey.f4):const PlutoGridActionToggleColumnSort(),
          // Copy the values of cells
          // LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyC):
          // const PlutoGridActionCopyValues(),
          // Paste values from clipboard
          LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyV):
          const PlutoGridActionPasteValues(),
          // Select all cells or rows
          LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyA):
          const PlutoGridActionSelectAll(),

          LogicalKeySet(LogicalKeyboardKey.tab):
              CustomTabKeyAction(focusNode, previousWidgetFN),
          LogicalKeySet(LogicalKeyboardKey.shift, LogicalKeyboardKey.tab):
              CustomTabKeyAction(focusNode, previousWidgetFN),
          LogicalKeySet(LogicalKeyboardKey.space): CustomSpaceKeyAction(),
          // You can override the enter key behavior as below.
          LogicalKeySet(LogicalKeyboardKey.enter): CustomEnterKeyAction(
              actionOnPress: actionOnPress, actionKey: actionKey),
        },
      ),
      columnSize: PlutoGridColumnSizeConfig(
        resizeMode: PlutoResizeMode.normal,
        autoSizeMode:
            autoScale ? PlutoAutoSizeMode.scale : PlutoAutoSizeMode.none,
      ),
      style: PlutoGridStyleConfig(
        rowHeight: 20,
        columnHeight: 25,
        defaultCellPadding: const EdgeInsets.all(0),
        enableCellBorderHorizontal: true,
        gridBorderColor: Colors.black,
        activatedBorderColor: Color(0xFF2979FF),
        inactivatedBorderColor: Color(0xFF2979FF)!,
        cellColorInEditState: Color(0xFF2979FF)!,
        activatedColor: Color(0xFF2979FF)!,
        checkedColor: checkColor!,
        // borderColor: Colors.black,

        gridBorderRadius: BorderRadius.circular(0),
        enableColumnBorderHorizontal: false,
        enableCellBorderVertical: true,
        enableGridBorderShadow: false,
        cellTextStyle: TextStyle(
          fontSize: SizeDefine.columnTitleFontSize,
        ),
        columnTextStyle: TextStyle(
            fontSize: SizeDefine.columnTitleFontSize,
            fontWeight: FontWeight.bold),
      ),
      enterKeyAction: PlutoGridEnterKeyAction.none,
      tabKeyAction: PlutoGridTabKeyAction.moveToNextOnEdge,
      scrollbar: PlutoGridScrollbarConfig(
        draggableScrollbar: true,
        isAlwaysShown: true,
        hoverWidth: 15,
        scrollbarThickness: 15,
        scrollbarThicknessWhileDragging: 15,
        scrollbarRadius: Radius.circular(8),
        scrollbarRadiusWhileDragging: Radius.circular(8),
      ),
    );

PlutoGridConfiguration plutoGridConfiguration2({
  Function(PlutoGridCellPosition index, bool isSpace)? actionOnPress,
  required List<String?> actionKey,
  bool autoScale = false,
  required FocusNode focusNode,
  FocusNode? previousWidgetFN,
  double rowHeight = 25,
  Function()? actionOnPressKeyboard,
  LogicalKeyboardKey? logicalKeyboardKey,
}) =>
    PlutoGridConfiguration(
        shortcut: PlutoGridShortcut(
          actions: {
            // This is a Map with basic shortcut keys and actions set.
            ...PlutoGridShortcut.defaultActions,
            LogicalKeySet(LogicalKeyboardKey.shift, LogicalKeyboardKey.tab):
                CustomTabKeyAction(focusNode, previousWidgetFN),
            LogicalKeySet(LogicalKeyboardKey.tab):
                CustomTabKeyAction(focusNode, previousWidgetFN),
            if (logicalKeyboardKey != null &&
                actionOnPressKeyboard != null) ...{
              LogicalKeySet(logicalKeyboardKey): CustomKeyActionOnKeyboard(
                  actionOnPressKeyboard, logicalKeyboardKey),
            },
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
          autoSizeMode:
              autoScale ? PlutoAutoSizeMode.scale : PlutoAutoSizeMode.none,
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
            gridBorderRadius: BorderRadius.circular(0),
            enableColumnBorderHorizontal: false,
            enableCellBorderVertical: true,
            enableGridBorderShadow: false,
            cellTextStyle: TextStyle(
              fontSize: SizeDefine.columnTitleFontSize,
            ),
            columnTextStyle: TextStyle(
                fontSize: SizeDefine.columnTitleFontSize,
                fontWeight: FontWeight.bold)),
        enterKeyAction: PlutoGridEnterKeyAction.none,
        tabKeyAction: PlutoGridTabKeyAction.moveToNextOnEdge,
        scrollbar: const PlutoGridScrollbarConfig(
          draggableScrollbar: true,
          isAlwaysShown: true,
          hoverWidth: 15,
          scrollbarThickness: 15,
          scrollbarThicknessWhileDragging: 15,
          scrollbarRadius: Radius.circular(8),
          scrollbarRadiusWhileDragging: Radius.circular(8),));

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
    if (stateManager.currentCell != null &&
        stateManager.currentCell!.column.field == actionKey) {
      actionOnPress!(stateManager.currentCell!.row.sortIdx);
    }
  }
}

class CustomKeyActionOnKeyboard extends PlutoGridShortcutAction {
  Function() actionOnPressKeyboard;
  LogicalKeyboardKey logicalKeyboardKey;

  CustomKeyActionOnKeyboard(
      this.actionOnPressKeyboard, this.logicalKeyboardKey);

  @override
  void execute(
      {required PlutoKeyManagerEvent keyEvent,
      required PlutoGridStateManager stateManager}) {
    if (keyEvent.event.isKeyPressed(logicalKeyboardKey)) {
      actionOnPressKeyboard();
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
      stateManager.setRowChecked(stateManager.currentCell!.row,
          !stateManager.currentCell!.row.checked!,
          notify: true);
    }
  }
}

class CustomSpaceKeyAction1 extends PlutoGridShortcutAction {
  CustomSpaceKeyAction1({
    this.spaceOnPress,
  });

  final Function(int rowIndex, bool isSelect)? spaceOnPress;

  @override
  void execute({
    required PlutoKeyManagerEvent keyEvent,
    required PlutoGridStateManager stateManager,
  }) {
    if (stateManager.currentCell!.column.enableRowChecked == true) {
      stateManager.setRowChecked(stateManager.currentCell!.row,
          !stateManager.currentCell!.row.checked!,
          notify: true);
      if (spaceOnPress != null) {
        spaceOnPress!(stateManager.currentRowIdx!,
            stateManager.currentCell!.row.checked!);
      }
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
      if (stateManager.currentRowIdx == 0 &&
          stateManager.currentCellPosition?.columnIdx == 0) {
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
      if (stateManager.currentCell!.row == stateManager.refRows.last &&
          stateManager.currentCell!.column == stateManager.refColumns.last) {
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
