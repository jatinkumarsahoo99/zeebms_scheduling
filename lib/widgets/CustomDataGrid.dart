import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:pluto_grid/pluto_grid.dart';

import '../app/styles/theme.dart';

class CustomDataGrid extends StatelessWidget {
  CustomDataGrid(
      {Key? key,
      required this.rows,
      required this.columns,
      this.colorCallback,
      this.showSrNo = false,
      this.hideCode = true,
      this.onSelected,
      this.mode = PlutoGridMode.normal,
      this.onload,
      this.hideKeys,
      this.onRowDoubleTap,
      this.actionOnPress,
      this.actionKey})
      : super(key: key);
  final List<PlutoRow> rows;
  final List<PlutoColumn> columns;
  final bool? showSrNo;
  final PlutoGridMode mode;
  final bool? hideCode;
  final Function? actionOnPress;
  final String? actionKey;
  final List? hideKeys;
  Color Function(PlutoRowColorContext)? colorCallback;
  Function(PlutoGridOnSelectedEvent)? onSelected;
  Function(PlutoGridOnRowDoubleTapEvent)? onRowDoubleTap;
  Function(PlutoGridOnLoadedEvent)? onload;
  @override
  Widget build(BuildContext context) {
    FocusNode _focusNode = FocusNode();
    return Focus(
      autofocus: false,
      focusNode: _focusNode,
      child: PlutoGrid(
          mode: mode,
          configuration: plutoGridConfiguration(focusNode: _focusNode).copyWith(
              style:
                  plutoGridConfiguration(focusNode: _focusNode).style.copyWith(
                        checkedColor: Colors.deepPurple[100],
                      )),
          onSelected: onSelected,
          rowColorCallback: colorCallback,
          onLoaded: (loadEvent) {
            loadEvent.stateManager.setKeepFocus(false);
            onload!(loadEvent);
          },
          onRowDoubleTap: onRowDoubleTap,
          columns: columns,
          rows: rows),
    );
  }
}
