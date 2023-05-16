import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/sales_audit_new_controller.dart';

class SalesAuditNewView extends GetView<SalesAuditNewController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SalesAuditNewView'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'SalesAuditNewView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
