import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:math' as math;
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:intl/intl.dart';
import 'package:bms_scheduling/widgets/PlutoGrid/pluto_grid.dart';
import '../../../../widgets/DateTime/DateWithThreeTextField.dart';
import '../../../../widgets/DateWidget.dart';
import '../../../../widgets/FormButton.dart';
import '../../../../widgets/LoadingDialog.dart';
import '../../../../widgets/Snack.dart';
import '../../../../widgets/dropdown.dart';
import '../../../../widgets/editable_text.dart';
import '../../../../widgets/input_fields.dart';
import '../../../controller/ConnectorControl.dart';
import '../../../controller/MainController.dart';
import '../../../data/DropDownValue.dart';
import '../../../providers/ApiFactory.dart';
import '../../../providers/ExportData.dart';
import '../../../providers/Utils.dart';
import '../search_bindgrid.dart';
import '../views/pivotPage.dart';
import '../views/searchResult.dart';

class SearchController extends GetxController {
  SearchController(
      this.strViewName,
      this.screenName, {
        this.isPopUp = false,
        this.actionableSearch = false,
        this.actionableMap,
        this.dialogClose,
      });

  final String screenName;
  final void Function(dynamic)? dialogClose;
  final String strViewName;
  final bool? isPopUp;
  final bool actionableSearch;
  final Map<String, Function(String value)>? actionableMap;
  FocusNode gridFN = FocusNode();

  SearchBindGrid? grid;
  List? searchResult;
  List? searchPivotResult;
  List chklstRows = [];
  List chklstDataField = [];
  List chklstColumns = [];
  String cboAggregrateFunction = "";
  late PlutoGridStateManager gridStateManager;
  List<PlutoRow> rows = [];

  /////// MASTER SEARCH DAILOG //////
  var masterDialogList = RxList();
  var checknotcheck = RxBool(false);

  //////////////////////////////////
  var addsum = RxBool(false);
  List<DataColumn2> searchGridColumns = [];
  List<DataRow2> searchGridRows = [];
  List<DataRow2> filterSearchGridRows = [];
  List varainace = [];
  int? selectVarianceId;
  String searchQuery = "";

  String ?formName;
  @override
  void onInit() {
    formName = Utils.getPageRouteName();
    print(">>>>>formName onInit"+formName.toString());
    getInitialData();
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    gridFN.onKey = (node, event) {
      if (event is RawKeyDownEvent &&
          event.logicalKey == LogicalKeyboardKey.arrowDown) {
        gridFN.nextFocus();
        gridFN.nextFocus();
        gridFN.nextFocus();
        return KeyEventResult.ignored;
      } else if (event is RawKeyDownEvent &&
          event.logicalKey == LogicalKeyboardKey.arrowUp) {
        gridFN.previousFocus();
        gridFN.previousFocus();
        gridFN.previousFocus();
        return KeyEventResult.ignored;
      }
      return KeyEventResult.ignored;
    };
  }

  parsePivotTemplate(String templateString) {
    List template = templateString.split("#");
    cboAggregrateFunction = template[3];

    chklstDataField = (template[2].split("~"));
    chklstRows = template[0].split("~");
    chklstColumns = template[1].split("~");
    chklstColumns.removeWhere((element) => element == "");
    chklstRows.removeWhere((element) => element == "");
    chklstDataField.removeWhere((element) => element == "");
  }

  String getPivotTemplate() {
    if (chklstColumns.isEmpty ||
        chklstDataField.isEmpty ||
        chklstRows.isEmpty ||
        cboAggregrateFunction == "") {
      return "";
    } else {
      String template = "";
      for (var row in chklstRows) {
        template = template + "~$row~";
      }
      template = template + "#";
      for (var col in chklstColumns) {
        template = template + "~$col~";
      }
      template = template + "#";
      for (var data in chklstDataField) {
        template = template + "~$data~";
      }
      template = template + "#";
      template = template + cboAggregrateFunction;
      return template;
    }
  }

  formHandler(btnName) async {
    if (btnName == "Execute") {
      await executeSearch();
    }
    if (btnName == "Exit ") {
      dialogClose!(null);
    }
    if (btnName == "Clear") {
      grid = null;
      varainace = [];
      addsum.value = false;
      selectVarianceId = null;
      print(selectVarianceId.toString());
      update(["initialData"]);
      getInitialData();
    }

    if (btnName == "Add Variance") {
      TextEditingController _textEditingController = TextEditingController();
      var allUsers = RxBool(false);

      var databody = grid!.toJson();
      databody["pivotTemplate"] = getPivotTemplate();

      Get.defaultDialog(
          title: "Variance Name",
          content: Column(
            children: [
              InputFields.formField1(
                  hintTxt: "Add Vairiant",
                  controller: _textEditingController,
                  width: 0.30),
              Row(
                children: [
                  Obx(() => Checkbox(
                      value: allUsers.value,
                      onChanged: (value) {
                        allUsers.value = value!;
                      })),
                  Text("Add for all users")
                ],
              )
            ],
          ),
          actions: [
            /* FormButton(
              icon: Icon(Icons.clear),
              label: Text("Cancel"),
              onPressed: () {
                Get.back();
              },
            ),*/
            FormButtonWrapper(
              btnText: "Cancel",
              callback: () => Get.back(),
            ),
            FormButtonWrapper(
              btnText: "Clear",
              callback: () => _textEditingController.text = "",
            ),
            /* FormButton(
              icon: Icon(Icons.add),
              label: Text("Clear"),
              onPressed: () {
                _textEditingController.text="";
              },
            ),*/
            FormButtonWrapper(
              btnText: "Add Variance",
              callback: () async {
                try {
                  LoadingDialog.call();
                  await Get.find<ConnectorControl>().POSTMETHOD_FORMDATA_HEADER(
                      api: ApiFactory.ADD_SEARCH_VARIANCE(
                        screenName: screenName,
                        loginCode: allUsers.value
                            ? ""
                            : Get.find<MainController>().user?.logincode ?? "",
                        sVariant: _textEditingController.text,
                        strViewName: strViewName,
                      ),
                      json: databody,
                      fun: (value) {
                        Get.back();
                        Get.back();
                        // Snack.callSuccess("Varirant Added");
                        LoadingDialog.callDataSaved(msg: "Variance Added");
                      });
                } catch (e) {
                  Get.back();
                  Get.back();
                  // Snack.callError("Something Went Wrong");
                  LoadingDialog.showErrorDialog("Something Went Wrong");
                }
              },
            ),
            /*FormButton(
              onPressed: () async {
                try {
                  LoadingDialog.call();
                  await Get.find<ConnectorControl>().POSTMETHOD_FORMDATA(
                      api: ApiFactory.ADD_SEARCH_VARIANCE(
                        screenName: screenName,
                        loginCode: allUsers.value
                            ? ""
                            : Get.find<MainController>().user?.logincode ?? "",
                        sVariant: _textEditingController.text,
                        strViewName: strViewName,
                      ),
                      json: databody,
                      fun: (value) {
                        Get.back();
                        Get.back();
                        // Snack.callSuccess("Varirant Added");
                        LoadingDialog.callDataSaved(msg: "Varirant Added");
                      });
                } catch (e) {
                  Get.back();
                  Get.back();
                  // Snack.callError("Something Went Wrong");
                  LoadingDialog.showErrorDialog("Something Went Wrong");
                }
              },
              icon: Icon(Icons.done),
              label: Text("Add Variant"),
            )*/
          ]);
    }
    if (btnName == "Delete Variance") {
      print(selectVarianceId.toString());
      if (selectVarianceId == null) {
        LoadingDialog.showErrorDialog("Please Select Variance");
      } else {
        Get.defaultDialog(
            title: "Delete Variance",
            content: Text("Do you want to delete selected Variance?"),
            actions: [
              FormButton(
                // icon: Icon(Icons.clear),
                btnText: "No",
                callback: () {
                  Get.back();
                },
              ),
              FormButton(
                callback: () async {
                  LoadingDialog.call();
                  try {
                    await Get.find<ConnectorControl>()
                        .POSTMETHOD_FORMDATA_HEADER(
                        json: {},
                        api: ApiFactory.DELETE_SEARCH_VARIANCE(
                            screenName: screenName,
                            varianceId: selectVarianceId.toString(),
                            loginCode: Get.find<MainController>()
                                .user
                                ?.logincode ??
                                ""),
                        fun: (value) async {
                          Get.back();
                          Get.back();
                          LoadingDialog.callDataSavedMessage(
                              "Variance Deleted Successfully");
                          //Snack.callSuccess("Varinat Deleted Successfully");
                        });
                  } catch (e) {
                    Get.back();
                    // Snack.callError("Something Went Wrong");
                    LoadingDialog.showErrorDialog("Something Went Wrong");
                  }
                },
                // icon: Icon(Icons.done),
                btnText: "Yes",
              )
            ]);
      }
    }
  }

