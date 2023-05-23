import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/promo_master_controller.dart';

class PromoMasterView extends GetView<PromoMasterController> {
  const PromoMasterView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PromoMasterView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'PromoMasterView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
