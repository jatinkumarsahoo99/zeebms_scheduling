import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/log_additions_controller.dart';

class LogAdditionsView extends GetView<LogAdditionsController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('LogAdditionsView'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'LogAdditionsView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
