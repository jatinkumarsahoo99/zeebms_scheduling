import 'package:bms_scheduling/app/modules/RoBooking/views/dummydata.dart';
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
                  child: Container(
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
                            mainTextController: TextEditingController()),
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
                                    hideCode: false,
                                    onRowDoubleTap: (tapEvent) {
                                      print(tapEvent.rowIdx.toString());
                                    },
                                  ),
                                  if (index == 0)
                                    ElevatedButton(
                                        onPressed: () {},
                                        child: Text("Map Client")),
                                  if (index == 3)
                                    ElevatedButton(
                                        onPressed: () {},
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
          Container(
            height: 50.0,
            child: Center(
              child:
                  Text('This is the bottom button section based on permission'),
            ),
          ),
        ],
      ),
    );
  }
}
