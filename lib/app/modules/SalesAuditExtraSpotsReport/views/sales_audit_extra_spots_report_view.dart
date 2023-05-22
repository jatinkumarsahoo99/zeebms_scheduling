import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/sales_audit_extra_spots_report_controller.dart';

class SalesAuditExtraSpotsReportView
    extends GetView<SalesAuditExtraSpotsReportController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SalesAuditExtraSpotsReportView'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'SalesAuditExtraSpotsReportView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
