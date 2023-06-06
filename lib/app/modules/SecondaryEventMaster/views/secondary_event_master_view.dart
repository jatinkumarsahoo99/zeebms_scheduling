import 'package:bms_scheduling/widgets/DateTime/TimeWithThreeTextField.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../../widgets/DateTime/DateWithThreeTextField.dart';
import '../../../../widgets/FormButton.dart';
import '../../../../widgets/dropdown.dart';
import '../../../../widgets/input_fields.dart';
import '../../../../widgets/radio_row.dart';
import '../../../controller/HomeController.dart';
import '../controllers/secondary_event_master_controller.dart';

class SecondaryEventMasterView extends GetView<SecondaryEventMasterController> {
  const SecondaryEventMasterView({Key? key}) : super(key: key);
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
                  title: Text('Non Commercial Secondary Events'),
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
                        controller.getChannels,
                        "Location",
                        .23,
                        autoFocus: true,
                        selected: controller.selectedLoc,
                        inkWellFocusNode: controller.locFN,
                      );
                    }),
                    SizedBox(width: 20),
                    Obx(() {
                      return DropDownField.formDropDown1WidthMap(
                        controller.channelList.value,
                        (val) => controller.selectedChannel = val,
                        "Channel",
                        .23,
                        selected: controller.selectedChannel,
                      );
                    }),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: context.width * .23,
                        child: Obx(() {
                          return RadioRow(
                            items: ['Bug', 'Aston'],
                            groupValue: controller.selectedRadio.value,
                            disabledRadios: !(controller.controllsEnabled.value) ? ['Bug', 'Aston'] : null,
                            onchange: (va) => controller.selectedRadio = va,
                          );
                        }),
                      ),
                      SizedBox(width: 20),
                      Obx(
                        () {
                          return InputFields.formField1(
                            hintTxt: "Tx No",
                            controller: controller.txNoTC,
                            width: 0.225,
                            isEnable: controller.controllsEnabled.value,
                            focusNode: controller.txNOFN,
                          );
                        },
                      ),
                    ],
                  ),
                ),
                InputFields.formField1(
                  hintTxt: "Event Name",
                  controller: controller.eventNameTC,
                  focusNode: controller.eventNameFN,
                  width: 0.475,
                ),
                SizedBox(height: 4),
                InputFields.formField1(
                  hintTxt: "TX Caption",
                  controller: controller.txCaptionTC,
                  width: 0.475,
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InputFields.formFieldNumberMask(
                        hintTxt: "SOM",
                        controller: controller.somTC,
                        widthRatio: .15,
                      ),
                      SizedBox(width: 16),
                      InputFields.formFieldNumberMask(
                        hintTxt: "EOM",
                        controller: controller.eomTC,
                        widthRatio: .15,
                        textFieldFN: controller.eomFN,
                      ),
                      SizedBox(width: 16),
                      Obx(() {
                        return InputFields.formFieldDisable(
                          hintTxt: "Duration",
                          value: controller.duration.value,
                          widthRatio: .15,
                        );
                      }),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      DateWithThreeTextField(
                        title: "Start Date",
                        mainTextController: controller.startDateTC,
                        widthRation: .230,
                      ),
                      SizedBox(width: 20),
                      DateWithThreeTextField(
                        title: "End Date",
                        mainTextController: controller.endDateTC,
                        widthRation: .230,
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
                                    callback: () => controller.formHandler(btn['name'].toString()),
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
