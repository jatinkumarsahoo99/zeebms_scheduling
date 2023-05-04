import 'package:flutter/material.dart';

import 'package:get/get.dart';

class VerifySpotsView extends GetView {
  const VerifySpotsView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('VerifySpotsView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'VerifySpotsView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
