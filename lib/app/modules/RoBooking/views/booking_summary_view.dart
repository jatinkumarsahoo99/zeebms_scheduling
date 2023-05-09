import 'package:bms_scheduling/app/modules/RoBooking/views/dummydata.dart';
import 'package:bms_scheduling/widgets/DataGridShowOnly.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

class BookingSummaryView extends GetView {
  const BookingSummaryView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text("Summary"),
            Row(
              children: [
                Icon(Icons.check_box_outline_blank_outlined),
                Text("Default")
              ],
            )
          ],
        ),
        Expanded(
            child: Container(
          child: DataGridShowOnlyKeys(
            mapData: dummyProgram,
            formatDate: false,
          ),
        ))
      ],
    );
  }
}
