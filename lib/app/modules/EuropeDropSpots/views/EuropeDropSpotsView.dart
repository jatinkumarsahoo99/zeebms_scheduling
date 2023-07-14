import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../../widgets/DateTime/DateWithThreeTextField.dart';
import '../../../../widgets/FormButton.dart';
import '../../../../widgets/LoadingScreen.dart';
import '../../../../widgets/dropdown.dart';
import '../../../../widgets/gridFromMap.dart';
import '../../../../widgets/input_fields.dart';
import '../controllers/EuropeDropSpotsController.dart';

class EuropeDropSpotsView extends GetView<EuropeDropSpotsController> {
  EuropeDropSpotsController controller = Get.put(EuropeDropSpotsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: double.maxFinite,
        width: double.maxFinite,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 10,
            ),
            Obx(() => Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: CupertinoSlidingSegmentedControl(
                      groupValue: controller.segmentedControlGroupValue.value,
                      children: controller.myTabs,
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      onValueChanged: (i) {
                        controller.segmentedControlGroupValue.value = i as int;
                      }),
                )),
            SizedBox(
              height: 5,
            ),
            Obx(() => Expanded(
                  child: Column(
                    children: [
                      if (controller.segmentedControlGroupValue.value == 0)
                        droppedSpots()
                      else if (controller.segmentedControlGroupValue.value == 1)
                        removeRunningSpots()
                      else if (controller.segmentedControlGroupValue.value == 2)
                        deleteCommercial()
                    ],
                  ),
                ))
          ],
        ),
      ),
    );
  }

  Widget droppedSpots() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0),
        child: Column(
          children: [
            Row(
              children: [
                Obx(() => DropDownField.formDropDown1WidthMap(
                      controller.locationList.value ?? [],
                      (data) {
                        controller.selectLocation = data;
                        controller.getChannel(data.key, 1);
                      },
                      "Location",
                      controller.widthSize,
                      // isEnable: controllerX.isEnable.value,
                      searchReq: true,
                      selected: controller.selectLocation,
                    )),
                SizedBox(
                  width: 3,
                ),
                Obx(() => DropDownField.formDropDown1WidthMap(
                      controller.channelList.value ?? [],
                      (data) {
                        controller.selectChannel = data;
                        controller.getClientList();
                        ;
                      },
                      "Channel",
                      controller.widthSize,

                      // isEnable: controllerX.isEnable.value,
                      searchReq: true,
                      selected: controller.selectChannel,
                    )),
                SizedBox(
                  width: 3,
                ),
                Obx(() => DropDownField.formDropDown1WidthMap(
                      controller.clientList.value,
                      (data) {
                        controller.selectClient = data;
                        controller.getAgentList();
                      },
                      "Client",
                      controller.widthSize,
                      // isEnable: controllerX.isEnable.value,
                      searchReq: true,
                      // selected: controllerX.selectOrgValue,
                    )),
                SizedBox(
                  width: 3,
                ),
                Obx(() => DropDownField.formDropDown1WidthMap(
                      controller.agentList.value,
                      (data) {
                        controller.selectAgency = data;
                      },
                      "Agency",
                      controller.widthSize,
                      // isEnable: controllerX.isEnable.value,
                      searchReq: true,
                      // selected: controllerX.selectOrgValue,
                    )),
                SizedBox(
                  width: 3,
                ),
                DateWithThreeTextField(
                  title: "From Date",
                  splitType: "-",
                  widthRation: 0.12,
                  // isEnable: controller.isEnable.value,
                  onFocusChange: (data) {},
                  mainTextController: controller.selectedFrmDate,
                ),
                SizedBox(
                  width: 3,
                ),
                DateWithThreeTextField(
                  title: "To Date",
                  splitType: "-",
                  widthRation: 0.12,
                  // isEnable: controller.isEnable.value,
                  onFocusChange: (data) {},
                  mainTextController: controller.selectedToDate,
                ),
                SizedBox(
                  width: 5,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10, top: 15),
                  child: FormButton(
                    btnText: "Generate",
                    callback: () {
                      controller.postGenerate();
                      // controllerX.addTable();
                    },
                    showIcon: false,
                  ),
                ),
              ],
            ),
            GetBuilder<EuropeDropSpotsController>(
                id: "listUpdate",
                init: controller,
                // init: CreateBreakPatternController(),
                builder: (controller) {
                  if (controller.europeSpotModel != null &&
                      ((controller.europeSpotModel?.generates?.length ?? 0) >
                          0)) {
                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: DataGridFromMap(
                          mapData: (controller.europeSpotModel?.generates
                              ?.map((e) => e.toJson())
                              .toList())!,
                          widthRatio: (Get.width / 9) + 5,
                          checkRowKey: "clientname",
                          hideKeys: ["selectItem"],
                          checkRow: true,
                          showSrNo: false,
                          // actionIcon: Icons.delete_forever_rounded,
                        ),
                      ),
                    );
                  } else {
                    return Expanded(
                      child: Card(
                        clipBehavior: Clip.hardEdge,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(0), // if you need this
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
                }),
            Padding(
              padding: const EdgeInsets.only(right: 8.0, bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10, top: 15),
                    child: FormButton(
                      btnText: "Drop Spot",
                      callback: () {

                        // controllerX.addTable();
                      },
                      showIcon: false,
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget removeRunningSpots() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0),
        child: Column(
          children: [
            Obx(() => DropDownField.formDropDown1WidthMap(
                  controller.locationList.value ?? [],
                  (data) {
                    controller.selectLocation_removeorder = data;
                    controller.getChannel(data.key, 2);
                  },
                  "Location",
                  controller.widthSize1,
                  // isEnable: controllerX.isEnable.value,
                  searchReq: true,
                  // selected: controllerX.selectOrgValue,
                )),
            SizedBox(
              height: 5,
            ),
            Obx(() => DropDownField.formDropDown1WidthMap(
                  controller.channelList1.value ?? [],
                  (data) {
                    controller.selectChannel_removeorder = data;
                    controller.getRunDate1();
                  },
                  "Channel",
                  controller.widthSize1,

                  // isEnable: controllerX.isEnable.value,
                  searchReq: true,
                  // selected: controllerX.selectOrgValue,
                )),
            SizedBox(
              height: 5,
            ),
            DateWithThreeTextField(
              title: "Date",
              splitType: "-",
              widthRation: controller.widthSize1,
              // isEnable: controller.isEnable.value,
              onFocusChange: (data) {
                controller.getRunDate1();
              },
              mainTextController: controller.selectedRemoveDate,
            ),
            SizedBox(
              height: 5,
            ),
            Obx(() {
              print("Data refresh");
              return DropDownField.formDropDown1WidthMap(
                controller.fileList.value,
                    (data) {
                      controller.selectFile=data;
                },
                "Select File Name",
                controller.widthSize1,
                // isEnable: controllerX.isEnable.value,
                searchReq: true,
                // selected: controllerX.selectOrgValue,
              );
            } ),
            SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, top: 15),
              child: FormButton(
                btnText: "Remove File",
                callback: () {
                  // controllerX.calculateSegDur();
                  // controllerX.addTable();
                  controller.postRemoval();
                },
                showIcon: false,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget deleteCommercial() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0),
        child: Column(
          children: [
            Obx(() => DropDownField.formDropDown1WidthMap(
                  controller.locationList.value ?? [],
                  (data) {
                    controller.selectLocation_deleteRussia = data;
                    controller.getChannel(data.key, 3);
                  },
                  "Location",
                  controller.widthSize1,
                  // isEnable: controllerX.isEnable.value,
                  searchReq: true,
                  // selected: controllerX.selectOrgValue,
                )),
            SizedBox(
              height: 5,
            ),
            Obx(() => DropDownField.formDropDown1WidthMap(
                  controller.channelList2.value ?? [],
                  (data) {
                    controller.selectChannel_deleteRussia = data;
                  },
                  "Channel",
                  controller.widthSize1,

                  // isEnable: controllerX.isEnable.value,
                  searchReq: true,
                  // selected: controllerX.selectOrgValue,
                )),
            SizedBox(
              height: 5,
            ),
            InputFields.formField1Width(
              hintTxt: "T.O. Number",
              paddingLeft: 0,
              controller: controller.toNumber,
              widthRatio: controller.widthSize1,
              // fN: controllerX.partNoFocus,
            ),

            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, top: 15),
              child: FormButton(
                btnText: "Delete Commercial",
                callback: () {
                  // controllerX.calculateSegDur();
                  controller.deleteCommercial();
                },
                showIcon: false,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
