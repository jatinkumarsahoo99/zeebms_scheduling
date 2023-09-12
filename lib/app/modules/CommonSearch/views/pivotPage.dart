import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bms_scheduling/widgets/PlutoGrid/pluto_grid.dart';

import '../../../../widgets/FormButton.dart';
import '../../../../widgets/gridFromMap.dart';
import '../../../providers/Utils.dart';
import '../controllers/search_controller.dart';

class SearchPivotPage extends StatelessWidget {
  const SearchPivotPage(
      {Key? key,
      required this.controller,
      this.searchForm,
      this.directPivot = false})
      : super(key: key);
  final SearchController controller;
  final String? searchForm;
  final bool directPivot;

  @override
  Widget build(BuildContext context) {
    print("My search form>>>" + (searchForm ?? ""));
    // List<PlutoColumn> columns = [];
    // for (var column in controller.searchPivotResult![0].keys) {
    //   columns.add(PlutoColumn(
    //       title: column,
    //       enableRowChecked: false,
    //       readOnly: true,
    //       enableSorting: true,
    //       enableRowDrag: false,
    //       enableEditingMode: false,
    //       enableDropToResize: true,
    //       enableContextMenu: false,
    //       width: Utils.getColumnSize(
    //           key: column, value: controller.searchPivotResult![0][key]),
    //       sort: PlutoColumnSort.ascending,
    //       enableAutoEditing: false,
    //       enableColumnDrag: false,
    //       field: column,
    //       type: PlutoColumnType.text()));
    // }

    // List<PlutoRow> rows = [];
    // for (var row in controller.searchPivotResult!) {
    //   Map<String, PlutoCell> cells = {};
    //   for (var value in (row as Map).entries) {
    //     cells[value.key] = PlutoCell(value: (value.value ?? "").toString());
    //   }
    //   rows.add(PlutoRow(cells: cells));
    // }

    return Scaffold(
        appBar: AppBar(
          title: Text(controller.screenName + "- Pivoted Data",
              style: TextStyle(color: Colors.deepPurple)),
          backgroundColor: Colors.white,
          elevation: 4,
          leading: IconButton(
              icon: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black),
              onPressed: () {
                Get.back();
              }),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Container(
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
              for (var btn in ["Save", "Data", "Refresh", "Done", "Exit "])
                FormButtonWrapper(
                  btnText: btn,
                  callback: () =>
                      {controller.pivotBtnHandler(btn, directPivot)},
                )
            ],
          ),
        ),
        body: Container(
          padding:
              const EdgeInsets.fromLTRB(8, 8, 8, kBottomNavigationBarHeight),
          width: Get.width * 2,
          child: DataGridFromMap(
            // columnAutoResize: (controller.searchPivotResult!.length > 5) ? false : true,
            // columnAutoResize: false,
            exportFileName:
                "${controller.screenName}_${controller.selectVarianceId == null ? "" : controller.varainace.firstWhere((element) => element["id"].toString() == controller.selectVarianceId.toString())["varianceName"]}_Pivot",
            mapData: controller.searchPivotResult!,
            onRowDoubleTap: (plutoEvent) {
              if (searchForm == "BMS_view_programmaster") {
                print("Tapped Called");
                // Get.to(ProgramMasterPage());
              }
            },
            mode: PlutoGridMode.select,
          ),
        ));
  }
}
