import 'package:bms_scheduling/app/modules/RoBooking/controllers/ro_booking_controller.dart';
import 'package:bms_scheduling/app/modules/RoBooking/views/dummydata.dart';
import 'package:bms_scheduling/widgets/DataGridShowOnly.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

class BookingSummaryView extends GetView<RoBookingController> {
  const BookingSummaryView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: Get.find<RoBookingController>(),
        builder: (context) {
          return Column(
            children: [
              Row(
                children: [
                  Text("Summary"),
                  Row(
                    children: [
                      Obx(
                        () => InkWell(
                            onTap: () {
                              controller.bookingsummaryDefault.value = !controller.bookingsummaryDefault.value;
                            },
                            child: Icon(controller.bookingsummaryDefault.value ? Icons.check_box_outlined : Icons.check_box_outline_blank_outlined)),
                      ),
                      Text("Default")
                    ],
                  )
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Expanded(
                  child: Container(
                decoration: BoxDecoration(border: Border.all(width: 1.0, color: Colors.grey)),
                child: DataGridWithShowOnlyKeys(
                  mapData: controller.savecheckData?.lstdgvbookingSummary?.map((e) => e.toJson()).toList() ?? [],
                  formatDate: true,
                ),
              ))
            ],
          );
        });
  }
}
