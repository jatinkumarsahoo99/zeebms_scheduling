import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/commercial_time_update_controller.dart';

class CommercialTimeUpdateView extends GetView<CommercialTimeUpdateController> {
  const CommercialTimeUpdateView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CommercialTimeUpdateView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'CommercialTimeUpdateView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
