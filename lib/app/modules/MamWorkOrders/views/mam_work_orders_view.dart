import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/mam_work_orders_controller.dart';
import 'cancel_wo_view.dart';
import 'release_wo_non_fpc_view.dart';
import 'wo_as_per_daily_fpc_view.dart';
import 'wo_history_view.dart';
import 'wo_repush_view.dart';

class MamWorkOrdersView extends GetView<MamWorkOrdersController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: CupertinoSlidingSegmentedControl(
                groupValue: null,
                children: Map.fromEntries(
                    controller.mainTabs.map((e) => MapEntry(e, Text(e)))),
                onValueChanged: (value) {
                  controller.pageController.jumpToPage(controller.mainTabs
                      .indexWhere((element) => element == value));
                }),
          ),
          Expanded(
              child: Card(
            margin: EdgeInsets.symmetric(vertical: 0, horizontal: 5),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                    top: Radius.zero, bottom: Radius.circular(8))),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: PageView(
                controller: controller.pageController,
                children: [
                  ReleaseWoNonFpcView(),
                  WoAsPerDailyFpcView(),
                  WoRepushView(),
                  CancelWoView(),
                  WoHistoryView()
                ],
              ),
            ),
          )),
          Container(
            height: 50,
            color: Colors.red,
          )
        ],
      ),
    );
  }
}
