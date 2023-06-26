import 'package:bms_scheduling/widgets/DateTime/DateWithThreeTextField.dart';
import 'package:bms_scheduling/widgets/NumericStepButton.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../../widgets/DateTime/TimeWithThreeTextField.dart';
import '../../../../widgets/FormButton.dart';
import '../../../../widgets/dropdown.dart';
import '../../../../widgets/input_fields.dart';
import '../../../controller/HomeController.dart';
import '../../../providers/SizeDefine.dart';
import '../../../providers/Utils.dart';
import '../controllers/promo_master_controller.dart';

class PromoMasterView extends GetView<PromoMasterController> {
  const PromoMasterView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: FocusTraversalGroup(
                policy: WidgetOrderTraversalPolicy(),
                child: Row(
                  children: [
                    FocusTraversalGroup(
                      policy: WidgetOrderTraversalPolicy(),
                      child: Expanded(
                        flex: 12,
                        child: Container(
                          decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
                          padding: EdgeInsets.all(16),
                          child: ListView(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  InputFields.formField1(
                                    hintTxt: "Caption",
                                    controller: controller.captionCtr,
                                    width: 0.17,
                                    autoFocus: true,
                                  ),
                                  // SizedBox(width: 20),
                                  DropDownField.formDropDown1WidthMap(
                                    [],
                                    (p0) => null,
                                    "Category",
                                    .17,
                                  ),
                                  Obx(() {
                                    return InputFields.formField1(
                                      hintTxt: "TX Caption",
                                      controller: controller.txCaptionCtr,
                                      width: 0.17,
                                      prefixText: controller.txCaptionPreFix.value,
                                    );
                                  }),
                                ],
                              ),
                              SizedBox(height: 14),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  InputFields.formField1(
                                    hintTxt: "Tape ID",
                                    controller: controller.tapeIDCtr,
                                    width: 0.17,
                                    focusNode: controller.tapeIDFN,
                                  ),
                                  // SizedBox(width: 20),
                                  SizedBox(
                                    width: context.width * .17,
                                    child: Obx(
                                      () {
                                        return NumericStepButton(
                                          onChanged: (val) {},
                                          hint: "Seg #",
                                          isEnable: false,
                                          minValue: controller.segHash.value,
                                          maxValue: 100000,
                                        );
                                      },
                                    ),
                                  ),
                                  // SizedBox(width: 20),
                                  InputFields.formField1(
                                    hintTxt: "TX No",
                                    controller: controller.txNoCtr,
                                    focusNode: controller.txNoFN,
                                    width: 0.17,
                                  ),
                                ],
                              ),
                              SizedBox(height: 14),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  DropDownField.formDropDownSearchAPI2(
                                    GlobalKey(),
                                    context,
                                    width: context.width * 0.17,
                                    onchanged: (val) {},
                                    title: 'Company',
                                    url: '',
                                  ),
                                  DropDownField.formDropDown1WidthMap(
                                    [],
                                    (a) {},
                                    "Location",
                                    .17,
                                    autoFocus: true,
                                    // selected: controller.selectedDropDowns[0],
                                    // inkWellFocusNode: controller.locationFN,
                                  ),
                                  // SizedBox(width: 20),
                                  DropDownField.formDropDown1WidthMap(
                                    [],
                                    (a) {},
                                    "Channel",
                                    .17,
                                    autoFocus: true,
                                    // selected: controller.selectedDropDowns[0],
                                    // inkWellFocusNode: controller.locationFN,
                                  ),
                                ],
                              ),
                              SizedBox(height: 14),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  DropDownField.formDropDown1WidthMap(
                                    [],
                                    (a) {},
                                    "Promo Type",
                                    .17,
                                    autoFocus: true,
                                    // selected: controller.selectedDropDowns[0],
                                    // inkWellFocusNode: controller.locationFN,
                                  ),
                                  // SizedBox(width: 20),
                                  InputFields.formField1(
                                    hintTxt: "Blan Tape ID",
                                    controller: controller.blankTapeIDCtr,
                                    width: 0.17,
                                  ),
                                ],
                              ),
                              SizedBox(height: 14),
                              Align(
                                alignment: Alignment.topRight,
                                child: DropDownField.formDropDown1WidthMap(
                                  [],
                                  (a) {},
                                  "",
                                  .17,
                                  autoFocus: true,
                                  // selected: controller.selectedDropDowns[0],
                                  // inkWellFocusNode: controller.locationFN,
                                ),
                              ),
                              SizedBox(height: 14),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  DropDownField.formDropDownSearchAPI2(
                                    GlobalKey(),
                                    context,
                                    width: context.width * 0.5,
                                    onchanged: (val) {},
                                    title: 'Program',
                                    url: '',
                                  ),
                                  FormButton(
                                    btnText: "...",
                                    callback: () {},
                                    showIcon: false,
                                  )
                                ],
                              ),
                              SizedBox(height: 14),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  DropDownField.formDropDown1WidthMap(
                                    [],
                                    (p0) => null,
                                    "Tag Detail",
                                    .27,
                                  ),
                                  // SizedBox(width: 20),
                                  DropDownField.formDropDown1WidthMap(
                                    [],
                                    (p0) => null,
                                    "Org/Repeat",
                                    .27,
                                  ),
                                  // SizedBox(width: 20),
                                ],
                              ),
                              SizedBox(height: 14),
                              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                DropDownField.formDropDown1WidthMap(
                                  [],
                                  (p0) => null,
                                  "Billing",
                                  .27,
                                ),
                                DropDownField.formDropDown1WidthMap(
                                  [],
                                  (p0) => null,
                                  "Tape Type",
                                  .27,
                                ),
                              ]),
                              SizedBox(height: 14),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  InputFields.formFieldNumberMask(
                                    controller: controller.somCtr,
                                    hintTxt: 'SOM',
                                    widthRatio: .17,
                                    paddingLeft: 0,
                                    // textFieldFN: controller.eomFN,
                                  ),
                                  InputFields.formFieldNumberMask(
                                    controller: controller.eomCtr,
                                    hintTxt: 'EOM',
                                    widthRatio: .17,
                                    paddingLeft: 0,
                                    // textFieldFN: controller.eomFN,
                                  ),
                                  InputFields.formField1(
                                    controller: controller.durationCtr,
                                    hintTxt: 'Duration',
                                    width: .17,
                                    isEnable: false,
                                  ),
                                ],
                              ),
                              SizedBox(height: 4),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  DateWithThreeTextField(
                                    title: "Start Date",
                                    mainTextController: controller.startDateCtr,
                                    widthRation: 0.27,
                                  ),
                                  DateWithThreeTextField(
                                    title: "End Date",
                                    mainTextController: controller.endDateCtr,
                                    widthRation: 0.27,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    FocusTraversalGroup(
                      policy: WidgetOrderTraversalPolicy(),
                      child: Expanded(
                        flex: 8,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Text("Annotation Details"),
                            SizedBox(height: 5),
                            Expanded(
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  children: [
                                    DropDownField.formDropDownSearchAPI2(
                                      GlobalKey(),
                                      context,
                                      width: context.width * 0.37,
                                      onchanged: (DropDownValue) {},
                                      title: 'Event',
                                      url: '',
                                    ),
                                    SizedBox(height: 14),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        InputFields.formFieldNumberMask(
                                          controller: controller.tcInCtr,
                                          hintTxt: 'TC In',
                                          widthRatio: .17,
                                          paddingLeft: 0,
                                          // textFieldFN: controller.eomFN,
                                        ),
                                        Spacer(),
                                        InputFields.formFieldNumberMask(
                                          controller: controller.tcOutCtr,
                                          hintTxt: 'TC Out',
                                          widthRatio: .17,
                                          paddingLeft: 0,
                                          // textFieldFN: controller.eomFN,
                                        ),
                                        // TimeWithThreeTextField(
                                        //     title: "TC Out", mainTextController: TextEditingController(), widthRation: 0.11, isTime: false),
                                      ],
                                    ),
                                    SizedBox(height: 14),
                                    Row(
                                      children: [
                                        FormButton(btnText: "Add", callback: controller.handleAddTapFromAnnotations),
                                        Spacer(),
                                        Text(
                                          'Press "DEL" to delete Annotation Detail',
                                          style: TextStyle(
                                            color: Colors.deepPurple,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 14),
                                    Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                          color: Colors.grey,
                                        )),
                                      ),
                                    ),
                                    SizedBox(height: 14),
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        InputFields.formField1(hintTxt: "Copy", controller: controller.copyCtr, width: 0.11),
                                        Spacer(),
                                        InputFields.formField1(hintTxt: "Seg No", controller: controller.segIDCtr, width: 0.11),
                                        SizedBox(width: 20),
                                        FormButton(btnText: "Copy", callback: controller.handleCopyTap),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 8),

            /// Commom Buttons
            Align(
              alignment: Alignment.bottomLeft,
              child: GetBuilder<HomeController>(
                  init: Get.find<HomeController>(),
                  builder: (btncontroller) {
                    if (btncontroller.buttons != null) {
                      return Wrap(
                        spacing: 5,
                        runSpacing: 15,
                        alignment: WrapAlignment.center,
                        children: [
                          for (var btn in btncontroller.buttons!) ...{
                            FormButtonWrapper(
                              btnText: btn["name"],
                              callback: ((Utils.btnAccessHandler(btn['name'], controller.formPermissions!) == null))
                                  ? null
                                  : () => controller.formHandler(btn['name']),
                            )
                          },
                        ],
                      );
                    }
                    return Container();
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
