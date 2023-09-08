import 'package:bms_scheduling/app/providers/SizeDefine.dart';
import 'package:bms_scheduling/widgets/DateTime/TimeWithThreeTextField.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../../widgets/DateTime/DateWithThreeTextField.dart';
import '../../../../widgets/FormButton.dart';
import '../../../../widgets/dropdown.dart';
import '../../../../widgets/input_fields.dart';
import '../../../../widgets/radio_row.dart';
import '../../../controller/HomeController.dart';
import '../../../providers/Utils.dart';
import '../controllers/secondary_event_master_controller.dart';

class SecondaryEventMasterView extends GetView<SecondaryEventMasterController> {
  const SecondaryEventMasterView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
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
                    title: Text('Non Commercial Secondary Events'),
                    centerTitle: true,
                    backgroundColor: Colors.deepPurple,
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Obx(() {
                        return FocusTraversalOrder(
                          order: const NumericFocusOrder(0),
                          child: DropDownField.formDropDown1WidthMap(
                            controller.locationList.value,
                            controller.getChannels,
                            "Location",
                            .23,
                            autoFocus: true,
                            selected: controller.selectedLoc,
                            inkWellFocusNode: controller.locFN,
                          ),
                        );
                      }),
                      SizedBox(width: size.width * .01),
                      Obx(() {
                        return FocusTraversalOrder(
                          order: const NumericFocusOrder(1),
                          child: DropDownField.formDropDown1WidthMap(
                            controller.channelList.value,
                            (val) => controller.selectedChannel = val,
                            "Channel",
                            .23,
                            selected: controller.selectedChannel,
                          ),
                        );
                      }),
                    ],
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: size.width * .47,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Row(
                        //   children: [
                        //     Obx(
                        //       () => InkWell(
                        //           focusNode: FocusNode(
                        //             skipTraversal:
                        //                 controller.selectedRadio.value ==
                        //                     "Auston",
                        //           ),
                        //           borderRadius: BorderRadius.circular(50),
                        //           onTap: () {
                        //             controller.selectedRadio.value = "Bug";
                        //           },
                        //           child: Icon(
                        //             (controller.selectedRadio.value) == "Bug"
                        //                 ? Icons.radio_button_checked
                        //                 : Icons.circle_outlined,
                        //             color: (controller.selectedRadio.value) ==
                        //                     "Bug"
                        //                 ? Colors.black
                        //                 : Colors.grey,
                        //           )),
                        //     ),
                        //     Padding(
                        //       padding: const EdgeInsets.only(left: 10),
                        //       child: Text(
                        //         "Bugs",
                        //         style: TextStyle(
                        //             fontSize: SizeDefine.labelSize1,
                        //             color: Colors.black),
                        //       ),
                        //     )
                        //   ],
                        // ),
                        // Row(
                        //   children: [
                        //     Obx(
                        //       () => InkWell(
                        //           focusNode: FocusNode(
                        //             skipTraversal:
                        //                 controller.selectedRadio.value == "Bug",
                        //           ),
                        //           borderRadius: BorderRadius.circular(50),
                        //           onTap: () {
                        //             controller.selectedRadio.value = "Aston";
                        //           },
                        //           child: Icon(
                        //             (controller.selectedRadio.value) == "Aston"
                        //                 ? Icons.radio_button_checked
                        //                 : Icons.circle_outlined,
                        //             color: (controller.selectedRadio.value) ==
                        //                     "Aston"
                        //                 ? Colors.black
                        //                 : Colors.grey,
                        //           )),
                        //     ),
                        //     Padding(
                        //       padding: const EdgeInsets.only(left: 10),
                        //       child: Text(
                        //         "Aston",
                        //         style: TextStyle(
                        //             fontSize: SizeDefine.labelSize1 + 2,
                        //             color: Colors.black),
                        //       ),
                        //     )
                        //   ],
                        // ),
                        Obx(
                          () {
                            return RadioRow(
                              items: ['Bug', 'Aston'],
                              groupValue: controller.selectedRadio.value,
                              disabledRadios:
                                  !(controller.controllsEnabled.value)
                                      ? ['Bug', 'Aston']
                                      : null,
                              onchange: (va) =>
                                  controller.selectedRadio.value = va,
                            );
                          },
                        ),
                        Obx(
                          () {
                            return InputFields.formField1(
                              hintTxt: "Tx No",
                              controller: controller.txNoTC,
                              width: 0.23,
                              readOnly: !controller.controllsEnabled.value,
                              focusNode: controller.txNOFN,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 8),
                  InputFields.formField1(
                    hintTxt: "Event Name",
                    controller: controller.eventNameTC,
                    focusNode: controller.eventNameFN,
                    width: 0.47,
                    padLeft: 0,
                  ),
                  SizedBox(height: 8),
                  InputFields.formField1(
                    hintTxt: "TX Caption",
                    controller: controller.txCaptionTC,
                    width: 0.47,
                    padLeft: 0,
                  ),
                  SizedBox(height: 8),

                  SizedBox(
                    width: size.width * .47,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        DateWithThreeTextField(
                          title: "Start Date",
                          mainTextController: controller.startDateTC,
                          widthRation: .23,
                          endDate: DateTime.now(),
                        ),
                        DateWithThreeTextField(
                          title: "End Date",
                          mainTextController: controller.endDateTC,
                          widthRation: .23,
                          startDate: DateTime.now(),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 8),
                  SizedBox(
                    width: size.width * .47,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: size.width * .23,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InputFields.formFieldNumberMask(
                                hintTxt: "SOM",
                                controller: controller.somTC,
                                widthRatio: .11,
                                paddingLeft: 0,
                              ),
                              InputFields.formFieldNumberMask(
                                hintTxt: "EOM",
                                controller: controller.eomTC,
                                widthRatio: .11,
                                textFieldFN: controller.eomFN,
                                paddingLeft: 0,
                              ),
                            ],
                          ),
                        ),
                        Obx(() {
                          return InputFields.formFieldDisable(
                            hintTxt: "Duration",
                            value: controller.duration.value,
                            widthRatio: .23,
                            leftPad: 0,
                            color: Colors.black,
                          );
                        }),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),

                  /// bottom common buttons
                  SizedBox(
                    width: size.width * .47,
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: GetBuilder<HomeController>(
                          id: "buttons",
                          init: Get.find<HomeController>(),
                          builder: (btncontroller) {
                            if (btncontroller.buttons != null) {
                              return Wrap(
                                spacing: 5,
                                runSpacing: 15,
                                alignment: WrapAlignment.center,
                                // alignment: MainAxisAlignment.start,
                                // mainAxisSize: MainAxisSize.min,
                                children: [
                                  for (var btn in btncontroller.buttons!) ...{
                                    FormButtonWrapper(
                                      btnText: btn["name"],
                                      callback: ((Utils.btnAccessHandler(
                                                  btn['name'],
                                                  controller
                                                      .formPermissions!) ==
                                              null))
                                          ? null
                                          : () => controller
                                              .formHandler(btn['name']),
                                    )
                                  },
                                  // for (var btn in btncontroller.buttons!)
                                  //   FormButtonWrapper(
                                  //     btnText: btn["name"],
                                  //     callback: () => controller.formHandler(btn['name'].toString()),
                                  //   ),
                                ],
                              );
                            }
                            return Container();
                          }),
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
