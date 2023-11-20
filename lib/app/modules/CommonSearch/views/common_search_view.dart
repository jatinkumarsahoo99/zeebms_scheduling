import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/utils.dart';
import '../../../../widgets/FormButton.dart';
import '../../../../widgets/LoadingScreen.dart';
import '../../../../widgets/dropdown.dart';
import '../../../../widgets/input_fields.dart';
import '../../../data/DropDownValue.dart';
import '../../../data/system_envirtoment.dart';
import '../controllers/search_controller.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({
    Key? key,
    required this.screenName,
    required this.strViewName,
    this.appBarName,
    this.isAppBarReq,
    this.isPopup = false,
    this.actionableSearch = false,
    this.actionableMap,
    this.dialogClose,
  }) : super(key: key);
  final String screenName;
  final void Function(dynamic)? dialogClose;
  final String strViewName;
  final bool? isAppBarReq;
  final bool? isPopup;
  final String? appBarName;
  final bool actionableSearch;
  final Map<String, void Function(String value)>? actionableMap;

  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
      focusNode: FocusNode(),
      onKeyEvent: (value) {
        if (value.logicalKey == LogicalKeyboardKey.escape) {
          if (dialogClose != null) {
            dialogClose!(null);
          } else {
            Get.back();
          }
        }
      },
      child: GetBuilder<SearchController>(
          key: key,
          id: "initialData",
          init: SearchController(
            strViewName,
            screenName,
            isPopUp: isPopup,
            actionableSearch: actionableSearch,
            actionableMap: actionableMap,
            dialogClose: dialogClose,
          ),
          builder: (controller) {
            if (controller.grid != null &&
                controller.grid!.variances!.isNotEmpty) {
              return Scaffold(
                  appBar: (isAppBarReq != null && isAppBarReq == true)
                      ? AppBar(
                    title: Text(
                        appBarName != null
                            ? "${appBarName ?? ""} - Search"
                            : "Search",
                        style: const TextStyle(color: Colors.deepPurple)),
                    backgroundColor: Colors.white,
                    elevation: 2,
                    leading: IconButton(
                        icon: Icon(
                            (dialogClose != null)
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
                  )
                      : null,
                  body: FocusTraversalGroup(
                    policy: ReadingOrderTraversalPolicy(),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Wrap(
                            alignment: WrapAlignment.spaceEvenly,
                            children: [
                              /// varaince
                              /* DropDownField.simpleDropDownwithWidthRatio(
                                  controller.varainace
                                      .map((e) => DropDownValue(
                                            key: e["id"].toString(),
                                            value: e["varianceName"],
                                          ))
                                      .toList(), (value) async {
                                controller.selectVarianceId =
                                    int.parse(value!.key!);
                                await controller.getVaraince(int.parse(value.key!));
                              }, "Variance", 0.3, context),*/

                              DropDownField.formDropDown1Width(
                                Get.context!,
                                controller.varainace
                                    .map((e) => SystemEnviroment(
                                  key: e["id"].toString(),
                                  value: e["varianceName"],
                                ))
                                    .toList(),
                                    (value) async {
                                  // controllerX.selectedLanguage = val;
                                  controller.selectVarianceId =
                                      int.parse(value?.key!);
                                  await controller
                                      .getVaraince(int.parse(value.key!));
                                },
                                "Variance",
                                0.3,
                                searchReq: true,
                                autoFocus: true,
                                // paddingTop: 4,
                                // paddingLeft: 5,
                                dialogHeight: Get.height * .8,
                              ),

                              const SizedBox(width: 10),

                              /// search
                              InputFields.formField1(
                                hintTxt: "Search",
                                controller: TextEditingController(),
                                onchanged: (value) {
                                  controller.updateGrid(value: value);
                                },
                                width: 0.3,
                              ),

                              /// add sum
                              Padding(
                                padding:
                                const EdgeInsets.only(top: 13, left: 10),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Obx(
                                          () => Checkbox(
                                          value: controller.addsum.value,
                                          onChanged: (value) {
                                            controller.addsum.value = value!;
                                          }),
                                    ),
                                    const Text("Add Sum")
                                  ],
                                ),
                              )
                            ],
                          ),

                          /// datatable
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.deepPurpleAccent)),
                                child: GetBuilder<SearchController>(
                                  id: "searchGrid",
                                  init: controller,
                                  builder: (controller) => RawKeyboardListener(
                                    focusNode: controller.gridFN,
                                    child: DataTable2(
                                      horizontalMargin: 0,
                                      showBottomBorder: true,
                                      columnSpacing: 3,
                                      dataRowHeight: 30,
                                      headingRowHeight: 35,
                                      bottomMargin: 30,
                                      showCheckboxColumn: false,
                                      sortAscending: true,
                                      border: TableBorder.all(width: 0.1),
                                      columns: controller.searchGridColumns,
                                      // columns: [
                                      //   for (var column in controller
                                      //       .grid!.variances![0]
                                      //       .toJson()
                                      //       .keys)
                                      //     DataColumn2(
                                      //       size: ColumnSize.M,
                                      //       label: Center(
                                      //         child: Text(
                                      //           column.capitalizeFirst!,
                                      //           textAlign: TextAlign.center,
                                      //           style: TextStyle(
                                      //               color: Colors.black,
                                      //               fontWeight: FontWeight.bold,
                                      //               fontSize: 12),
                                      //         ),
                                      //       ),
                                      //     ),
                                      // ],
                                      rows: controller.searchQuery == ""
                                          ? controller.searchGridRows
                                          : controller.filterSearchGridRows,

                                      // rows: List<DataRow2>.generate(
                                      //     controller.grid!.variances!.length,
                                      //     (index) {
                                      //   var filter = controller
                                      //       .grid!.variances![index]
                                      //       .toJson();
                                      //   return DataRow2(
                                      //       onTap: () {},
                                      //       onSelectChanged: (value) {
                                      //         controller.grid!.variances![index]
                                      //             .selected = value;
                                      //         controller.update(["searchParam"]);
                                      //       },
                                      //       selected: controller
                                      //           .grid!.variances![index].selected!,
                                      //       cells: [
                                      //         for (var value in filter.values)
                                      //           DataCell(Center(
                                      //             child: value is bool
                                      //                 ? Checkbox(
                                      //                     value: value,
                                      //                     onChanged: (value) {
                                      //                       controller
                                      //                           .grid!
                                      //                           .variances![index]
                                      //                           .selected = value;
                                      //                       controller.update(
                                      //                           ["searchParam"]);
                                      //                     })
                                      //                 : Text(value.toString()),
                                      //           ))
                                      //       ]);
                                      // })
                                      //
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),

                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              padding:
                              const EdgeInsets.symmetric(horizontal: 8),
                              margin: EdgeInsets.zero,
                              width: double.infinity,
                              decoration: const BoxDecoration(
                                  color: Colors.white,
                                  border: Border(
                                      top: BorderSide(
                                          width: 1.0, color: Colors.grey))),
                              child: ButtonBar(
                                buttonHeight: 30,
                                alignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  for (var btn in [
                                    "Execute",
                                    "Clear",
                                    "Add Variance",
                                    "Delete Variance",
                                    (dialogClose != null ? "Exit " : "Exit")
                                  ])
                                    FormButtonWrapper(
                                      btnText: btn,
                                      callback: () =>
                                      {controller.formHandler(btn)},
                                    )
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ));
            } else {
              return const PleaseWaitCard();
            }
          }),
    );
  }
}