  pivotBtnHandler(btnName, isDirect) async {
    if (btnName == "Exit ") {
      dialogClose!(null);
    }
    if (btnName == "Save") {
      ExportData().exportExcelFromJsonList(searchResult, screenName);
    }
    if (btnName == "Done") {
      Get.back();
      Get.back();
    }
    if (btnName == "Data") {
      Get.back();
      if (isDirect) {
        LoadingDialog.call();
        await Get.find<ConnectorControl>().POSTMETHOD_FORMDATA_HEADER(
            api: ApiFactory.SEARCH_EXECUTE_SEARCH(
                screenName: screenName,
                strViewName: strViewName,
                loginCode: Get.find<MainController>().user?.logincode ?? ""),
            json: grid!.toJson(),
            fun: (value) {
              searchResult = jsonDecode(value)["Table"];
              if (searchResult is String) {
                LoadingDialog.showErrorDialog(value);
              } else {
                print(value);
                print(value.runtimeType.toString());
                searchResult = jsonDecode(value)["Table"];
                Get.back();
                if (searchResult!.isEmpty) {
                  // Snack.callError("NO Data");
                  LoadingDialog.showErrorDialog("NO Data");
                } else {
                  Get.to(() => SearchResultPage(
                    controller: this,
                    appFormName: this.strViewName,
                    fromName:formName,
                  ));
                }
              }
            });
      }
    }
    if (btnName == "Refresh") {
      LoadingDialog.call();
      if (isDirect) {
        await Get.find<ConnectorControl>().POSTMETHOD_FORMDATA_HEADER(
          api: ApiFactory.SEARCH_EXCUTE_PIVOT(
            screenName: screenName,
            strViewname: strViewName,
          ),
          json: {
            "variances": grid!.variances!.map((e) => e.toJson()).toList(),
            "type": grid!.type,
            "pivotTemplate": grid!.pivotTemplate,
          },
          fun: (json) {
            Get.back();
            Get.back();
            if (json is String) {
              LoadingDialog.showErrorDialog(json);
            } else {
              searchPivotResult = json;
              Get.to(() => SearchPivotPage(
                directPivot: true,
                controller: this,
                searchForm: strViewName,
              ));
            }
          },
        );
      } else {
        try {
          await Get.find<ConnectorControl>().POSTMETHOD_FORMDATA_HEADER(
              api: ApiFactory.SEARCH_PIVOT(
                screenName: screenName,
              ),
              json: {
                "AggregateSelected": cboAggregrateFunction,
                "DataFields": chklstDataField,
                "RowFields": chklstRows,
                "ColumnFields": chklstColumns,
                "originalData": searchResult
              },
              fun: (value) async {
                searchPivotResult = value;
                Get.back();
                Get.back();
                Get.to(() => SearchPivotPage(controller: this));
              });
        } catch (e) {
          Get.back();
          // Snack.callError("Something Went Wrong");
          LoadingDialog.showErrorDialog("Something Went Wrong");
        }
      }
    }
  }

