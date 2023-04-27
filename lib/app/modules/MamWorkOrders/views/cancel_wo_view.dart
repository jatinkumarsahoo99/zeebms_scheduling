import 'package:flutter/material.dart';

import 'package:get/get.dart';

class CancelWoView extends GetView {
  const CancelWoView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CancelWoView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'CancelWoView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
