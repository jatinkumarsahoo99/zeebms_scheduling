import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import 'input_fields.dart';

class IncreDecreButton {
  static Widget updateButton(title,count) {
    // var count = RxInt(1);
    return Row(
      children: [
        InkWell(
            onTap: () {
              if (count.value != 1) {
                count.value--;
              }
            },
            child: Icon(Icons.remove_circle)),
        Obx(() => InputFields.formFieldDisableWidth(
            hintTxt: title, value: count.value.toString(), widthRatio: 0.07)),
        SizedBox(
          width: 10,
        ),
        InkWell(
            onTap: () {
              count.value++;
            },
            child: Icon(Icons.add_circle)),
      ],
    );
  }
}

