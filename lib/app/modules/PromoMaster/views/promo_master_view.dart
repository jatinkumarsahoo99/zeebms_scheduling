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
                                          focusNode: controller.captionFN,
                                        ),
                                        DropDownField.formDropDown1WidthMap(
                                          controller.onloadModel?.promoMasterOnLoad?.lstCategory ?? [],
                                          controller.handleOnChangedCategory,
                                          "Category",
                                          .17,
                                          selected: controller.selectedDropDowns[0],
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
                                          onchanged: (val) => controller.selectedDropDowns[1] = val,
                                          title: 'Company',
                                          selectedValue: controller.selectedDropDowns[1],
                                          url: ApiFactory.PROMO_MASTER_COMPANY_SEARCH,
                                          parseKeyForKey: "CompanyCode",
                                          parseKeyForValue: "CompanyName",
                                          inkwellFocus: controller.companyFN,
                                        ),
                                        DropDownField.formDropDown1WidthMap(
                                          controller.onloadModel?.promoMasterOnLoad?.lstLocation ?? [],
                                          controller.locationOnChanged,
                                          "Location",
                                          .17,
                                          selected: controller.selectedDropDowns[2],
                                        ),
                                        // SizedBox(width: 20),
                                        Obx(() {
                                          return DropDownField.formDropDown1WidthMap(
                                            controller.channelList.value,
                                            (val) => controller.selectedDropDowns[3] = val,
                                            "Channel",
                                            .17,
                                            selected: controller.selectedDropDowns[3],
                                          );
                                        }),
                                      ],
                                    ),
                                    SizedBox(height: 14),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        DropDownField.formDropDown1WidthMap(
                                          controller.onloadModel?.promoMasterOnLoad?.lstPromoType ?? [],
                                          (val) => controller.selectedDropDowns[4] = val,
                                          "Promo Type",
                                          .17,
                                          selected: controller.selectedDropDowns[4],
                                          // inkWellFocusNode: controller.locationFN,
                                        ),
                                        InputFields.formField1(
                                          hintTxt: "Blan Tape ID",
                                          controller: controller.blankTapeIDCtr,
                                          width: 0.17,
                                          focusNode: controller.blanktapeIdFN,
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 14),
                                    Align(
                                      alignment: Alignment.topRight,
                                      child: DropDownField.formDropDown1WidthMap(
                                        controller.onloadModel?.promoMasterOnLoad?.lstptype ?? [],
                                        (val) => controller.selectedDropDowns[5] = val,
                                        "",
                                        .17,
                                        selected: controller.selectedDropDowns[5],
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
                                          onchanged: (val) => controller.selectedDropDowns[6] = val,
                                          title: 'Program',
                                          url: ApiFactory.PROMO_MASTER_PROGRAM_SEARCH,
                                          selectedValue: controller.selectedDropDowns[6],
                                          parseKeyForKey: "ProgramCode",
                                          parseKeyForValue: "ProgramName",
                                        ),
                                        FormButton(
                                          btnText: "...",
                                          callback: controller.handleProgramPickerTap,
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
                                          (val) => controller.selectedDropDowns[7] = val,
                                          "Tag Detail",
                                          .27,
                                          selected: controller.selectedDropDowns[7],
                                        ),
                                        // SizedBox(width: 20),
                                        DropDownField.formDropDown1WidthMap(
                                          controller.onloadModel?.promoMasterOnLoad?.lstOriginalRepeat ?? [],
                                          (val) => controller.selectedDropDowns[8] = val,
                                          "Org/Repeat",
                                          .27,
                                          selected: controller.selectedDropDowns[8],
                                        ),
                                        // SizedBox(width: 20),
                                      ],
                                    ),
                                    SizedBox(height: 14),
                                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                      DropDownField.formDropDown1WidthMap(
                                        controller.onloadModel?.promoMasterOnLoad?.lstBilling ?? [],
                                        (val) => controller.selectedDropDowns[9] = val,
                                        "Billing",
                                        .27,
                                        selected: controller.selectedDropDowns[9],
                                      ),
                                      DropDownField.formDropDown1WidthMap(
                                        controller.onloadModel?.promoMasterOnLoad?.lstTapeType ?? [],
                                        (val) => controller.selectedDropDowns[10] = val,
                                        "Tape Type",
                                        .27,
                                        selected: controller.selectedDropDowns[10],
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
                                        ),
                                        InputFields.formFieldNumberMask(
                                          controller: controller.eomCtr,
                                          hintTxt: 'EOM',
                                          widthRatio: .17,
                                          paddingLeft: 0,
                                          textFieldFN: controller.eomFN,
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
                            policy: OrderedTraversalPolicy(),
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
                                            onchanged: (val) => controller.selectedDropDowns[11] = val,
                                            title: 'Event',
                                            selectedValue: controller.selectedDropDowns[11],
                                            url: ApiFactory.PROMO_MASTER_EVENT_SEARCH,
                                            customInData: "onLeaveEvent",
                                            parseKeyForKey: "eventid", //eventid
                                            parseKeyForValue: "eventname",
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
                                            child: Obx(() {
                                              return Container(
                                                decoration: controller.rightDataTable.value.isEmpty
                                                    ? BoxDecoration(
                                                        border: Border.all(
                                                        color: Colors.grey,
                                                      ))
                                                    : null,
                                                child: controller.rightDataTable.value.isEmpty
                                                    ? null
                                                    : RawKeyboardListener(
                                                        onKey: (value) {
                                                          if (value.isKeyPressed(LogicalKeyboardKey.delete) && controller.rightDataTable.isNotEmpty) {
                                                            controller.rightDataTable.removeAt(controller.rightTableSelectedIdx);
                                                            controller.rightTableSelectedIdx = 0;
                                                          }
                                                        },
                                                        focusNode: controller.rightTableFN,
                                                        child: DataGridFromMap(
                                                          mapData: controller.rightDataTable.value.map((e) => e.toJson()).toList(),
                                                          // focusNode: controller.rightTableFN,
                                                          mode: PlutoGridMode.selectWithOneTap,
                                                          onSelected: (selected) => controller.rightTableSelectedIdx = selected.rowIdx ?? -1,
                                                        ),
                                                      ),
                                              );
                                            }),
                                          ),
                                          SizedBox(height: 14),
                                          Row(
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            children: [
                                              InputFields.formField1(hintTxt: "Copy", controller: controller.copyCtr, width: 0.11),
                                              Spacer(),
                                              InputFields.formField1(
                                                hintTxt: "Seg No",
                                                controller: controller.segNoCtr,
                                                width: 0.11,
                                              ),
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
                    );
                  }),
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
