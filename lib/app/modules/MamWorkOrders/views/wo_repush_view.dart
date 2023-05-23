import 'package:bms_scheduling/app/modules/RoBooking/views/dummydata.dart';
import 'package:bms_scheduling/widgets/FormButton.dart';
import 'package:bms_scheduling/widgets/gridFromMap.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/mam_work_orders_controller.dart';
import 'package:pluto_grid/pluto_grid.dart' show PlutoGridMode;

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
              return (controller.rePushModel.value.programResponse?.lstResendWorkOrders?.isEmpty ?? true)
                  ? Container(
                      decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
                    )
                  : DataGridFromMap3(
                      mapData: controller.rePushModel.value.programResponse?.lstResendWorkOrders?.map((e) => e.toJson()).toList() ?? [],
                      checkBoxColumnKey: ['resend'],
                      enableColumnDoubleTap: ['resend'],
                      onEdit: controller.handleOnChangedInDTInWORePush,
                      checkBoxStrComparison: "true",
                      uncheckCheckBoxStr: "false",
                      onColumnHeaderDoubleTap: controller.handleDoubleTabInDTInWORePush,
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
            decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
            child: TextFormField(
              controller: controller.rePushJsonTC,
              decoration: const InputDecoration(
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                focusedErrorBorder: InputBorder.none,
              ),
            ),
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
