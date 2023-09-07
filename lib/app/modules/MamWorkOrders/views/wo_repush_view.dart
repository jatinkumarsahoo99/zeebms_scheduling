import 'package:bms_scheduling/app/modules/RoBooking/views/dummydata.dart';
import 'package:bms_scheduling/widgets/FormButton.dart';
import 'package:bms_scheduling/widgets/gridFromMap.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../data/user_data_settings_model.dart';
import '../controllers/mam_work_orders_controller.dart';
import 'package:bms_scheduling/widgets/PlutoGrid/pluto_grid.dart'
    show PlutoGridMode;

class WoRepushView extends GetView {
  const WoRepushView(this.controller, {Key? key}) : super(key: key);
  @override
  final MamWorkOrdersController controller;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 4,
          child: Obx(
            () {
              return (controller.rePushModel.value.programResponse
                          ?.lstResendWorkOrders?.isEmpty ??
                      true)
                  ? Container(
                      decoration:
                          BoxDecoration(border: Border.all(color: Colors.grey)),
                    )
                  : DataGridFromMap3(
                      mapData: controller.rePushModel.value.programResponse
                              ?.lstResendWorkOrders
                              ?.map((e) => e.toJson())
                              .toList() ??
                          [],
                      checkBoxColumnKey: ['resend'],
                      enableColumnDoubleTap: ['resend'],
                      actionIconKey: ['resend'],
                      actionOnPress: (position, isSpaceCalled) {
                        if (isSpaceCalled) {
                          controller.woRepushSM!.changeCellValue(
                            controller.woRepushSM!
                                .getRowByIdx(position.rowIdx)!
                                .cells['resend']!,
                            (!(controller
                                        .rePushModel
                                        .value
                                        .programResponse
                                        ?.lstResendWorkOrders?[position.rowIdx!]
                                        .resend ??
                                    false))
                                .toString(),
                            callOnChangedEvent: true,
                            force: true,
                            notify: true,
                          );
                        }
                      },
                      witdthSpecificColumn: (controller
                          .userDataSettings?.userSetting
                          ?.firstWhere(
                              (element) => element.controlName == "woRepushSM",
                              orElse: () => UserSetting())
                          .userSettings),
                      onload: (sm) {
                        controller.woRepushSM = sm.stateManager;
                      },
                      onEdit: controller.handleOnChangedInDTInWORePush,
                      checkBoxStrComparison: "true",
                      uncheckCheckBoxStr: "false",
                      onColumnHeaderDoubleTap:
                          controller.handleDoubleTabInDTInWORePush,
                      mode: PlutoGridMode.selectWithOneTap,
                      onSelected: controller.getJSONINWORepush,
                    );
            },
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          child: Text("JSON"),
        ),
        Expanded(
          flex: 2,
          child: Container(
            width: double.infinity,
            height: double.infinity,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
            child: Obx(() {
              return SelectableText(controller.rePushJsonTC.value);
            }),
          ),
        ),
        const SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Select row in above grid to get JSON",
              style: TextStyle(color: Colors.blue),
            ),
            Row(
              children: [
                FormButtonWrapper(
                  btnText: "Load WOs To Repush",
                  callback: controller.rePushLoadGetData,
                ),
                SizedBox(width: 15),
                FormButtonWrapper(
                  btnText: "Re-push WO",
                  callback: controller.rePushWO,
                ),
              ],
            )
          ],
        )
      ],
    );
  }
}
