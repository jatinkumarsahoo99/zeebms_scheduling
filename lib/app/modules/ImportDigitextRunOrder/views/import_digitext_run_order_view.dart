import 'package:bms_scheduling/app/data/DropDownValue.dart';
import 'package:bms_scheduling/app/modules/RoBooking/views/dummydata.dart';
import 'package:bms_scheduling/app/providers/ApiFactory.dart';
import 'package:bms_scheduling/widgets/DataGridShowOnly.dart';
import 'package:bms_scheduling/widgets/DateTime/DateWithThreeTextField.dart';
import 'package:bms_scheduling/widgets/FormButton.dart';
import 'package:bms_scheduling/widgets/dropdown.dart';
import 'package:bms_scheduling/widgets/gridFromMap.dart';
import 'package:bms_scheduling/widgets/input_fields.dart';
import 'package:bms_scheduling/widgets/radio_row.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../controller/HomeController.dart';
import '../controllers/import_digitext_run_order_controller.dart';

class ImportDigitextRunOrderView
    extends GetView<ImportDigitextRunOrderController> {
  const ImportDigitextRunOrderView({Key? key}) : super(key: key);

  getPageData(int index) {
    switch (index) {
      case 0:
        return (controller.digitexRunOrderData?.missingClients
                ?.map((e) => e.toJson())
                .toList() ??
            []);
      case 1:
        return (controller.digitexRunOrderData?.newBrands ?? []);
      case 2:
        return (controller.digitexRunOrderData?.newClocks ?? []);
      case 3:
        return (controller.digitexRunOrderData?.missingAgencies
                ?.map((e) => e.toJson())
                .toList() ??
            []);
      case 4:
        return (controller.digitexRunOrderData?.missingLinks
                ?.map((e) => e.toJson())
                .toList() ??
            []);
      case 5:
        return (controller.digitexRunOrderData?.myData
                ?.map((e) => e.toJson())
                .toList() ??
            []);
      default:
        return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Top Section with Controls
          Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: Get.width * 0.72,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Obx(
                          () => DropDownField.formDropDown1WidthMap(
                              controller.locations.value, (value) {
                            controller.selectedLocation = value;
                            controller.getChannel(value.key);
                          }, "Location", 0.24),
                        ),
                        Obx(
                          () => DropDownField.formDropDown1WidthMap(
                              controller.channels.value, (value) {
                            controller.selectedChannel = value;
                          }, "Channel", 0.24),
                        ),
                        DateWithThreeTextField(
                            title: "Schedule Date.",
                            widthRation: 0.12,
                            mainTextController: controller.scheduleDate),
                        FormButtonWrapper(
                          btnText: "Load",
                          callback: () {
                            controller.pickFile();
                          },
                        )
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InputFields.formField1(
                      hintTxt: "File",
                      isEnable: false,
                      width: 0.72,
                      controller: controller.fileController),
                ),
              ],
            ),
          ),
          // Card(
          //   clipBehavior: Clip.hardEdge,
          //   shape: RoundedRectangleBorder(
          //       borderRadius: BorderRadius.vertical(
          //           top: Radius.circular(8), bottom: Radius.zero)),
          //   margin: EdgeInsets.fromLTRB(4, 4, 4, 0),
          //   child: RadioRow(
          //       items: controller.radiofilters,
          //       groupValue: controller.selectedradiofilter),
          // ),
          Obx(() => Padding(
                padding: const EdgeInsets.all(4.0),
                child: CupertinoSlidingSegmentedControl(
                    groupValue: controller.selectedradiofilter.value,
                    children: Map.fromEntries(controller.radiofilters
                        .map((e) => MapEntry(e, Text(e)))),
                    onValueChanged: (value) {
                      controller.selectedradiofilter.value = value ?? "";
                      controller.pageController
                          .jumpToPage(controller.radiofilters.indexOf(value!));
                    }),
              )),
          // Middle Section taking up entire remaining space
          Expanded(
            child: Container(
                padding: EdgeInsets.all(4),
                child: GetBuilder<ImportDigitextRunOrderController>(
                    init: controller,
                    id: "data",
                    builder: (digtexController) {
                      print("updating  grid");
                      if (digtexController.digitexRunOrderData != null) {
                        return PageView.builder(
                            controller: controller.pageController,
                            itemCount: controller.radiofilters.length,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return Stack(
                                alignment: Alignment.bottomRight,
                                children: [
                                  DataGridShowOnlyKeys(
                                    mapData: getPageData(index),
                                    formatDate: false,
                                    onload: (load) {
                                      if (index == 0) {
                                        controller.clientGridStateManager =
                                            load.stateManager;
                                      }
                                    },
                                    hideCode: false,
                                    onRowDoubleTap: (tapEvent) {
                                      DropDownValue? _client;
                                      if (index == 0) {
                                        Get.defaultDialog(
                                            title: "Map Clients",
                                            content: Column(
                                              children: [
                                                InputFields.formField1(
                                                    hintTxt: "Digitex",
                                                    width: 0.24,
                                                    isEnable: false,
                                                    controller:
                                                        TextEditingController(
                                                            text: tapEvent
                                                                    .row
                                                                    .cells[
                                                                        "clientstoCreate"]
                                                                    ?.value ??
                                                                "")),
                                                DropDownField
                                                    .formDropDownSearchAPI2(
                                                        GlobalKey(), context,
                                                        parseKeyForKey:
                                                            "clientCode",
                                                        parseKeyForValue:
                                                            "clientName",
                                                        title: "Client",
                                                        url: ApiFactory
                                                            .IMPORT_DIGITEX_RUN_ORDER_CLIENT,
                                                        onchanged: (data) {
                                                  _client = data;
                                                }),
                                              ],
                                            ),
                                            cancel: FormButtonWrapper(
                                                btnText: "Map",
                                                callback: () {
                                                  if (_client != null) {
                                                    controller.updateClientData(
                                                        tapEvent, _client!);
                                                  }
                                                }),
                                            confirm: FormButtonWrapper(
                                                btnText: "Clear",
                                                callback: () {
                                                  controller.clearClientData(
                                                      tapEvent, _client!);
                                                }));
                                      } else if (index == 3) {
                                        Get.defaultDialog(
                                            title: "Map Agency",
                                            content: Column(
                                              children: [
                                                InputFields.formField1(
                                                    hintTxt: "Digitex",
                                                    width: 0.24,
                                                    isEnable: false,
                                                    controller:
                                                        TextEditingController(
                                                            text: tapEvent
                                                                    .row
                                                                    .cells[
                                                                        "agenciestoCreate"]
                                                                    ?.value ??
                                                                "")),
                                                DropDownField
                                                    .formDropDownSearchAPI2(
                                                        GlobalKey(), context,
                                                        parseKeyForKey:
                                                            "agencyCode",
                                                        parseKeyForValue:
                                                            "agencyName",
                                                        title: "Agency",
                                                        url: ApiFactory
                                                            .IMPORT_DIGITEX_RUN_ORDER_AGENCY,
                                                        onchanged: (data) {
                                                  _client = data;
                                                }),
                                              ],
                                            ),
                                            cancel: FormButtonWrapper(
                                                btnText: "Map",
                                                callback: () {
                                                  if (_client != null) {
                                                    controller.updateAgencyData(
                                                        tapEvent, _client!);
                                                  }
                                                }),
                                            confirm: FormButtonWrapper(
                                                btnText: "Clear",
                                                callback: () {
                                                  controller.clearAgencyData(
                                                      tapEvent, _client!);
                                                }));
                                      }
                                    },
                                  ),
                                  if (index == 0)
                                    ElevatedButton(
                                        onPressed: () {
                                          controller.mapClients();
                                        },
                                        child: Text("Map Client")),
                                  if (index == 3)
                                    ElevatedButton(
                                        onPressed: () {
                                          controller.mapAgencies();
                                        },
                                        child: Text("Map Agencies"))
                                ],
                              );
                            });
                      } else {
                        return Container();
                      }
                    })),
          ),

          // Bottom Section with 50 height container
          GetBuilder<HomeController>(
              id: "buttons",
              init: Get.find<HomeController>(),
              builder: (btncontroller) {
                /* PermissionModel formPermissions = Get.find<MainController>()
                      .permissionList!
                      .lastWhere((element) {
                    return element.appFormName == "frmSegmentsDetails";
                  });*/

                return SizedBox(
                  height: 40,
                  child: ButtonBar(
                    // buttonHeight: 20,
                    alignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    // pa
                    children: [
                      for (var btn in btncontroller.buttons!)
                        btn["name"] == "Save"
                            ? Obx(() => FormButtonWrapper(
                                  btnText: btn["name"],

                                  // isEnabled: btn['isDisabled'],
                                  callback: controller.allowSave.value == true
                                      ? () {
                                          controller.saveRunOrder();
                                        }
                                      : null,
                                ))
                            : btn["name"] == "Clear"
                                ? FormButtonWrapper(
                                    btnText: btn["name"],

                                    // isEnabled: btn['isDisabled'],
                                    callback: () {
                                      btncontroller.clearPage1();
                                    },
                                  )
                                : FormButtonWrapper(
                                    btnText: btn["name"],

                                    // isEnabled: btn['isDisabled'],
                                    callback: null,
                                  ),
                    ],
                  ),
                );
              }),
        ],
      ),
    );
  }
}
