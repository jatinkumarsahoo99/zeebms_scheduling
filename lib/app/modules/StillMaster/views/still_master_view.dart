import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/still_master_controller.dart';

class StillMasterView extends GetView<StillMasterController> {
  const StillMasterView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('StillMasterView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'StillMasterView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
