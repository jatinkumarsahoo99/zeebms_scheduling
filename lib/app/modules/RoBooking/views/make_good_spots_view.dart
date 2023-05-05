import 'package:flutter/material.dart';

import 'package:get/get.dart';

class MakeGoodSpotsView extends GetView {
  const MakeGoodSpotsView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MakeGoodSpotsView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'MakeGoodSpotsView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
