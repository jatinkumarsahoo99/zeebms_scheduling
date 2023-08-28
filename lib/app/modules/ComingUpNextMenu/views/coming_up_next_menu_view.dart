import 'package:bms_scheduling/app/data/DropDownValue.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../widgets/DateTime/DateWithThreeTextField.dart';
import '../../../../widgets/DateTime/TimeWithThreeTextField.dart';
import '../../../../widgets/FormButton.dart';
import '../../../../widgets/LoadingDialog.dart';
import '../../../../widgets/dropdown.dart';
import '../../../../widgets/input_fields.dart';
import '../../../../widgets/radio_row1.dart';
import '../../../controller/HomeController.dart';
import '../../../controller/MainController.dart';
import '../../../data/PermissionModel.dart';
import '../../../providers/ApiFactory.dart';
import '../../../providers/Utils.dart';
import '../controllers/coming_up_next_menu_controller.dart';

class ComingUpNextMenuView extends StatelessWidget {
  ComingUpNextMenuView({Key? key}) : super(key: key);

  ComingUpNextMenuController controllerX =
  Get.put<ComingUpNextMenuController>(ComingUpNextMenuController());

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery
        .of(context)
        .size;
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: size.width * .64,
          child: Dialog(
            child: FocusTraversalGroup(
              policy: OrderedTraversalPolicy(),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppBar(
                    title: Text('Coming Up Next Master'),
                    centerTitle: true,
                    backgroundColor: Colors.deepPurple,
                  ),
                  GetBuilder<ComingUpNextMenuController>(
                      id: "top",
                      builder: (controllerX) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              SizedBox(
                                height: 5,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceBetween,
                                children: [
                                  Obx(() {
                                    return DropDownField.formDropDown1WidthMap(
                                      controllerX.locationList.value,
                                          (value) {
                                        controllerX.selectedLocation?.value =
                                            value;
                                        controllerX.fetchListOfChannel(
                                            controllerX.selectedLocation?.value
                                                ?.key ?? "");
                                      }, "Location", .26,
                                      isEnable: controllerX.isEnable,
                                      selected: controllerX.selectedLocation
                                          ?.value,
                                      inkWellFocusNode: controllerX
                                          .locationFocus,
                                      autoFocus: true,);
                                  }),
                                  Obx(() {
                                    return DropDownField.formDropDown1WidthMap(
                                      controllerX.channelList.value,
                                          (value) {
                                        controllerX.selectedChannel?.value =
                                            value;
                                      }, "Channel", .26,
                                      isEnable: controllerX.isEnable,
                                      selected: controllerX.selectedChannel
                                          ?.value,
                                      inkWellFocusNode: controllerX
                                          .channelFocus,
                                      autoFocus: false,);
                                  }),
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceBetween,
                                children: [
                                  Obx(() {
                                    return SizedBox(
                                      width: size.width * 0.26,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment
                                            .spaceBetween,
                                        children: [
                                          InputFields.formField1(
                                            hintTxt: "Tape Id",
                                            controller: controllerX
                                                .tapeIdController,
                                            width: 0.11,
                                            focusNode: controllerX.tapeIdFocus,
                                            isEnable: controllerX.isEnable1
                                                .value,
                                            onchanged: (value) {

                                            },
                                            autoFocus: false,
                                          ),
                                          InputFields.numbers3(
                                              hintTxt: "Seg No.",
                                              padLeft: 0,
                                              controller: controllerX
                                                  .segNoController,
                                              width: 0.11,
                                              fN: controllerX.segNoFocus,
                                              isEnabled: controllerX.isEnable1
                                                  .value,
                                              onchanged: (value) {

                                              }

                                          ),
                                        ],
                                      ),
                                    );
                                  }),

                                  SizedBox(
                                    width: size.width * 0.26,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment
                                          .spaceBetween,
                                      children: [
                                        Obx(() {
                                          return InputFields.formField1(
                                              hintTxt: "House Id",
                                              controller: controllerX
                                                  .houseIdController,
                                              width: 0.1,
                                              isEnable: controllerX.isEnable1
                                                  .value,
                                              onchanged: (value) {},
                                              focusNode: controllerX
                                                  .houseIdFocus
                                          );
                                        }),
                                        Container(
                                          width: size.width * 0.1,
                                        )
                                      ],
                                    ),
                                  ),

                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Obx(() {
                                return DropDownField
                                    .formDropDownSearchAPI2(
                                  GlobalKey(),
                                  context,
                                  width: context.width * 0.6,
                                  onchanged: (DropDownValue? val) {
                                    print(">>>" + val.toString());
                                    controllerX.selectedProgram?.value = val;
                                  },
                                  title: 'Program',
                                  url: ApiFactory
                                      .COMINGUPNEXTMASTER_PROGRAMSEARCH,
                                  parseKeyForKey: "programcode",
                                  parseKeyForValue: 'programname',
                                  selectedValue: controllerX.selectedProgram
                                      ?.value,
                                  autoFocus: false,
                                  // maxLength: 1
                                );
                              }),
                              const SizedBox(
                                height: 5,
                              ),
                              InputFields.formField1(
                                hintTxt: "Tx Caption",
                                controller: controllerX.txCaptionController,
                                width: 0.6,
                                capital: true,
                                autoFocus: false,
                                isEnable: controllerX.isEnable,
                                prefixText: "NEXT/",
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Align(
                                alignment: Alignment.topLeft,
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    InputFields.formFieldNumberMask(
                                        hintTxt: "SOM",
                                        controller: controllerX.somController,
                                        widthRatio: 0.1,
                                        isEnable: controllerX.isEnable,
                                        onEditComplete: (val) {},
                                        // isTime: true,
                                        // isEnable: controller.isEnable.value,
                                        paddingLeft: 0),
                                    InputFields.formFieldNumberMask(
                                        hintTxt: "EOM",
                                        controller: controllerX.eomController,
                                        widthRatio: 0.1,
                                        isEnable: controllerX.isEnable,
                                        onEditComplete: (val) {
                                          controllerX.calculateDuration();
                                        },
                                        // isTime: true,
                                        // isEnable: controller.isEnable.value,
                                        paddingLeft: 0),

                                    Obx(() =>
                                        InputFields.formFieldDisable(
                                          /*title: "Duration",
                                    mainTextController: controllerX.durationController,
                                    widthRation: 0.07,
                                    isTime: false,
                                    isEnable: false,*/
                                          hintTxt: 'Duration',
                                          value: controllerX.duration.value,
                                          widthRatio: 0.1,
                                        )),

                                    Obx(() {
                                      return RadioRow1(
                                        items: ['Non-Dated', 'Dated'],
                                        groupValue: controllerX.selectedRadio
                                            .value,
                                        disabledRadios: ['Non-Dated', 'Dated']
                                            .where((element) =>
                                        element !=
                                            controllerX.selectedRadio.value)
                                            .toList(),
                                        onchange: (va) =>
                                        controllerX.selectedRadio.value = va,
                                      );
                                    }),
                                    GetBuilder<ComingUpNextMenuController>(
                                      assignId: true,
                                      id: "date",
                                      builder: (controllerX) {
                                        return DateWithThreeTextField(
                                          title: "Upto Date",
                                          mainTextController: controllerX.uptoDateController,
                                          widthRation: .1,
                                          formatting: "dd-MM-yyyy",
                                          isEnable: controllerX.isEnable,
                                          startDate: controllerX.startDate,
                                          intailDate: controllerX.startDate,
                                          endDate: DateTime.now().add(const Duration(days: 2050)),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                            ],
                          ),
                        );
                      }
                  ),

                  /// bottom common buttons
                  Align(
                    alignment: Alignment.topCenter,
                    child: GetBuilder<HomeController>(
                        id: "buttons",
                        init: Get.find<HomeController>(),
                        builder: (controller) {
                          PermissionModel formPermissions = Get
                              .find<MainController>()
                              .permissionList!
                              .lastWhere((element) =>
                          element.appFormName == "frmComingUpNextMaster");
                          if (controller.buttons != null) {
                            return Wrap(
                              spacing: 5,
                              runSpacing: 15,
                              alignment: WrapAlignment.center,
                              children: [
                                for (var btn in controller.buttons!)
                                  FormButtonWrapper(
                                    btnText: btn["name"],
                                    callback: Utils.btnAccessHandler2(
                                        btn['name'],
                                        controller, formPermissions) ==
                                        null
                                        ? null
                                        : () =>
                                        controllerX.formHandler(
                                          btn['name'],
                                        ),
                                  )
                              ],
                            );
                          }
                          return Container();
                        }),
                  ),
                  SizedBox(height: 8),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
