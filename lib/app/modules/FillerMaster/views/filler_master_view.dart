import 'package:bms_scheduling/widgets/LoadingDialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../../widgets/DateTime/DateWithThreeTextField.dart';
import '../../../../widgets/FormButton.dart';
import '../../../../widgets/PlutoGrid/src/pluto_grid.dart';
import '../../../../widgets/dropdown.dart';
import '../../../../widgets/gridFromMap.dart';
import '../../../../widgets/input_fields.dart';
import '../../../controller/HomeController.dart';
import '../../../providers/ApiFactory.dart';
import '../../../providers/SizeDefine.dart';
import '../../../providers/Utils.dart';
import '../controllers/filler_master_controller.dart';

class FillerMasterView extends GetView<FillerMasterController> {
  const FillerMasterView({Key? key}) : super(key: key);

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
                              flex: 10,
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey)),
                                child: ListView(
                                  children: [
                                    const SizedBox(height: 16),
                                    Wrap(
                                      alignment: WrapAlignment.center,
                                      spacing: 10,
                                      runSpacing: 10,
                                      children: [
                                        DropDownField.formDropDown1WidthMap(
                                            controller
                                                    .onloadModel
                                                    ?.fillerMasterOnload
                                                    ?.lstLocation ??
                                                [],
                                            controller.locationOnChanged,
                                            "Location",
                                            0.26,
                                            autoFocus: true,
                                            selected:
                                                controller.selectedDropDowns[0],
                                            inkWellFocusNode:
                                                controller.locationFN,
                                            isMandatory: true,
                                            /*validator: (value) {
                                            if (value == null || value == "") {
                                              return "Please select location";
                                            }
                                          },*/
                                            dropdownOpen: (val) {
                                          controller.isLocOpen = val;
                                        }),
                                        Obx(() {
                                          return DropDownField
                                              .formDropDown1WidthMap(
                                            controller.channelList.value,
                                            (a) => controller
                                                .selectedDropDowns[19] = a,
                                            "Channel",
                                            0.26,
                                            selected: controller
                                                .selectedDropDowns[19],
                                            inkWellFocusNode:
                                                controller.channelFN,
                                            isMandatory: true,
                                            dropdownOpen: (val) {
                                              controller.isChannelOpen = val;
                                            },
                                          );
                                        }),
                                        DropDownField.formDropDownSearchAPI2(
                                          GlobalKey(),
                                          context,
                                          width: context.width * 0.525,
                                          onchanged: (v) => controller
                                              .selectedDropDowns[2] = v,
                                          title: 'Banner',
                                          selectedValue:
                                              controller.selectedDropDowns[2],
                                          url: ApiFactory
                                              .FILLER_MASTER_BANNER_SEARCH,
                                          parseKeyForKey: "BannerCode",
                                          parseKeyForValue: "BannerName",
                                          isMandatory: true,
                                          inkwellFocus: controller.bannerFN,
                                          dropdownOpen: (val) {
                                            controller.isBannerOpen = val;
                                          },
                                        ),
                                        InputFields.formField1(
                                          hintTxt: "Filler Name",
                                          controller: controller.fillerNameCtr,
                                          width: controller.componentWidthRatio,
                                          focusNode: controller.fillerNameFN,
                                          maxLen: 40,
                                          padLeft: 0,
                                          isMandatory: true,
                                        ),
                                        InputFields.formField1(
                                          hintTxt: "TX Caption",
                                          controller: controller.txCaptionCtr,
                                          width:
                                              (controller.componentWidthRatio +
                                                      0.0035) *
                                                  2,
                                          prefixText: "F/",
                                          maxLen: 40,
                                          focusNode: controller.txCaptionFN,
                                          padLeft: 0,
                                          isMandatory: true,
                                        ),

                                        InputFields.formField1(
                                            hintTxt: "Tape ID",
                                            controller: controller.tapeIDCtr,
                                            width:
                                                controller.componentWidthRatio,
                                            focusNode: controller.tapeIDFN,
                                            // maxLen: 10,
                                            padLeft: 0,
                                            isMandatory: true),
                                        // SizedBox(width: 20),
                                        InputFields.formField1(
                                          hintTxt: "Seg No",
                                          controller: controller.segNoCtrLeft,
                                          width: controller.componentWidthRatio,
                                          focusNode: controller.segNoFN,
                                          maxLen: 5,
                                          padLeft: 0,
                                          isMandatory: true,
                                          inputformatters: [
                                            FilteringTextInputFormatter
                                                .digitsOnly,
                                          ],
                                        ),
                                        // SizedBox(width: 20),
                                        InputFields.formField1(
                                            hintTxt: "TX No",
                                            controller: controller.txNoCtr,
                                            width:
                                                controller.componentWidthRatio,
                                            padLeft: 0,
                                            isMandatory: true),
                                        InputFields.formFieldNumberMask(
                                            controller: controller.somCtr,
                                            hintTxt: 'SOM',
                                            widthRatio:
                                                controller.componentWidthRatio,
                                            textFieldFN: controller.somFN,
                                            paddingLeft: 0,
                                            isMandatory: true),
                                        InputFields.formFieldNumberMask(
                                            controller: controller.eomCtr,
                                            hintTxt: 'EOM',
                                            widthRatio:
                                                controller.componentWidthRatio,
                                            paddingLeft: 0,
                                            textFieldFN: controller.eomFN,
                                            // onEditComplete: (val) {
                                            //   controller.calculateDuration();
                                            // },
                                            isMandatory: true),
                                        Obx(() => InputFields.formFieldDisable(
                                              hintTxt: "Duration",
                                              value: controller.duration.value,
                                              widthRatio: 0.17,
                                            )),

                                        Obx(
                                          () => DropDownField
                                              .formDropDown1WidthMap2(
                                            controller
                                                    .onloadModel
                                                    ?.fillerMasterOnload
                                                    ?.lstTapetypemaster ??
                                                [],
                                            (val) {
                                              if (val.type == "true") {
                                                controller.selectedTapeType
                                                    .value = val;
                                              } else {
                                                LoadingDialog.callErrorMessage1(
                                                    msg:
                                                        'Only HD & SD are allowed');
                                              }
                                            },
                                            "Tape Type",
                                            controller.componentWidthRatio,
                                            selected: controller
                                                .selectedTapeType.value,
                                            isMandatory: true,
                                            inkWellFocusNode:
                                                controller.tapeTypeFN,
                                            dropdownOpen: (val) {
                                              controller.isTapeTypOpen = val;
                                            },
                                          ),
                                        ),
                                        DropDownField.formDropDown1WidthMap(
                                          controller
                                                  .onloadModel
                                                  ?.fillerMasterOnload
                                                  ?.lstfillertypemaster ??
                                              [],
                                          (v) => controller
                                              .selectedDropDowns[4] = v,
                                          "Type",
                                          controller.componentWidthRatio,
                                          selected:
                                              controller.selectedDropDowns[4],
                                          inkWellFocusNode: controller.typeFN,
                                          isMandatory: true,
                                          dropdownOpen: (val) {
                                            controller.isTypOpen = val;
                                          },
                                        ),
                                        // SizedBox(width: 20),
                                        DropDownField.formDropDown1WidthMap(
                                          controller
                                                  .onloadModel
                                                  ?.fillerMasterOnload
                                                  ?.lstCensorshipMaster ??
                                              [],
                                          (v) => controller
                                              .selectedDropDowns[5] = v,
                                          "Censorship",
                                          controller.componentWidthRatio,
                                          selected:
                                              controller.selectedDropDowns[5],
                                          isMandatory: true,
                                          inkWellFocusNode: controller.censorFN,
                                          dropdownOpen: (val) {
                                            controller.isCensorOpen = val;
                                          },
                                        ),
                                        DropDownField.formDropDown1WidthMap(
                                          controller
                                                  .onloadModel
                                                  ?.fillerMasterOnload
                                                  ?.lstLanguagemaster ??
                                              [],
                                          (v) => controller
                                              .selectedDropDowns[6] = v,
                                          "Language",
                                          controller.componentWidthRatio,
                                          selected:
                                              controller.selectedDropDowns[6],
                                          isMandatory: true,
                                          inkWellFocusNode: controller.langFN,
                                          dropdownOpen: (val) {
                                            controller.isLangOpen = val;
                                          },
                                        ),
                                        DropDownField.formDropDown1WidthMap(
                                          controller
                                                  .onloadModel
                                                  ?.fillerMasterOnload
                                                  ?.lstproduction ??
                                              [],
                                          (v) => controller
                                              .selectedDropDowns[7] = v,
                                          "Production",
                                          controller.componentWidthRatio,
                                          selected:
                                              controller.selectedDropDowns[7],
                                          isMandatory: true,
                                          inkWellFocusNode: controller.prodFN,
                                          dropdownOpen: (val) {
                                            controller.isPrdOpen = val;
                                          },
                                        ),
                                        InputFields.formField1(
                                          hintTxt: "Seg ID",
                                          controller: controller.segIDCtr,
                                          width: 0.17,
                                        ),
                                        DropDownField.formDropDown1WidthMap(
                                          controller
                                                  .onloadModel
                                                  ?.fillerMasterOnload
                                                  ?.lstcolor ??
                                              [],
                                          (v) => controller
                                              .selectedDropDowns[8] = v,
                                          "Color",
                                          controller.componentWidthRatio,
                                          selected:
                                              controller.selectedDropDowns[8],
                                          isMandatory: true,
                                          inkWellFocusNode: controller.colorFN,
                                          dropdownOpen: (val) {
                                            controller.isColorOpen = val;
                                          },
                                        ),
                                        DropDownField.formDropDown1WidthMap(
                                          controller
                                                  .onloadModel
                                                  ?.fillerMasterOnload
                                                  ?.lstRegion ??
                                              [],
                                          (v) => controller
                                              .selectedDropDowns[9] = v,
                                          "Region",
                                          controller.componentWidthRatio,
                                          selected:
                                              controller.selectedDropDowns[9],
                                        ),
                                        DropDownField.formDropDown1WidthMap(
                                          controller
                                                  .onloadModel
                                                  ?.fillerMasterOnload
                                                  ?.lstEnegry ??
                                              [],
                                          (v) => controller
                                              .selectedDropDowns[10] = v,
                                          "Energy",
                                          controller.componentWidthRatio,
                                          selected:
                                              controller.selectedDropDowns[10],
                                        ),
                                        DropDownField.formDropDown1WidthMap(
                                          controller
                                                  .onloadModel
                                                  ?.fillerMasterOnload
                                                  ?.lstEra ??
                                              [],
                                          (v) => controller
                                              .selectedDropDowns[11] = v,
                                          "Era",
                                          controller.componentWidthRatio,
                                          selected:
                                              controller.selectedDropDowns[11],
                                        ),
                                        DropDownField.formDropDown1WidthMap(
                                          controller
                                                  .onloadModel
                                                  ?.fillerMasterOnload
                                                  ?.lstSongGrade ??
                                              [],
                                          (v) => controller
                                              .selectedDropDowns[12] = v,
                                          "Song Grade",
                                          controller.componentWidthRatio,
                                          selected:
                                              controller.selectedDropDowns[12],
                                        ),
                                        DropDownField.formDropDown1WidthMap(
                                          controller
                                                  .onloadModel
                                                  ?.fillerMasterOnload
                                                  ?.lstMood ??
                                              [],
                                          (v) => controller
                                              .selectedDropDowns[13] = v,
                                          "Mood",
                                          controller.componentWidthRatio,
                                          selected:
                                              controller.selectedDropDowns[13],
                                        ),
                                        DropDownField.formDropDown1WidthMap(
                                          controller
                                                  .onloadModel
                                                  ?.fillerMasterOnload
                                                  ?.lstTempo ??
                                              [],
                                          (v) => controller
                                              .selectedDropDowns[14] = v,
                                          "Tempo",
                                          controller.componentWidthRatio,
                                          selected:
                                              controller.selectedDropDowns[14],
                                        ),
                                        InputFields.formField1(
                                          hintTxt: "Movie Name",
                                          controller: controller.movieNameCtr,
                                          width: controller.componentWidthRatio,
                                          maxLen: 80,
                                          padLeft: 0,
                                        ),
                                        InputFields.formField1(
                                          hintTxt: "Release Year",
                                          controller: controller.releaseYearCtr,
                                          width: 0.17,
                                          maxLen: 80,
                                          padLeft: 0,
                                        ),
                                        InputFields.formField1(
                                          hintTxt: "Singer",
                                          controller: controller.singerCtr,
                                          width: 0.17,
                                          maxLen: 80,
                                          padLeft: 0,
                                        ),
                                        InputFields.formField1(
                                          hintTxt: "Music Director",
                                          controller:
                                              controller.musicDirectorCtr,
                                          width: 0.17,
                                          maxLen: 80,
                                          padLeft: 0,
                                        ),
                                        InputFields.formField1(
                                          hintTxt: "Music company",
                                          controller:
                                              controller.musicCompanyCtr,
                                          width: 0.17,
                                          maxLen: 80,
                                          padLeft: 0,
                                        ),
                                        DropDownField.formDropDown1WidthMap(
                                          controller
                                                  .onloadModel
                                                  ?.fillerMasterOnload
                                                  ?.lstMovieGrade ??
                                              [],
                                          (v) => controller
                                              .selectedDropDowns[15] = v,
                                          "Movie Grade",
                                          controller.componentWidthRatio,
                                          selected:
                                              controller.selectedDropDowns[15],
                                        ),
                                        SizedBox(
                                            width: context.width *
                                                controller.componentWidthRatio),
                                        SizedBox(
                                            width: context.width *
                                                controller.componentWidthRatio),
                                        Container(
                                            height: 6,
                                            width: context.width *
                                                controller.componentWidthRatio),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 14),
                          FocusTraversalGroup(
                            policy: OrderedTraversalPolicy(),
                            child: Expanded(
                              flex: 8,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Expanded(
                                    child: Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                          border:
                                              Border.all(color: Colors.grey)),
                                      padding: const EdgeInsets.all(16.0),
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              DropDownField
                                                  .formDropDown1WidthMap(
                                                controller
                                                        .onloadModel
                                                        ?.fillerMasterOnload
                                                        ?.lsttapesource ??
                                                    [],
                                                (v) => controller
                                                    .selectedDropDowns[16] = v,
                                                "Source",
                                                controller.componentWidthRatio +
                                                    .01,
                                                selected: controller
                                                    .selectedDropDowns[16],
                                              ),
                                              DropDownField.formDropDown1WidthMap(
                                                  controller
                                                          .onloadModel
                                                          ?.fillerMasterOnload
                                                          ?.lstProducerTape ??
                                                      [],
                                                  (v) => controller
                                                          .selectedDropDowns[17] =
                                                      v,
                                                  "ID No",
                                                  controller
                                                          .componentWidthRatio +
                                                      .01,
                                                  selected: controller
                                                      .selectedDropDowns[17],
                                                  isMandatory: true,
                                                  inkWellFocusNode:
                                                      controller.idNoFN,
                                                  dropdownOpen: (v) {
                                                controller.isIdOpen = v;
                                              }),
                                            ],
                                          ),
                                          SizedBox(height: 10),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              DateWithThreeTextField(
                                                title: "Start Date",
                                                mainTextController:
                                                    controller.startDateCtr,
                                                widthRation: controller
                                                        .componentWidthRatio +
                                                    .01,
                                              ),
                                              DateWithThreeTextField(
                                                title: "End Date",
                                                mainTextController:
                                                    controller.endDateCtr,
                                                widthRation: controller
                                                        .componentWidthRatio +
                                                    .01,
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 10),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Synopsis",
                                                  style: TextStyle(
                                                    fontSize:
                                                        SizeDefine.labelSize1,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                const SizedBox(height: 2),
                                                Expanded(
                                                  child: TextFormField(
                                                    expands: true,
                                                    minLines: null,
                                                    maxLines: null,
                                                    controller:
                                                        controller.synopsisCtr,
                                                    textAlignVertical:
                                                        TextAlignVertical.top,
                                                    keyboardType:
                                                        TextInputType.multiline,
                                                    decoration: InputDecoration(
                                                      filled: true,
                                                      fillColor: Colors.white,
                                                      contentPadding:
                                                          EdgeInsets.all(10),
                                                      border:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(0),
                                                        borderSide: BorderSide(
                                                          color: Colors
                                                              .deepPurpleAccent,
                                                        ),
                                                      ),
                                                      enabledBorder:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(0),
                                                        borderSide: BorderSide(
                                                          color: Colors
                                                              .deepPurpleAccent,
                                                        ),
                                                      ),
                                                      focusedBorder:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(0),
                                                        borderSide: BorderSide(
                                                          color: Colors
                                                              .deepPurpleAccent,
                                                        ),
                                                      ),
                                                      errorBorder:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(0),
                                                        borderSide: BorderSide(
                                                          color: Colors
                                                              .deepPurpleAccent,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: 5),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Text("Annotation"),
                                  SizedBox(height: 2),
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
                                            width: context.width *
                                                ((controller.componentWidthRatio +
                                                        .035) *
                                                    2),
                                            onchanged: (v) => controller
                                                .selectedDropDowns[18] = v,
                                            title: 'Event',
                                            selectedValue: controller
                                                .selectedDropDowns[18],
                                            url: ApiFactory
                                                .FILLER_MASTER_GET_EVENT,
                                            customInData: "onLeaveEvent",
                                            parseKeyForKey: "eventid",
                                            parseKeyForValue: "eventname",
                                            miniumSearchLength: 1,
                                          ),
                                          SizedBox(height: 14),
                                          Row(
                                            // mainAxisAlignment:
                                            //     MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              InputFields.formFieldNumberMask(
                                                controller: controller.tcInCtr,
                                                hintTxt: 'TC In',
                                                widthRatio: controller
                                                        .componentWidthRatio -
                                                    .05,
                                                paddingLeft: 0,
                                                // textFieldFN: controller.eomFN,
                                              ),
                                              Spacer(),
                                              InputFields.formFieldNumberMask(
                                                controller: controller.tcOutCtr,
                                                hintTxt: 'TC Out',
                                                widthRatio: controller
                                                        .componentWidthRatio -
                                                    .05,
                                                paddingLeft: 0,
                                                // textFieldFN: controller.eomFN,
                                              ),
                                              Spacer(flex: 2),
                                              FormButton(
                                                  btnText: "Add",
                                                  callback:
                                                      controller.handleAddTap),
                                            ],
                                          ),
                                          SizedBox(height: 10),
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
                                          SizedBox(height: 10),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              InputFields.formField1(
                                                hintTxt: "Copy",
                                                controller: controller.copyCtr,
                                                width: controller
                                                        .componentWidthRatio -
                                                    .05,
                                                maxLen: 99999,
                                                padLeft: 0,
                                              ),
                                              Spacer(flex: 1),
                                              InputFields.formField1(
                                                hintTxt: "Seg No",
                                                padLeft: 0,
                                                controller:
                                                    controller.segNoCtrRight,
                                                width: controller
                                                        .componentWidthRatio -
                                                    .05,
                                                inputformatters: [
                                                  FilteringTextInputFormatter
                                                      .digitsOnly,
                                                ],
                                              ),
                                              Spacer(flex: 2),
                                              FormButton(
                                                  btnText: "Copy",
                                                  callback:
                                                      controller.handleCopyTap),
                                            ],
                                          ),
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
