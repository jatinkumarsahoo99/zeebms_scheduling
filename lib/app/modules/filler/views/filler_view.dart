import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:pluto_grid/pluto_grid.dart';

import '../../../../widgets/DateTime/DateWithThreeTextField.dart';
import '../../../../widgets/FormButton.dart';
import '../../../../widgets/dropdown.dart';
import '../../../../widgets/gridFromMap.dart';
import '../../../controller/HomeController.dart';
import '../controllers/filler_controller.dart';

class FillerView extends GetView<FillerController> {
  FillerView({Key? key}) : super(key: key);

  late PlutoGridStateManager stateManager;
  var formName = 'Scheduling Filler';

  void handleOnRowChecked(PlutoGridOnRowCheckedEvent event) {}
  FillerController controllerX = Get.put(FillerController());

  @override
  Widget build(BuildContext context) {

    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    return GetBuilder<FillerController>(
        init: FillerController(),
        id: "initData",
        builder: (controller) {
          FocusNode _channelsFocus = FocusNode();

          return Scaffold(
            body: FocusTraversalGroup(
              policy: OrderedTraversalPolicy(),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: SizedBox(
                  height: double.maxFinite,
                  width: double.maxFinite,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GetBuilder<FillerController>(
                        id: "initialData",
                        builder: (control) {
                          return Padding(
                            padding: const EdgeInsets.only(left: 18.0, top: 10),
                            child: Row(
                              children: [
                                Obx(
                                      () => DropDownField.formDropDown1WidthMap(
                                    controllerX.locations.value,
                                        (value) {
                                      controllerX.selectLocation = value;
                                      // controllerX.selectedLocationId.text = value.key!;
                                      // controllerX.selectedLocationName.text = value.value!;
                                      // controller.getChannelsBasedOnLocation(value.key!);
                                    },
                                    "Location",
                                    0.12,
                                    isEnable: controllerX.isEnable.value,
                                    selected: controllerX.selectLocation,
                                    autoFocus: true,
                                    dialogWidth: 330,
                                    dialogHeight: Get.height * .7,
                                  ),
                                ),
                                const SizedBox(width: 15),
                                Obx(() {
                                  return DropDownField.formDropDown1Width(
                                    Get.context!,
                                    controllerX.channelList ?? [],
                                        (value) {
                                      controllerX.selectedChannel = value;
                                    },
                                    "Channel",
                                    controllerX.widthSize,
                                    paddingLeft: 5,
                                    searchReq: true,
                                    isEnable: control.channelEnable.value,
                                    selected: controllerX.selectedChannel,
                                    dialogHeight: Get.height * .7,
                                  );
                                }),
                                const SizedBox(width: 15),
                                DateWithThreeTextField(
                                  title: "From Date",
                                  mainTextController: controllerX.date_,
                                  widthRation: controllerX.widthSize,
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 17.0),
                                  child: FormButton(
                                    btnText: "Import Excel",
                                    callback: () {},
                                  ),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 17.0),
                                  child: FormButton(
                                    btnText: "Import Fillers",
                                    callback: () {},
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(15, 15, 7, 0),
                          child: GetBuilder<FillerController>(
                              init: FillerController(),
                              id: "reports",
                              builder: (controller) {
                                if (controller.conflictReport.isEmpty ||
                                    controller.beams.isEmpty) {
                                  return Container(
                                    width: w * 0.65,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.grey.shade300,
                                          width: 0.5,
                                        ),
                                        borderRadius: const BorderRadius.all(Radius.circular(10))
                                      //color: Colors.deepPurpleAccent
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: fillerTable(context),
                                    ),
                                  );
                                } else {
                                  return Container();
                                }
                              }),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(15, 15, 7, 0),
                          child: GetBuilder<FillerController>(
                              init: FillerController(),
                              id: "reports",
                              builder: (controller) {
                                if (controller.conflictReport.isEmpty ||
                                    controller.beams.isEmpty) {
                                  return Flexible(
                                    child: Container(
                                      width: w * 0.65,
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors.grey.shade300,
                                            width: 0.5,
                                          ),
                                          borderRadius: const BorderRadius.all(Radius.circular(10))
                                        //color: Colors.deepPurpleAccent
                                      ),
                                      child: Column(
                                        children: [
                                          Text('Filler Schedule'),
                                          Padding(
                                            padding: const EdgeInsets.all(2.0),
                                            child: fillerTable(context),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                } else {
                                  return Container();
                                }
                              }),
                        ),
                      ),

                      GetBuilder<HomeController>(
                          id: "buttons",
                          init: Get.find<HomeController>(),
                          builder: (btcontroller) {
                            if (btcontroller.buttons != null) {
                              return Container(
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                ),
                                child: ButtonBar(
                                  alignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    for (var btn in btcontroller.buttons!)
                                    //if (Utils.btnAccessHandler(btn['name'], controller.formPermissions!) != null)
                                      FormButtonWrapper(
                                        btnText: btn["name"],
                                        callback: () => controller.formHandler(
                                          btn['name'],
                                        ),
                                      )
                                  ],
                                ),
                              );
                            }
                            return Container();
                          }),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  Widget fillerTable(context) {
    return GetBuilder<FillerController>(
        id: "fillerTable",
        // init: CreateBreakPatternController(),
        builder: (controller) {
          if (controllerX.fillerList != null &&
              (controllerX.fillerList?.isNotEmpty)!) {
            // final key = GlobalKey();
            return DataGridFromMap(
              mapData: (controllerX.fillerList
                  ?.map((e) => e.toJson1())
                  .toList())!,
              widthRatio: (Get.width * 0.2) / 2 + 7,
              // mode: PlutoGridMode.select,
              onSelected: (plutoGrid) {
                controllerX.selectedFiller =
                controllerX.fillerList![plutoGrid.rowIdx!];
                print(jsonEncode(controllerX.selectedFiller?.toJson()));
              },
            );
          } else {
            return Expanded(
              child: Card(
                clipBehavior: Clip.hardEdge,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0), // if you need this
                  side: BorderSide(
                    color: Colors.grey.shade300,
                    width: 1,
                  ),
                ),
                child: Container(
                  height: Get.height - (4 * kToolbarHeight),
                ),
              ),
            );
          }
        });
  }

  Widget fillerScheduleTable(context) {
    return GetBuilder<FillerController>(
        id: "fillerScheduleTable",
        // init: CreateBreakPatternController(),
        builder: (controller) {
          if (controllerX.fillerScheduleList != null &&
              (controllerX.fillerScheduleList?.isNotEmpty)!) {
            // final key = GlobalKey();
            return Expanded(
              // height: 400,
              child: DataGridFromMap(
                mapData: (controllerX.fillerScheduleList
                    ?.map((e) => e.toJson1())
                    .toList())!,
                widthRatio: (Get.width * 0.2) / 2 + 7,
                // mode: PlutoGridMode.select,
                onSelected: (plutoGrid) {
                  controllerX.selectedFillerSchedule =
                  controllerX.fillerScheduleList![plutoGrid.rowIdx!];
                  print(jsonEncode(controllerX.selectedFillerSchedule?.toJson()));
                },
              ),
            );
          } else {
            return Expanded(
              child: Card(
                clipBehavior: Clip.hardEdge,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0), // if you need this
                  side: BorderSide(
                    color: Colors.grey.shade300,
                    width: 1,
                  ),
                ),
                child: Container(
                  height: Get.height - (4 * kToolbarHeight),
                ),
              ),
            );
          }
        });
  }

}
