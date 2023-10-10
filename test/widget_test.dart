// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:bms_scheduling/app/modules/MamWorkOrders/controllers/mam_work_orders_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:bms_scheduling/main.dart';

void main() {
  var controller = MamWorkOrdersController();
  expect(controller.showMsgDialogSuccess2(["msgList", ""], () {}), () {
    print("hey i am here");
  });
}
