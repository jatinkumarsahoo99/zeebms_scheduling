import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../../widgets/DateTime/DateWithThreeTextField.dart';
import '../../../../widgets/FormButton.dart';
import '../../../../widgets/LoadingScreen.dart';
import '../../../../widgets/dropdown.dart';
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
                      padding:EdgeInsets.symmetric(horizontal: 5),
                      onValueChanged: (i) {
                        controller.segmentedControlGroupValue.value = i as int;
                      }),
                )),
            Obx(() => Expanded(
              child: Column(
                children: [
                  if(controller.segmentedControlGroupValue.value==0)
                     droppedSpots()
                  else if(controller.segmentedControlGroupValue.value==1)
                     removeRunningSpots()
                  else if(controller.segmentedControlGroupValue.value==2)
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
                      (data) {},
                  "Location",
                  controller.widthSize,
                  // isEnable: controllerX.isEnable.value,
                  searchReq: true,
                  // selected: controllerX.selectOrgValue,
                )),
                SizedBox(width: 3,),
                Obx(() => DropDownField.formDropDown1WidthMap(
                  controller.channelList.value ?? [],
                      (data) {
                    // controllerX.orgRepeatId = data.key;
                    // controllerX.getEpisodeAndSegment();
                    // controllerX.txtEditingControl[0].text = "AUTO";
                    // controllerX.selectOrgValue.value = data;
                  },
                  "Channel",
                  controller.widthSize,

                  // isEnable: controllerX.isEnable.value,
                  searchReq: true,
                  // selected: controllerX.selectOrgValue,
                )),
                SizedBox(width: 3,),
                Obx(() => DropDownField.formDropDown1WidthMap(
                  controller.channelList.value,
                      (data) {
                    // controllerX.orgRepeatId = data.key;
                    // controllerX.getEpisodeAndSegment();
                    // controllerX.txtEditingControl[0].text = "AUTO";
                    // controllerX.selectOrgValue.value = data;
                  },
                  "Client",
                  controller.widthSize,
                  // isEnable: controllerX.isEnable.value,
                  searchReq: true,
                  // selected: controllerX.selectOrgValue,
                )),
                SizedBox(width: 3,),
                Obx(() => DropDownField.formDropDown1WidthMap(
                  controller.channelList.value,
                      (data) {
                    // controllerX.orgRepeatId = data.key;
                    // controllerX.getEpisodeAndSegment();
                    // controllerX.txtEditingControl[0].text = "AUTO";
                    // controllerX.selectOrgValue.value = data;
                  },
                  "Agency",
                  controller.widthSize,
                  // isEnable: controllerX.isEnable.value,
                  searchReq: true,
                  // selected: controllerX.selectOrgValue,
                )),
                SizedBox(width: 3,),
                DateWithThreeTextField(
                  title: "From Date",
                  splitType: "-",
                  widthRation: 0.12,
                  // isEnable: controller.isEnable.value,
                  onFocusChange: (data) {
                    // controller.selectedDate.text =
                    //     DateFormat('dd/MM/yyyy').format(
                    //         DateFormat("dd-MM-yyyy").parse(data));
                    // DateFormat("dd-MM-yyyy").parse(data);
                    print("Called when focus changed");
                    /*controller.getDailyFPCDetailsList(
                                          controller.selectedLocationId.text,
                                          controller.selectedChannelId.text,
                                          controller.convertToAPIDateType(),
                                        );*/

                    // controller.isTableDisplayed.value = true;
                  },
                  mainTextController: controller.selectedFrmDate,

                ),
                SizedBox(width: 3,),
                DateWithThreeTextField(
                  title: "To Date",
                  splitType: "-",
                  widthRation: 0.12,
                  // isEnable: controller.isEnable.value,
                  onFocusChange: (data) {
                    // controller.selectedDate.text =
                    //     DateFormat('dd/MM/yyyy').format(
                    //         DateFormat("dd-MM-yyyy").parse(data));
                    // DateFormat("dd-MM-yyyy").parse(data);
                    print("Called when focus changed");
                    /*controller.getDailyFPCDetailsList(
                                          controller.selectedLocationId.text,
                                          controller.selectedChannelId.text,
                                          controller.convertToAPIDateType(),
                                        );*/

                    // controller.isTableDisplayed.value = true;
                  },
                  mainTextController: controller.selectedToDate,
                ),
                SizedBox(width: 5,),
                Padding(
                  padding: const EdgeInsets.only(left: 10, top: 15),
                  child: FormButton(
                    btnText: "Generate",
                    callback: () {
                      // controllerX.calculateSegDur();
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
                  print("Called this Update >>>listUpdate");
                  // if (controller.actualDefaults != null &&
                  //     (controller.actualDefaults!.isNotEmpty)) {
                  //   print("Actual Defaults Not Empty");
                  //   // final key = GlobalKey();
                  //   return Expanded(
                  //     child: Padding(
                  //       padding: const EdgeInsets.symmetric(horizontal: 10),
                  //       child: DataGridFromMap(
                  //         onFocusChange: (f) {
                  //           if (f) {
                  //             controllerX.gridcanFocus =
                  //                 PlutoGridMode.selectWithOneTap;
                  //           }
                  //         },
                  //         mapData: (controller.actualDefaults
                  //             ?.map((e) => e.toJson1())
                  //             .toList())!,
                  //         widthRatio: (Get.width / 9) + 5,
                  //         actionOnPress: (index) {
                  //           print("Tapping $index");
                  //           // LoadingDialog.modify(
                  //           //   title,
                  //           //   confirm,
                  //           //   cancel,
                  //           // );
                  //           // Loadi
                  //           LoadingDialog.delete(
                  //               "Do you want to remove this row?", () {
                  //             // Get.find<TechnicalCheckController>().tcMasterModel1?.faultDetails?.removeAt(index);
                  //             // notifyListeners();
                  //             controller.actualDefaults?.removeAt(index);
                  //             controllerX.totalCalc();
                  //             controller.update(["listUpdate"]);
                  //           });
                  //
                  //           //     /*controller.stateManager!.updateRowData(controllerX.actualDefaults
                  //           // ?.map((e) => e.toJson1())
                  //           // .toList());*/
                  //
                  //           // controller.stateManager!.updateRowData(controllerX
                  //           //     .actualDefaults
                  //           //     ?.map((e) => e.toJson1())
                  //           //     .toList());
                  //         },
                  //         onRowDoubleTap: (event) {
                  //           var data = controller.actualDefaults![event.rowIdx];
                  //           controllerX.wholeCap.value =
                  //               data.segmentCaption ?? ""; //caption
                  //           controllerX.tcIn_.text = data.som!;
                  //           controllerX.segCtr.text = data.segNo!;
                  //           controllerX.segsNo.value = int.parse(data.segNo!);
                  //           controllerX.partNo.value =
                  //               int.parse(data.partnumber!);
                  //           controllerX.partCtr.text =
                  //               (data.partnumber ?? "").toString();
                  //           controllerX.tcOut_.text = data.eom!; //out
                  //           controllerX.durationVal.value =
                  //               data.segdur ?? ""; //duration
                  //         },
                  //         onSelected: (event) {
                  //           var data =
                  //               controller.actualDefaults![event.rowIdx ?? 0];
                  //           controllerX.segsNo.value = int.parse(data.segNo!);
                  //           controllerX.segCtr.text = data.segNo!;
                  //           controllerX.partNo.value =
                  //               int.parse(data.partnumber!);
                  //           controllerX.partCtr.text =
                  //               (data.partnumber ?? "").toString();
                  //           controllerX.wholeCap.value =
                  //               data.segmentCaption ?? ""; //caption
                  //           controllerX.tcIn_.text = data.som!; //in
                  //           controllerX.tcOut_.text = data.eom!; //out
                  //           controllerX.durationVal.value =
                  //               data.segdur ?? ""; //duration
                  //         },
                  //         showSrNo: true,
                  //         onload: (val) {
                  //           // print("onload Called ");
                  //           controller.stateManager = val.stateManager;
                  //           // print(controller.stateManager!.rows.length);
                  //           val.stateManager.setColumnSizeConfig(
                  //               PlutoGridColumnSizeConfig(
                  //                   autoSizeMode: PlutoAutoSizeMode.scale));
                  //         },
                  //         actionIcon: Icons.delete_forever_rounded,
                  //         actionIconKey: "Action",
                  //         // mode: controllerX.gridcanFocus,
                  //       ),
                  //     ),
                  //   );
                  // } else {
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
                  // }
                }),
            Padding(
              padding: const EdgeInsets.only(right:8.0,bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10, top: 15),
                    child: FormButton(
                      btnText: "Drop Spot",
                      callback: () {
                        // controllerX.calculateSegDur();
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
                  (data) {},
              "Location",
              controller.widthSize1,
              // isEnable: controllerX.isEnable.value,
              searchReq: true,
              // selected: controllerX.selectOrgValue,
            )),
            SizedBox(height: 5,),
            Obx(() => DropDownField.formDropDown1WidthMap(
              controller.channelList.value ?? [],
                  (data) {
                // controllerX.orgRepeatId = data.key;
                // controllerX.getEpisodeAndSegment();
                // controllerX.txtEditingControl[0].text = "AUTO";
                // controllerX.selectOrgValue.value = data;
              },
              "Channel",
              controller.widthSize1,

              // isEnable: controllerX.isEnable.value,
              searchReq: true,
              // selected: controllerX.selectOrgValue,
            )),
            SizedBox(height: 5,),
            DateWithThreeTextField(
              title: "Date",
              splitType: "-",
              widthRation: controller.widthSize1,
              // isEnable: controller.isEnable.value,
              onFocusChange: (data) {
                // controller.selectedDate.text =
                //     DateFormat('dd/MM/yyyy').format(
                //         DateFormat("dd-MM-yyyy").parse(data));
                // DateFormat("dd-MM-yyyy").parse(data);
                print("Called when focus changed");
                /*controller.getDailyFPCDetailsList(
                                      controller.selectedLocationId.text,
                                      controller.selectedChannelId.text,
                                      controller.convertToAPIDateType(),
                                    );*/

                // controller.isTableDisplayed.value = true;
              },
              mainTextController: controller.selectedFrmDate,


            ),

            SizedBox(height: 5,),
            Obx(() => DropDownField.formDropDown1WidthMap(
              controller.channelList.value,
                  (data) {
                // controllerX.orgRepeatId = data.key;
                // controllerX.getEpisodeAndSegment();
                // controllerX.txtEditingControl[0].text = "AUTO";
                // controllerX.selectOrgValue.value = data;
              },
              "Select File Name",
              controller.widthSize1,
              // isEnable: controllerX.isEnable.value,
              searchReq: true,
              // selected: controllerX.selectOrgValue,
            )),
            SizedBox(height: 5,),
            Padding(
              padding: const EdgeInsets.only(left: 10, top: 15),
              child: FormButton(
                btnText: "Remove File",
                callback: () {
                  // controllerX.calculateSegDur();
                  // controllerX.addTable();
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
                  (data) {},
              "Location",
              controller.widthSize1,
              // isEnable: controllerX.isEnable.value,
              searchReq: true,
              // selected: controllerX.selectOrgValue,
            )),
            SizedBox(height: 5,),
            Obx(() => DropDownField.formDropDown1WidthMap(
              controller.channelList.value ?? [],
                  (data) {
                // controllerX.orgRepeatId = data.key;
                // controllerX.getEpisodeAndSegment();
                // controllerX.txtEditingControl[0].text = "AUTO";
                // controllerX.selectOrgValue.value = data;
              },
              "Channel",
              controller.widthSize1,

              // isEnable: controllerX.isEnable.value,
              searchReq: true,
              // selected: controllerX.selectOrgValue,
            )),
            SizedBox(height: 5,),
            InputFields.formField1Width(
              hintTxt: "T.O. Number",
              paddingLeft: 0,
              controller: controller.toNumber,
              widthRatio: controller.widthSize1,
              // fN: controllerX.partNoFocus,
            ),

            SizedBox(height: 5,),
            Obx(() => DropDownField.formDropDown1WidthMap(
              controller.channelList.value,
                  (data) {
                // controllerX.orgRepeatId = data.key;
                // controllerX.getEpisodeAndSegment();
                // controllerX.txtEditingControl[0].text = "AUTO";
                // controllerX.selectOrgValue.value = data;
              },
              "Select File Name",
              controller.widthSize1,
              // isEnable: controllerX.isEnable.value,
              searchReq: true,
              // selected: controllerX.selectOrgValue,
            )),
            SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.only(left: 10, top: 15),
              child: FormButton(
                btnText: "Delete Commercial",
                callback: () {
                  // controllerX.calculateSegDur();
                  // controllerX.addTable();
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
