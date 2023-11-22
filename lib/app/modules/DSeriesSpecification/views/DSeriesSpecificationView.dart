import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';

import '../../../../widgets/FormButton.dart';
import '../../../../widgets/LoadingScreen.dart';
import '../../../../widgets/PlutoGrid/src/pluto_grid.dart';
import '../../../../widgets/dropdown.dart';
import '../../../../widgets/gridFromMap.dart';
import '../../../../widgets/input_fields.dart';
import '../../../controller/HomeController.dart';
import '../../../controller/MainController.dart';
import '../../../data/PermissionModel.dart';
import '../../../data/user_data_settings_model.dart';
import '../../../providers/SizeDefine.dart';
import '../../../providers/Utils.dart';
import '../../../routes/app_pages.dart';
import '../controllers/DSeriesSpecificationController.dart';

class DSeriesSpecificationView extends GetView<DSeriesSpecificationController> {
  DSeriesSpecificationController controllerX =
      Get.put(DSeriesSpecificationController());

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: size.width * .67,
          child: Dialog(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppBar(
                  title: const Text('D Series Specification'),
                  centerTitle: true,
                  backgroundColor: Colors.deepPurple,
                ),
                SizedBox(height: 2),
                GetBuilder<DSeriesSpecificationController>(
                  init: controllerX,
                  id: "updateView",
                  builder: (control) {
                    if (controllerX.locationList == null) {
                      return SizedBox(
                          width: Get.width,
                          height: Get.height * 0.2,
                          child: LoadingScreen());
                    }
                    return Padding(
                      padding:
                          const EdgeInsets.symmetric(vertical: 2, horizontal: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          SizedBox(
                            width:size.width*0.5,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Obx(() => DropDownField.formDropDown1WidthMap(
                                    controllerX.locationList.value,
                                        (data) {
                                      controllerX.selectLocation = data;
                                      controllerX.getChannel(data.key);
                                    },
                                    "Location",
                                    controllerX.widthSize,
                                    inkWellFocusNode: controllerX.locationFocus,
                                    // isEnable: controllerX.isEnable.value,
                                    searchReq: true,
                                    selected: controllerX.selectLocation,
                                    autoFocus: true,
                                )),

                                Obx(() => DropDownField.formDropDown1WidthMap(
                                  controllerX.channelList.value,
                                      (data) {
                                    controllerX.selectChannel = data;
                                    controllerX.getChannelLeave();
                                  },
                                  "Channel",
                                  controllerX.widthSize,
                                  inkWellFocusNode: controllerX.channelFocus,
                                  // isEnable: controllerX.isEnable.value,
                                  searchReq: true,
                                  selected: controllerX.selectChannel,
                                )),

                                Obx(() => DropDownField.formDropDown1WidthMap(
                                  controllerX.eventList.value,
                                      (data) {
                                    controllerX.selectEvent?.value = data;
                                    controllerX.getEventLeave(data.key ?? "");
                                  },
                                  "Event",
                                  controllerX.widthSize,
                                  inkWellFocusNode: controllerX.eventFocus,
                                  // isEnable: controllerX.isEnable.value,
                                  searchReq: true,
                                  selected: controllerX.selectEvent?.value,
                                )),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 2,
                          ),
                          SizedBox(
                            width:size.width*0.5,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width:size.width*0.145,
                                  child: Row(
                                    children: [
                                      Obx(() => Padding(
                                        padding: const EdgeInsets.only(top: 10.0,left: 0),
                                        child: Checkbox(
                                          value: controllerX.chckLastSegment.value,
                                          onChanged: (val) {
                                            controllerX.chckLastSegment.value = val!;
                                            controllerX.chckLastSegment.refresh();
                                          },
                                          materialTapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                        ),
                                      )),
                                      Padding(
                                        padding:
                                        const EdgeInsets.only(top: 10.0, left: 0),
                                        child: Text(
                                          "Last Segment",
                                          style:
                                          TextStyle(fontSize: SizeDefine.labelSize1),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                InputFields.numbers(
                                  hintTxt: "From",
                                  inputformatters: [
                                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                                  ],
                                  controller: controllerX.from_,
                                  onchanged: (v) {},
                                  padLeft: 5,
                                  isNegativeReq: false,
                                  width: controllerX.widthSize,
                                ),

                                /// Part NO#
                                InputFields.numbers3(
                                  hintTxt: "To",
                                  controller: controllerX.to_,
                                  padLeft: 0,
                                  inputformatters: [
                                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                                  ],
                                  onchanged: (v) {},
                                  isNegativeReq: false,
                                  width: controllerX.widthSize,
                                  // fN: controllerX.partNoFocus,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 2,
                          ),
                          SizedBox(
                            width:size.width*0.5,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                /// Part NO#
                                InputFields.formField1Width(
                                  hintTxt: "Value",
                                  paddingLeft: 0,
                                  controller: controllerX.value_,
                                  widthRatio: controllerX.widthSize,
                                  // fN: controllerX.partNoFocus,
                                ),
                                InputFields.formField1Width(
                                  hintTxt: "Desc",
                                  paddingLeft: 0,
                                  controller: controllerX.desc_,
                                  widthRatio: controllerX.widthSize,
                                  // fN: controllerX.partNoFocus,
                                ),

                                /// Add Btn
                                SizedBox(
                                  width: size.width*0.15,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(left: 0, top: 15),
                                        child: FormButton(
                                          btnText: "Add",
                                          callback: () {
                                            controllerX.btnAdd_Click();
                                            // controllerX.addTable();
                                          },
                                          showIcon: true,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 0, top: 15),
                                        child: FormButton(
                                          btnText: "Remove",
                                          callback: () {
                                            controllerX.btnRemove_Click();
                                            // controllerX.addTable();
                                          },
                                          showIcon: true,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                              ],
                            ),
                          ),

                         /* Wrap(
                            crossAxisAlignment: WrapCrossAlignment.start,
                            alignment:WrapAlignment.start,
                            runSpacing: 5,
                            spacing: 5,runAlignment:WrapAlignment.start ,
                            children: [





                            ],
                          ),*/
                        ],
                      ),
                    );
                  },
                ),
                SizedBox(height: 2),
                GetBuilder<DSeriesSpecificationController>(
                    id: "listUpdate",
                    init: controllerX,
                    // init: CreateBreakPatternController(),
                    builder: (controller) {
                      print("Called this Update >>>listUpdate");
                      if (controller.dSeriesModel != null &&
                          ((controller.dSeriesModel?.search?.length ?? 0) > 0)) {
                        return Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 0),
                            child: DataGridFromMap4(
                              witdthSpecificColumn: (controllerX
                                  .userDataSettings?.userSetting
                                  ?.firstWhere(
                                      (element) =>
                                          element.controlName == "stateManager",
                                      orElse: () => UserSetting())
                                  .userSettings),
                              mapData: (controller.dSeriesModel?.search
                                  ?.map((e) => e.toJson())
                                  .toList())!,
                              widthRatio: (Get.width / 9) + 5,
                              colorCallback: (row) =>
                              (row.row.cells.containsValue(controllerX.stateManager?.currentCell))
                                  ? Colors.deepPurple.shade200
                                  : Colors.white,
                              showSrNo: true,
                              csvFormat: true,
                              showOnlyCheckBox: true,
                              focusNode: controllerX.gridFocus,
                              checkRowKey: "isLastSegment",
                              exportFileName: "D Series Specifications",
                              onload: (PlutoGridOnLoadedEvent grid) {
                                controllerX.stateManager = grid.stateManager;
                              },
                              mode: PlutoGridMode.selectWithOneTap,
                              // actionIcon: Icons.delete_forever_rounded,
                              onSelected: (PlutoGridOnSelectedEvent pluto) {
                                controllerX.onDoubleClick(pluto);
                              },
                              // mode: controllerX.gridcanFocus,
                            ),
                          ),
                        );
                      } else {
                        return Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 0),
                            child: Card(
                              clipBehavior: Clip.hardEdge,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(0), // if you need this
                                side: BorderSide(
                                  color: Colors.grey.shade300,
                                  width: 1,
                                ),
                              ),
                              child: Container(
                                height: Get.height - (4 * kToolbarHeight),
                              ),
                            ),
                          ),
                        );
                      }
                    }),
                // Divider(),

                GetBuilder<HomeController>(
                    id: "buttons",
                    init: Get.find<HomeController>(),
                    builder: (controller) {
                      PermissionModel formPermissions = Get.find<MainController>()
                          .permissionList!
                          .lastWhere((element) {
                        return element.appFormName ==
                            Routes.D_SERIES_SPECIFICATION.replaceAll("/", "");
                      });
                      if (controller.buttons != null) {
                        return ButtonBar(
                          alignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            for (var btn in controller.buttons!)
                              FormButtonWrapper(
                                btnText: btn["name"],
                                callback: Utils.btnAccessHandler2(btn['name'],
                                            controller, formPermissions) ==
                                        null
                                    ? null
                                    : () => formHandler(btn['name']),
                              )
                          ],
                        );
                      } else {
                        return Container();
                      }
                    }),
                const SizedBox(height: 3),
              ],
            ),
          ),
        ),
      ),
    );
  }

  formHandler(btn) {
    switch (btn) {
      case "Save":
        controllerX.save();
        break;
      case "Clear":
        Get.find<HomeController>().clearPage1();
        Get.delete<DSeriesSpecificationController>();
        break;
      case "Search":
        controllerX.callSearchApi();
        break;
      case "Exit":
        Get.find<HomeController>().postUserGridSetting2(listStateManager: [
          {"stateManager": controllerX.stateManager}
        ]);
        break;
    }
  }
}
