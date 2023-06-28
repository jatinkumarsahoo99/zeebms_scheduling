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
                              flex: 12,
                              child: Container(
                                decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
                                padding: EdgeInsets.all(16),
                                child: ListView(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        DropDownField.formDropDown1WidthMap(
                                          controller.onloadModel?.fillerMasterOnload?.lstLocation ?? [],
                                          controller.locationOnChanged,
                                          "Location",
                                          .17,
                                          autoFocus: true,
                                          selected: controller.selectedDropDowns[0],
                                          inkWellFocusNode: controller.locationFN,
                                        ),
                                        // SizedBox(width: 20),
                                        Obx(() {
                                          return DropDownField.formDropDown1WidthMap(
                                            controller.channelList.value,
                                            (a) => controller.selectedDropDowns[19] = a,
                                            "Channel",
                                            .17,
                                            selected: controller.selectedDropDowns[19],
                                          );
                                        }),
                                        // SizedBox(width: 20),
                                        DropDownField.formDropDown1WidthMap(
                                          controller.onloadModel?.fillerMasterOnload?.lstMovieGrade ?? [],
                                          (v) => controller.selectedDropDowns[15] = v,
                                          "Movie Grade",
                                          .17,
                                          selected: controller.selectedDropDowns[15],
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
                                          onchanged: (v) => controller.selectedDropDowns[2] = v,
                                          title: 'Banner',
                                          selectedValue: controller.selectedDropDowns[2],
                                          url: ApiFactory.FILLER_MASTER_BANNER_SEARCH,
                                          parseKeyForKey: "BannerCode",
                                          parseKeyForValue: "BannerName",
                                        ),
                                        // SizedBox(width: 20),
                                        InputFields.formField1(
                                          hintTxt: "Filler Name",
                                          controller: controller.fillerNameCtr,
                                          width: 0.17,
                                          focusNode: controller.fillerNameFN,
                                        ),
                                        // SizedBox(width: 20),
                                        InputFields.formField1(
                                          hintTxt: "TX Caption",
                                          controller: controller.txCaptionCtr,
                                          width: 0.17,
                                          prefixText: "F/",
                                        ),
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
                                        InputFields.formField1(
                                          hintTxt: "Seg No",
                                          controller: controller.segNoCtrLeft,
                                          width: 0.17,
                                          focusNode: controller.segNoFN,
                                        ),
                                        // SizedBox(width: 20),
                                        InputFields.formField1(
                                          hintTxt: "TX No",
                                          controller: controller.txNoCtr,
                                          width: 0.17,
                                        ),
                                      ],
                                    ),
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
                                    SizedBox(height: 14),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        DropDownField.formDropDown1WidthMap(
                                          controller.onloadModel?.fillerMasterOnload?.lstTapetypemaster ?? [],
                                          (v) => controller.selectedDropDowns[3] = v,
                                          "Tape Type",
                                          .17,
                                          selected: controller.selectedDropDowns[3],
                                        ),
                                        // SizedBox(width: 20),
                                        DropDownField.formDropDown1WidthMap(
                                          controller.onloadModel?.fillerMasterOnload?.lstfillertypemaster ?? [],
                                          (v) => controller.selectedDropDowns[4] = v,
                                          "Type",
                                          .17,
                                          selected: controller.selectedDropDowns[4],
                                        ),
                                        // SizedBox(width: 20),
                                        DropDownField.formDropDown1WidthMap(
                                          controller.onloadModel?.fillerMasterOnload?.lstCensorshipMaster ?? [],
                                          (v) => controller.selectedDropDowns[5] = v,
                                          "Censhorship",
                                          .17,
                                          selected: controller.selectedDropDowns[5],
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 14),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        DropDownField.formDropDown1WidthMap(
                                          controller.onloadModel?.fillerMasterOnload?.lstLanguagemaster ?? [],
                                          (v) => controller.selectedDropDowns[6] = v,
                                          "Langauge",
                                          .17,
                                          selected: controller.selectedDropDowns[6],
                                        ),
                                        DropDownField.formDropDown1WidthMap(
                                          controller.onloadModel?.fillerMasterOnload?.lstproduction ?? [],
                                          (v) => controller.selectedDropDowns[7] = v,
                                          "Production",
                                          .17,
                                          selected: controller.selectedDropDowns[7],
                                        ),
                                        InputFields.formField1(
                                          hintTxt: "Seg ID",
                                          controller: controller.segIDCtr,
                                          width: 0.17,
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 14),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        DropDownField.formDropDown1WidthMap(
                                          controller.onloadModel?.fillerMasterOnload?.lstcolor ?? [],
                                          (v) => controller.selectedDropDowns[8] = v,
                                          "Color",
                                          .17,
                                          selected: controller.selectedDropDowns[8],
                                        ),
                                        DropDownField.formDropDown1WidthMap(
                                          controller.onloadModel?.fillerMasterOnload?.lstRegion ?? [],
                                          (v) => controller.selectedDropDowns[9] = v,
                                          "Region",
                                          .17,
                                          selected: controller.selectedDropDowns[9],
                                        ),
                                        DropDownField.formDropDown1WidthMap(
                                          controller.onloadModel?.fillerMasterOnload?.lstEnegry ?? [],
                                          (v) => controller.selectedDropDowns[10] = v,
                                          "Energy",
                                          .17,
                                          selected: controller.selectedDropDowns[10],
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 14),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        DropDownField.formDropDown1WidthMap(
                                          controller.onloadModel?.fillerMasterOnload?.lstEra ?? [],
                                          (v) => controller.selectedDropDowns[11] = v,
                                          "Era",
                                          .17,
                                          selected: controller.selectedDropDowns[11],
                                        ),
                                        DropDownField.formDropDown1WidthMap(
                                          controller.onloadModel?.fillerMasterOnload?.lstSongGrade ?? [],
                                          (v) => controller.selectedDropDowns[12] = v,
                                          "Song Grade",
                                          .17,
                                          selected: controller.selectedDropDowns[12],
                                        ),
                                        DropDownField.formDropDown1WidthMap(
                                          controller.onloadModel?.fillerMasterOnload?.lstMood ?? [],
                                          (v) => controller.selectedDropDowns[13] = v,
                                          "Mood",
                                          .17,
                                          selected: controller.selectedDropDowns[13],
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 14),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        DropDownField.formDropDown1WidthMap(
                                          controller.onloadModel?.fillerMasterOnload?.lstTempo ?? [],
                                          (v) => controller.selectedDropDowns[14] = v,
                                          "Tempo",
                                          .17,
                                          selected: controller.selectedDropDowns[14],
                                        ),
                                        InputFields.formField1(hintTxt: "Movie Name", controller: controller.movieNameCtr, width: 0.17),
                                        InputFields.formField1(hintTxt: "Release Year", controller: controller.releaseYearCtr, width: 0.17),
                                      ],
                                    ),
                                    SizedBox(height: 14),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        InputFields.formField1(hintTxt: "Singer", controller: controller.singerCtr, width: 0.17),
                                        // SizedBox(width: 20),
                                        InputFields.formField1(hintTxt: "Music Director", controller: controller.musicDirectorCtr, width: 0.17),
                                        // SizedBox(width: 20),
                                        InputFields.formField1(hintTxt: "Music Company", controller: controller.musicCompanyCtr, width: 0.17),
                                      ],
                                    ),
                                    // SizedBox(height: 4),
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
                                      decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
                                      padding: const EdgeInsets.all(16.0),
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              DropDownField.formDropDown1WidthMap(
                                                controller.onloadModel?.fillerMasterOnload?.lsttapesource ?? [],
                                                (v) => controller.selectedDropDowns[16] = v,
                                                "Source",
                                                .17,
                                                selected: controller.selectedDropDowns[16],
                                              ),
                                              DropDownField.formDropDown1WidthMap(
                                                controller.onloadModel?.fillerMasterOnload?.lstProducerTape ?? [],
                                                (v) => controller.selectedDropDowns[17] = v,
                                                "ID No",
                                                .17,
                                                selected: controller.selectedDropDowns[17],
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 14),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              DateWithThreeTextField(
                                                title: "Start Date",
                                                mainTextController: controller.startDateCtr,
                                                widthRation: .17,
                                              ),
                                              DateWithThreeTextField(
                                                title: "End Date",
                                                mainTextController: controller.endDateCtr,
                                                widthRation: .17,
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 14),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Synopsis",
                                                  style: TextStyle(
                                                    fontSize: SizeDefine.labelSize1,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                const SizedBox(height: 5),
                                                Expanded(
                                                  child: TextFormField(
                                                    expands: true,
                                                    minLines: null,
                                                    maxLines: null,
                                                    controller: controller.synopsisCtr,
                                                    textAlignVertical: TextAlignVertical.top,
                                                    keyboardType: TextInputType.multiline,
                                                    decoration: InputDecoration(
                                                      filled: true,
                                                      fillColor: Colors.white,
                                                      contentPadding: EdgeInsets.all(10),
                                                      border: OutlineInputBorder(
                                                        borderRadius: BorderRadius.circular(0),
                                                        borderSide: BorderSide(
                                                          color: Colors.deepPurpleAccent,
                                                        ),
                                                      ),
                                                      enabledBorder: OutlineInputBorder(
                                                        borderRadius: BorderRadius.circular(0),
                                                        borderSide: BorderSide(
                                                          color: Colors.deepPurpleAccent,
                                                        ),
                                                      ),
                                                      focusedBorder: OutlineInputBorder(
                                                        borderRadius: BorderRadius.circular(0),
                                                        borderSide: BorderSide(
                                                          color: Colors.deepPurpleAccent,
                                                        ),
                                                      ),
                                                      errorBorder: OutlineInputBorder(
                                                        borderRadius: BorderRadius.circular(0),
                                                        borderSide: BorderSide(
                                                          color: Colors.deepPurpleAccent,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: 14),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 14),
                                  Text("Annotation"),
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
                                            onchanged: (v) => controller.selectedDropDowns[18] = v,
                                            title: 'Event',
                                            selectedValue: controller.selectedDropDowns[18],
                                            url: ApiFactory.FILLER_MASTER_GET_EVENT,
                                            customInData: "onLeaveEvent",
                                            parseKeyForKey: "eventid",
                                            parseKeyForValue: "eventname",
                                            miniumSearchLength: 1,
                                          ),
                                          SizedBox(height: 14),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            children: [
                                              InputFields.formFieldNumberMask(
                                                controller: controller.tcInCtr,
                                                hintTxt: 'TC In',
                                                widthRatio: .11,
                                                paddingLeft: 0,
                                                // textFieldFN: controller.eomFN,
                                              ),
                                              InputFields.formFieldNumberMask(
                                                controller: controller.tcOutCtr,
                                                hintTxt: 'TC Out',
                                                widthRatio: .11,
                                                paddingLeft: 0,
                                                // textFieldFN: controller.eomFN,
                                              ),
                                              FormButton(btnText: "Add", callback: controller.handleAddTap),
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
                                              InputFields.formField1(hintTxt: "Seg No", controller: controller.segNoCtrRight, width: 0.11),
                                              SizedBox(width: 20),
                                              FormButton(btnText: "Copy", callback: controller.handleCopyTap),
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
