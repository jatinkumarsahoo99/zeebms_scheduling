import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/EuropeRunningOrderStatusController.dart';

class EuropeRunningOrderStatusView
    extends GetView<EuropeRunningOrderStatusController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('EuropeRunningOrderStatusView'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'EuropeRunningOrderStatusView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
