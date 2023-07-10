import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/EuropeDropSpotsController.dart';

class EuropeDropSpotsView extends GetView<EuropeDropSpotsController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('EuropeDropSpotsView'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'EuropeDropSpotsView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
