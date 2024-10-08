import 'package:bms_scheduling/app/controller/HomeController.dart';
import 'package:bms_scheduling/app/modules/CommonSearch/views/common_search_view.dart';
import 'package:bms_scheduling/widgets/LoadingDialog.dart';
import 'package:bms_scheduling/widgets/dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
                title: const Text('Sting Master'),
                // Text('New Short Content Form'),
                centerTitle: true,
                backgroundColor: Colors.deepPurple,
              ),
              const SizedBox(
                height: 10,
              ),
              SingleChildScrollView(
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.end,
                  runSpacing: 10,
                  spacing: Get.width * 0.01,
                  children: [
                    Obx(
                      () => DropDownField.formDropDown1WidthMap(
                          controller.locations.value,
                          (value) {
                            controller.getChannel(value.key);
                            controller.selectedLocation.value = value;
                            controller.locationFocusNode.requestFocus();
                          },
                          "Location",
                          0.16,
                          inkWellFocusNode: controller.locationFocusNode,
                          selected: controller.selectedLocation.value,
                          autoFocus: true,
                          isEnable: controller.enable.value,
                          isMandatory: true,
                          dropdownOpen: (val) {
                            controller.isLocOpen = val;
                          }),
                    ),
                    Obx(
                      () => DropDownField.formDropDown1WidthMap(
                          controller.channels.value,
                          (value) {
                            controller.selectedChannel.value = value;
                            controller.channelFocusNode.requestFocus();
                          },
                          "Channel",
                          0.16,
                          autoFocus: true,
                          isEnable: controller.enable.value,
                          inkWellFocusNode: controller.channelFocusNode,
                          isMandatory: true,
                          selected: controller.selectedChannel.value,
                          dropdownOpen: (val) {
                            controller.isChnlOpen = val;
                          }),
                    ),
                    // Obx(
                    //   () => DropDownField.formDropDown1WidthMap(
                    //       controller.types.value, (value) {
                    //     controller.selectedType.value = value;
                    //     controller.tapeFocusNode.requestFocus();
                    //     controller.typeleave(value.key);
                    //   }, "Type", 0.16,
                    //       inkWellFocusNode: controller.typeFocusNode,
                    //       autoFocus: true,
                    //       selected: controller.selectedType.value),
                    // ),
                    Obx(
                      () => DropDownField.formDropDown1WidthMap2(
                          controller.categeroies.value,
                          (value) {
                            controller.selectedCategory.value = value;
                            controller.categoryFocusNode.requestFocus();
                            controller.typeleave(value.type);
                            // selectedId(value.value);
                            // print(
                            //     "Key: ${controller.selectedCategory.value!.key}");
                            // print(
                            //     "type: ${controller.selectedCategory.value!.type}");
                            // print(
                            //     "value: ${controller.selectedCategory.value!.value}");
                            if (value.type == "SLIDE MASTER") {
                              controller.formId.value = "L/";
                            } else if (value.type == "STILL MASTER") {
                              controller.formId.value = "S/";
                            } else {
                              controller.formId.value = "VP/";
                            }
                          },
                          "Category",
                          0.16,
                          inkWellFocusNode: controller.categoryFocusNode,
                          autoFocus: true,
                          isEnable: controller.enable.value,
                          selected: controller.selectedCategory.value,
                          isMandatory: true,
                          dropdownOpen: (val) {
                            controller.isCatOpen = val;
                          }),
                    ),
                    InputFields.formField1(
                        hintTxt: "Caption",
                        controller: controller.caption,
                        width: 0.16,
                        focusNode: controller.captionFN),
                    Obx(
                      () => InputFields.formField1(
                        hintTxt: "TX Caption",
                        controller: controller.txCaption,
                        width: 0.16,
                        prefixText: controller.formId.value,
                      ),
                    ),
                    Obx(
                      () => DropDownField.formDropDown1WidthMap2(
                        controller.tapes.value,
                        (value) {
                          if (value.type == "true") {
                            controller.selectedTape.value = value;
                            print(controller.selectedTape.value?.key);
                            controller.tapeFocusNode.requestFocus();
                          } else {
                            LoadingDialog.callErrorMessage1(
                                msg: 'Only HD & SD are allowed');
                          }
                        },
                        "Tape",
                        0.16,
                        inkWellFocusNode: controller.tapeFocusNode,
                        selected: controller.selectedTape.value,
                        autoFocus: true,
                        isEnable: controller.selectedCategory.value?.type ==
                                "VIGNETTE MASTER"
                            ? false
                            : true,
                      ),
                    ),
                    Obx(
                      () => DropDownField.formDropDown1WidthMap(
                        controller.orgRepeats.value,
                        (value) {
                          controller.selectedOrgRep.value = value;
                          controller.orgFocusNode.requestFocus();
                        },
                        "Org / Repeat",
                        0.16,
                        inkWellFocusNode: controller.orgFocusNode,
                        selected: controller.selectedOrgRep.value,
                        autoFocus: true,
                        dialogHeight: 250,
                        isEnable: controller.selectedCategory.value?.type ==
                                "STILL MASTER"
                            ? false
                            : controller.selectedCategory.value?.type ==
                                    "SLIDE MASTER"
                                ? false
                                : true,
                      ),
                    ),
                    InputFields.formField1(
                      hintTxt: "Segment Number",
                      controller: controller.segment,
                      width: 0.16,
                      focusNode: controller.segmentFN,
                      inputformatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                    ),
                    InputFields.formField1(
                        hintTxt: "House ID",
                        controller: controller.houseId,
                        width: 0.16,
                        onchanged: (val) {
                          if (val.toString().trim() == "" || val == "AUTOID") {
                            controller.enable.value = true;
                            controller.enable.refresh();
                          }
                        },
                        focusNode: controller.houseFocusNode),
                    Obx(
                      () => DropDownField.formDropDownSearchAPI2(
                        GlobalKey(),
                        context,
                        title: "Program",
                        parseKeyForKey: "ProgramCode",
                        parseKeyForValue: "ProgramName",
                        url: ApiFactory.NEW_SHORT_CONTENT_Program_Search,
                        onchanged: (value) {
                          controller.selectedProgram.value = value;
                          controller.programFocusNode.requestFocus();
                        },
                        inkwellFocus: controller.programFocusNode,
                        selectedValue: controller.selectedProgram.value,
                        width: Get.width * 0.500,
                        dialogHeight: 200,
                        isEnable: controller.selectedCategory.value?.type ==
                                "SLIDE MASTER"
                            ? false
                            : true,
                        // isMandatory:true
                      ),
                    ),
                    // InputFields.formField1(
                    //   hintTxt: "Program",
                    //   controller: TextEditingController(),
                    //   width: 0.325,
                    // ),
                    InputFields.formFieldNumberMask(
                        hintTxt: "SOM",
                        widthRatio: 0.16,
                        controller: controller.som,
                        paddingLeft: 0,
                        isMandatory: true,
                        textFieldFN: controller.somFN
                        // isTime: true
                        ),
                    InputFields.formFieldNumberMask(
                      hintTxt: "EOM",
                      widthRatio: 0.16,
                      controller: controller.eom,
                      textFieldFN: controller.eomFN,
                      // isTime: true,
                      paddingLeft: 0,
                      isMandatory: true,
                      /*onEditComplete: (val) {
                          controller.calculateDuration();
                        }*/
                    ),
                    Obx(() => InputFields.formFieldDisable(
                          hintTxt: "Duration",
                          value: controller.duration.value,
                          widthRatio: 0.16,
                        )),
                    Obx(
                      () => DateWithThreeTextField(
                        title: "Start Date",
                        mainTextController: controller.startData,
                        widthRation: 0.16,
                        isEnable: controller.selectedCategory.value?.type ==
                                "STILL MASTER"
                            ? false
                            : controller.selectedCategory.value?.type ==
                                    "SLIDE MASTER"
                                ? false
                                : true,
                      ),
                    ),
                    DateWithThreeTextField(
                      title: "End Date",
                      mainTextController: controller.endDate,
                      widthRation: 0.16,
                    ),
                    Obx(
                      () => controller.selectedCategory.value?.type ==
                              "STILL MASTER"
                          ? defaultCheckBox()
                          : controller.selectedCategory.value?.type !=
                                  "SLIDE MASTER"
                              ? SizedBox(
                                  width: Get.width * 0.16,
                                  child: Row(
                                    children: [
                                      Obx(
                                        () => Checkbox(
                                            value: controller.toBeBilled.value,
                                            onChanged: (value) {
                                              controller.toBeBilled.value =
                                                  value!;
                                            }),
                                      ),
                                      Text(
                                        "To be Billed",
                                        style: TextStyle(
                                            fontSize: SizeDefine.labelSize1),
                                      )
                                    ],
                                  ),
                                )
                              : defaultCheckBox(),
                    ),

                    Obx(
                      () => InputFields.formField1(
                        hintTxt: "Remarks",
                        controller: controller.remark,
                        width: 0.50,
                        isEnable: controller.selectedCategory.value?.type ==
                                "STILL MASTER"
                            ? false
                            : controller.selectedCategory.value?.type ==
                                    "SLIDE MASTER"
                                ? false
                                : true,
                      ),
                    ),
                  ],
                ),
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

  defaultCheckBox() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 7, left: 8),
      child: SizedBox(
        width: Get.width * 0.16,
        child: Row(
          children: [
            Container(
              width: 17,
              height: 17,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey, width: 2)),
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              "To be Billed",
              style: TextStyle(
                  fontSize: SizeDefine.labelSize1, color: Colors.grey),
            )
          ],
        ),
      ),
    );
  }

  btnHandler(name) async {
    switch (name) {
      case "Save":
        await controller.saveValidate();

        break;
      case "Search":
        Get.to(
          const SearchPage(
            key: Key("New Short Content Form"),
            screenName: "New Short Content Form",
            appBarName: "New Short Content Form",
            strViewName: "bms_view_fillermaster",
            isAppBarReq: true,
          ),
        );
        break;
      case "Clear":
        // Get.delete<NewShortContentFormController>();
        controller.clearPage();
        Get.find<HomeController>().clearPage1();
        break;
      default:
    }
  }
}
