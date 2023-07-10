import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/creative_tag_on_controller.dart';

class CreativeTagOnView extends GetView<CreativeTagOnController> {
   CreativeTagOnView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(
        child: Text(
          'CreativeTagOnView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
