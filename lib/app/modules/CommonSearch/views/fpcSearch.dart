import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/utils.dart';
import 'package:pluto_grid/pluto_grid.dart';

import '../../../../widgets/FormButton.dart';
import '../../../../widgets/LoadingScreen.dart';
import '../../../../widgets/dropdown.dart';
import '../../../../widgets/input_fields.dart';
import '../../../controller/HomeController.dart';
import '../../../data/DropDownValue.dart';
import '../../../providers/Utils.dart';
import '../controllers/search_controller.dart';

class FPCSearchPage extends StatelessWidget {
  FPCSearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SearchController>(
        id: "initialData",
        init: SearchController("VTYUI", "dasdas"),
        builder: (controller) {
          if (controller.grid != null &&
              controller.grid!.variances!.isNotEmpty) {
            return Scaffold(
                appBar: AppBar(
                  title: const Text(
                    "FPC Search",
                    style: TextStyle(
                        color: Colors.deepPurple, fontWeight: FontWeight.bold),
                  ),
                ),
                floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
                floatingActionButton: GetBuilder<HomeController>(
                    id: "buttons",
                    init: Get.find<HomeController>(),
                    builder: (btncontroller) {
                      if (btncontroller.buttons != null) {
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          margin: EdgeInsets.zero,
                          width: double.infinity,
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              border: const Border(
                                  top: BorderSide(
                                      width: 1.0, color: Colors.grey))),
                          child: ButtonBar(
                            buttonHeight: 30,
                            alignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              for (var btn in btncontroller.buttons!)
                                FormButtonWrapper(
                                  btnText: btn["name"],
                                  callback: () =>
                                  {controller.formHandler(btn["name"])},
                                )
                            ],
                          ),
                        );
                      }
                      return Container();
                    }),
                body: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Wrap(
                        children: [
                          /// Varraince
                          DropDownField.simpleDropDownwithWidthRatio(
                            [
                              DropDownValue(key: "BIG", value: "BIG VALUE"),
                              DropDownValue(
                                  key: "Select Variance",
                                  value: "BIG Vararaince"),
                            ],
                                (value) => null,
                            "Variant",
                            0.3,
                            context,
                          ),

                          /// search
                          InputFields.formField1(
                            hintTxt: "Search",
                            controller: TextEditingController(),
                            width: 0.3,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: Get.height - (2.2 * kToolbarHeight),
                        child: Card(
                          child: GetBuilder<SearchController>(
                              id: "searchParam",
                              init: controller,
                              builder: (controller) => PlutoGrid(
                                  configuration: PlutoGridConfiguration(
                                      style: PlutoGridStyleConfig(
                                        gridBorderColor: Colors.transparent,
                                        activatedBorderColor: Colors.deepPurple,
                                        activatedColor: Colors.deepPurple[100]!,
                                        gridBorderRadius:
                                        BorderRadius.circular(10),
                                        enableColumnBorderHorizontal: false,
                                        enableCellBorderVertical: false,
                                        enableGridBorderShadow: false,
                                      ),
                                      scrollbar: const PlutoGridScrollbarConfig(
                                        draggableScrollbar: true,
                                        isAlwaysShown: true,
                                      )),
                                  onChanged: (PlutoGridOnChangedEvent event) {
                                    print(event);
                                  },
                                  onRowChecked: (event) {
                                    print('Grid B : $event');
                                  },
                                  onLoaded: (PlutoGridOnLoadedEvent event) {
                                    controller.gridStateManager =
                                        event.stateManager;
                                  },
                                  columns: [
                                    for (var key
                                    in (controller
                                        .grid!.variances![0]
                                        .toJson())
                                        .keys)
                                      PlutoColumn(
                                          title: key.toString(),
                                          readOnly: true,
                                          enableSorting: true,
                                          enableRowChecked:
                                          key == "selected" ? true : false,
                                          enableRowDrag: false,
                                          enableEditingMode: false,
                                          enableDropToResize: true,
                                          enableContextMenu: false,
                                          width: Utils.getColumnSize(
                                              key: key,
                                              value: controller
                                                  .grid!.variances![0]
                                                  .toJson()[key]),
                                          enableAutoEditing: false,
                                          hide: (key == "dataType" ||
                                              key == "tableName" ||
                                              key == "valueColumnName"),
                                          enableColumnDrag: false,
                                          field: key,
                                          type: PlutoColumnType.text())
                                  ],
                                  rows: controller.rows)),
                        ),
                      ),
                    ],
                  ),
                ));
          } else {
            return PleaseWaitCard();
          }
        });
  }
}
