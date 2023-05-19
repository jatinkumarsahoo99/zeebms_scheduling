import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/slide_master_controller.dart';

class SlideMasterView extends GetView<SlideMasterController> {
  const SlideMasterView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SlideMasterView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'SlideMasterView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
