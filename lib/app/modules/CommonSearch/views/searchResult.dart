import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bms_scheduling/widgets/PlutoGrid/pluto_grid.dart';

import '../../../../widgets/FormButton.dart';
import '../../../../widgets/Snack.dart';
import '../../../../widgets/gridFromMap.dart';
import '../../../providers/Utils.dart';
import '../controllers/search_controller.dart';

class SearchResultPage extends StatelessWidget {
  const SearchResultPage({
    Key? key,
    required this.controller,
    required this.appFormName,
    this.actionableSearch = false,
    this.actionableMap,
    this.dialogClose,
  }) : super(key: key);
  final SearchController controller;
  final void Function(dynamic)? dialogClose;
  final String appFormName;
  final bool actionableSearch;
  final Map<String, void Function(String value)>? actionableMap;

  @override
  Widget build(BuildContext context) {
    List<PlutoColumn> columns = [];
    for (var column in controller.searchResult![0].keys) {
      columns.add(PlutoColumn(
          title: column,
          enableRowChecked: false,
          readOnly: true,
          enableSorting: false,
          enableRowDrag: false,
          enableEditingMode: false,
          enableDropToResize: true,
          enableContextMenu: true,
          enableHideColumnMenuItem: false,
          enableSetColumnsMenuItem: false,
          enableFilterMenuItem: true,
          width: Utils.getColumnSize(
              key: column, value: controller.searchResult![0][key]),
          enableAutoEditing: false,
          enableColumnDrag: false,
          field: column,
          type: PlutoColumnType.text()));
    }
    PlutoGridStateManager? sm;

    List<PlutoRow> rows = [];
    for (var row in controller.searchResult!) {
      Map<String, PlutoCell> cells = {};
      for (var value in (row as Map).entries) {
        cells[value.key] = PlutoCell(value: value.value ?? "");
      }
      rows.add(PlutoRow(cells: cells));
    }

    return Scaffold(
        appBar: AppBar(
          title: Text(/*controller.screenName +*/ "Search Result",
              style: TextStyle(color: Colors.deepPurple)),
          backgroundColor: Colors.white,
          elevation: 4,
          leading: IconButton(
              icon: Icon(
                  dialogClose != null
                      ? Icons.close
                      : Icons.arrow_back_ios_new_rounded,
                  color: Colors.black),
              onPressed: () {
                if (dialogClose != null) {
                  dialogClose!(null);
                } else {
                  Get.back();
                }
              }),
        ),
        // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        // floatingActionButton:,
        body: Column(
          children: [
            Expanded(
              child: Container(
                width: Get.width * 2,
                padding:
                const EdgeInsets.only(bottom: 8, top: 8, left: 8, right: 8),
                child: DataGridFromMap(
                  columnAutoResize: false,
                  // showSrNo: false,
                  // columnAutoResize:
                  //     (controller.searchResult!.length > 5) ? false : true,
                  exportFileName:
                  "${controller.screenName}_${controller.selectVarianceId == null ? "" : controller.varainace.firstWhere(
                        (element) =>
                    element["id"].toString() ==
                        controller.selectVarianceId.toString(),
                  )["varianceName"]} _Search_Result",
                  hideCode: false,
                  mapData: controller.searchResult!,
                  doPasccal: false,
                  onload: (event) {
                    sm = event.stateManager;
                    for (var element in event.stateManager.refColumns) {
                      event.stateManager.autoFitColumn(context, element);
                    }
                    // event.stateManager.setColumnSizeConfig(
                    //     PlutoGridColumnSizeConfig(
                    //         autoSizeMode: PlutoAutoSizeMode.none,
                    //         resizeMode: PlutoResizeMode.normal));
                  },
                  mode: PlutoGridMode.select,
                  colorCallback: (row) => sm?.currentRow == row.row
                      ? Colors.deepPurple.shade100
                      : Colors.white,
                  onRowDoubleTap: (plutoEvent) {
                    if (appFormName == "BMS_view_programmaster") {
                      String val = controller.searchResult![plutoEvent.rowIdx]
                      ["ProgramName"];
                      print("Tapped Called>> is>>" +
                          val.toString().replaceAll("\"", ""));
                      // Get.to(ProgramMasterPage(appBarReq: true,searchProgramName:"Meet",key: Key("ProgramMaster"),));
                      Get.toNamed("/programMaster?progName=" + val.toString());
                    }
                    if (actionableSearch) {
                      if (actionableMap
                          ?.containsKey(plutoEvent.cell.column.field) ??
                          false) {
                        // if (actionableMap != null && actionableMap!.containsKey()) {
                        actionableMap![plutoEvent.cell.column.field]!(
                            plutoEvent.cell.value ?? "");
                        // }
                      }
                    }
                    if (dialogClose != null) {
                      sm?.setCurrentCell(plutoEvent.cell, plutoEvent.rowIdx);
                      dialogClose!(plutoEvent.row);
                    }
                  },
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              margin: EdgeInsets.zero,
              width: double.infinity,
              decoration: const BoxDecoration(
                  color: Colors.white,
                  border: const Border(
                      top: BorderSide(width: 1.0, color: Colors.grey))),
              child: ButtonBar(
                buttonHeight: 30,
                alignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (var btn in [
                    "Save",
                    "Pivot",
                    "Refresh",
                    "Done",
                    (dialogClose != null ? "Exit " : "Exit")
                  ])
                    FormButtonWrapper(
                      btnText: btn,
                      callback: () => {controller.searchResultBtnHandler(btn)},
                    )
                ],
              ),
            )
          ],
        ));
  }
}
