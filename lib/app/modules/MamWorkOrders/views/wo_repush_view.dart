import 'package:flutter/material.dart';

import 'package:get/get.dart';

class WoRepushView extends GetView {
  const WoRepushView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WoRepushView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'WoRepushView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
