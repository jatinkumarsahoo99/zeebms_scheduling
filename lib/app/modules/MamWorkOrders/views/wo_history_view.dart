import 'package:flutter/material.dart';

import 'package:get/get.dart';

class WoHistoryView extends GetView {
  const WoHistoryView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WoHistoryView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'WoHistoryView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
