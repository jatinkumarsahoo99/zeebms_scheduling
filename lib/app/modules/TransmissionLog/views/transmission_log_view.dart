import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/transmission_log_controller.dart';

class TransmissionLogView extends GetView<TransmissionLogController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TransmissionLogView'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'TransmissionLogView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
