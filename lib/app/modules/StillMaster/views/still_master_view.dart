import 'package:bms_scheduling/app/providers/ApiFactory.dart';
import 'package:bms_scheduling/widgets/radio_row.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../widgets/DateTime/DateWithThreeTextField.dart';
import '../../../../widgets/DateTime/TimeWithThreeTextField.dart';
import '../../../../widgets/FormButton.dart';
import '../../../../widgets/LoadingDialog.dart';
import '../../../../widgets/dropdown.dart';
import '../../../../widgets/gridFromMap.dart';
import '../../../../widgets/input_fields.dart';
import '../../../controller/HomeController.dart';
import '../controllers/still_master_controller.dart';

typedef SaySomething = void Function(String name);

typedef Hey = void Function();

class StillMasterView extends GetView<StillMasterController> {
  const StillMasterView({Key? key}) : super(key: key);

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
                  title: Text('Still Master'),
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
                        selected: controller.selectedLocation,
                        inkWellFocusNode: controller.locationFN,
                      );
                    }),
                    SizedBox(width: 20),
                    Obx(() {
                      return DropDownField.formDropDown1WidthMap(
                        controller.channelList.value,
                        (p0) => controller.selectedChannel = p0,
                        "Channel",
                        .23,
                        selected: controller.selectedChannel,
                      );
                    }),
                  ],
                ),
                SizedBox(height: 4),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Spacer(),
                    Obx(() {
                      controller.locationList.value;
                      return DropDownField.formDropDownSearchAPI2(
                        GlobalKey(),
                        context,
                        width: context.width * 0.42,
                        onchanged: controller.handleOnChangedProgram,
                        title: 'Program',
                        url: ApiFactory.STILL_MASTER_PROGRAM_SEARCH,
                        selectedValue: controller.selectedProgram,
                        parseKeyForKey: "ProgramCode",
                        parseKeyForValue: "ProgramName",
                        inkwellFocus: controller.programFN,
                      );
                    }),
                    SizedBox(width: 20),
                    FormButton(
                      btnText: "..",
                      iconDataM: Icons.table_view_sharp,
                      callback: () => handleProgramShowDT(context),
                    ),
                    Spacer(),
                  ],
                ),
                SizedBox(height: 4),
                InputFields.formField1(
                  hintTxt: "Caption",
                  controller: controller.captionTC,
                  width: 0.475,
                  focusNode: controller.captionFN,
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
                            controller: controller.tapIDTC,
                            width: 0.112,
                            focusNode: controller.tapeIDFN,
                          ),
                          SizedBox(width: 10),
                          Obx(() {
                            return InputFields.formField1(
                              hintTxt: "Seg No.",
                              controller: controller.segTC,
                              width: 0.11,
                              isEnable: controller.controllsEnabled.value,
                              focusNode: controller.segFN,
                            );
                          }),
                        ],
                      ),
                      SizedBox(width: 20),
                      Row(
                        children: [
                          InputFields.formField1(
                            hintTxt: "House ID",
                            controller: controller.houseIDTC,
                            width: 0.11,
                            focusNode: controller.houseIDFN,
                          ),
                          SizedBox(width: 10),
                          InputFields.formField1(
                            hintTxt: "Copy",
                            controller: controller.copyTC,
                            width: 0.11,
                            focusNode: controller.copyFN,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: context.width * .23,
                      child: Column(
                        children: [
                          Obx(() {
                            return RadioRow(
                              items: ["Bumper", "Opening"],
                              groupValue: controller.firststSelectedRadio.value,
                              onchange: controller.handleChangeInRadio,
                            );
                          }),
                          Obx(() {
                            return RadioRow(
                              items: ["Closing", "Generic"],
                              groupValue: controller.firststSelectedRadio.value,
                              // onchange: (val) => controller.firststSelectedRadio.value = val,
                              onchange: controller.handleChangeInRadio,
                            );
                          }),
                        ],
                      ),
                    ),
                    SizedBox(width: 20),
                    Obx(() {
                      return InputFields.formField1(
                        hintTxt: "TX Caption",
                        controller: controller.txCaptionTC,
                        prefixText: controller.prefixText.value,
                        width: .225,
                        focusNode: controller.txCaptionFN,
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
                              controller.tapeList.value,
                              (p0) => controller.selectedTape = p0,
                              "Tape",
                              .112,
                              selected: controller.selectedTape,
                            );
                          }),
                          SizedBox(width: 10),
                          InputFields.formFieldNumberMask(
                            hintTxt: "SOM",
                            controller: controller.somTC,
                            widthRatio: .11,
                            paddingLeft: 0,
                          ),
                        ],
                      ),
                      SizedBox(width: 20),
                      Row(
                        children: [
                          InputFields.formFieldNumberMask(
                            hintTxt: "EOM",
                            controller: controller.eomTC,
                            widthRatio: .11,
                            paddingLeft: 0,
                            textFieldFN: controller.eomFN,
                          ),
                          SizedBox(width: 10),
                          Obx(() {
                            return InputFields.formFieldDisable(
                              hintTxt: "Duration",
                              value: controller.duration.value,
                              widthRatio: .11,
                              leftPad: 0,
                            );
                          }),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: context.width * .23,
                        child: RadioRow(
                          items: ['Non-Dated', 'Dated'],
                          groupValue: controller.secondSelectedRadio.value,
                          disabledRadios: ['Non-Dated'],
                        ),
                      ),
                      SizedBox(width: 20),
                      DateWithThreeTextField(
                        title: "Upto Date",
                        mainTextController: controller.upToDateTC,
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

  handleProgramShowDT(BuildContext context) {
    if (controller.selectedLocation == null || controller.selectedChannel == null) {
      LoadingDialog.showErrorDialog("Please select Location,Channel");
    } else {
      Get.defaultDialog(
        title: "Program Picker",
        content: FutureBuilder<bool>(
          initialData: true,
          future: controller.getProgramPickerData(),
          builder: (context, snapShot) {
            return Container(
              alignment: Alignment.center,
              decoration: controller.programPickerList.isEmpty
                  ? BoxDecoration(
                      border: Border.all(
                      color: Colors.grey,
                    ))
                  : null,
              height: context.width * .5,
              width: context.width * .5,
              child: (snapShot.data!)
                  ? const CircularProgressIndicator()
                  : controller.programPickerList.isEmpty
                      ? Text("No Data Found")
                      : DataGridFromMap(
                          mapData: controller.programPickerList,
                          onRowDoubleTap: (row) => controller.tblProgramPickerCellDoubleClick(row.rowIdx),
                        ),
            );
          },
        ),
      );
    }
  }
}
