import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WarningBox extends StatelessWidget {
  final text;
  const WarningBox({Key? key, required String this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: Get.width * 0.3,
        height: 150,
        padding: const EdgeInsets.all(0),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Container(
              //   margin: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
              //   padding: EdgeInsets.all(8),
              //   child: Icon(
              //     Icons.warning,
              //     color: Colors.white,
              //     size: 24,
              //   ),
              //   decoration: BoxDecoration(
              //     color: Colors.deepPurple,
              //     shape: BoxShape.circle,
              //     // borderRadius: BorderRadius.circular(100),
              //   ),
              // ),
              // SizedBox(
              //   height: 10,
              // ),
              // Text(
              //   text,
              //   style: const TextStyle(fontWeight: FontWeight.bold),
              //   textAlign: TextAlign.center,
              // ),
            ],
          ),
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          // border: Border.all(style: BorderStyle.solid)
        ),
      ),
    );
  }
}
