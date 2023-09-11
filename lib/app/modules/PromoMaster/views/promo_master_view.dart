import 'package:bms_scheduling/app/providers/ApiFactory.dart';
import 'package:bms_scheduling/widgets/DateTime/DateWithThreeTextField.dart';
import 'package:bms_scheduling/widgets/NumericStepButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../../widgets/FormButton.dart';
import '../../../../widgets/PlutoGrid/src/pluto_grid.dart';
import '../../../../widgets/dropdown.dart';
import '../../../../widgets/gridFromMap.dart';
import '../../../../widgets/input_fields.dart';
import '../../../controller/HomeController.dart';
import '../../../data/user_data_settings_model.dart';
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
              child: GetBuilder(
                  init: controller,
                  id: "rootUI",
                  builder: (_) {
                    return FocusTraversalGroup(
                      policy: WidgetOrderTraversalPolicy(),
                      child: Row(
                        children: [
                          FocusTraversalGroup(
                            policy: OrderedTraversalPolicy(),
                            child: Expanded(
                              flex: 11,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  const Text(""),
                                  const SizedBox(height: 5),
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                          border: Border.all(color: Colors.grey)),
                                      padding: const EdgeInsets.only(top: 16),
                                      child: ListView(
                                        children: [
                                          Wrap(
                                            spacing:
                                                MediaQuery.of(context).size.width *
                                                    .01,
                                            runSpacing: 15,
                                            alignment: WrapAlignment.center,
                                            children: [
                                              InputFields.formField1(
                                                hintTxt: "Caption",
                                                controller: controller.captionCtr,
                                                width: controller.componentWidthRatio,
                                                autoFocus: true,
                                                focusNode: controller.captionFN,
                                                padLeft: 0,
                                              ),
                                              DropDownField.formDropDown1WidthMap(
                                                controller
                                                        .onloadModel
                                                        ?.promoMasterOnLoad
                                                        ?.lstCategory ??
                                                    [],
                                                (val) => controller
                                                    .handleOnChangedCategory(val,
                                                        callAPI: true),
                                                "Category",
                                                .35,
                                                selected:
                                                    controller.selectedDropDowns[0],
                                                inkWellFocusNode:
                                                    controller.categoryFN,
                                              ),
                                              Obx(
                                                () {
                                                  return InputFields.formField1(
                                                    hintTxt: "TX Caption",
                                                    controller:
                                                        controller.txCaptionCtr,
                                                    width: controller
                                                        .componentWidthRatio,
                                                    prefixText: controller
                                                        .txCaptionPreFix.value,
                                                    padLeft: 0,
                                                  );
                                                },
                                              ),
                                              InputFields.formField1(
                                                hintTxt: "Tape ID",
                                                controller: controller.tapeIDCtr,
                                                width: controller.componentWidthRatio,
                                                focusNode: controller.tapeIDFN,
                                                padLeft: 0,
                                              ),
                                              Obx(
                                                () {
                                                  return InputFields.numbers(
                                                    hintTxt: "Seg #",
                                                    controller: TextEditingController(
                                                        text: controller.segHash.value
                                                            .toString()),
                                                    isEnabled: false,
                                                    width: controller
                                                        .componentWidthRatio,
                                                    padLeft: 0,
                                                  );
                                                },
                                              ),
                                              InputFields.formField1(
                                                hintTxt: "TX No",
                                                controller: controller.txNoCtr,
                                                focusNode: controller.txNoFN,
                                                width: controller.componentWidthRatio,
                                                padLeft: 0,
                                              ),
                                              DropDownField.formDropDownSearchAPI2(
                                                GlobalKey(),
                                                context,
                                                width: context.width *
                                                    controller.componentWidthRatio,
                                                onchanged: (val) => controller
                                                    .selectedDropDowns[1] = val,
                                                title: 'Company',
                                                selectedValue:
                                                    controller.selectedDropDowns[1],
                                                url: ApiFactory
                                                    .PROMO_MASTER_COMPANY_SEARCH,
                                                parseKeyForKey: "CompanyCode",
                                                parseKeyForValue: "CompanyName",
                                                inkwellFocus: controller.companyFN,
                                              ),
                                              DropDownField.formDropDown1WidthMap(
                                                controller
                                                        .onloadModel
                                                        ?.promoMasterOnLoad
                                                        ?.lstLocation ??
                                                    [],
                                                controller.locationOnChanged,
                                                "Location",
                                                controller.componentWidthRatio,
                                                selected:
                                                    controller.selectedDropDowns[2],
                                              ),
                                              // SizedBox(width: 20),
                                              Obx(() {
                                                return DropDownField
                                                    .formDropDown1WidthMap(
                                                  controller.channelList.value,
                                                  (val) => controller
                                                      .selectedDropDowns[3] = val,
                                                  "Channel",
                                                  controller.componentWidthRatio,
                                                  selected:
                                                      controller.selectedDropDowns[3],
                                                );
                                              }),
                                              GetBuilder(
                                                  init: controller,
                                                  id: 'promoTypeUI',
                                                  builder: (_) {
                                                    return DropDownField
                                                        .formDropDown1WidthMap(
                                                      controller
                                                              .onloadModel
                                                              ?.promoMasterOnLoad
                                                              ?.lstPromoType ??
                                                          [],
                                                      (val) => controller
                                                          .selectedDropDowns[4] = val,
                                                      "Promo Type",
                                                      controller.componentWidthRatio,
                                                      selected: controller
                                                          .selectedDropDowns[4],
                                                    );
                                                  }),
                                              InputFields.formField1(
                                                hintTxt: "Blan Tape ID",
                                                controller: controller.blankTapeIDCtr,
                                                width: controller.componentWidthRatio,
                                                padLeft: 0,
                                                focusNode: controller.blanktapeIdFN,
                                              ),
                                              DropDownField.formDropDown1WidthMap(
                                                controller
                                                        .onloadModel
                                                        ?.promoMasterOnLoad
                                                        ?.lstptype ??
                                                    [],
                                                (val) => controller
                                                    .selectedDropDowns[5] = val,
                                                "",
                                                controller.componentWidthRatio,
                                                selected:
                                                    controller.selectedDropDowns[5],
                                              ),
                                              DropDownField.formDropDownSearchAPI2(
                                                GlobalKey(),
                                                context,
                                                width: context.width *
                                                    controller.componentWidthRatio,
                                                onchanged: (val) => controller
                                                    .selectedDropDowns[6] = val,
                                                title: 'Program',
                                                url: ApiFactory
                                                    .PROMO_MASTER_PROGRAM_SEARCH,
                                                selectedValue:
                                                    controller.selectedDropDowns[6],
                                                parseKeyForKey: "ProgramCode",
                                                parseKeyForValue: "ProgramName",
                                                suffixCallBack: () {
                                                  controller.handleProgramPickerTap();
                                                },
                                              ),
                                              DropDownField.formDropDown1WidthMap(
                                                [],
                                                (val) => controller
                                                    .selectedDropDowns[7] = val,
                                                "Tag Detail",
                                                controller.componentWidthRatio,
                                                selected:
                                                    controller.selectedDropDowns[7],
                                              ),
                                              // SizedBox(width: 20),
                                              DropDownField.formDropDown1WidthMap(
                                                controller
                                                        .onloadModel
                                                        ?.promoMasterOnLoad
                                                        ?.lstOriginalRepeat ??
                                                    [],
                                                (val) => controller
                                                    .selectedDropDowns[8] = val,
                                                "Org/Repeat",
                                                controller.componentWidthRatio,
                                                selected:
                                                    controller.selectedDropDowns[8],
                                              ),
                                              DropDownField.formDropDown1WidthMap(
                                                controller
                                                        .onloadModel
                                                        ?.promoMasterOnLoad
                                                        ?.lstBilling ??
                                                    [],
                                                (val) => controller
                                                    .selectedDropDowns[9] = val,
                                                "Billing",
                                                controller.componentWidthRatio,
                                                selected:
                                                    controller.selectedDropDowns[9],
                                              ),
                                              DropDownField.formDropDown1WidthMap(
                                                controller
                                                        .onloadModel
                                                        ?.promoMasterOnLoad
                                                        ?.lstTapeType ??
                                                    [],
                                                (val) => controller
                                                    .selectedDropDowns[10] = val,
                                                "Tape Type",
                                                controller.componentWidthRatio,
                                                selected:
                                                    controller.selectedDropDowns[10],
                                              ),
                                              InputFields.formFieldNumberMask(
                                                controller: controller.somCtr,
                                                hintTxt: 'SOM',
                                                widthRatio:
                                                    controller.componentWidthRatio,
                                                paddingLeft: 0,
                                                textFieldFN: controller.somFN,
                                              ),
                                              InputFields.formFieldNumberMask(
                                                controller: controller.eomCtr,
                                                hintTxt: 'EOM',
                                                widthRatio:
                                                    controller.componentWidthRatio,
                                                paddingLeft: 0,
                                                textFieldFN: controller.eomFN,
                                              ),
                                              InputFields.formField1(
                                                controller: controller.durationCtr,
                                                hintTxt: 'Duration',
                                                width: controller.componentWidthRatio,
                                                isEnable: false,
                                                padLeft: 0,
                                              ),
                                              DateWithThreeTextField(
                                                title: "Start Date",
                                                mainTextController:
                                                    controller.startDateCtr,
                                                widthRation:
                                                    controller.componentWidthRatio,
                                              ),

                                              DateWithThreeTextField(
                                                title: "End Date",
                                                mainTextController:
                                                    controller.endDateCtr,
                                                widthRation:
                                                    controller.componentWidthRatio,
                                              ),
                                              SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      controller.componentWidthRatio)
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),
                          FocusTraversalGroup(
                            policy: OrderedTraversalPolicy(),
                            child: Expanded(
                              flex: 8,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  const Text("Annotation Details"),
                                  const SizedBox(height: 5),
                                  Expanded(
                                    child: Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                          border:
                                              Border.all(color: Colors.grey)),
                                      padding: const EdgeInsets.all(16.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          DropDownField.formDropDownSearchAPI2(
                                            GlobalKey(),
                                            context,
                                            width: context.width * 0.4,
                                            onchanged: (val) => controller
                                                .selectedDropDowns[11] = val,
                                            title: 'Event',
                                            selectedValue: controller
                                                .selectedDropDowns[11],
                                            url: ApiFactory
                                                .PROMO_MASTER_EVENT_SEARCH,
                                            customInData: "onLeaveEvent",
                                            parseKeyForKey: "eventid", //eventid
                                            parseKeyForValue: "eventname",
                                          ),
                                          const SizedBox(height: 14),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              InputFields.formFieldNumberMask(
                                                controller: controller.tcInCtr,
                                                hintTxt: 'TC In',
                                                widthRatio: .12,
                                                paddingLeft: 0,
                                              ),
                                              InputFields.formFieldNumberMask(
                                                controller: controller.tcOutCtr,
                                                hintTxt: 'TC Out',
                                                widthRatio: .12,
                                                paddingLeft: 0,
                                              ),
                                              FormButton(
                                                  btnText: "Add",
                                                  callback: controller
                                                      .handleAddTapFromAnnotations),
                                            ],
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            'Press "DEL" to delete Annotation Detail',
                                            style: TextStyle(
                                              color: Colors.deepPurple,
                                              fontSize: 12,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Expanded(
                                            child: Obx(() {
                                              return Container(
                                                decoration: controller
                                                        .rightDataTable
                                                        .value
                                                        .isEmpty
                                                    ? BoxDecoration(
                                                        border: Border.all(
                                                        color: Colors.grey,
                                                      ))
                                                    : null,
                                                child: controller.rightDataTable
                                                        .value.isEmpty
                                                    ? null
                                                    : RawKeyboardListener(
                                                        onKey: (value) {
                                                          if (value.isKeyPressed(
                                                                  LogicalKeyboardKey
                                                                      .delete) &&
                                                              controller
                                                                  .rightDataTable
                                                                  .isNotEmpty) {
                                                            controller
                                                                .rightDataTable
                                                                .removeAt(controller
                                                                    .rightTableSelectedIdx);
                                                            controller
                                                                .rightTableSelectedIdx = 0;
                                                          }
                                                        },
                                                        focusNode: controller
                                                            .rightTableFN,
                                                        child: DataGridFromMap(
                                                          witdthSpecificColumn: (controller
                                                              .userDataSettings
                                                              ?.userSetting
                                                              ?.firstWhere(
                                                                  (element) =>
                                                                      element
                                                                          .controlName ==
                                                                      "stateManager",
                                                                  orElse: () =>
                                                                      UserSetting())
                                                              .userSettings),
                                                          onload: (sm) {
                                                            controller
                                                                    .stateManager =
                                                                sm.stateManager;
                                                          },
                                                          mapData: controller
                                                              .rightDataTable
                                                              .value
                                                              .map((e) =>
                                                                  e.toJson())
                                                              .toList(),
                                                          // focusNode: controller.rightTableFN,
                                                          mode: PlutoGridMode
                                                              .selectWithOneTap,
                                                          onSelected: (selected) =>
                                                              controller
                                                                      .rightTableSelectedIdx =
                                                                  selected.rowIdx ??
                                                                      -1,
                                                        ),
                                                      ),
                                              );
                                            }),
                                          ),
                                          const SizedBox(height: 14),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              InputFields.formField1(
                                                  hintTxt: "Copy",
                                                  controller:
                                                      controller.copyCtr,
                                                  width: 0.12),
                                              InputFields.formField1(
                                                hintTxt: "Seg No",
                                                controller: controller.segNoCtr,
                                                width: 0.12,
                                              ),
                                              FormButton(
                                                btnText: "Copy",
                                                callback:
                                                    controller.handleCopyTap,
                                              ),
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
                    );
                  }),
            ),
            const SizedBox(height: 8),

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
                              callback: ((Utils.btnAccessHandler(btn['name'],
                                          controller.formPermissions!) ==
                                      null))
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
