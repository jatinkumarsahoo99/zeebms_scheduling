import 'package:flutter/material.dart';

import 'package:get/get.dart';

class BookingSummaryView extends GetView {
  const BookingSummaryView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BookingSummaryView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'BookingSummaryView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
