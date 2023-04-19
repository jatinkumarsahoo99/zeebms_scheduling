import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/mam_work_orders_controller.dart';

class MamWorkOrdersView extends GetView<MamWorkOrdersController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MamWorkOrdersView'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'MamWorkOrdersView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
