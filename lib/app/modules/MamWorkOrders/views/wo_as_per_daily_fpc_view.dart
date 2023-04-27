import 'package:flutter/material.dart';

import 'package:get/get.dart';

class WoAsPerDailyFpcView extends GetView {
  const WoAsPerDailyFpcView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WoAsPerDailyFpcView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'WoAsPerDailyFpcView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
