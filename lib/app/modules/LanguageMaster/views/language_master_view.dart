import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/language_master_controller.dart';

class LanguageMasterView extends GetView<LanguageMasterController> {
  const LanguageMasterView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LanguageMasterView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'LanguageMasterView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