  searchResultBtnHandler(btnName) async {
    if (btnName == "Exit ") {
      dialogClose!(null);
    }
    if (btnName == "Save") {
      ExportData().exportExcelFromJsonList(searchResult, screenName);
    }
    if (btnName == "Done") {
      Get.back();
    }
    if (btnName == "Refresh") {
      Get.back();
      executeSearch();
    }
    if (btnName == "Pivot") {
      List allFields = searchResult!.isEmpty
          ? []
          : searchResult![0].keys.map((e) => e).toList();
      var dataFields = RxList(chklstDataField);
      var rowFields = RxList(chklstRows);
      var columnFields = RxList(chklstColumns);
      var aggerateFnc =
      cboAggregrateFunction == "" ? "Average" : cboAggregrateFunction;
      Get.defaultDialog(
          title: "Pivot Your Data",
          content: Column(
            children: [
              DropDownField.formDropDown1WidthMap(
                ["Average", "Sum", "Count", "Min", "Max"]
                    .map((e) => DropDownValue(key: e, value: e))
                    .toList(),
                    (value) {
                  aggerateFnc = value.value!;
                },
                "Aggergate Function",
                0.20,
                // Get.context,
                selected: DropDownValue(
                  key: cboAggregrateFunction,
                  value: cboAggregrateFunction,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(width: Get.width * 0.15, child: Text("Data Fields")),
                  SizedBox(width: Get.width * 0.15, child: Text("Row Fields")),
                  SizedBox(
                      width: Get.width * 0.15, child: Text("Columns Fields")),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: Get.width * 0.15,
                    height: Get.height / 2,
                    child: ListView.builder(
                        controller: ScrollController(),
                        itemBuilder: (context, index) {
                          return Card(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Obx(() => Checkbox(
                                    value:
                                    dataFields.contains(allFields[index]),
                                    onChanged: (value) {
                                      if (value!) {
                                        dataFields.add(allFields[index]);
                                      } else {
                                        dataFields.remove(allFields[index]);
                                      }
                                    })),
                                Text(allFields[index])
                              ],
                            ),
                          );
                        },
                        itemCount: allFields.length),
                  ),
                  Container(
                    width: Get.width * 0.15,
                    height: Get.height / 2,
                    child: ListView.builder(
                        controller: ScrollController(),
                        itemBuilder: (context, index) {
                          return Card(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Obx(() => Checkbox(
                                    value: rowFields.contains(allFields[index]),
                                    onChanged: (value) {
                                      if (value!) {
                                        rowFields.add(allFields[index]);
                                      } else {
                                        rowFields.remove(allFields[index]);
                                      }
                                    })),
                                Text(allFields[index])
                              ],
                            ),
                          );
                        },
                        itemCount: allFields.length),
                  ),
                  Container(
                    width: Get.width * 0.15,
                    height: Get.height / 2,
                    child: ListView.builder(
                        controller: ScrollController(),
                        itemBuilder: (context, index) {
                          return Card(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Obx(() => Checkbox(
                                    value:
                                    columnFields.contains(allFields[index]),
                                    onChanged: (value) {
                                      if (value!) {
                                        columnFields.add(allFields[index]);
                                      } else {
                                        columnFields.remove(allFields[index]);
                                      }
                                    })),
                                Text(allFields[index])
                              ],
                            ),
                          );
                        },
                        itemCount: allFields.length),
                  ),
                ],
              )
            ],
          ),
          actions: [
            FormButton(
              // icon: Icon(Icons.clear),
              btnText: "Cancel",
              callback: () {
                Get.back();
              },
            ),
            FormButton(
              callback: () async {
                LoadingDialog.call();
                cboAggregrateFunction = aggerateFnc;
                chklstDataField = dataFields;
                chklstRows = rowFields;
                chklstColumns = columnFields;
                try {
                  await Get.find<ConnectorControl>().POSTMETHOD_FORMDATA_HEADER(
                      api: ApiFactory.SEARCH_PIVOT(
                        screenName: screenName,
                      ),
                      json: {
                        "AggregateSelected": aggerateFnc,
                        "DataFields": dataFields,
                        "RowFields": rowFields,
                        "ColumnFields": columnFields,
                        "originalData": searchResult
                      },
                      fun: (value) async {
                        searchPivotResult = value;
                        Get.back();
                        Get.back();
                        Get.to(() => SearchPivotPage(controller: this));
                      });
                } catch (e) {
                  Get.back();
                  // Snack.callError("Something Went Wrong");
                  LoadingDialog.showErrorDialog("Something Went Wrong");
                }
              },
              // icon: Icon(Icons.done),
              btnText: "Show Pivot",
            )
          ]);
    }
  }

  updateGrid({String? value = ""}) async {
    searchGridColumns = [];
    searchGridRows = [];
    for (var key in grid!.variances![0].toJson().keys) {
      if (key != "dataType" && key != "tableName" && key != "valueColumnName") {
        searchGridColumns.add(DataColumn2(
          size: ColumnSize.S,
          label: key == "name"
              ? Text(
            key.capitalizeFirst!,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          )
              : Center(
            heightFactor: 1,
            child: Text(
              key.capitalizeFirst!,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 12),
            ),
          ),
        ));
      }
    }
    for (var variance in value == ""
        ? grid!.variances!
        : grid!.variances!.where((element) =>
        element.name!.toLowerCase().contains(value!.toLowerCase()))) {
      var row = variance.toJson();
      if (!(row["name"]).contains("code")) {
        List<DataCell> cells = [];
        for (var key in row.keys) {
          if (key != "dataType" &&
              key != "tableName" &&
              key != "valueColumnName") {
            log(row["searchCriteria"].toString());
            cells.add(DataCell(key != "name"
                ? Center(
              child: row[key] is bool
                  ? Checkbox(
                  focusColor: Colors.deepPurple[200],
                  value: row[key],
                  onChanged: (value) {
                    if (key == "selected") {
                      var selected = grid!.variances!.where(
                              (element) => element.selected == true);
                      if (selected.isEmpty) {
                        row["sequence"] = 1;
                      } else {
                        var _variance = grid!.variances!
                            .where(
                                (element) => element.selected == true)
                            .map((e) => e.sequence)
                            .toList();
                        row["sequence"] = (_variance.reduce(
                                (value, nxtvalue) =>
                            (value!) > (nxtvalue!)
                                ? value
                                : nxtvalue) ??
                            1) +
                            1;
                      }
                    }
                    row[key] = value;
                    grid!.variances![grid!.variances!.indexWhere(
                            (element) =>
                        element.name == row["name"])] =
                        Variances.fromJson(row);

                    updateGrid();
                  })
                  : key == "searchCriteria"
                  ? ChangableText(
                focusColor: Colors.deepPurple[200],
                key: Key(row["name"] +
                    "${math.Random().nextInt(342)}"),
                intialtext: row["searchCriteria"].toString(),
                onChange: (value) {
                  grid!
                      .variances![grid!.variances!.indexWhere(
                          (element) =>
                      element.name == row["name"])]
                      .searchCriteria = value;
                },
                onDoubleTap: () {
                  print("onDoubleTap===>>>>>>>>>>>>");
                  doubleClickHandler(variance);
                },
              )
                  : Text(
                row[key].toString(),
                textAlign: TextAlign.left,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            )
                : Text(
              row[key].toString(),
              textAlign: TextAlign.left,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            )));
          }
        }
        searchGridRows.add(DataRow2(
          cells: cells,
          selected: grid!
              .variances![grid!.variances!
              .indexWhere((element) => element.name == row["name"])]
              .selected!,
        ));
      }
    }
    update(["searchGrid"]);
    // searchGridColumns = grid!.variances![0]
    //     .toJson()
    //     .keys
    //     .map((e) => DataColumn2(label: label))
    //     .toList();
  }

  var selectedRow = 0.obs;

  // void handleArrowKey(RawKeyEvent event) {
  //   if (event is RawKeyDownEvent) {
  //     if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
  //       if (selectedRow.value < searchGridColumns.length - 1) {
  //         selectedRow.value++;
  //         FocusScope.of(Get.context!).nextFocus();
  //       }
  //     } else if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
  //       if (selectedRow.value > 0) {
  //         selectedRow.value--;
  //         FocusScope.of(Get.context!).previousFocus();
  //       }
  //     }
  //   }
  // }

  executeSearch() async {
    LoadingDialog.call();
    try {
      if ((grid!.pivotTemplate!) != "" &&
          (grid!.pivotTemplate!.split("#").length == 4)) {
        if (grid!.pivotTemplate!.isNotEmpty) {
          parsePivotTemplate(grid!.pivotTemplate!);
          await Get.find<ConnectorControl>().POSTMETHOD_FORMDATA_HEADER(
            api: ApiFactory.SEARCH_EXCUTE_PIVOT(
              screenName: screenName,
              strViewname: strViewName,
            ),
            json: {
              "variances": grid!.variances!.map((e) => e.toJson()).toList(),
              "type": grid!.type,
              "pivotTemplate": grid!.pivotTemplate,
            },
            fun: (json) {
              Get.back();
              if (json is String) {
                LoadingDialog.showErrorDialog(json);
              }
              else {
                searchPivotResult = json;
                if (dialogClose != null) {
                  dialogClose!(null);
                  dialogClose!(SearchPivotPage(
                    directPivot: true,
                    controller: this,
                    searchForm: strViewName,
                    dialogClose: dialogClose,
                  ));
                } else {
                  Get.to(() => SearchPivotPage(
                    directPivot: true,
                    controller: this,
                    searchForm: strViewName,
                  ));
                }
              }
            },
          );
        }
        // List template = grid!.pivotTemplate!.split("#");
        // await Get.find<ConnectorControl>().POSTMETHOD_FORMDATA(
        //     api: ApiFactory.SEARCH_PIVOT(
        //       screenName: screenName,
        //     ),
        //     json: {
        //       "AggregateSelected": template[3],
        //       "DataFields": template[1].split("1"),
        //       "RowFields": template[0].split("~"),
        //       "ColumnFields": template[1].split("~"),
        //       "originalData": grid!.variances!.map((e) => e.toJson()).toList()
        //     },
        //     fun: (value) async {
        //       Get.back();
        //       searchPivotResult = value;
        //       Get.to(() => SearchPivotPage(
        //             controller: this,
        //             searchForm: this.strViewName,
        //           ));
        //     });
      } else {
        await Get.find<ConnectorControl>().POSTMETHOD_FORMDATA_HEADER(
            api: ApiFactory.SEARCH_EXECUTE_SEARCH(
                screenName: screenName,
                strViewName: strViewName,
                loginCode: Get.find<MainController>().user?.logincode ?? ""),
            json: grid!.toJson(),
            fun: (value) {
              var dataValue = jsonDecode(value);
              Get.back();
              if (dataValue is String) {
                LoadingDialog.showErrorDialog(value);
              } else {
                print(value);
                print(value.runtimeType.toString());
                searchResult = jsonDecode(value)["Table"];

                if (searchResult!.isEmpty) {
                  // Snack.callError("NO Data");
                  LoadingDialog.showErrorDialog("NO Data");
                } else {
                  if (dialogClose != null) {
                    // dialogClose!(null);
                    dialogClose!(SearchResultPage(
                      controller: this,
                      appFormName: this.strViewName,
                      actionableMap: this.actionableMap,
                      actionableSearch: this.actionableSearch,
                      dialogClose: dialogClose,
                      fromName: formName,
                    ));
                  } else {
                    Get.to(() => SearchResultPage(
                      controller: this,
                      appFormName: this.strViewName,
                      actionableMap: this.actionableMap,
                      actionableSearch: this.actionableSearch,
                      fromName: formName,
                    ));
                  }
                }
              }
            });
      }
    } catch (e) {
      Get.back();
      // Snack.callError("Something Went Wrong");
      LoadingDialog.showErrorDialog("Server timeout. Please try again later");
    }
  }

  doubleClickHandler(Variances rowvariance) {
    // print(">>>>>>row data type${rowvariance.dataType} - ${grid!.type}");
    if (rowvariance.dataType == "datetime" && grid!.type == "V") {
      var dateType = RxString("My Dates");
      // String from = DateFormat('dd-MMM-yyyy').format(DateTime.now());
      // String to = DateFormat('dd-MMM-yyyy').format(DateTime.now());
      List queries = [
        "between '${DateFormat('dd-MMM-yyyy').format(DateTime.now())}' and '${DateFormat('dd-MMM-yyyy').format(DateTime.now())}'",
        " = CONVERT ( date , GETDATE() ) ",
        " = CONVERT ( date , GETDATE()+1 ) ",
        " Between dateadd ( day , - datepart ( day , getdate() ) + 1 , CONVERT ( date , getdate() )) AND dateadd ( day, - datepart ( day , getdate() ) , dateadd ( month , 1 , CONVERT ( date , getdate() )))",
        " between convert ( date , convert ( varchar(10) , year( getdate()) + case when month ( getdate() ) < 3 then -1 else 0 end ) + '0401' , 112 ) and convert ( date , dateadd ( day , - datepart ( day , getdate() ) , dateadd ( month , 1 , getdate() )))",
        " between convert ( varchar(6) , dateadd ( month , -1 , getdate() ) , 112 ) + '01' and dateadd ( day , - datepart ( day , getdate() ) , getdate() ) "
      ];

      List dateTypes = [
        "My Dates",
        "Today",
        "Tomorrow",
        "Current Month",
        "Current Year",
        "Last Month"
      ];
      var fromTextCtr = TextEditingController(),
          toTextCtr = TextEditingController();
      Get.defaultDialog(
          title: rowvariance.name!,
          content: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  DateWithThreeTextField(
                    title: "Between",
                    mainTextController: fromTextCtr,
                    // onFocusChange: (date) {
                    //   from = DateFormat("dd-MMM-yyyy")
                    //       .format(DateFormat('dd-MM-yyyy').parse(fromTextCtr.text));
                    // },
                  ),
                  const SizedBox(width: 15),
                  DateWithThreeTextField(
                    title: "And",
                    mainTextController: toTextCtr,
                    // onFocusChange: (date) {
                    //   to = DateFormat("dd-MMM-yyyy")
                    //       .format(DateFormat('dd-MM-yyyy').parse(toTextCtr.text));
                    // },
                  ),
                  // DateWidget.date(
                  //   Get.context,
                  //   "Between",
                  //   (data) {
                  //     from = DateFormat('dd-MMM-yyyy').format(data);
                  //   },
                  //   false,
                  //   validator: (value) {
                  //     if (value == null || value == "") {
                  //       return "Please Effective From Date ";
                  //     }
                  //   },
                  //   width: 0.20,
                  //   // preslected: DateFormat("yyyy-MM-dd")
                  //   //     .format(DateTime.parse(controller
                  //   //         .inwardinitialData!.currentSQLDate!))
                  //   //     .toString()
                  // ),
                  // DateWidget.date(
                  //   Get.context,
                  //   "And",
                  //   (data) {
                  //     to = DateFormat('dd-MMM-yyyy').format(data);
                  //   },
                  //   false,
                  //   validator: (value) {
                  //     if (value == null || value == "") {
                  //       return "Please Effective From Date ";
                  //     }
                  //   },
                  //   width: 0.20,
                  //   // preslected: DateFormat("yyyy-MM-dd")
                  //   //     .format(DateTime.parse(controller
                  //   //         .inwardinitialData!.currentSQLDate!))
                  //   //     .toString()
                  // )
                ],
              ),
              Row(
                children: dateTypes
                    .map(
                      (e) => Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: Row(
                      children: [
                        Obx(
                              () => Radio<String>(
                              value: e,
                              groupValue: dateType.value,
                              onChanged: (value) {
                                log(dateType.value);
                                dateType.value = value as String;
                              }),
                        ),
                        Text(e),
                      ],
                    ),
                  ),
                )
                    .toList(),
              )
            ],
          ),
          actions: [
            /* FormButton(
                onPressed: () {

                },
                icon: Icon(Icons.done),
                label: Text("Done")),*/
            FormButton(
              btnText: "Done",
              callback: () {
                if (dateType.value == "My Dates") {
                  grid!.variances!
                      .firstWhere((element) => element.name == rowvariance.name)
                      .searchCriteria =
                  "between '${DateFormat("dd-MMM-yyyy").format(DateFormat('dd-MM-yyyy').parse(fromTextCtr.text))}' and '${DateFormat("dd-MMM-yyyy").format(DateFormat('dd-MM-yyyy').parse(toTextCtr.text))}'";
                } else {
                  grid!.variances!
                      .firstWhere((element) => element.name == rowvariance.name)
                      .searchCriteria =
                  queries[
                  dateTypes.indexWhere((dType) => dateType == dType)];
                }
                // grid!.variances!
                //         .firstWhere((element) => element.name == rowvariance.name)
                //         .searchCriteria =
                //     "${checknotcheck.value ? "Not In" : "In"} ${masterDialogList.where((e) => e["selected"] == true).map((e) => "'${e["name"]}'")}";
                updateGrid();
                Get.back();
              },
            ),
            FormButton(
              btnText: "Clear",
              callback: () {
                grid!.variances!
                    .firstWhere((element) => element.name == rowvariance.name)
                    .searchCriteria = "";
                updateGrid();

                Get.back();
              },
            ),
            /*
            FormButton(
                onPressed: () {

                },
                icon: Icon(Icons.remove_circle_outline),
                label: Text("Clear")),*/
            FormButton(
              btnText: "Cancel",
              callback: () {
                masterDialogList.value = [];
                checknotcheck.value = false;
                Get.back();
              },
            ),
            /*  FormButton(
                onPressed: () {
                  masterDialogList.value = [];
                  checknotcheck.value = false;
                  Get.back();
                },
                icon: Icon(Icons.clear),
                label: Text("Cancel")),*/
          ],
          radius: 10.0);
    }
    else if ((rowvariance.dataType == "varchar" ||
        rowvariance.dataType == "char") &&
        rowvariance.tableName != "") {
      var allselect = RxBool(false);
      if (rowvariance.searchCriteria != "") {
        List<String> tempser = [];
        try {
          tempser = rowvariance.searchCriteria
              ?.replaceAll("In ('", "")
              .replaceAll("in ( '", "")
              .replaceAll("Not In('", "")
              .replaceAll(")", "")
              .replaceAll("'", "")
              .split(",") ??
              [];
        } catch (e) {
          print(e.toString());
        }
        List tempmaster = [];
        for (var element in tempser) {
          tempmaster.add({"name": element, "selected": true});
        }
        masterDialogList.addAll(tempmaster);
      }
      ///// Master Dialog /////
      Get.defaultDialog(
          title: rowvariance.name.toString(),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      Obx(
                            () => Checkbox(
                            value: checknotcheck.value,
                            onChanged: (value) {
                              checknotcheck.value = value!;
                            }),
                      ),
                      Text("Like / Not Like")
                    ],
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  InputFields.formField1(
                      hintTxt: "",
                      autoFocus: true,
                      controller: TextEditingController(),
                      inputformatters: [
                        FilteringTextInputFormatter.deny("  "),
                        // FilteringTextInputFormatter.deny("  "),
                      ],
                      onchanged: (value) {
                        if (value == "%%" || value.length > 2) {
                          masterDialogList.removeWhere(
                                  (element) => element["selected"] == false);
                          Get.find<ConnectorControl>()
                              .GET_METHOD_CALL_HEADER(
                              api: ApiFactory.SEARCH_MASTER_SEARCH(
                                  screenName: screenName,
                                  name: rowvariance.name.toString(),
                                  valuecolumnname:
                                  rowvariance.valueColumnName!,
                                  TableName: rowvariance.tableName!,
                                  chkLikeNotLike: checknotcheck.value,
                                  searchvalue: value),
                              fun: (map) {
                                if (map is List) {
                                  var templist = [];
                                  for (var element in map) {
                                    if (masterDialogList
                                        .firstWhereOrNull((value) =>
                                    element["name"] ==
                                        value["name"]) ==
                                        null) {
                                      element["selected"] = false;
                                      templist.add(element);
                                    }
                                  }
                                  masterDialogList.addAll(templist);


                                    for (var value1 in masterDialogList) {

                                      for (var element in map) {
                                        if (value1['code'] != null && value1['code'] != "") {
                                          break;
                                        }
                                      if (value1['name'] == element['name']) {
                                        value1['code'] = element['code'];
                                        break;
                                      }
                                    }
                                  }



                                  print(map.toString());
                                } else {
                                  // Snack.callError("Failed To Get Data");
                                  LoadingDialog.showErrorDialog(
                                      "Failed To Get Data");
                                }
                              });
                        }
                      }),
                ],
              ),
              SizedBox(
                height: 30.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Obx(() => masterDialogList.isEmpty
                      ? Icon(
                    Icons.check_box_outline_blank,
                    color: Colors.grey,
                  )
                      : Checkbox(
                      value: allselect.value,
                      onChanged: (val) {
                        allselect.value = val!;
                        for (var i = 0;
                        i < masterDialogList.length;
                        i++) {
                          masterDialogList[i]["selected"] = val;
                        }
                        masterDialogList.refresh();
                      })),
                  Text("Select All")
                ],
              ),
              Obx(() => Container(
                width: Get.width / 4,
                height: Get.height / 2,
                decoration: BoxDecoration(
                  border: Border.all(
                      style: masterDialogList.isEmpty
                          ? BorderStyle.none
                          : BorderStyle.solid),
                ),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    var item = masterDialogList[index];
                    return ListTile(
                      visualDensity: const VisualDensity(vertical: -3),
                      leading: Checkbox(
                          value: item["selected"],
                          onChanged: (value) {
                            item["selected"] = value;
                            masterDialogList.refresh();
                          }),
                      title: Text(item["name"]),
                    );
                  },
                  itemCount: masterDialogList.length,
                ),
              )),
              const SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  /*FormButton(
                    onPressed: () {

                    },
                    icon: Icon(Icons.done),
                    label: Text("Done")),*/

                  /*FormButton(
                    onPressed: () {

                    },
                    icon: Icon(Icons.clear),
                    label: Text("Cancel")),*/
                  FormButton(
                      btnText: "Done",
                      callback: () {
                        String _searchCriteria = "";
                        String _searchCriteria1 = "";
                        if ((grid!.type!) == "V") {
                          for (var i = 0;
                          i <
                              masterDialogList
                                  .where((e) => e["selected"] == true)
                                  .length;
                          i++) {
                            print(">>>>>>>>>>masterDialogList"+masterDialogList.toString());

                            _searchCriteria = _searchCriteria +
                                (i ==
                                    (masterDialogList
                                        .where((e) =>
                                    e["selected"] == true)
                                        .length -
                                        1)
                                    ? "'" +
                                    masterDialogList
                                        .where((e) =>
                                    e["selected"] == true)
                                        .toList()[i]["name"] +
                                    "'"
                                    : "'" +
                                    masterDialogList
                                        .where((e) =>
                                    e["selected"] == true)
                                        .toList()[i]["name"] +
                                    "',");

                            _searchCriteria1 = _searchCriteria1 +
                                (i ==
                                    (masterDialogList
                                        .where((e) =>
                                    e["selected"] == true)
                                        .length -
                                        1)
                                    ? "'" +
                                    (masterDialogList
                                        .where((e) =>
                                    e["selected"] == true)
                                        .toList()[i]["code"]??"") +
                                    "'"
                                    : "'" +
                                    (masterDialogList
                                        .where((e) =>
                                    e["selected"] == true)
                                        .toList()[i]["code"] ??"")+
                                    "',");

                          }
                        }
                        else {
                          for (var i = 0;
                          i <
                              masterDialogList
                                  .where((e) => e["selected"] == true)
                                  .length;
                          i++) {
                            _searchCriteria = _searchCriteria +
                                (i ==
                                    (masterDialogList
                                        .where((e) =>
                                    e["selected"] == true)
                                        .length -
                                        1)
                                    ? masterDialogList
                                    .where((e) => e["selected"] == true)
                                    .toList()[i]["name"]
                                    : (masterDialogList
                                    .where((e) =>
                                e["selected"] == true)
                                    .toList()[i]["name"] +
                                    ","));
                            _searchCriteria1 = _searchCriteria1 +
                                (i ==
                                    (masterDialogList
                                        .where((e) =>
                                    e["selected"] == true)
                                        .length -
                                        1)
                                    ? (masterDialogList
                                    .where((e) => e["selected"] == true)
                                    .toList()[i]["code"]??"")
                                    : ((masterDialogList
                                    .where((e) =>
                                e["selected"] == true)
                                    .toList()[i]["code"]??"" )+
                                    ","));

                          }
                        }
                        Variances varData1 =   grid!.variances!
                            .firstWhere((element) =>
                        element.name == rowvariance.name,orElse: () =>  Variances());

                        if(varData1.name != null ){
                          varData1.searchCriteria = (grid!.type!) ==
                              "V"
                              ? "${checknotcheck.value ? "Not In" : "In"} ($_searchCriteria)"
                              : _searchCriteria;
                        }


                        Variances varData2 = grid!.variances!
                            .firstWhere((element) =>
                        element.name.toString() == rowvariance.valueColumnName.toString().toLowerCase(), orElse: ()=> Variances());

                        if(varData2.name != null){
                          varData2.searchCriteria = (grid!.type!) ==
                              "V"
                              ? "${checknotcheck.value ? "Not In" : "In"} ($_searchCriteria1)"
                              : _searchCriteria1;
                        }

                        updateGrid();
                        Get.back();
                      }),
                  const SizedBox(
                    width: 5,
                  ),
                  FormButton(
                    btnText: "Clear",
                    callback: () {
                      grid!.variances!
                          .firstWhere(
                              (element) => element.name == rowvariance.name)
                          .searchCriteria = "";
                      updateGrid();
                      Get.back();
                    },
                  ),
                  /*FormButton(
                    onPressed: () {

                    },
                    icon: Icon(Icons.remove_circle_outline),
                    label: Text("Clear")),*/
                  const SizedBox(
                    width: 5,
                  ),
                  FormButton(
                    btnText: "Cancel",
                    callback: () {
                      masterDialogList.value = [];
                      checknotcheck.value = false;
                      Get.back();
                    },
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              const Align(
                alignment: Alignment.bottomCenter,
                child: Text(
                  "Note: Type %% to fetch all records. Tick for Not Like",
                  style: TextStyle(fontSize: 15),
                ),
              ),
            ],
          ),
          radius: 10.0)
          .then((value) {
        masterDialogList.value = [];
        checknotcheck.value = false;
      });
    }
    else if (rowvariance.dataType == "time" ||
        rowvariance.dataType == "ime(0)") {
      // var timenow = DateTime.now();

      TextEditingController fromctrl = TextEditingController();
      TextEditingController toctrl = TextEditingController();
      // String to = "0";
      Get.defaultDialog(
          title: rowvariance.name!,
          content: Column(
            children: [
              Row(
                children: [
                  DateWithThreeTextField(
                    title: "Between",
                    mainTextController: fromctrl,
                    // onFocusChange: (date) {
                    //   fromctrl.text = DateFormat("dd-MMM-yyyy")
                    //       .format(DateFormat('dd-MM-yyyy').parse(date));
                    // },
                    widthRation: .15,
                  ),
                  const SizedBox(width: 15),
                  DateWithThreeTextField(
                    title: "And",
                    mainTextController: toctrl,
                    // onFocusChange: (date) {
                    //   toctrl.text = DateFormat("dd-MMM-yyyy")
                    //       .format(DateFormat('dd-MM-yyyy').parse(date));
                    // },
                    widthRation: .15,
                  ),
                  // InputFields.timeField3(
                  //     widthRatio: 0.15,
                  //     hintTxt: "Between",
                  //     controller: fromctrl),
                  // InputFields.timeField3(
                  //     widthRatio: 0.15, hintTxt: "And", controller: toctrl),
                ],
              )
            ],
          ),
          actions: [
            FormButton(
                callback: () {
                  try {
                    grid!.variances!
                        .firstWhere(
                            (element) => element.name == rowvariance.name)
                        .searchCriteria =
                    "between '${DateFormat("dd-MMM-yyyy").format(DateFormat('dd-MM-yyyy').parse(fromctrl.text))}' and '${DateFormat("dd-MMM-yyyy").format(DateFormat('dd-MM-yyyy').parse(toctrl.text))}'";
                    updateGrid();
                    Get.back();
                  } catch (e) {
                    // Snack.call("Invalid Number");
                    LoadingDialog.showErrorDialog("Invalid Number");
                  }
                },
                btnText: "Done"),
            FormButton(
                callback: () {
                  grid!.variances!
                      .firstWhere((element) => element.name == rowvariance.name)
                      .searchCriteria = "";
                  updateGrid();
                  Get.back();
                },
                // icon: Icon(Icons.remove_circle_outline),
                btnText: "Clear"),
            FormButton(
                callback: () {
                  Get.back();
                },
                // icon: Icon(Icons.clear),
                btnText: "Cancel"),
          ],
          radius: 10.0);
    }
    else if (rowvariance.dataType == "money" ||
        rowvariance.dataType == "float" ||
        rowvariance.dataType == "int" ||
        rowvariance.dataType == "numeric") {
      String from = "0";
      String to = "0";
      Get.defaultDialog(
          title: rowvariance.name!,
          content: Column(
            children: [
              Row(
                children: [
                  InputFields.numbers(
                      width: 0.15,
                      onchanged: (value) {
                        from = value;
                      },
                      hintTxt: "Between",
                      controller: TextEditingController(text: from)),
                  InputFields.numbers(
                      width: 0.15,
                      onchanged: (value) {
                        to = value;
                      },
                      hintTxt: "And",
                      controller: TextEditingController(text: to)),
                ],
              )
            ],
          ),
          actions: [
            FormButton(
                callback: () {
                  try {
                    int.parse(from);
                    int.parse(to);
                    grid!.variances!
                        .firstWhere(
                            (element) => element.name == rowvariance.name)
                        .searchCriteria = "between '$from' and '$to'";
                    updateGrid();
                    Get.back();
                  } catch (e) {
                    // Snack.call("Invalid Number");
                    LoadingDialog.showErrorDialog("Invalid Number");
                  }
                },
                // icon: Icon(Icons.done),
                btnText: "Done"),
            FormButton(
                callback: () {
                  grid!.variances!
                      .firstWhere((element) => element.name == rowvariance.name)
                      .searchCriteria = "";
                  updateGrid();
                  Get.back();
                },
                // icon: Icon(Icons.remove_circle_outline),
                btnText: "Clear"),
            FormButton(
                callback: () {
                  Get.back();
                },
                // icon: Icon(Icons.clear),
                btnText: "Cancel"),
          ],
          radius: 10.0);
    }
    else if ((rowvariance.dataType == "varchar" ||
        rowvariance.dataType == "char") &&
        rowvariance.tableName == "") {
      var multiValue = RxBool(false);
      String valueText = "";
      Get.defaultDialog(
          title: rowvariance.name!,
          content: Column(
            children: [
              InputFields.formField1(
                  width: 0.30,
                  onchanged: (value) {
                    valueText = value;
                  },
                  inputformatters: [
                    FilteringTextInputFormatter.deny("  "),
                    // FilteringTextInputFormatter.deny("  "),
                  ],
                  hintTxt: "Like",
                  controller: TextEditingController()),
              Row(
                children: [
                  Obx(
                        () => Checkbox(
                        value: multiValue.value,
                        onChanged: (value) {
                          multiValue.value = value!;
                        }),
                  ),
                  Text("Multi Value")
                ],
              )
            ],
          ),
          actions: [
            FormButton(
                callback: () {
                  grid!.variances!
                      .firstWhere((element) => element.name == rowvariance.name)
                      .searchCriteria = multiValue
                      .value
                      ? "in ${valueText.split(",").map((e) => "'${e.trim()}'")}"
                      : "like %$valueText%";
                  updateGrid();
                  Get.back();
                },
                // icon: Icon(Icons.done),
                btnText: "Done"),
            FormButton(
                callback: () {
                  grid!.variances!
                      .firstWhere((element) => element.name == rowvariance.name)
                      .searchCriteria = "";
                  updateGrid();
                  Get.back();
                },
                // icon: Icon(Icons.remove_circle_outline),
                btnText: "Clear"),
            FormButton(
                callback: () {
                  Get.back();
                },
                // icon: Icon(Icons.clear),
                btnText: "Cancel"),
          ],
          radius: 10.0);
    }
    else if ((rowvariance.dataType!.toLowerCase() == "datetime") &&
        grid!.type == "P") {
      // String valueText = DateFormat('dd-MMM-yyyy').format(DateTime.now());
      var tempCtr = TextEditingController();
      Get.defaultDialog(
          title: rowvariance.name!,
          content: Container(
            child: DateWithThreeTextField(
              title: "Between",
              mainTextController: tempCtr,
              // onFocusChange: (date) {
              //   valueText = DateFormat("dd-MMM-yyyy")
              //       .format(DateFormat('dd-MM-yyyy').parse(date));
              // },
            ),
            // DateWidget.date(Get.context, "Between", (data) {
            //   valueText = DateFormat('dd-MMM-yyyy').format(data);
            // }, false),
          ),
          actions: [
            FormButton(
                callback: () {
                  grid!.variances!
                      .firstWhere((element) => element.name == rowvariance.name)
                      .searchCriteria = DateFormat(
                      "dd-MMM-yyyy")
                      .format(DateFormat('dd-MM-yyyy').parse(tempCtr.text));
                  updateGrid();
                  Get.back();
                },
                // icon: Icon(Icons.done),
                btnText: "Done"),

            //
            FormButton(
                callback: () {
                  grid!.variances!
                      .firstWhere((element) => element.name == rowvariance.name)
                      .searchCriteria = "";
                  updateGrid();
                  Get.back();
                },
                // icon: Icon(Icons.remove_circle_outline),
                btnText: "Clear"),
            //
            FormButton(
                callback: () {
                  Get.back();
                },
                // icon: Icon(Icons.clear),
                btnText: "Cancel"),
          ],
          radius: 10.0);
    }
    else if ((rowvariance.dataType!.toLowerCase() == "date") &&
        grid!.type == "P") {
      List dateTypes = [
        "My Dates",
        "Today",
        "Tomorrow",
        "StartofMonth",
        "EndofMonth",
        "LastMonth"
      ];
      var selectedType = RxString("My Dates");
      // String valueText = DateFormat('dd-MMM-yyyy').format(DateTime.now());
      TextEditingController tempCtr = TextEditingController();
      Get.defaultDialog(
          title: rowvariance.name!,
          content: Column(
            children: [
              // DateWidget.date(Get.context, "Between", (value) {
              //   valueText = DateFormat('dd-MMM-yyyy').format(value);
              // }, false),
              DateWithThreeTextField(
                title: "Between",
                mainTextController: tempCtr,
                // onFocusChange: (date) {
                //   valueText = DateFormat("dd-MMM-yyyy")
                //       .format(DateFormat('dd-MM-yyyy').parse(date));
                // },
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: dateTypes
                    .map(
                      (e) => Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: Row(
                      children: [
                        Obx(
                              () => Radio<String>(
                              value: e,
                              groupValue: selectedType.value,
                              onChanged: (value) {
                                log(selectedType.value);
                                selectedType.value = value as String;
                              }),
                        ),
                        Text(e),
                      ],
                    ),
                  ),
                )
                    .toList(),
              )
            ],
          ),
          actions: [
            FormButton(
                callback: () {
                  if (selectedType.value == "My Dates") {
                    grid!.variances!
                        .firstWhere(
                            (element) => element.name == rowvariance.name)
                        .searchCriteria = DateFormat("dd-MMM-yyyy").format(
                      DateFormat('dd-MM-yyyy').parse(tempCtr.text),
                    );
                    grid!.variances!
                        .firstWhere(
                            (element) => element.name == rowvariance.name)
                        .formula = "";
                  } else {
                    grid!.variances!
                        .firstWhere(
                            (element) => element.name == rowvariance.name)
                        .searchCriteria = "";
                    grid!.variances!
                        .firstWhere(
                            (element) => element.name == rowvariance.name)
                        .formula = selectedType.value;
                  }
                  updateGrid();
                  Get.back();
                },
                // icon: Icon(Icons.done),
                btnText: "Done"),
            FormButton(
                callback: () {
                  grid!.variances!
                      .firstWhere((element) => element.name == rowvariance.name)
                      .searchCriteria = "";

                  grid!.variances!
                      .firstWhere((element) => element.name == rowvariance.name)
                      .formula = "";

                  updateGrid();
                  Get.back();
                },
                // icon: Icon(Icons.remove_circle_outline),
                btnText: "Clear"),
            FormButton(
                callback: () {
                  Get.back();
                },
                // icon: Icon(Icons.clear),
                btnText: "Cancel"),
          ],
          radius: 10.0);
    }
  }

  getInitialData() async {
    await Get.find<ConnectorControl>().GET_METHOD_CALL_HEADER(
      api: ApiFactory.SEARCH_VARIANCE(
          screenName: screenName,
          viewName: strViewName,
          loginCode: Get.find<MainController>().user?.logincode ?? ""),
      fun: (value) {
        varainace = value;
        log(varainace.toString());
        log(value);
        print(value.toString());

        // try {
        //   for (var element in value) {
        //     filters.add(SearchFilter.fromJson(element));
        //   }
        //   update(["initialData"]);
        // } catch (e) {
        //   log("data fetching & parsing error");
        // }
      },
    );
    await Get.find<ConnectorControl>().GET_METHOD_CALL_HEADER(
      api: ApiFactory.SEARCH_BINDGRID(
          screenName: screenName, viewName: strViewName, code: "0"),
      fun: (value) async {
        log(value.toString());
        print(value.toString());
        grid = SearchBindGrid.fromJson(value);
        await updateGrid();

        // List<PlutoColumn> columns = [];
        // for (Variances variance in grid!.variances!) {
        //   Map row = variance.toJson();
        //   if (!row["name"].toString().toLowerCase().contains("code")) {
        //     print(row.toString());
        //     Map<String, PlutoCell> cells = {};
        //     try {
        //       for (var element in row.entries) {
        //         cells[element.key] = PlutoCell(
        //           value: element.key == "selected" || element.value == null
        //               ? ""
        //               : element.value.toString(),
        //         );
        //       }
        //       rows.add(PlutoRow(
        //         cells: cells,
        //       ));
        //     } catch (e) {
        //       log("problem in adding rows");
        //     }
        //   }
        // }

        // try {
        //   for (var element in value) {
        //     filters.add(SearchFilter.fromJson(element));
        //   }
        //   update(["initialData"]);
        // } catch (e) {
        //   log("data fetching & parsing error");
        // }
      },
    );
    update(["initialData"]);
  }

  getVaraince(id) async {
    Get.find<ConnectorControl>().GET_METHOD_CALL_HEADER(
      api: ApiFactory.SEARCH_BINDGRID(
          screenName: screenName, viewName: strViewName, code: id.toString()),
      fun: (value) async {
        grid = SearchBindGrid.fromJson(value);
        await updateGrid();
      },
    );
  }
}
