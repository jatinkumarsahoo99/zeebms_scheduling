import 'package:bms_scheduling/app/data/DropDownValue.dart';
import 'package:bms_scheduling/widgets/DateTime/DateWithThreeTextField.dart';
import 'package:bms_scheduling/widgets/dropdown.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../widgets/DateTime/TimeWithThreeTextField.dart';
import '../../../../widgets/FormButton.dart';
import '../../../../widgets/input_fields.dart';
import '../../../../widgets/radio_row.dart';
import '../../../controller/HomeController.dart';
import '../controllers/slide_master_controller.dart';

class SlideMasterView extends GetView<SlideMasterController> {
  const SlideMasterView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: size.width * .64,
          child: Dialog(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppBar(
                  title: Text('Slide Master'),
                  centerTitle: true,
                  backgroundColor: Colors.deepPurple,
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Obx(() {
                      return DropDownField.formDropDown1WidthMap(
                        controller.locationList.value,
                        controller.handleOnChangedLocation,
                        "Location",
                        .23,
                        autoFocus: true,
                        selected: controller.selectedLocation,
                      );
                    }),
                    SizedBox(width: 20),
                    Obx(() {
                      return DropDownField.formDropDown1WidthMap(
                        controller.channelList.value,
                        controller.handleOnChangedChannel,
                        "Channel",
                        .23,
                        selected: controller.selectedChannel,
                      );
                    }),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          InputFields.formField1(
                            hintTxt: "Tape ID",
                            controller: controller.tapeIDCtr,
                            width: 0.112,
                            focusNode: controller.tapIDFN,
                            // isEnable: controllsEnable,
                          ),
                          SizedBox(width: 10),
                          InputFields.formField1(
                            hintTxt: "Seg No.",
                            controller: controller.segNoCtr,
                            width: 0.11,
                          ),
                        ],
                      ),
                      SizedBox(width: 20),
                      Row(
                        children: [
                          InputFields.formField1(
                            hintTxt: "House ID",
                            controller: controller.houseIDCtr,
                            width: 0.11,
                          ),
                          SizedBox(width: 10),
                          InputFields.formField1(
                            hintTxt: "TX Caption",
                            controller: controller.txCaptionCtr,
                            width: 0.11,
                            prefixText: "L/",
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InputFields.formField1(
                      hintTxt: "Caption",
                      controller: controller.captionCtr,
                      width: 0.23,
                    ),
                    SizedBox(width: 20),
                    Obx(() {
                      return DropDownField.formDropDown1WidthMap(
                        controller.slideTypeList.value
                            .map((e) => DropDownValue(
                                  key: e['lookupCode'].toString(),
                                  value: e['lookupType'].toString(),
                                ))
                            .toList(),
                        controller.handleOnChangedSlideType,
                        "Slide type",
                        .23,
                      );
                    }),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Obx(() {
                            return DropDownField.formDropDown1WidthMap(
                              controller.tapeTypeList.value
                                  .map((e) => DropDownValue(
                                        key: e['tapetypecode'],
                                        value: e['tapeTypeName'],
                                      ))
                                  .toList(),
                              controller.handleOnChangedTapeType,
                              "Tape Type",
                              .112,
                              selected: controller.selectedTape,
                            );
                          }),
                          SizedBox(width: 13),
                          TimeWithThreeTextField(
                            title: "SOM",
                            mainTextController: controller.somCtr,
                            widthRation: 0.11,
                            isTime: false,
                          ),
                        ],
                      ),
                      SizedBox(width: 20),
                      Row(
                        children: [
                          TimeWithThreeTextField(
                            title: "EOM",
                            mainTextController: controller.eomCtr,
                            widthRation: 0.11,
                            isTime: false,
                          ),
                          SizedBox(width: 10),
                          TimeWithThreeTextField(
                            title: "Duration",
                            mainTextController: controller.durationCtr,
                            widthRation: 0.11,
                            isTime: false,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(
                        width: context.width * .23,
                        child: Obx(() {
                          return RadioRow(
                            items: ['Non-Dated', 'Dated'],
                            groupValue: controller.selectedRadio.value,
                            onchange: (val) {
                              controller.selectedRadio.value = val;
                            },
                            disabledRadios: ['Non-Dated'],
                          );
                        }),
                      ),
                      SizedBox(width: 20),
                      DateWithThreeTextField(
                        title: "Upto Date",
                        mainTextController: TextEditingController(),
                        widthRation: .225,
                      )
                    ],
                  ),
                ),
                SizedBox(height: 20),

                /// bottom common buttons
                Align(
                  alignment: Alignment.topCenter,
                  child: GetBuilder<HomeController>(
                      id: "buttons",
                      init: Get.find<HomeController>(),
                      builder: (btncontroller) {
                        if (btncontroller.buttons != null) {
                          return SizedBox(
                            height: 40,
                            child: Wrap(
                              spacing: 5,
                              runSpacing: 15,
                              alignment: WrapAlignment.center,
                              // alignment: MainAxisAlignment.start,
                              // mainAxisSize: MainAxisSize.min,
                              children: [
                                for (var btn in btncontroller.buttons!)
                                  FormButtonWrapper(
                                    btnText: btn["name"],
                                    callback: btn["name"] == "Save" ? null : () => controller.formHandler(btn['name'].toString()),
                                  ),
                              ],
                            ),
                          );
                        }
                        return Container();
                      }),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
