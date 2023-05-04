import 'package:flutter/material.dart';

import 'package:get/get.dart';

class SpotNotVerifiedView extends GetView {
  const SpotNotVerifiedView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SpotNotVerifiedView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'SpotNotVerifiedView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
