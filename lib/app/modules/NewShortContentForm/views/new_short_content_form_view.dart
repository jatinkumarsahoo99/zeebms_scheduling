import 'package:bms_scheduling/app/controller/HomeController.dart';
import 'package:bms_scheduling/widgets/dropdown.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../../widgets/DateTime/DateWithThreeTextField.dart';
import '../../../../widgets/FormButton.dart';
import '../../../../widgets/input_fields.dart';
import '../../../providers/ApiFactory.dart';
import '../../../providers/SizeDefine.dart';
import '../controllers/new_short_content_form_controller.dart';

class NewShortContentFormView extends StatelessWidget {
  NewShortContentFormView({Key? key}) : super(key: key);
  final controller =
      Get.put<NewShortContentFormController>(NewShortContentFormController());
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: Get.width * .64,
        child: Dialog(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppBar(
                title: const Text('New Short Content Form'),
                centerTitle: true,
                backgroundColor: Colors.deepPurple,
              ),
              const SizedBox(
                height: 10,
              ),
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.end,
                runSpacing: 5,
                spacing: Get.width * 0.01,
                children: [
                  Obx(
                    () => DropDownField.formDropDown1WidthMap(
                      controller.locations.value,
                      (value) {
                        controller.getChannel(value.key);
                        controller.selectedLocation = value;
                      },
                      "Location",
                      .24,
                      autoFocus: true,
                    ),
                  ),
                  Obx(
                    () => DropDownField.formDropDown1WidthMap(
                      controller.channels.value,
                      (value) {
                        controller.selectedChannel = value;
                      },
                      "Channel",
                      .24,
                      autoFocus: true,
                    ),
                  ),
                  Obx(
                    () => DropDownField.formDropDown1WidthMap(
                      controller.types.value,
                      (value) {
                        controller.selectedType = value;
                        controller.typeleave(value.key);
                      },
                      "Type",
                      .24,
                      autoFocus: true,
                    ),
                  ),
                  Obx(
                    () => DropDownField.formDropDown1WidthMap(
                      controller.categeroies.value,
                      (value) {
                        controller.selectedCategory = value;
                      },
                      "Category",
                      .24,
                      autoFocus: true,
                    ),
                  ),
                  InputFields.formField1(
                    hintTxt: "Caption",
                    controller: controller.caption,
                    width: 0.24,
                  ),
                  InputFields.formField1(
                    hintTxt: "TX Caption",
                    controller: controller.txCaption,
                    width: 0.24,
                  ),
                  Obx(
                    () => DropDownField.formDropDown1WidthMap(
                      controller.tapes.value,
                      (value) {
                        controller.selectedTape = value;
                      },
                      "Tape",
                      .155,
                      selected: controller.selectedTape,
                      autoFocus: true,
                    ),
                  ),
                  Obx(
                    () => DropDownField.formDropDown1WidthMap(
                      controller.orgRepeats.value,
                      (value) {
                        controller.selectedOrgRep = value;
                      },
                      "Org / Repeat",
                      .155,
                      selected: controller.selectedOrgRep,
                      autoFocus: true,
                    ),
                  ),
                  InputFields.formField1(
                    hintTxt: "Segment Number",
                    controller: controller.segment,
                    width: 0.16,
                  ),
                  InputFields.formField1(
                    hintTxt: "House ID",
                    controller: controller.houseId,
                    focusNode: controller.houseFocusNode,
                    width: 0.155,
                  ),
                  DropDownField.formDropDownSearchAPI2(
                    GlobalKey(),
                    context,
                    title: "Program",
                    parseKeyForKey: "ProgramCode",
                    parseKeyForValue: "ProgramName",
                    url: ApiFactory.NEW_SHORT_CONTENT_Program_Search,
                    onchanged: (value) {
                      controller.selectedProgram = value;
                    },
                    selectedValue: controller.selectedProgram,
                    width: Get.width * 0.325,
                  ),
                  // InputFields.formField1(
                  //   hintTxt: "Program",
                  //   controller: TextEditingController(),
                  //   width: 0.325,
                  // ),
                  InputFields.formFieldNumberMask(
                      hintTxt: "SOM",
                      widthRatio: .155,
                      controller: controller.som,
                      paddingLeft: 0,
                      isTime: true),
                  InputFields.formFieldNumberMask(
                      hintTxt: "EOM",
                      widthRatio: .155,
                      controller: controller.eom,
                      isTime: true,
                      paddingLeft: 0),
                  InputFields.formFieldNumberMask(
                      hintTxt: "Duration",
                      widthRatio: .16,
                      isTime: true,
                      controller: controller.duration,
                      paddingLeft: 0),
                  DateWithThreeTextField(
                    title: "Start Date",
                    mainTextController: controller.startData,
                    widthRation: .155,
                  ),
                  DateWithThreeTextField(
                    title: "End Date",
                    mainTextController: controller.endDate,
                    widthRation: .155,
                  ),
                  SizedBox(
                    width: Get.width * 0.16,
                    child: Row(
                      children: [
                        Obx(
                          () => Checkbox(
                              value: controller.toBeBilled.value,
                              onChanged: (value) {
                                controller.toBeBilled.value = value!;
                              }),
                        ),
                        Text(
                          "To be Billed",
                          style: TextStyle(fontSize: SizeDefine.labelSize1),
                        )
                      ],
                    ),
                  ),

                  InputFields.formField1(
                    hintTxt: "Remarks",
                    controller: controller.remark,
                    width: 0.49,
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Align(
                alignment: Alignment.bottomCenter,
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
                              for (var btn in btncontroller.buttons!) ...{
                                FormButtonWrapper(
                                    btnText: btn["name"],
                                    callback: () {
                                      btnHandler(btn["name"]);
                                    }
                                    //  ((Utils.btnAccessHandler(btn['name'], controller.formPermissions!) == null))
                                    //     ? null
                                    //     : () => controller.formHandler(btn['name']),
                                    )
                              },
                              // for (var btn in btncontroller.buttons!)
                              //   FormButtonWrapper(
                              //     btnText: btn["name"],
                              //     callback: () => controller.formHandler(btn['name'].toString()),
                              //   ),
                            ],
                          ),
                        );
                      }
                      return Container();
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  btnHandler(name) async {
    switch (name) {
      case "Save":
        if (await controller.save()) {
          Get.delete<NewShortContentFormController>();
          Get.find<HomeController>().clearPage1();
        }

        break;
      case "Search":
        break;
      case "Clear":
        Get.delete<NewShortContentFormController>();
        Get.find<HomeController>().clearPage1();
        break;
      default:
    }
  }
}
