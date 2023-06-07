import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bms_scheduling/widgets/PlutoGrid/pluto_grid.dart';
import '../../../../widgets/DateTime/DateWithThreeTextField.dart';
import '../../../../widgets/FormButton.dart';
import '../../../../widgets/dropdown.dart';
import '../../../../widgets/gridFromMap.dart';
import '../../../../widgets/input_fields.dart';
import '../../../controller/HomeController.dart';
import '../../../providers/SizeDefine.dart';
import '../../filler/controllers/filler_controller.dart';
import '../controllers/promos_controller.dart';

class PromosView extends GetView<PromosController> {
  PromosView({Key? key}) : super(key: key);

  late PlutoGridStateManager stateManager;
  var formName = 'Scheduling Promo';

  void handleOnRowChecked(PlutoGridOnRowCheckedEvent event) {}
  //PromosController controllerX = Get.put(PromosController());
  FillerController controllerX = Get.put(FillerController());

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    return GetBuilder<PromosController>(
        init: PromosController(),
        id: "initData",
        builder: (controller) {
          return Scaffold(
            body: FocusTraversalGroup(
              policy: OrderedTraversalPolicy(),
              child: SizedBox(
                height: double.maxFinite,
                width: double.maxFinite,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          /// Two Table
                          Expanded(
                            flex: 2,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding:
                                    const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                    child: GetBuilder<FillerController>(
                                      id: "initialData",
                                      builder: (control) {
                                        return Row(
                                          children: [
                                            Obx(
                                                  () => DropDownField
                                                  .formDropDown1WidthMap(
                                                  controller.locations
                                                      .value, (value) {
                                                // controller.selectedLocation = value;
                                                // controller.getChannel(value.key);
                                              }, "Location", 0.15),
                                            ),
                                            const SizedBox(width: 15),
                                            Obx(
                                                  () => DropDownField
                                                  .formDropDown1WidthMap(
                                                controller.channels.value,
                                                    (value) {
                                                  //controller.selectedChannel = value;
                                                },
                                                "Channel",
                                                0.15,
                                                dialogHeight: Get.height * .7,
                                              ),
                                            ),
                                            const SizedBox(width: 15),
                                            Obx(
                                                  () => DateWithThreeTextField(
                                                title: "From Date",
                                                splitType: "-",
                                                widthRation: controllerX.widthSize,
                                                isEnable: controller.isEnable.value,
                                                onFocusChange: (data) {
                                                  print('Selected Date $data');

                                                },
                                                mainTextController: controllerX.date_,
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10, top: 17.0),
                                              child: FormButton(
                                                btnText: "Show Details",
                                                callback: () {},
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 17.0),
                                              child: FormButton(
                                                btnText: "Import",
                                                callback: () {},
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10, top: 17.0),
                                              child: FormButton(
                                                btnText: "Delete",
                                                callback: () {},
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                  ),
                                  Expanded(
                                    //flex: 1,
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        programTable(context),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    //flex: 1,
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        policyTable(context),
                                      ],
                                    ),
                                  ),
                                  const Padding(
                                      padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                                      child: Text("Time Band : 00:00:00")),
                                  Padding(
                                    padding:
                                    const EdgeInsets.fromLTRB(0, 0, 0, 10),
                                    child: Row(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.end,
                                      children: [
                                        const Text("Program : PrgName"),
                                        const Spacer(),
                                        Padding(
                                          padding:
                                          const EdgeInsets.only(top: 5.0),
                                          child: InputFields.formField1Width(
                                              widthRatio: 0.09,
                                              paddingLeft: 5,
                                              hintTxt: "Available",
                                              controller: controllerX.segNo_,
                                              maxLen: 10),
                                        ),
                                        Padding(
                                          padding:
                                          const EdgeInsets.only(top: 5.0),
                                          child: InputFields.formField1Width(
                                              widthRatio: 0.09,
                                              paddingLeft: 5,
                                              hintTxt: "Scheduled",
                                              controller: controllerX.segNo_,
                                              maxLen: 10),
                                        ),
                                        Padding(
                                          padding:
                                          const EdgeInsets.only(top: 5.0),
                                          child: InputFields.formField1Width(
                                              widthRatio: 0.09,
                                              paddingLeft: 5,
                                              hintTxt: "Count",
                                              controller: controllerX.segNo_,
                                              maxLen: 10),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          /// Caption Table
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(0, 10, 15, 0),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Padding(
                                          padding:
                                          const EdgeInsets.only(top: 5.0),
                                          child: InputFields.formField1Width(
                                              widthRatio: .15,
                                              paddingLeft: 5,
                                              hintTxt: "Promo Caption",
                                              controller: controllerX.tapeId_,
                                              maxLen: 10),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Padding(
                                          padding:
                                          const EdgeInsets.only(top: 5.0),
                                          child: InputFields.formField1Width(
                                              widthRatio:
                                              (Get.width * 0.2) / 2 + 7,
                                              paddingLeft: 5,
                                              isEnable: false,
                                              hintTxt: "",
                                              controller: controllerX.segNo_,
                                              maxLen: 10),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Padding(
                                          padding:
                                          const EdgeInsets.only(top: 5.0),
                                          child: InputFields.formField1Width(
                                              widthRatio:
                                              (Get.width * 0.2) / 2 + 7,
                                              paddingLeft: 5,
                                              hintTxt: "Promo Id",
                                              controller: controllerX.tapeId_,
                                              maxLen: 10),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            bottom: 8.0, top: 8.0),
                                        child: Row(children: [
                                          Radio(
                                            value: 0,
                                            groupValue:
                                            controllerX.selectedAfter,
                                            onChanged: (int? value) {},
                                          ),
                                          const Text('My')
                                        ]),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10, bottom: 5.0, top: 5.0),
                                        child: FormButton(
                                          btnText: "Search",
                                          callback: () {},
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10, bottom: 5.0, top: 5.0),
                                        child: FormButton(
                                          btnText: "Add",
                                          callback: () {},
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10, bottom: 5.0, top: 5.0),
                                        child: FormButton(
                                          btnText: "Auto Add",
                                          callback: () {},
                                        ),
                                      ),
                                    ],
                                  ),
                                  captionTable(context)
                                ],
                              ),
                            ),
                          ),
                        ],
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
          );
        });
  }

  Widget programTable(context) {
    return GetBuilder<FillerController>(
        id: "programTable",
        builder: (controller) {
          if (controllerX.fillerDailyFpcList != null &&
              (controllerX.fillerDailyFpcList?.isNotEmpty)!) {
            // final key = GlobalKey();
            return DataGridFromMap(
              mapData: (controllerX.fillerDailyFpcList
                  ?.map((e) => e.toJson())
                  .toList())!,
              widthRatio: (Get.width * 0.2) / 2 + 7,
              // mode: PlutoGridMode.select,
              onSelected: (plutoGrid) {
                controllerX.selectedDailyFPC =
                controllerX.fillerDailyFpcList![plutoGrid.rowIdx!];
                print(jsonEncode(controllerX.selectedDailyFPC?.toJson()));
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
                child: Container(),
              ),
            );
          }
        });
  }

  Widget policyTable(context) {
    return GetBuilder<FillerController>(
        id: "policyTable",
        builder: (controller) {
          if (controllerX.fillerSegmentList != null &&
              (controllerX.fillerSegmentList?.isNotEmpty)!) {
            return Expanded(
              child: DataGridFromMap(
                mapData: (controllerX.fillerSegmentList
                    ?.map((e) => e.toJson())
                    .toList())!,
                widthRatio: (Get.width * 0.2) / 2 + 7,
                onSelected: (plutoGrid) {
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

                ),
              ),
            );
          }
        });
  }

  Widget captionTable(context) {
    return GetBuilder<PromosController>(
        id: "captionTable",
        builder: (controller) {
          if (controllerX.fillerDailyFpcList != null &&
              (controllerX.fillerDailyFpcList?.isNotEmpty)!) {
            // final key = GlobalKey();
            return Expanded(
              // height: 400,
              child: DataGridFromMap(
                mapData: (controllerX.fillerDailyFpcList
                    ?.map((e) => e.toJson())
                    .toList())!,
                widthRatio: (Get.width * 0.2) / 2 + 7,
                // mode: PlutoGridMode.select,
                onSelected: (plutoGrid) {
                  controllerX.selectedDailyFPC =
                  controllerX.fillerDailyFpcList![plutoGrid.rowIdx!];
                  print(jsonEncode(controllerX.selectedDailyFPC?.toJson()));
                },
              ),
            );
          } else {
            return Container(
              //height: Get.height - (4 * kToolbarHeight),
            );
          }
        });
  }
}
