import 'dart:convert';
import 'dart:isolate';

// import 'package:bms_programming/app/controller/MainController.dart';
// import 'package:bms_programming/app/providers/extensions/datagrid.dart';
import 'package:bms_scheduling/app/providers/extensions/datagrid.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_file_saver/flutter_file_saver.dart';
import 'package:get/get.dart';
import 'package:bms_scheduling/widgets/PlutoGrid/pluto_grid.dart';

// import 'package:pluto_grid_export/pluto_grid_export.dart' as pluto_grid_export;
import 'package:bms_scheduling/widgets/PlutoGridExport/pluto_grid_export.dart'
    as pluto_grid_export;

import '../../widgets/PlutoGridExport/src/pluto_grid_export1.dart';
import '../../widgets/PlutoGridExport/src/pluto_grid_export2.dart';
import '../../widgets/Snack.dart';
import '../../widgets/dropdown.dart';
import '../../widgets/input_fields.dart';
import '../controller/ConnectorControl.dart';
import '../controller/MainController.dart';
import '../data/DropDownValue.dart';
import '../data/rowfilter.dart';
import 'ApiFactory.dart';
import 'ExportData.dart';

class DataGridMenu {
  showGridMenu(PlutoGridStateManager stateManager, TapDownDetails details,
      BuildContext context,
      {String? exportFileName,
      List<SecondaryShowDialogModel>? extraList,
      List<String>? removeKeysFromFile,
      bool csvFormat = false}) async {
    print(">>>>>csvFormat" + csvFormat.toString());
    clearFilterList() {
      Get.find<MainController>().filters1[stateManager.hashCode.toString()] =
          RxList([]);
    }

    checkStateManagerIsNew() async {
      print("Hashcode======================> ${stateManager.hashCode}");
      if (Get.find<MainController>()
          .filters1
          .containsKey(stateManager.hashCode.toString())) {
      } else {
        clearFilterList();
      }
    }

    applyfilters(PlutoGridStateManager stateManager) {
      var _filters = Get.find<MainController>()
              .filters1[stateManager.hashCode.toString()] ??
          [];
      stateManager.setFilter((element) => true);
      List<PlutoRow> _filterRows = stateManager.rows;
      for (var filter in _filters) {
        if (filter.operator == "equal") {
          _filterRows = _filterRows
              .where((element) =>
                  element.cells[filter.field]!.value == filter.value)
              .toList();
        } else {
          _filterRows = _filterRows
              .where((element) =>
                  element.cells[filter.field]!.value != filter.value)
              .toList();
        }
      }
      stateManager.setFilter((element) => _filterRows.contains(element));
    }

    customFilter(PlutoGridStateManager stateManager, {String? selectedColumn}) {
      List _allValues = [];
      var _selectedValues = RxList([]);
      print("1st foucus Added");
      if (stateManager.currentCell == null &&
          ((stateManager.rows.length ?? 0) > 0)) {
        stateManager.setCurrentCell(
            (selectedColumn != null
                ? (stateManager.rows[0].cells[selectedColumn])
                : (stateManager.rows[0].cells.values.first)),
            0);
      }
      if (stateManager.currentCell != null) {
        _allValues = stateManager.rows
            .map((e) => e.cells[stateManager.currentCell!.column.field]!.value
                .toString())
            .toSet()
            .toList();
      }
      Get.defaultDialog(
          title: "Custom Filter",
          content: SizedBox(
            width: Get.width / 2,
            height: Get.height / 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(stateManager.currentColumn?.title ?? "null"),
                const SizedBox(height: 5),
                Expanded(
                  child: ListView.builder(
                    controller: ScrollController(),
                    shrinkWrap: true,
                    itemBuilder: ((context, index) {
                      return Obx(
                        () => Card(
                          color: _selectedValues.contains(_allValues[index])
                              ? Colors.deepPurple
                              : Colors.white,
                          child: InkWell(
                            focusColor: Colors.deepPurple[200],
                            canRequestFocus: true,
                            onTap: () {
                              if (_selectedValues.contains(_allValues[index])) {
                                _selectedValues.remove(_allValues[index]);
                              } else {
                                _selectedValues.add(_allValues[index]);
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Text(
                                _allValues[index] == ""
                                    ? "BLANK"
                                    : _allValues[index],
                                style:
                                    _selectedValues.contains(_allValues[index])
                                        ? TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                            color: Colors.white)
                                        : TextStyle(
                                            fontSize: 12,
                                          ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                    itemCount: _allValues.length,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton.icon(
              onPressed: () {
                Get.back();
              },
              icon: Icon(Icons.clear_rounded),
              label: Text("Cancel"),
            ),
            ElevatedButton.icon(
              onPressed: () {
                stateManager.setFilter((element) => _selectedValues.any(
                    (value) =>
                        value ==
                        element.cells[stateManager.currentCell!.column.field]!
                            .value
                            .toString()));
                Get.back();
              },
              icon: Icon(Icons.done),
              label: Text("Done"),
            ),
          ]);
    }

    var selected = await showMenu(
      context: context,
      position: RelativeRect.fromSize(
          details.globalPosition & Size(40, 40), Get.size),
      items: [
        const PopupMenuItem<DataGridMenuItem>(
          value: DataGridMenuItem.find,
          height: 36,
          enabled: true,
          child: Text('Find', style: TextStyle(fontSize: 13)),
        ),
        const PopupMenuItem<DataGridMenuItem>(
          value: DataGridMenuItem.selectedfilter,
          height: 36,
          enabled: true,
          child: Text('Filter By Selection', style: TextStyle(fontSize: 13)),
        ),
        const PopupMenuItem<DataGridMenuItem>(
          value: DataGridMenuItem.excludeslected,
          height: 36,
          enabled: true,
          child: Text('Filter By Exclusion', style: TextStyle(fontSize: 13)),
        ),
        PopupMenuItem<DataGridMenuItem>(
          value: DataGridMenuItem.removeLastFilter,
          height: 36,
          enabled: true,
          child: Obx(
            () {
              checkStateManagerIsNew();
              return ((Get.find<MainController>()
                              .filters1[stateManager.hashCode.toString()] ??
                          [])
                      .isEmpty)
                  ? Text('Remove Last Filter', style: TextStyle(fontSize: 13))
                  : PopupMenuButton<RowFilter>(
                      child: Text(
                        'Remove Last Filter',
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.normal),
                      ),
                      // onSelected: (Filter result) {
                      //   // setState(() { _selection = result; });
                      // Navigator.pop(context); },
                      itemBuilder: (BuildContext context) {
                        var _filters = Get.find<MainController>()
                            .filters1[stateManager.hashCode.toString()]!;
                        return <PopupMenuEntry<RowFilter>>[
                          for (var i = 0; i < _filters.length; i++)
                            PopupMenuItem(
                              child: Text(
                                  "[${_filters[i].field}] ${_filters[i].operator == 'equal' ? '=' : '<>'} ${_filters[i].value}"),
                              onTap: () {
                                _filters.removeAt(i);
                                applyfilters(stateManager);
                                Get.back();
                              },
                            )
                        ];
                      },
                    );
            },
          ),
        ),
        const PopupMenuItem<DataGridMenuItem>(
          value: DataGridMenuItem.clearfilter,
          height: 36,
          enabled: true,
          child: Text('Remove All Filters', style: TextStyle(fontSize: 13)),
        ),
        const PopupMenuItem<DataGridMenuItem>(
          value: DataGridMenuItem.export,
          height: 36,
          enabled: true,
          child: Text('Export To Excel', style: TextStyle(fontSize: 13)),
        ),
        const PopupMenuItem<DataGridMenuItem>(
          value: DataGridMenuItem.print,
          height: 36,
          enabled: true,
          child: Text('Print', style: TextStyle(fontSize: 13)),
        ),
        const PopupMenuItem<DataGridMenuItem>(
          value: DataGridMenuItem.customFilter,
          height: 36,
          enabled: true,
          child: Text('Custom Filter', style: TextStyle(fontSize: 13)),
        ),
        const PopupMenuItem<DataGridMenuItem>(
          value: DataGridMenuItem.exportToXml,
          height: 36,
          enabled: true,
          child: Text('Export To XML', style: TextStyle(fontSize: 13)),
        ),
        const PopupMenuItem<DataGridMenuItem>(
          value: DataGridMenuItem.export,
          height: 36,
          enabled: true,
          child: Text('Fast Export To Excel', style: TextStyle(fontSize: 13)),
        ),
        const PopupMenuItem<DataGridMenuItem>(
          value: DataGridMenuItem.exportToCSv,
          height: 36,
          enabled: true,
          child: Text('Export To CSV', style: TextStyle(fontSize: 13)),
        ),
        if (extraList != null && extraList.isNotEmpty) ...{
          ...List.generate(
            extraList.length,
            (index) {
              return PopupMenuItem<DataGridMenuItem>(
                value: DataGridMenuItem.extraList,
                height: 36,
                enabled: true,
                onTap: () => extraList[index].callback(),
                child: Text(extraList[index].title,
                    style: TextStyle(fontSize: 13)),
              );
            },
          ).toList(),
        }
      ],
    );

    switch (selected) {
      case DataGridMenuItem.selectedfilter:
        if (stateManager.currentCell != null) {
          Get.find<MainController>()
              .filters1[stateManager.hashCode.toString()]!
              .add(RowFilter(
                  field: stateManager.currentCell!.column.field,
                  operator: "equal",
                  value: stateManager.currentCell!.value));
        }

        applyfilters(stateManager);
        // stateManager.setFilter((element) => stateManager.currentCell == null
        //     ? true
        //     : element.cells[stateManager.currentCell!.column.field]!.value ==
        //         stateManager.currentCell!.value);
        break;

      case DataGridMenuItem.excludeslected:
        if (stateManager.currentCell != null) {
          Get.find<MainController>()
              .filters1[stateManager.hashCode.toString()]!
              .add(RowFilter(
                  field: stateManager.currentCell!.column.field,
                  operator: "notequal",
                  value: stateManager.currentCell!.value));
        }
        applyfilters(stateManager);

        // stateManager.setFilter((element) => stateManager.currentCell == null
        //     ? true
        //     : element.cells[stateManager.currentCell!.column.field]!.value !=
        //         stateManager.currentCell!.value);

        break;
      case DataGridMenuItem.removeLastFilter:
        // print(filters.length);
        // // filters.length > 1 ? filters.removeLast() : filters.clear();
        // applyfilters(stateManager);
        break;
      case DataGridMenuItem.clearfilter:
        clearFilterList();
        applyfilters(stateManager);

        break;
      case DataGridMenuItem.noaction:
        break;
      case DataGridMenuItem.export:
        ExportData().exportExcelFromJsonList(stateManager.toJson(),
            exportFileName ?? "Excel-${DateTime.now().toString()}");
        break;
      case DataGridMenuItem.exportPDF:
        // pluto_grid_export.PlutoGridDefaultPdfExport plutoGridPdfExport =
        //     pluto_grid_export.PlutoGridDefaultPdfExport(
        //   title: "ExportedData${DateTime.now().toString()}",
        //   creator: "BMS_Flutter",
        //   format: pluto_grid_export.PdfPageFormat.a4.landscape,
        // );
        // ExportData().exportPdfFromGridData(plutoGridPdfExport, stateManager);

        break;
      case DataGridMenuItem.print:
        stateManager.setShowLoading(true);
        Get.find<ConnectorControl>().POSTMETHOD_FORMDATAWITHTYPE(
            api: ApiFactory.CONVERT_TO_PDF,
            fun: (value) {
              stateManager.setShowLoading(false);
              // ExportData().printFromGridData1((exportFileName ?? 'export${DateTime.now().toString()}') + ".pdf",value);
              ExportData().printFromGridData1(
                  (exportFileName ?? 'export${DateTime.now().toString()}') +
                      ".pdf",
                  base64.decode(value));
            },
            json: stateManager.toJson(),
            failed: () {
              stateManager.setShowLoading(false);
            });
        /*pluto_grid_export
            .PlutoGridDefaultPdfExport plutoGridPdfExport = pluto_grid_export
            .PlutoGridDefaultPdfExport(
          title: exportFileName ?? "ExportedData${DateTime.now().toString()}",
          creator: "BMS_Flutter",
          format: pluto_grid_export.PdfPageFormat.a4.landscape,
        );
        ExportData().printFromGridData(plutoGridPdfExport, stateManager);*/

        break;
      case DataGridMenuItem.exportToCSv:
        String title = "csv_export";
        var exportCSV;

        if (!csvFormat) {
          exportCSV = pluto_grid_export.PlutoGridExport.exportCSV(stateManager);
        } else if (removeKeysFromFile != null &&
            removeKeysFromFile.isNotEmpty) {
          // PlutoGridExport2 bookingNumber
          print(">>>>>>>>>>>>>>>>>>>>>>>removeKeysFromFile" +
              removeKeysFromFile.toString());
          exportCSV = PlutoGridExport2.exportCSV(stateManager,
              removeKeysFromFile: removeKeysFromFile);
        } else {
          exportCSV = PlutoGridExport1.exportCSV(stateManager);
        }
        var exported = const Utf8Encoder().convert(
            // FIX Add starting \u{FEFF} / 0xEF, 0xBB, 0xBF
            // This allows open the file in Excel with proper character interpretation
            // See https://stackoverflow.com/a/155176
            '\u{FEFF}$exportCSV');

        FlutterFileSaver()
            .writeFileAsBytes(
          fileName:
              (exportFileName ?? 'export${DateTime.now().toString()}') + '.csv',
          bytes: exported,
        )
            .catchError((error) {
          // This code will be executed if there is an error while saving the file.
          Snack.callError("Error saving file: $error");
        });
        // await FileSaver.instance.saveFile("$title.csv", exported, ".csv");
        break;
      case DataGridMenuItem.exportToXml:
        Get.find<ConnectorControl>().POSTMETHOD_FORMDATAWITHTYPE(
          api: ApiFactory.EXPORT_TO_XML,
          fun: (value) {
            ExportData().exportFilefromString(
                value,
                (exportFileName ?? 'export${DateTime.now().toString()}') +
                    ".xml");
          },
          json: stateManager.toJson(),
        );
        break;
      case DataGridMenuItem.find:

        // ignore: use_build_context_synchronously
        showBottomSheet(
            context: context,
            builder: (context) {
              var forFN = FocusNode();
              WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                stateManager.gridFocusNode.unfocus();
                forFN.requestFocus();
              });

              // Future.delayed(Duration(seconds: 1)).then((value) {
              // stateManager.gridFocusNode.unfocus();
              // forFN.requestFocus();
              // });
              var _selectedColumn = stateManager.currentColumn?.field ?? "";
              DropDownValue _preselectedColumn = DropDownValue(
                  key: stateManager.currentColumn?.field ?? "",
                  value: stateManager.currentColumn?.title ?? "");
              TextEditingController _findctrl = TextEditingController();
              var _almost = RxBool(true);
              var _fromstart = RxBool(false);
              int _index = stateManager.currentRowIdx ?? 0;
              return Card(
                child: Padding(
                  padding: EdgeInsets.zero,
                  child: Container(
                    width: Get.width,
                    height: 50,
                    child: FocusTraversalGroup(
                      policy: OrderedTraversalPolicy(),
                      child: Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          FocusTraversalOrder(
                            order: NumericFocusOrder(1),
                            child: Row(
                              children: [
                                Text(
                                  "Column",
                                  // style: TextStyle(
                                  //   fontSize: SizeDefine.labelSize1,
                                  //   color: Colors.black,
                                  //   fontWeight: FontWeight.w500,
                                  // ),
                                ),
                                const SizedBox(width: 5),
                                DropDownField.formDropDown1WidthMap(
                                  stateManager.columns
                                      .map((e) => DropDownValue(
                                          key: e.field, value: e.title))
                                      .toList(),
                                  (value) {
                                    _selectedColumn = value.key!;
                                    _preselectedColumn = value;
                                  },
                                  "Column",
                                  0.15,
                                  selected: _preselectedColumn,
                                  // context,
                                  showtitle: false,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 15),
                          FocusTraversalOrder(
                            order: NumericFocusOrder(2),
                            child: Row(
                              // crossAxisAlignment: CrossAxisAlignment.center,
                              // mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 24),
                                  child: Text(
                                    "For",
                                    // style: TextStyle(
                                    //   fontSize: SizeDefine.labelSize1,
                                    //   color: Colors.black,
                                    //   fontWeight: FontWeight.w500,
                                    // ),
                                  ),
                                ),
                                const SizedBox(width: 5),
                                InputFields.formField1(
                                  hintTxt: "For",
                                  controller: _findctrl,
                                  width: 0.15,
                                  focusNode: forFN,
                                  showTitle: false,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 15),
                          FocusTraversalOrder(
                              order: NumericFocusOrder(3),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  InkWell(
                                      onTap: () {
                                        _almost.value = !_almost.value;
                                      },
                                      child: Obx(
                                        () => Icon(_almost.value
                                            ? Icons.check_box_outlined
                                            : Icons
                                                .check_box_outline_blank_rounded),
                                      )),
                                  Text("Almost"),
                                ],
                              )),
                          const SizedBox(width: 5),
                          FocusTraversalOrder(
                              order: NumericFocusOrder(4),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  InkWell(
                                      onTap: () {
                                        _fromstart.value = !_fromstart.value;
                                      },
                                      child: Obx(
                                        () => Icon(_fromstart.value
                                            ? Icons.check_box_outlined
                                            : Icons
                                                .check_box_outline_blank_rounded),
                                      )),
                                  Text("From Start")
                                ],
                              )),
                          const SizedBox(width: 15),
                          Transform.scale(
                            scale: .85,
                            child: Row(
                              children: [
                                ElevatedButton.icon(
                                    label: Text(""),
                                    onPressed: () {
                                      if (_findctrl.text != "" &&
                                          _selectedColumn != "") {
                                        if (_fromstart.value) {
                                          _index = -1;
                                        }
                                        var _slecetedRow = _almost.value
                                            ? stateManager.rows.firstWhereOrNull(
                                                (element) => (element
                                                        .cells[_selectedColumn]!
                                                        .value
                                                        .toString()
                                                        .toLowerCase()
                                                        .trim()
                                                        .contains(_findctrl.text
                                                            .toLowerCase()
                                                            .trim()) &&
                                                    (element.sortIdx > _index)))
                                            : stateManager.rows.firstWhereOrNull((element) =>
                                                (element.cells[_selectedColumn]!.value.toString().toLowerCase().trim() ==
                                                        _findctrl.text.toLowerCase().trim() &&
                                                    (element.sortIdx > _index)));

                                        if (_slecetedRow == null) {
                                          stateManager.resetScrollToZero();

                                          Get.defaultDialog(
                                              content: Text(
                                                  "You Have reach the end !\nDo u want to restart?"),
                                              actions: [
                                                ElevatedButton.icon(
                                                    onPressed: () {
                                                      _index = 0;
                                                      stateManager
                                                          .resetScrollToZero();
                                                      Get.back();
                                                      var _slecetedRow = _almost.value
                                                          ? stateManager.rows.firstWhereOrNull((element) => (element
                                                                  .cells[
                                                                      _selectedColumn]!
                                                                  .value
                                                                  .toString()
                                                                  .toLowerCase()
                                                                  .trim()
                                                                  .contains(_findctrl.text
                                                                      .toLowerCase()
                                                                      .trim()) &&
                                                              (_index == 0 ||
                                                                  element.sortIdx >
                                                                      (_index ??
                                                                          0))))
                                                          : stateManager.rows
                                                              .firstWhere((element) => (element.cells[_selectedColumn]!.value.toString().toLowerCase().trim() == _findctrl.text.toLowerCase().trim() && (_index == 0 || element.sortIdx > (_index ?? 0))));
                                                      print(_slecetedRow!
                                                              .cells[
                                                                  _selectedColumn]!
                                                              .value
                                                              .toString() +
                                                          _slecetedRow
                                                              .cells[
                                                                  _selectedColumn]!
                                                              .value
                                                              .runtimeType
                                                              .toString());
                                                      _index =
                                                          _slecetedRow.sortIdx;
                                                      stateManager
                                                          .resetScrollToZero();

                                                      stateManager
                                                          .moveScrollByRow(
                                                              PlutoMoveDirection
                                                                  .down,
                                                              _slecetedRow
                                                                      .sortIdx -
                                                                  1);

                                                      stateManager
                                                          .setKeepFocus(false);
                                                      // for (var element in stateManager
                                                      //     .rows) {
                                                      //   stateManager
                                                      //       .setRowChecked(
                                                      //       element, false,
                                                      //       notify: false);
                                                      // }
                                                      // stateManager
                                                      //     .setRowChecked(
                                                      //     _slecetedRow, true,
                                                      //     notify: true);
                                                      stateManager.setCurrentCell(
                                                          _slecetedRow.cells[
                                                              _selectedColumn],
                                                          _slecetedRow.sortIdx);
                                                    },
                                                    icon: Icon(Icons.done),
                                                    label: Text("YES")),
                                                ElevatedButton.icon(
                                                    onPressed: () {
                                                      Get.back();
                                                    },
                                                    icon: Icon(Icons.clear),
                                                    label: Text("NO")),
                                              ]);
                                        } else {
                                          // print(_slecetedRow
                                          //         .cells[_selectedColumn]!.value
                                          //         .toString() +
                                          //     _slecetedRow
                                          //         .cells[_selectedColumn]!
                                          //         .value
                                          //         .runtimeType
                                          //         .toString());
                                          // if (_slecetedRow.sortIdx == 0) {
                                          //   _index = 1;
                                          // } else {
                                          //   _index = _slecetedRow.sortIdx;
                                          // }
                                          if (_fromstart.value) {
                                            _fromstart.value = false;
                                          }
                                          _index = _slecetedRow.sortIdx;
                                          stateManager.resetScrollToZero();
                                          if (_index <= 10) {
                                            stateManager.moveScrollByRow(
                                                PlutoMoveDirection.up,
                                                _slecetedRow.sortIdx);
                                          } else {
                                            stateManager.moveScrollByRow(
                                                PlutoMoveDirection.down,
                                                _slecetedRow.sortIdx + 10);
                                          }
                                          stateManager.setKeepFocus(false);
                                          stateManager.setCurrentCell(
                                              _slecetedRow
                                                  .cells[_selectedColumn],
                                              _slecetedRow.sortIdx);
                                          // for (var element in stateManager
                                          //     .rows) {
                                          //   stateManager.setRowChecked(
                                          //       element, false, notify: false);
                                          // }
                                          // stateManager.setRowChecked(
                                          //     _slecetedRow, true, notify: true);
                                          // stateManager.setCurrentCell(
                                          //     _index == 1
                                          //         ? stateManager
                                          //             .getRowByIdx(_index)!
                                          //             .cells[_selectedColumn]
                                          //         : _slecetedRow
                                          //             .cells[_selectedColumn],
                                          //     _index);
                                          // if(stateManager.currentRow!=null && stateManager.currentRow?.sortIdx==0 && _slecetedRow.sortIdx==2){
                                          //   stateManager.setCurrentCell(
                                          //       stateManager.getRowByIdx(_slecetedRow.sortIdx-1)?.cells[_selectedColumn],
                                          //       _slecetedRow.sortIdx-1);
                                          // }else {
                                          //   stateManager.setCurrentCell(
                                          //       _slecetedRow
                                          //           .cells[_selectedColumn],
                                          //       _slecetedRow.sortIdx);
                                          // }
                                        }
                                      }
                                    },
                                    icon: Icon(Icons
                                        .keyboard_double_arrow_right_rounded)),
                                SizedBox(width: 15),
                                ElevatedButton.icon(
                                    label: Text(""),
                                    onPressed: () {
                                      // for (var element in stateManager
                                      //     .rows) {
                                      //   stateManager
                                      //       .setRowChecked(
                                      //       element, false,
                                      //       notify: false);
                                      // }
                                      Navigator.pop(context);
                                    },
                                    icon: Icon(Icons.clear_outlined)),
                                SizedBox(width: 15),
                                ElevatedButton(
                                    onPressed: () {
                                      stateManager.setFilter((element) =>
                                          stateManager.currentCell == null
                                              ? true
                                              : element
                                                      .cells[stateManager
                                                          .currentCell!
                                                          .column
                                                          .field]!
                                                      .value ==
                                                  stateManager
                                                      .currentCell!.value);
                                    },
                                    child: Text("FS")),
                                SizedBox(width: 15),
                                ElevatedButton(
                                    onPressed: () {
                                      stateManager.setFilter((element) =>
                                          stateManager.currentCell == null
                                              ? true
                                              : element
                                                      .cells[stateManager
                                                          .currentCell!
                                                          .column
                                                          .field]!
                                                      .value !=
                                                  stateManager
                                                      .currentCell!.value);
                                    },
                                    child: Text("XF")),
                                SizedBox(width: 15),
                                ElevatedButton(
                                    onPressed: () {
                                      stateManager.setFilter((element) => true);
                                    },
                                    child: Text("RF")),
                                SizedBox(width: 15),
                                ElevatedButton(
                                    onPressed: () {
                                      customFilter(stateManager,
                                          selectedColumn: _selectedColumn);
                                    },
                                    child: Text("CF")),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            });

        break;
      case DataGridMenuItem.customFilter:
        customFilter(stateManager);
        break;
      case DataGridMenuItem.extraList:
        break;
    }
  }

  showGridCustomMenu(PlutoGridStateManager stateManager, TapDownDetails details,
      BuildContext context,
      {String? exportFileName,
      Function? onPressedClick,
      required PlutoColumnRendererContext plutoContext}) async {
    clearFilterList() {
      Get.find<MainController>().filters1[stateManager.hashCode.toString()] =
          RxList([]);
    }

    void printStatement(List list) {
      try {
        list[1].setShowLoading(true);
        ExportData().printFromGridData(list[0], list[1]);
      } catch (e) {
        list[1].setShowLoading(false);
      }
    }

    void printStatement1() async {
      try {
        stateManager.setShowLoading(true);
        pluto_grid_export.PlutoGridDefaultPdfExport plutoGridPdfExport =
            pluto_grid_export.PlutoGridDefaultPdfExport(
          title: exportFileName ?? "ExportedData${DateTime.now().toString()}",
          creator: "BMS_Flutter",
          format: pluto_grid_export.PdfPageFormat.a4.landscape,
        );
        await ExportData().printFromGridData(plutoGridPdfExport, stateManager);
      } catch (e) {
        stateManager.setShowLoading(false);
      }
    }

    checkStateManagerIsNew() async {
      print("Hashcode======================> ${stateManager.hashCode}");
      if (Get.find<MainController>()
          .filters1
          .containsKey(stateManager.hashCode.toString())) {
      } else {
        clearFilterList();
      }
    }

    applyfilters(PlutoGridStateManager stateManager) {
      var _filters = Get.find<MainController>()
              .filters1[stateManager.hashCode.toString()] ??
          [];
      stateManager.setFilter((element) => true);
      List<PlutoRow> _filterRows = stateManager.rows;
      for (var filter in _filters) {
        if (filter.operator == "equal") {
          _filterRows = _filterRows
              .where((element) =>
                  element.cells[filter.field]!.value == filter.value)
              .toList();
        } else {
          _filterRows = _filterRows
              .where((element) =>
                  element.cells[filter.field]!.value != filter.value)
              .toList();
        }
      }
      stateManager.setFilter((element) => _filterRows.contains(element));
    }

    customFilter(PlutoGridStateManager stateManager) {
      List _allValues = [];
      var _selectedValues = RxList([]);
      print("1st foucus Added");
      if (stateManager.currentCell == null &&
          ((stateManager.rows.length ?? 0) > 0)) {
        stateManager.setCurrentCell(
            (stateManager.rows[0].cells.values.first), 0);
      }
      if (stateManager.currentCell != null) {
        _allValues = stateManager.rows
            .map((e) => e.cells[stateManager.currentCell!.column.field]!.value
                .toString())
            .toSet()
            .toList();
      }
      Get.defaultDialog(
          title: "Custom Filter",
          content: SizedBox(
            width: Get.width / 2,
            height: Get.height / 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(stateManager.currentColumn?.title ?? "null"),
                const SizedBox(height: 5),
                Expanded(
                  child: ListView.builder(
                    controller: ScrollController(),
                    shrinkWrap: true,
                    itemBuilder: ((context, index) {
                      return Obx(
                        () => Card(
                          color: _selectedValues.contains(_allValues[index])
                              ? Colors.deepPurple
                              : Colors.white,
                          child: InkWell(
                            focusColor: Colors.deepPurple[200],
                            canRequestFocus: true,
                            onTap: () {
                              if (_selectedValues.contains(_allValues[index])) {
                                _selectedValues.remove(_allValues[index]);
                              } else {
                                _selectedValues.add(_allValues[index]);
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Text(
                                _allValues[index],
                                style:
                                    _selectedValues.contains(_allValues[index])
                                        ? TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                            color: Colors.white)
                                        : TextStyle(
                                            fontSize: 12,
                                          ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                    itemCount: _allValues.length,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton.icon(
                onPressed: () {
                  Get.back();
                },
                icon: Icon(Icons.clear_rounded),
                label: Text("Cancel")),
            ElevatedButton.icon(
                onPressed: () {
                  stateManager.setFilter((element) => _selectedValues.any(
                      (value) =>
                          value ==
                          element.cells[stateManager.currentCell!.column.field]!
                              .value
                              .toString()));
                  Get.back();
                },
                icon: Icon(Icons.done),
                label: Text("Filter")),
          ]);
    }

    var selected = await showMenu(
        context: context,
        position: RelativeRect.fromSize(
            details.globalPosition & Size(40, 40), Get.size),
        items: [
          const PopupMenuItem<DataGridMenuItem>(
            value: DataGridMenuItem.find,
            height: 36,
            enabled: true,
            child: Text('Find', style: TextStyle(fontSize: 13)),
          ),
          const PopupMenuItem<DataGridMenuItem>(
            value: DataGridMenuItem.selectedfilter,
            height: 36,
            enabled: true,
            child: Text('Filter By Selection', style: TextStyle(fontSize: 13)),
          ),
          const PopupMenuItem<DataGridMenuItem>(
            value: DataGridMenuItem.excludeslected,
            height: 36,
            enabled: true,
            child: Text('Filter By Exclusion', style: TextStyle(fontSize: 13)),
          ),
          PopupMenuItem<DataGridMenuItem>(
            value: DataGridMenuItem.removeLastFilter,
            height: 36,
            enabled: true,
            child: Obx(
              () {
                checkStateManagerIsNew();
                return ((Get.find<MainController>()
                                .filters1[stateManager.hashCode.toString()] ??
                            [])
                        .isEmpty)
                    ? Text('Remove Last Filter', style: TextStyle(fontSize: 13))
                    : PopupMenuButton<RowFilter>(
                        child: Text(
                          'Remove Last Filter',
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.normal),
                        ),
                        // onSelected: (Filter result) {
                        //   // setState(() { _selection = result; });
                        // Navigator.pop(context); },
                        itemBuilder: (BuildContext context) {
                          var _filters = Get.find<MainController>()
                              .filters1[stateManager.hashCode.toString()]!;
                          return <PopupMenuEntry<RowFilter>>[
                            for (var i = 0; i < _filters.length; i++)
                              PopupMenuItem(
                                child: Text(
                                    "[${_filters[i].field}] ${_filters[i].operator == 'equal' ? '=' : '<>'} ${_filters[i].value}"),
                                onTap: () {
                                  _filters.removeAt(i);
                                  applyfilters(stateManager);
                                  Get.back();
                                },
                              )
                          ];
                        },
                      );
              },
            ),
          ),
          const PopupMenuItem<DataGridMenuItem>(
            value: DataGridMenuItem.clearfilter,
            height: 36,
            enabled: true,
            child: Text('Remove All Filters', style: TextStyle(fontSize: 13)),
          ),
          /*const PopupMenuItem<DataGridMenuItem>(
            value: DataGridMenuItem.export,
            height: 36,
            enabled: true,
            child: Text('Export To Excel', style: TextStyle(fontSize: 13)),
          ),*/
          const PopupMenuItem<DataGridMenuItem>(
            value: DataGridMenuItem.print,
            height: 36,
            enabled: true,
            child: Text('Print', style: TextStyle(fontSize: 13)),
          ),
          const PopupMenuItem<DataGridMenuItem>(
            value: DataGridMenuItem.customFilter,
            height: 36,
            enabled: true,
            child: Text('Custom Filter', style: TextStyle(fontSize: 13)),
          ),
          const PopupMenuItem<DataGridMenuItem>(
            value: DataGridMenuItem.exportToXml,
            height: 36,
            enabled: true,
            child: Text('Export To XML', style: TextStyle(fontSize: 13)),
          ),
          const PopupMenuItem<DataGridMenuItem>(
            value: DataGridMenuItem.export,
            height: 36,
            enabled: true,
            child: Text('Fast Export To Excel', style: TextStyle(fontSize: 13)),
          ),
          const PopupMenuItem<DataGridMenuItem>(
            value: DataGridMenuItem.exportToCSv,
            height: 36,
            enabled: true,
            child: Text('Export To CSV', style: TextStyle(fontSize: 13)),
          ),
          const PopupMenuItem<DataGridMenuItem>(
            value: DataGridMenuItem.setPriority,
            height: 36,
            enabled: true,
            child: Text('Set Priority', style: TextStyle(fontSize: 13)),
          ),
          const PopupMenuItem<DataGridMenuItem>(
            value: DataGridMenuItem.clearPriority,
            height: 36,
            enabled: true,
            child: Text('Clear Priority', style: TextStyle(fontSize: 13)),
          ),
        ]);
    if (onPressedClick != null) {
      print("Selected index is>>>" + plutoContext.rowIdx.toString());
      // print("Selected column>>>"+stateManager.currentCell!.column.field);
      // print("Selected index>>>"+stateManager.currentCell!.row.sortIdx.toString());
      onPressedClick(selected, plutoContext.rowIdx);
    }
    switch (selected) {
      case DataGridMenuItem.selectedfilter:
        if (stateManager.currentCell != null) {
          Get.find<MainController>()
              .filters1[stateManager.hashCode.toString()]!
              .add(RowFilter(
                  field: stateManager.currentCell!.column.field,
                  operator: "equal",
                  value: stateManager.currentCell!.value));
        }

        applyfilters(stateManager);
        // stateManager.setFilter((element) => stateManager.currentCell == null
        //     ? true
        //     : element.cells[stateManager.currentCell!.column.field]!.value ==
        //         stateManager.currentCell!.value);
        break;

      case DataGridMenuItem.excludeslected:
        if (stateManager.currentCell != null) {
          Get.find<MainController>()
              .filters1[stateManager.hashCode.toString()]!
              .add(RowFilter(
                  field: stateManager.currentCell!.column.field,
                  operator: "notequal",
                  value: stateManager.currentCell!.value));
        }
        applyfilters(stateManager);

        // stateManager.setFilter((element) => stateManager.currentCell == null
        //     ? true
        //     : element.cells[stateManager.currentCell!.column.field]!.value !=
        //         stateManager.currentCell!.value);

        break;
      case DataGridMenuItem.removeLastFilter:
        // print(filters.length);
        // // filters.length > 1 ? filters.removeLast() : filters.clear();
        // applyfilters(stateManager);
        break;
      case DataGridMenuItem.clearfilter:
        clearFilterList();
        applyfilters(stateManager);

        break;
      case DataGridMenuItem.noaction:
        break;
      case DataGridMenuItem.export:
        ExportData().exportExcelFromJsonList(stateManager.toJson(),
            exportFileName ?? "Excel-${DateTime.now().toString()}");
        break;
      case DataGridMenuItem.exportPDF:
        // pluto_grid_export.PlutoGridDefaultPdfExport plutoGridPdfExport =
        //     pluto_grid_export.PlutoGridDefaultPdfExport(
        //   title: "ExportedData${DateTime.now().toString()}",
        //   creator: "BMS_Flutter",
        //   format: pluto_grid_export.PdfPageFormat.a4.landscape,
        // );
        // ExportData().exportPdfFromGridData(plutoGridPdfExport, stateManager);

        break;
      case DataGridMenuItem.print:
        /*try {
          stateManager.setShowLoading(true);
          pluto_grid_export
              .PlutoGridDefaultPdfExport plutoGridPdfExport = pluto_grid_export
              .PlutoGridDefaultPdfExport(
            title: exportFileName ?? "ExportedData${DateTime.now().toString()}",
            creator: "BMS_Flutter",
            format: pluto_grid_export.PdfPageFormat.a4.landscape,
          );
          ExportData().printFromGridData(plutoGridPdfExport, stateManager);
        }catch(e){
          stateManager.setShowLoading(false);
        }*/

        stateManager.setShowLoading(true);
        Get.find<ConnectorControl>().POSTMETHOD_FORMDATAWITHTYPE(
            api: ApiFactory.CONVERT_TO_PDF,
            fun: (value) {
              stateManager.setShowLoading(false);
              ExportData().printFromGridData1(
                  (exportFileName ?? 'export${DateTime.now().toString()}') +
                      ".pdf",
                  base64.decode(value));
              // ExportData().printFromGridData1((exportFileName ?? 'export${DateTime.now().toString()}') + ".pdf",value);
            },
            json: stateManager.toJson(),
            failed: () {
              stateManager.setShowLoading(false);
            });
        // printStatement1();
        break;
      case DataGridMenuItem.exportToCSv:
        String title = "csv_export";
        var exportCSV =
            pluto_grid_export.PlutoGridExport.exportCSV(stateManager);
        var exported = const Utf8Encoder().convert(
            // FIX Add starting \u{FEFF} / 0xEF, 0xBB, 0xBF
            // This allows open the file in Excel with proper character interpretation
            // See https://stackoverflow.com/a/155176
            '\u{FEFF}$exportCSV');

        FlutterFileSaver()
            .writeFileAsBytes(
              fileName:
                  (exportFileName ?? 'export${DateTime.now().toString()}') +
                      '.csv',
              bytes: exported,
            )
            .then((value) => Snack.callSuccess("File save to $value"));
        // await FileSaver.instance.saveFile("$title.csv", exported, ".csv");
        break;
      case DataGridMenuItem.exportToXml:
        //TODO
        Get.find<ConnectorControl>().POSTMETHOD_FORMDATAWITHTYPE(
          api: ApiFactory.EXPORT_TO_XML,
          fun: (value) {
            ExportData().exportFilefromString(
                value,
                (exportFileName ?? 'export${DateTime.now().toString()}') +
                    ".xml");
          },
          json: stateManager.toJson(),
        );
        break;
      case DataGridMenuItem.find:

        // ignore: use_build_context_synchronously
        showBottomSheet(
            context: context,
            builder: (context) {
              var forFN = FocusNode();
              WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                stateManager.gridFocusNode.unfocus();
                forFN.requestFocus();
              });
              var _selectedColumn = stateManager.currentColumn?.field ?? "";
              DropDownValue _preselectedColumn = DropDownValue(
                  key: stateManager.currentColumn?.field ?? "",
                  value: stateManager.currentColumn?.title ?? "");
              TextEditingController _findctrl = TextEditingController();
              var _almost = RxBool(true);
              var _fromstart = RxBool(false);
              int _index = stateManager.currentRowIdx ?? 0;
              return Card(
                child: Padding(
                  padding: EdgeInsets.zero,
                  child: Container(
                    width: Get.width,
                    height: 50,
                    child: FocusTraversalGroup(
                      policy: OrderedTraversalPolicy(),
                      child: Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          FocusTraversalOrder(
                            order: NumericFocusOrder(1),
                            child: Row(
                              children: [
                                Text(
                                  "Column",
                                  // style: TextStyle(
                                  //   fontSize: SizeDefine.labelSize1,
                                  //   color: Colors.black,
                                  //   fontWeight: FontWeight.w500,
                                  // ),
                                ),
                                const SizedBox(width: 5),
                                DropDownField.formDropDown1WidthMap(
                                  stateManager.columns
                                      .map((e) => DropDownValue(
                                          key: e.field, value: e.title))
                                      .toList(),
                                  (value) {
                                    _selectedColumn = value.key!;
                                    _preselectedColumn = value;
                                  },
                                  "Column",
                                  0.15,
                                  selected: _preselectedColumn,
                                  // context,
                                  showtitle: false,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 15),
                          FocusTraversalOrder(
                            order: NumericFocusOrder(2),
                            child: Row(
                              // crossAxisAlignment: CrossAxisAlignment.center,
                              // mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 24),
                                  child: Text(
                                    "For",
                                    // style: TextStyle(
                                    //   fontSize: SizeDefine.labelSize1,
                                    //   color: Colors.black,
                                    //   fontWeight: FontWeight.w500,
                                    // ),
                                  ),
                                ),
                                const SizedBox(width: 5),
                                InputFields.formField1(
                                    hintTxt: "For",
                                    controller: _findctrl,
                                    width: 0.15,
                                    focusNode: forFN,
                                    showTitle: false),
                              ],
                            ),
                          ),
                          SizedBox(width: 15),
                          FocusTraversalOrder(
                              order: NumericFocusOrder(3),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  InkWell(
                                      onTap: () {
                                        _almost.value = !_almost.value;
                                      },
                                      child: Obx(
                                        () => Icon(_almost.value
                                            ? Icons.check_box_outlined
                                            : Icons
                                                .check_box_outline_blank_rounded),
                                      )),
                                  Text("Almost"),
                                ],
                              )),
                          const SizedBox(width: 5),
                          FocusTraversalOrder(
                              order: NumericFocusOrder(4),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  InkWell(
                                      onTap: () {
                                        _fromstart.value = !_fromstart.value;
                                      },
                                      child: Obx(
                                        () => Icon(_fromstart.value
                                            ? Icons.check_box_outlined
                                            : Icons
                                                .check_box_outline_blank_rounded),
                                      )),
                                  Text("From Start")
                                ],
                              )),
                          const SizedBox(width: 15),
                          Transform.scale(
                            scale: .85,
                            child: Row(
                              children: [
                                ElevatedButton.icon(
                                    label: Text(""),
                                    onPressed: () {
                                      if (_findctrl.text != "" &&
                                          _selectedColumn != "") {
                                        if (_fromstart.value) {
                                          _index = -1;
                                        }
                                        var _slecetedRow = _almost.value
                                            ? stateManager.rows.firstWhereOrNull(
                                                (element) => (element
                                                        .cells[_selectedColumn]!
                                                        .value
                                                        .toString()
                                                        .toLowerCase()
                                                        .trim()
                                                        .contains(_findctrl.text
                                                            .toLowerCase()
                                                            .trim()) &&
                                                    (element.sortIdx > _index)))
                                            : stateManager.rows.firstWhereOrNull((element) =>
                                                (element.cells[_selectedColumn]!.value.toString().toLowerCase().trim() ==
                                                        _findctrl.text.toLowerCase().trim() &&
                                                    (element.sortIdx > _index)));
                                        if (_slecetedRow == null) {
                                          stateManager.resetScrollToZero();

                                          Get.defaultDialog(
                                              content: Text(
                                                  "You Have reach the end !\nDo u want to restart?"),
                                              actions: [
                                                ElevatedButton.icon(
                                                    onPressed: () {
                                                      _index = 0;
                                                      stateManager
                                                          .resetScrollToZero();
                                                      Get.back();
                                                      var _slecetedRow = _almost.value
                                                          ? stateManager.rows.firstWhereOrNull((element) => (element
                                                                  .cells[
                                                                      _selectedColumn]!
                                                                  .value
                                                                  .toString()
                                                                  .toLowerCase()
                                                                  .trim()
                                                                  .contains(_findctrl.text
                                                                      .toLowerCase()
                                                                      .trim()) &&
                                                              (_index == 0 ||
                                                                  element.sortIdx >
                                                                      (_index ??
                                                                          0))))
                                                          : stateManager.rows
                                                              .firstWhere((element) => (element.cells[_selectedColumn]!.value.toString().toLowerCase().trim() == _findctrl.text.toLowerCase().trim() && (_index == 0 || element.sortIdx > (_index ?? 0))));
                                                      print(_slecetedRow!
                                                              .cells[
                                                                  _selectedColumn]!
                                                              .value
                                                              .toString() +
                                                          _slecetedRow
                                                              .cells[
                                                                  _selectedColumn]!
                                                              .value
                                                              .runtimeType
                                                              .toString());
                                                      _index =
                                                          _slecetedRow.sortIdx;
                                                      stateManager
                                                          .resetScrollToZero();

                                                      stateManager
                                                          .moveScrollByRow(
                                                              PlutoMoveDirection
                                                                  .down,
                                                              _slecetedRow
                                                                      .sortIdx -
                                                                  1);

                                                      stateManager
                                                          .setKeepFocus(false);
                                                      // for (var element in stateManager
                                                      //     .rows) {
                                                      //   stateManager
                                                      //       .setRowChecked(
                                                      //       element, false,
                                                      //       notify: false);
                                                      // }
                                                      // stateManager
                                                      //     .setRowChecked(
                                                      //     _slecetedRow, true,
                                                      //     notify: true);
                                                      stateManager.setCurrentCell(
                                                          _slecetedRow.cells[
                                                              _selectedColumn],
                                                          _slecetedRow.sortIdx);
                                                    },
                                                    icon: Icon(Icons.done),
                                                    label: Text("YES")),
                                                ElevatedButton.icon(
                                                    onPressed: () {
                                                      Get.back();
                                                    },
                                                    icon: Icon(Icons.clear),
                                                    label: Text("NO")),
                                              ]);
                                        } else {
                                          if (_fromstart.value) {
                                            _fromstart.value = false;
                                          }
                                          _index = _slecetedRow.sortIdx;
                                          stateManager.resetScrollToZero();
                                          if (_index <= 10) {
                                            stateManager.moveScrollByRow(
                                                PlutoMoveDirection.up,
                                                _slecetedRow.sortIdx);
                                          } else {
                                            stateManager.moveScrollByRow(
                                                PlutoMoveDirection.down,
                                                _slecetedRow.sortIdx);
                                          }
                                          stateManager.setKeepFocus(false);
                                          stateManager.setCurrentCell(
                                              _slecetedRow
                                                  .cells[_selectedColumn],
                                              _slecetedRow.sortIdx);
                                          // print(_slecetedRow
                                          //         .cells[_selectedColumn]!.value
                                          //         .toString() +
                                          //     _slecetedRow
                                          //         .cells[_selectedColumn]!
                                          //         .value
                                          //         .runtimeType
                                          //         .toString());
                                          // if (_slecetedRow.sortIdx == 0) {
                                          //   _index = 1;
                                          // } else {
                                          //   _index = _slecetedRow.sortIdx;
                                          // }

                                          // stateManager.resetScrollToZero();
                                          // stateManager.moveScrollByRow(
                                          //     PlutoMoveDirection.down, _index);
                                          // stateManager.setKeepFocus(false);
                                          // for (var element in stateManager
                                          //     .rows) {
                                          //   stateManager.setRowChecked(
                                          //       element, false, notify: false);
                                          // }
                                          // stateManager.setRowChecked(
                                          //     _slecetedRow, true, notify: true);
                                          /*stateManager.setCurrentCell(
                                              _index == 1
                                                  ? stateManager
                                                  .getRowByIdx(_index)!
                                                  .cells[_selectedColumn]
                                                  : _slecetedRow
                                                  .cells[_selectedColumn],
                                              _index);*/
                                          // if (stateManager.currentRow != null &&
                                          //     stateManager
                                          //             .currentRow?.sortIdx ==
                                          //         0 &&
                                          //     _slecetedRow.sortIdx == 2) {
                                          //   stateManager.setCurrentCell(
                                          //       stateManager
                                          //           .getRowByIdx(
                                          //               _slecetedRow.sortIdx -
                                          //                   1)
                                          //           ?.cells[_selectedColumn],
                                          //       _slecetedRow.sortIdx - 1);
                                          // } else {
                                          //   stateManager.setCurrentCell(
                                          //       _slecetedRow
                                          //           .cells[_selectedColumn],
                                          //       _slecetedRow.sortIdx);
                                          // }
                                        }
                                      }
                                    },
                                    icon: Icon(Icons
                                        .keyboard_double_arrow_right_rounded)),
                                SizedBox(width: 15),
                                ElevatedButton.icon(
                                    label: Text(""),
                                    onPressed: () {
                                      // for (var element in stateManager
                                      //     .rows) {
                                      //   stateManager
                                      //       .setRowChecked(
                                      //       element, false,
                                      //       notify: false);
                                      // }
                                      Navigator.pop(context);
                                    },
                                    icon: Icon(Icons.clear_outlined)),
                                SizedBox(width: 15),
                                ElevatedButton(
                                    onPressed: () {
                                      stateManager.setFilter((element) =>
                                          stateManager.currentCell == null
                                              ? true
                                              : element
                                                      .cells[stateManager
                                                          .currentCell!
                                                          .column
                                                          .field]!
                                                      .value ==
                                                  stateManager
                                                      .currentCell!.value);
                                    },
                                    child: Text("FS")),
                                SizedBox(width: 15),
                                ElevatedButton(
                                    onPressed: () {
                                      stateManager.setFilter((element) =>
                                          stateManager.currentCell == null
                                              ? true
                                              : element
                                                      .cells[stateManager
                                                          .currentCell!
                                                          .column
                                                          .field]!
                                                      .value !=
                                                  stateManager
                                                      .currentCell!.value);
                                    },
                                    child: Text("XF")),
                                SizedBox(width: 15),
                                ElevatedButton(
                                    onPressed: () {
                                      stateManager.setFilter((element) => true);
                                    },
                                    child: Text("RF")),
                                SizedBox(width: 15),
                                ElevatedButton(
                                    onPressed: () {
                                      customFilter(stateManager);
                                    },
                                    child: Text("CF")),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            });

        break;
      case DataGridMenuItem.customFilter:
        customFilter(stateManager);
        break;

      case null:
        break;
    }
  }

  showGridCustomTransmissionLog(PlutoGridStateManager stateManager,
      TapDownDetails details, BuildContext context,
      {String? exportFileName,
      Function? onPressedClick,
      required PlutoColumnRendererContext plutoContext}) async {
    clearFilterList() {
      Get.find<MainController>().filters1[stateManager.hashCode.toString()] =
          RxList([]);
    }

    checkStateManagerIsNew() async {
      print("Hashcode======================> ${stateManager.hashCode}");
      if (Get.find<MainController>()
          .filters1
          .containsKey(stateManager.hashCode.toString())) {
      } else {
        clearFilterList();
      }
    }

    applyfilters(PlutoGridStateManager stateManager) {
      var _filters = Get.find<MainController>()
              .filters1[stateManager.hashCode.toString()] ??
          [];
      stateManager.setFilter((element) => true);
      List<PlutoRow> _filterRows = stateManager.rows;
      for (var filter in _filters) {
        if (filter.operator == "equal") {
          _filterRows = _filterRows
              .where((element) =>
                  element.cells[filter.field]!.value == filter.value)
              .toList();
        } else {
          _filterRows = _filterRows
              .where((element) =>
                  element.cells[filter.field]!.value != filter.value)
              .toList();
        }
      }
      stateManager.setFilter((element) => _filterRows.contains(element));
    }

    customFilter(PlutoGridStateManager stateManager) {
      List _allValues = [];
      var _selectedValues = RxList([]);
      print("1st foucus Added");
      if (stateManager.currentCell == null &&
          ((stateManager.rows.length ?? 0) > 0)) {
        stateManager.setCurrentCell(
            (stateManager.rows[0].cells.values.first), 0);
      }
      if (stateManager.currentCell != null) {
        _allValues = stateManager.rows
            .map((e) => e.cells[stateManager.currentCell!.column.field]!.value
                .toString())
            .toSet()
            .toList();
      }
      Get.defaultDialog(
          title: "Custom Filter",
          content: SizedBox(
            width: Get.width / 2,
            height: Get.height / 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(stateManager.currentColumn?.title ?? "null"),
                const SizedBox(height: 5),
                Expanded(
                  child: ListView.builder(
                    controller: ScrollController(),
                    shrinkWrap: true,
                    itemBuilder: ((context, index) {
                      return Obx(
                        () => Card(
                          color: _selectedValues.contains(_allValues[index])
                              ? Colors.deepPurple
                              : Colors.white,
                          child: InkWell(
                            focusColor: Colors.deepPurple[200],
                            canRequestFocus: true,
                            onTap: () {
                              if (_selectedValues.contains(_allValues[index])) {
                                _selectedValues.remove(_allValues[index]);
                              } else {
                                _selectedValues.add(_allValues[index]);
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Text(
                                _allValues[index],
                                style:
                                    _selectedValues.contains(_allValues[index])
                                        ? TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                            color: Colors.white)
                                        : TextStyle(
                                            fontSize: 12,
                                          ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                    itemCount: _allValues.length,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton.icon(
                onPressed: () {
                  Get.back();
                },
                icon: Icon(Icons.clear_rounded),
                label: Text("Cancel")),
            ElevatedButton.icon(
                onPressed: () {
                  stateManager.setFilter((element) => _selectedValues.any(
                      (value) =>
                          value ==
                          element.cells[stateManager.currentCell!.column.field]!
                              .value
                              .toString()));
                  Get.back();
                },
                icon: Icon(Icons.done),
                label: Text("Filter")),
          ]);
    }

    var selected = await showMenu(
        context: context,
        position: RelativeRect.fromSize(
            details.globalPosition & Size(40, 40), Get.size),
        items: [
          const PopupMenuItem<DataGridMenuItem>(
            value: DataGridMenuItem.delete,
            height: 25,
            enabled: true,
            child: Text('Delete', style: TextStyle(fontSize: 11)),
          ),
          const PopupMenuItem<DataGridMenuItem>(
            value: DataGridMenuItem.find,
            height: 25,
            enabled: true,
            child: Text('Find', style: TextStyle(fontSize: 11)),
          ),
          const PopupMenuItem<DataGridMenuItem>(
            value: DataGridMenuItem.rescheduleSpots,
            height: 25,
            enabled: true,
            child: Text('Reschedule Spots', style: TextStyle(fontSize: 11)),
          ),
          const PopupMenuItem<DataGridMenuItem>(
            value: DataGridMenuItem.selectedfilter,
            height: 25,
            enabled: true,
            child: Text('Filter By Selection', style: TextStyle(fontSize: 11)),
          ),
          const PopupMenuItem<DataGridMenuItem>(
            value: DataGridMenuItem.excludeslected,
            height: 25,
            enabled: true,
            child: Text('Filter By Exclusion', style: TextStyle(fontSize: 11)),
          ),
          PopupMenuItem<DataGridMenuItem>(
            value: DataGridMenuItem.removeLastFilter,
            height: 25,
            enabled: true,
            child: Obx(
              () {
                checkStateManagerIsNew();
                return ((Get.find<MainController>()
                                .filters1[stateManager.hashCode.toString()] ??
                            [])
                        .isEmpty)
                    ? Text('Remove Last Filter', style: TextStyle(fontSize: 11))
                    : PopupMenuButton<RowFilter>(
                        child: Text(
                          'Remove Last Filter',
                          style: TextStyle(
                              fontSize: 11, fontWeight: FontWeight.normal),
                        ),
                        // onSelected: (Filter result) {
                        //   // setState(() { _selection = result; });
                        // Navigator.pop(context); },
                        itemBuilder: (BuildContext context) {
                          var _filters = Get.find<MainController>()
                              .filters1[stateManager.hashCode.toString()]!;
                          return <PopupMenuEntry<RowFilter>>[
                            for (var i = 0; i < _filters.length; i++)
                              PopupMenuItem(
                                child: Text(
                                    "[${_filters[i].field}] ${_filters[i].operator == 'equal' ? '=' : '<>'} ${_filters[i].value}"),
                                onTap: () {
                                  _filters.removeAt(i);
                                  applyfilters(stateManager);
                                  Get.back();
                                },
                              )
                          ];
                        },
                      );
              },
            ),
          ),
          const PopupMenuItem<DataGridMenuItem>(
            value: DataGridMenuItem.clearfilter,
            height: 25,
            enabled: true,
            child: Text('Remove All Filters', style: TextStyle(fontSize: 11)),
          ),
          const PopupMenuItem<DataGridMenuItem>(
            value: DataGridMenuItem.export,
            height: 25,
            enabled: true,
            child: Text('Export To Excel', style: TextStyle(fontSize: 11)),
          ),
          /* const PopupMenuItem<DataGridMenuItem>(
            value: DataGridMenuItem.print,
            height: 36,
            enabled: true,
            child: Text('Print', style: TextStyle(fontSize: 13)),
          ),*/
          const PopupMenuItem<DataGridMenuItem>(
            value: DataGridMenuItem.customFilter,
            height: 25,
            enabled: true,
            child: Text('Custom Filter', style: TextStyle(fontSize: 11)),
          ),
          const PopupMenuItem<DataGridMenuItem>(
            value: DataGridMenuItem.exportToXml,
            height: 25,
            enabled: true,
            child: Text('Export To XML', style: TextStyle(fontSize: 11)),
          ),
          const PopupMenuItem<DataGridMenuItem>(
            value: DataGridMenuItem.export,
            height: 25,
            enabled: true,
            child: Text('Fast Export To Excel', style: TextStyle(fontSize: 11)),
          ),
          const PopupMenuItem<DataGridMenuItem>(
            value: DataGridMenuItem.exportToCSv,
            height: 25,
            enabled: true,
            child: Text('Export To CSV', style: TextStyle(fontSize: 11)),
          ),
          const PopupMenuItem<DataGridMenuItem>(
            value: DataGridMenuItem.delete,
            height: 25,
            enabled: true,
            child: Text('Delete (Del)', style: TextStyle(fontSize: 11)),
          ),
          const PopupMenuItem<DataGridMenuItem>(
            value: DataGridMenuItem.cut,
            height: 25,
            enabled: true,
            child: Text('Cut (F2)', style: TextStyle(fontSize: 11)),
          ),
          const PopupMenuItem<DataGridMenuItem>(
            value: DataGridMenuItem.copy,
            height: 25,
            enabled: true,
            child: Text('Copy (F3)', style: TextStyle(fontSize: 11)),
          ),
          const PopupMenuItem<DataGridMenuItem>(
            value: DataGridMenuItem.paste,
            height: 25,
            enabled: true,
            child: Text('Paste (F4)', style: TextStyle(fontSize: 11)),
          ),
          const PopupMenuItem<DataGridMenuItem>(
            value: DataGridMenuItem.clearpaste,
            height: 25,
            enabled: true,
            child: Text('Clear Paste', style: TextStyle(fontSize: 11)),
          ),
          const PopupMenuItem<DataGridMenuItem>(
            value: DataGridMenuItem.verifyTime,
            height: 25,
            enabled: true,
            child: Text('Verify Time (F5)', style: TextStyle(fontSize: 11)),
          ),
          const PopupMenuItem<DataGridMenuItem>(
            value: DataGridMenuItem.fixedEvent,
            height: 25,
            enabled: true,
            child: Text('Fixed Event', style: TextStyle(fontSize: 11)),
          ),
          const PopupMenuItem<DataGridMenuItem>(
            value: DataGridMenuItem.freezeColumn,
            height: 25,
            enabled: true,
            child: Text('Freeze Column', style: TextStyle(fontSize: 11)),
          ),
          const PopupMenuItem<DataGridMenuItem>(
            value: DataGridMenuItem.unFreezeColumn,
            height: 25,
            enabled: true,
            child: Text('Un-Freeze Column', style: TextStyle(fontSize: 11)),
          ),
          const PopupMenuItem<DataGridMenuItem>(
            value: DataGridMenuItem.removeMarkError,
            height: 25,
            enabled: true,
            child:
                Text('Remove & Mark as Error', style: TextStyle(fontSize: 11)),
          ),

        ]);
    if (onPressedClick != null) {
      print("Selected index is>>>" + plutoContext.rowIdx.toString());
      // print("Selected column>>>"+stateManager.currentCell!.column.field);
      // print("Selected index>>>"+stateManager.currentCell!.row.sortIdx.toString());
      onPressedClick(selected, plutoContext.rowIdx, plutoContext);
    }
    switch (selected) {
      case DataGridMenuItem.selectedfilter:
        if (stateManager.currentCell != null) {
          Get.find<MainController>()
              .filters1[stateManager.hashCode.toString()]!
              .add(RowFilter(
                  field: stateManager.currentCell!.column.field,
                  operator: "equal",
                  value: stateManager.currentCell!.value));
        }

        applyfilters(stateManager);
        // stateManager.setFilter((element) => stateManager.currentCell == null
        //     ? true
        //     : element.cells[stateManager.currentCell!.column.field]!.value ==
        //         stateManager.currentCell!.value);
        break;

      case DataGridMenuItem.excludeslected:
        if (stateManager.currentCell != null) {
          Get.find<MainController>()
              .filters1[stateManager.hashCode.toString()]!
              .add(RowFilter(
                  field: stateManager.currentCell!.column.field,
                  operator: "notequal",
                  value: stateManager.currentCell!.value));
        }
        applyfilters(stateManager);

        // stateManager.setFilter((element) => stateManager.currentCell == null
        //     ? true
        //     : element.cells[stateManager.currentCell!.column.field]!.value !=
        //         stateManager.currentCell!.value);

        break;
      case DataGridMenuItem.removeLastFilter:
        // print(filters.length);
        // // filters.length > 1 ? filters.removeLast() : filters.clear();
        // applyfilters(stateManager);
        break;
      case DataGridMenuItem.clearfilter:
        clearFilterList();
        applyfilters(stateManager);

        break;
      case DataGridMenuItem.noaction:
        break;
      case DataGridMenuItem.export:
        ExportData().exportExcelFromJsonList(stateManager.toJson(),
            exportFileName ?? "Excel-${DateTime.now().toString()}");
        break;
      case DataGridMenuItem.exportPDF:
        // pluto_grid_export.PlutoGridDefaultPdfExport plutoGridPdfExport =
        //     pluto_grid_export.PlutoGridDefaultPdfExport(
        //   title: "ExportedData${DateTime.now().toString()}",
        //   creator: "BMS_Flutter",
        //   format: pluto_grid_export.PdfPageFormat.a4.landscape,
        // );
        // ExportData().exportPdfFromGridData(plutoGridPdfExport, stateManager);

        break;
      case DataGridMenuItem.print:
        /*pluto_grid_export
            .PlutoGridDefaultPdfExport plutoGridPdfExport = pluto_grid_export
            .PlutoGridDefaultPdfExport(
          title: exportFileName ?? "ExportedData${DateTime.now().toString()}",
          creator: "BMS_Flutter",
          format: pluto_grid_export.PdfPageFormat.a4.landscape,
        );
        ExportData().printFromGridData(plutoGridPdfExport, stateManager);*/
        stateManager.setShowLoading(true);
        Get.find<ConnectorControl>().POSTMETHOD_FORMDATAWITHTYPE(
            api: ApiFactory.CONVERT_TO_PDF,
            fun: (value) {
              stateManager.setShowLoading(false);
              ExportData().printFromGridData1(
                  (exportFileName ?? 'export${DateTime.now().toString()}') +
                      ".pdf",
                  base64.decode(value));
              // ExportData().printFromGridData1((exportFileName ?? 'export${DateTime.now().toString()}') + ".pdf",value);
            },
            json: stateManager.toJson(),
            failed: () {
              stateManager.setShowLoading(false);
            });
        break;
      case DataGridMenuItem.exportToCSv:
        String title = "csv_export";
        var exportCSV =
            pluto_grid_export.PlutoGridExport.exportCSV(stateManager);
        var exported = const Utf8Encoder().convert(
            // FIX Add starting \u{FEFF} / 0xEF, 0xBB, 0xBF
            // This allows open the file in Excel with proper character interpretation
            // See https://stackoverflow.com/a/155176
            '\u{FEFF}$exportCSV');

        FlutterFileSaver()
            .writeFileAsBytes(
              fileName:
                  (exportFileName ?? 'export${DateTime.now().toString()}') +
                      '.csv',
              bytes: exported,
            )
            .then((value) => Snack.callSuccess("File save to $value"));
        // await FileSaver.instance.saveFile("$title.csv", exported, ".csv");
        break;
      case DataGridMenuItem.exportToXml:
        //TODO
        Get.find<ConnectorControl>().POSTMETHOD_FORMDATAWITHTYPE(
          api: ApiFactory.EXPORT_TO_XML,
          fun: (value) {
            ExportData().exportFilefromString(
                value,
                (exportFileName ?? 'export${DateTime.now().toString()}') +
                    ".xml");
          },
          json: stateManager.toJson(),
        );
        break;
      case DataGridMenuItem.find:

        // ignore: use_build_context_synchronously
        showBottomSheet(
            context: context,
            builder: (context) {
              var forFN = FocusNode();
              WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                stateManager.gridFocusNode.unfocus();
                forFN.requestFocus();
              });
              var _selectedColumn = stateManager.currentColumn?.field ?? "";
              DropDownValue _preselectedColumn = DropDownValue(
                  key: stateManager.currentColumn?.field ?? "",
                  value: stateManager.currentColumn?.title ?? "");
              TextEditingController _findctrl = TextEditingController();
              var _almost = RxBool(true);
              var _fromstart = RxBool(false);
              int _index = stateManager.currentRowIdx ?? 0;
              return Card(
                child: Padding(
                  padding: EdgeInsets.zero,
                  child: Container(
                    width: Get.width,
                    height: 50,
                    child: FocusTraversalGroup(
                      policy: OrderedTraversalPolicy(),
                      child: Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          FocusTraversalOrder(
                            order: NumericFocusOrder(1),
                            child: Row(
                              children: [
                                Text(
                                  "Column",
                                  // style: TextStyle(
                                  //   fontSize: SizeDefine.labelSize1,
                                  //   color: Colors.black,
                                  //   fontWeight: FontWeight.w500,
                                  // ),
                                ),
                                const SizedBox(width: 5),
                                DropDownField.formDropDown1WidthMap(
                                  stateManager.columns
                                      .map((e) => DropDownValue(
                                          key: e.field, value: e.title))
                                      .toList(),
                                  (value) {
                                    _selectedColumn = value.key!;
                                    _preselectedColumn = value;
                                  },
                                  "Column",
                                  0.15,
                                  selected: _preselectedColumn,
                                  // context,
                                  showtitle: false,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 15),
                          FocusTraversalOrder(
                            order: NumericFocusOrder(2),
                            child: Row(
                              // crossAxisAlignment: CrossAxisAlignment.center,
                              // mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 24),
                                  child: Text(
                                    "For",
                                    // style: TextStyle(
                                    //   fontSize: SizeDefine.labelSize1,
                                    //   color: Colors.black,
                                    //   fontWeight: FontWeight.w500,
                                    // ),
                                  ),
                                ),
                                const SizedBox(width: 5),
                                InputFields.formField1(
                                    hintTxt: "For",
                                    controller: _findctrl,
                                    width: 0.15,
                                    focusNode: forFN,
                                    showTitle: false),
                              ],
                            ),
                          ),
                          SizedBox(width: 15),
                          FocusTraversalOrder(
                              order: NumericFocusOrder(3),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  InkWell(
                                      onTap: () {
                                        _almost.value = !_almost.value;
                                      },
                                      child: Obx(
                                        () => Icon(_almost.value
                                            ? Icons.check_box_outlined
                                            : Icons
                                                .check_box_outline_blank_rounded),
                                      )),
                                  Text("Almost"),
                                ],
                              )),
                          const SizedBox(width: 5),
                          FocusTraversalOrder(
                              order: NumericFocusOrder(4),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  InkWell(
                                      onTap: () {
                                        _fromstart.value = !_fromstart.value;
                                      },
                                      child: Obx(
                                        () => Icon(_fromstart.value
                                            ? Icons.check_box_outlined
                                            : Icons
                                                .check_box_outline_blank_rounded),
                                      )),
                                  Text("From Start")
                                ],
                              )),
                          const SizedBox(width: 15),
                          Transform.scale(
                            scale: .85,
                            child: Row(
                              children: [
                                ElevatedButton.icon(
                                    label: Text(""),
                                    onPressed: () {
                                      if (_findctrl.text != "" &&
                                          _selectedColumn != "") {
                                        if (_fromstart.value) {
                                          _index = -1;
                                        }
                                        var _slecetedRow = _almost.value
                                            ? stateManager.rows.firstWhereOrNull(
                                                (element) => (element
                                                        .cells[_selectedColumn]!
                                                        .value
                                                        .toString()
                                                        .toLowerCase()
                                                        .trim()
                                                        .contains(_findctrl.text
                                                            .toLowerCase()
                                                            .trim()) &&
                                                    (element.sortIdx > _index)))
                                            : stateManager.rows.firstWhereOrNull((element) =>
                                                (element.cells[_selectedColumn]!.value.toString().toLowerCase().trim() ==
                                                        _findctrl.text.toLowerCase().trim() &&
                                                    (element.sortIdx > _index)));

                                        if (_slecetedRow == null) {
                                          stateManager.resetScrollToZero();

                                          Get.defaultDialog(
                                              content: Text(
                                                  "You Have reach the end !\nDo u want to restart?"),
                                              actions: [
                                                ElevatedButton.icon(
                                                    onPressed: () {
                                                      _index = 0;
                                                      stateManager
                                                          .resetScrollToZero();
                                                      Get.back();
                                                      var _slecetedRow = _almost.value
                                                          ? stateManager.rows.firstWhereOrNull((element) => (element
                                                                  .cells[
                                                                      _selectedColumn]!
                                                                  .value
                                                                  .toString()
                                                                  .toLowerCase()
                                                                  .trim()
                                                                  .contains(_findctrl.text
                                                                      .toLowerCase()
                                                                      .trim()) &&
                                                              (_index == 0 ||
                                                                  element.sortIdx >
                                                                      (_index ??
                                                                          0))))
                                                          : stateManager.rows
                                                              .firstWhere((element) => (element.cells[_selectedColumn]!.value.toString().toLowerCase().trim() == _findctrl.text.toLowerCase().trim() && (_index == 0 || element.sortIdx > (_index ?? 0))));
                                                      print(_slecetedRow!
                                                              .cells[
                                                                  _selectedColumn]!
                                                              .value
                                                              .toString() +
                                                          _slecetedRow
                                                              .cells[
                                                                  _selectedColumn]!
                                                              .value
                                                              .runtimeType
                                                              .toString());
                                                      _index =
                                                          _slecetedRow.sortIdx;
                                                      stateManager
                                                          .resetScrollToZero();

                                                      stateManager
                                                          .moveScrollByRow(
                                                              PlutoMoveDirection
                                                                  .down,
                                                              _slecetedRow
                                                                      .sortIdx -
                                                                  1);

                                                      stateManager
                                                          .setKeepFocus(false);
                                                      // for (var element in stateManager
                                                      //     .rows) {
                                                      //   stateManager
                                                      //       .setRowChecked(
                                                      //       element, false,
                                                      //       notify: false);
                                                      // }
                                                      // stateManager
                                                      //     .setRowChecked(
                                                      //     _slecetedRow, true,
                                                      //     notify: true);
                                                      stateManager.setCurrentCell(
                                                          _slecetedRow.cells[
                                                              _selectedColumn],
                                                          _slecetedRow.sortIdx);
                                                    },
                                                    icon: Icon(Icons.done),
                                                    label: Text("YES")),
                                                ElevatedButton.icon(
                                                    onPressed: () {
                                                      Get.back();
                                                    },
                                                    icon: Icon(Icons.clear),
                                                    label: Text("NO")),
                                              ]);
                                        } else {
                                          if (_fromstart.value) {
                                            _fromstart.value = false;
                                          }
                                          _index = _slecetedRow.sortIdx;
                                          stateManager.resetScrollToZero();
                                          if (_index <= 10) {
                                            stateManager.moveScrollByRow(
                                                PlutoMoveDirection.up,
                                                _slecetedRow.sortIdx);
                                          } else {
                                            stateManager.moveScrollByRow(
                                                PlutoMoveDirection.down,
                                                _slecetedRow.sortIdx);
                                          }
                                          stateManager.setKeepFocus(false);
                                          stateManager.setCurrentCell(
                                              _slecetedRow
                                                  .cells[_selectedColumn],
                                              _slecetedRow.sortIdx);
                                          // print(_slecetedRow
                                          //         .cells[_selectedColumn]!.value
                                          //         .toString() +
                                          //     _slecetedRow
                                          //         .cells[_selectedColumn]!
                                          //         .value
                                          //         .runtimeType
                                          //         .toString());
                                          // print("Index selected is>>" +
                                          //     _slecetedRow.sortIdx.toString());
                                          // if (_slecetedRow.sortIdx == 0) {
                                          //   _index = 1;
                                          // } else {
                                          //   _index = _slecetedRow.sortIdx;
                                          // }

                                          // stateManager.resetScrollToZero();
                                          // stateManager.moveScrollByRow(
                                          //     PlutoMoveDirection.down,
                                          //     _slecetedRow.sortIdx);
                                          // stateManager.setKeepFocus(false);
                                          // for (var element in stateManager
                                          //     .rows) {
                                          //   stateManager.setRowChecked(
                                          //       element, false, notify: false);
                                          // }
                                          // stateManager.setRowChecked(
                                          //     _slecetedRow, true, notify: true);
                                          // if (stateManager.currentRow != null &&
                                          //     stateManager
                                          //             .currentRow?.sortIdx ==
                                          //         0 &&
                                          //     _slecetedRow.sortIdx == 2) {
                                          //   stateManager.setCurrentCell(
                                          //       stateManager
                                          //           .getRowByIdx(
                                          //               _slecetedRow.sortIdx -
                                          //                   1)
                                          //           ?.cells[_selectedColumn],
                                          //       _slecetedRow.sortIdx - 1);
                                          // } else {
                                          //   stateManager.setCurrentCell(
                                          //       _slecetedRow
                                          //           .cells[_selectedColumn],
                                          //       _slecetedRow.sortIdx);
                                          // }
                                        }
                                      }
                                    },
                                    icon: Icon(Icons
                                        .keyboard_double_arrow_right_rounded)),
                                SizedBox(width: 15),
                                ElevatedButton.icon(
                                    label: Text(""),
                                    onPressed: () {
                                      // for (var element in stateManager
                                      //     .rows) {
                                      //   stateManager
                                      //       .setRowChecked(
                                      //       element, false,
                                      //       notify: false);
                                      // }
                                      Navigator.pop(context);
                                    },
                                    icon: Icon(Icons.clear_outlined)),
                                SizedBox(width: 15),
                                ElevatedButton(
                                    onPressed: () {
                                      stateManager.setFilter((element) =>
                                          stateManager.currentCell == null
                                              ? true
                                              : element
                                                      .cells[stateManager
                                                          .currentCell!
                                                          .column
                                                          .field]!
                                                      .value ==
                                                  stateManager
                                                      .currentCell!.value);
                                    },
                                    child: Text("FS")),
                                SizedBox(width: 15),
                                ElevatedButton(
                                    onPressed: () {
                                      stateManager.setFilter((element) =>
                                          stateManager.currentCell == null
                                              ? true
                                              : element
                                                      .cells[stateManager
                                                          .currentCell!
                                                          .column
                                                          .field]!
                                                      .value !=
                                                  stateManager
                                                      .currentCell!.value);
                                    },
                                    child: Text("XF")),
                                SizedBox(width: 15),
                                ElevatedButton(
                                    onPressed: () {
                                      stateManager.setFilter((element) => true);
                                    },
                                    child: Text("RF")),
                                SizedBox(width: 15),
                                ElevatedButton(
                                    onPressed: () {
                                      customFilter(stateManager);
                                    },
                                    child: Text("CF")),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            });

        break;
      case DataGridMenuItem.customFilter:
        customFilter(stateManager);
        break;

      case null:
        break;
    }
  }


  showGridTransmissionLogFindOption(PlutoGridStateManager stateManager,
      BuildContext context) async {
    customFilter(PlutoGridStateManager stateManager) {
      List _allValues = [];
      var _selectedValues = RxList([]);
      print("1st foucus Added");
      if (stateManager.currentCell == null &&
          ((stateManager.rows.length ?? 0) > 0)) {
        stateManager.setCurrentCell(
            (stateManager.rows[0].cells.values.first), 0);
      }
      if (stateManager.currentCell != null) {
        _allValues = stateManager.rows
            .map((e) =>
            e.cells[stateManager.currentCell!.column.field]!.value
                .toString())
            .toSet()
            .toList();
      }
      Get.defaultDialog(
          title: "Custom Filter",
          content: SizedBox(
            width: Get.width / 2,
            height: Get.height / 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(stateManager.currentColumn?.title ?? "null"),
                const SizedBox(height: 5),
                Expanded(
                  child: ListView.builder(
                    controller: ScrollController(),
                    shrinkWrap: true,
                    itemBuilder: ((context, index) {
                      return Obx(
                            () =>
                            Card(
                              color: _selectedValues.contains(_allValues[index])
                                  ? Colors.deepPurple
                                  : Colors.white,
                              child: InkWell(
                                focusColor: Colors.deepPurple[200],
                                canRequestFocus: true,
                                onTap: () {
                                  if (_selectedValues.contains(
                                      _allValues[index])) {
                                    _selectedValues.remove(_allValues[index]);
                                  } else {
                                    _selectedValues.add(_allValues[index]);
                                  }
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Text(
                                    _allValues[index],
                                    style:
                                    _selectedValues.contains(_allValues[index])
                                        ? TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                        color: Colors.white)
                                        : TextStyle(
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                      );
                    }),
                    itemCount: _allValues.length,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton.icon(
                onPressed: () {
                  Get.back();
                },
                icon: Icon(Icons.clear_rounded),
                label: Text("Cancel")),
            ElevatedButton.icon(
                onPressed: () {
                  stateManager.setFilter((element) =>
                      _selectedValues.any(
                              (value) =>
                          value ==
                              element.cells[stateManager.currentCell!.column
                                  .field]!
                                  .value
                                  .toString()));
                  Get.back();
                },
                icon: Icon(Icons.done),
                label: Text("Filter")),
          ]);
    }


    showBottomSheet(
        context: context,
        builder: (context) {
          var forFN = FocusNode();
          /*WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            stateManager.gridFocusNode.unfocus();
            forFN.requestFocus();
          });*/
          var _selectedColumn = stateManager.currentColumn?.field ?? "";
          DropDownValue _preselectedColumn = DropDownValue(
              key: stateManager.currentColumn?.field ?? "",
              value: stateManager.currentColumn?.title ?? "");
          TextEditingController _findctrl = TextEditingController();
          var _almost = RxBool(true);
          var _fromstart = RxBool(false);
          int _index = stateManager.currentRowIdx ?? 0;
          return Card(
            child: Padding(
              padding: EdgeInsets.zero,
              child: Container(
                width: Get.width,
                height: 50,
                child: FocusTraversalGroup(
                  policy: OrderedTraversalPolicy(),
                  child: Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      FocusTraversalOrder(
                        order: NumericFocusOrder(1),
                        child: Row(
                          children: [
                            Text(
                              "Column",
                              // style: TextStyle(
                              //   fontSize: SizeDefine.labelSize1,
                              //   color: Colors.black,
                              //   fontWeight: FontWeight.w500,
                              // ),
                            ),
                            const SizedBox(width: 5),
                            DropDownField.formDropDown1WidthMap(
                              stateManager.columns
                                  .map((e) =>
                                  DropDownValue(
                                      key: e.field, value: e.title))
                                  .toList(),
                                  (value) {
                                _selectedColumn = value.key!;
                                _preselectedColumn = value;
                              },
                              "Column",
                              0.15,
                              selected: _preselectedColumn,
                              // context,
                              showtitle: false,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 15),
                      FocusTraversalOrder(
                        order: NumericFocusOrder(2),
                        child: Row(
                          // crossAxisAlignment: CrossAxisAlignment.center,
                          // mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 24),
                              child: Text(
                                "For",
                                // style: TextStyle(
                                //   fontSize: SizeDefine.labelSize1,
                                //   color: Colors.black,
                                //   fontWeight: FontWeight.w500,
                                // ),
                              ),
                            ),
                            const SizedBox(width: 5),
                            InputFields.formField1(
                                hintTxt: "For",
                                controller: _findctrl,
                                width: 0.15,
                                focusNode: forFN,
                                showTitle: false),
                          ],
                        ),
                      ),
                      SizedBox(width: 15),
                      FocusTraversalOrder(
                          order: NumericFocusOrder(3),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              InkWell(
                                  onTap: () {
                                    _almost.value = !_almost.value;
                                  },
                                  child: Obx(
                                        () =>
                                        Icon(_almost.value
                                            ? Icons.check_box_outlined
                                            : Icons
                                            .check_box_outline_blank_rounded),
                                  )),
                              Text("Almost"),
                            ],
                          )),
                      const SizedBox(width: 5),
                      FocusTraversalOrder(
                          order: NumericFocusOrder(4),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              InkWell(
                                  onTap: () {
                                    _fromstart.value = !_fromstart.value;
                                  },
                                  child: Obx(
                                        () =>
                                        Icon(_fromstart.value
                                            ? Icons.check_box_outlined
                                            : Icons
                                            .check_box_outline_blank_rounded),
                                  )),
                              Text("From Start")
                            ],
                          )),
                      const SizedBox(width: 15),
                      Transform.scale(
                        scale: .85,
                        child: Row(
                          children: [
                            ElevatedButton.icon(
                                label: Text(""),
                                onPressed: () {
                                  if (_findctrl.text != "" &&
                                      _selectedColumn != "") {
                                    if (_fromstart.value) {
                                      _index = -1;
                                    }
                                    var _slecetedRow = _almost.value
                                        ? stateManager.rows.firstWhereOrNull(
                                            (element) =>
                                        (element
                                            .cells[_selectedColumn]!
                                            .value
                                            .toString()
                                            .toLowerCase()
                                            .trim()
                                            .contains(_findctrl.text
                                            .toLowerCase()
                                            .trim()) &&
                                            (element.sortIdx > _index)))
                                        : stateManager.rows.firstWhereOrNull((
                                        element) =>
                                    (element.cells[_selectedColumn]!.value
                                        .toString().toLowerCase().trim() ==
                                        _findctrl.text.toLowerCase().trim() &&
                                        (element.sortIdx > _index)));

                                    if (_slecetedRow == null) {
                                      stateManager.resetScrollToZero();

                                      Get.defaultDialog(
                                          content: Text(
                                              "You Have reach the end !\nDo u want to restart?"),
                                          actions: [
                                            ElevatedButton.icon(
                                                onPressed: () {
                                                  _index = 0;
                                                  stateManager
                                                      .resetScrollToZero();
                                                  Get.back();
                                                  var _slecetedRow = _almost
                                                      .value
                                                      ? stateManager.rows
                                                      .firstWhereOrNull((
                                                      element) =>
                                                  (element
                                                      .cells[
                                                  _selectedColumn]!
                                                      .value
                                                      .toString()
                                                      .toLowerCase()
                                                      .trim()
                                                      .contains(_findctrl.text
                                                      .toLowerCase()
                                                      .trim()) &&
                                                      (_index == 0 ||
                                                          element.sortIdx >
                                                              (_index ??
                                                                  0))))
                                                      : stateManager.rows
                                                      .firstWhere((element) =>
                                                  (element
                                                      .cells[_selectedColumn]!
                                                      .value.toString()
                                                      .toLowerCase()
                                                      .trim() == _findctrl.text
                                                      .toLowerCase().trim() &&
                                                      (_index == 0 ||
                                                          element.sortIdx >
                                                              (_index ?? 0))));
                                                  print(_slecetedRow!
                                                      .cells[
                                                  _selectedColumn]!
                                                      .value
                                                      .toString() +
                                                      _slecetedRow
                                                          .cells[
                                                      _selectedColumn]!
                                                          .value
                                                          .runtimeType
                                                          .toString());
                                                  _index =
                                                      _slecetedRow.sortIdx;
                                                  stateManager
                                                      .resetScrollToZero();

                                                  stateManager
                                                      .moveScrollByRow(
                                                      PlutoMoveDirection
                                                          .down,
                                                      _slecetedRow
                                                          .sortIdx -
                                                          1);

                                                  stateManager
                                                      .setKeepFocus(false);
                                                  // for (var element in stateManager
                                                  //     .rows) {
                                                  //   stateManager
                                                  //       .setRowChecked(
                                                  //       element, false,
                                                  //       notify: false);
                                                  // }
                                                  // stateManager
                                                  //     .setRowChecked(
                                                  //     _slecetedRow, true,
                                                  //     notify: true);
                                                  stateManager.setCurrentCell(
                                                      _slecetedRow.cells[
                                                      _selectedColumn],
                                                      _slecetedRow.sortIdx);
                                                },
                                                icon: Icon(Icons.done),
                                                label: Text("YES")),
                                            ElevatedButton.icon(
                                                onPressed: () {
                                                  Get.back();
                                                },
                                                icon: Icon(Icons.clear),
                                                label: Text("NO")),
                                          ]);
                                    } else {
                                      if (_fromstart.value) {
                                        _fromstart.value = false;
                                      }
                                      _index = _slecetedRow.sortIdx;
                                      stateManager.resetScrollToZero();
                                      if (_index <= 10) {
                                        stateManager.moveScrollByRow(
                                            PlutoMoveDirection.up,
                                            _slecetedRow.sortIdx);
                                      } else {
                                        stateManager.moveScrollByRow(
                                            PlutoMoveDirection.down,
                                            _slecetedRow.sortIdx);
                                      }
                                      stateManager.setKeepFocus(false);
                                      stateManager.setCurrentCell(
                                          _slecetedRow
                                              .cells[_selectedColumn],
                                          _slecetedRow.sortIdx);
                                      // print(_slecetedRow
                                      //         .cells[_selectedColumn]!.value
                                      //         .toString() +
                                      //     _slecetedRow
                                      //         .cells[_selectedColumn]!
                                      //         .value
                                      //         .runtimeType
                                      //         .toString());
                                      // print("Index selected is>>" +
                                      //     _slecetedRow.sortIdx.toString());
                                      // if (_slecetedRow.sortIdx == 0) {
                                      //   _index = 1;
                                      // } else {
                                      //   _index = _slecetedRow.sortIdx;
                                      // }

                                      // stateManager.resetScrollToZero();
                                      // stateManager.moveScrollByRow(
                                      //     PlutoMoveDirection.down,
                                      //     _slecetedRow.sortIdx);
                                      // stateManager.setKeepFocus(false);
                                      // for (var element in stateManager
                                      //     .rows) {
                                      //   stateManager.setRowChecked(
                                      //       element, false, notify: false);
                                      // }
                                      // stateManager.setRowChecked(
                                      //     _slecetedRow, true, notify: true);
                                      // if (stateManager.currentRow != null &&
                                      //     stateManager
                                      //             .currentRow?.sortIdx ==
                                      //         0 &&
                                      //     _slecetedRow.sortIdx == 2) {
                                      //   stateManager.setCurrentCell(
                                      //       stateManager
                                      //           .getRowByIdx(
                                      //               _slecetedRow.sortIdx -
                                      //                   1)
                                      //           ?.cells[_selectedColumn],
                                      //       _slecetedRow.sortIdx - 1);
                                      // } else {
                                      //   stateManager.setCurrentCell(
                                      //       _slecetedRow
                                      //           .cells[_selectedColumn],
                                      //       _slecetedRow.sortIdx);
                                      // }
                                    }
                                  }
                                },
                                icon: Icon(Icons
                                    .keyboard_double_arrow_right_rounded)),
                            SizedBox(width: 15),
                            ElevatedButton.icon(
                                label: Text(""),
                                onPressed: () {
                                  // for (var element in stateManager
                                  //     .rows) {
                                  //   stateManager
                                  //       .setRowChecked(
                                  //       element, false,
                                  //       notify: false);
                                  // }
                                  Navigator.pop(context);
                                },
                                icon: Icon(Icons.clear_outlined)),
                            SizedBox(width: 15),
                            ElevatedButton(
                                onPressed: () {
                                  stateManager.setFilter((element) =>
                                  stateManager.currentCell == null
                                      ? true
                                      : element
                                      .cells[stateManager
                                      .currentCell!
                                      .column
                                      .field]!
                                      .value ==
                                      stateManager
                                          .currentCell!.value);
                                },
                                child: Text("FS")),
                            SizedBox(width: 15),
                            ElevatedButton(
                                onPressed: () {
                                  stateManager.setFilter((element) =>
                                  stateManager.currentCell == null
                                      ? true
                                      : element
                                      .cells[stateManager
                                      .currentCell!
                                      .column
                                      .field]!
                                      .value !=
                                      stateManager
                                          .currentCell!.value);
                                },
                                child: Text("XF")),
                            SizedBox(width: 15),
                            ElevatedButton(
                                onPressed: () {
                                  stateManager.setFilter((element) => true);
                                },
                                child: Text("RF")),
                            SizedBox(width: 15),
                            ElevatedButton(
                                onPressed: () {
                                  customFilter(stateManager);
                                },
                                child: Text("CF")),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}

enum DataGridMenuItem {
  delete,
  cut,
  copy,
  paste,
  clearpaste,
  verifyTime,
  fixedEvent,
  freezeColumn,
  unFreezeColumn,
  removeMarkError,
  rescheduleSpots,
  export,
  print,
  removeLastFilter,
  exportToCSv,
  exportPDF,
  exportToXml,
  find,
  selectedfilter,
  excludeslected,
  customFilter,
  clearfilter,
  noaction,
  setPriority,
  clearPriority,
  extraList,
}

class SecondaryShowDialogModel {
  String title;
  Function callback;

  SecondaryShowDialogModel(this.title, this.callback);
}
