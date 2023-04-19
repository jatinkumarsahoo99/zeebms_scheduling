import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:js' as js;

class NoDataFoundPage extends StatelessWidget {
  const NoDataFoundPage({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        width: Get.width,
        height: Get.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/images/lost.png",
              height: size.width * 0.3,
              width: size.width * 0.4,
            ),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Text(
                "This is wrong route",
                style: Theme.of(context).textTheme.headline4!.copyWith(
                    color: Colors.deepPurple, fontWeight: FontWeight.bold),
              ),
            ),
            MaterialButton(
              onPressed: () {
                js.context.callMethod('fromFlutter', ['Flutter is calling upon JavaScript!']);
              },
              child: Text("GO TO HOME", style: TextStyle(color: Colors.white)),
              elevation: 10,
              color: Colors.deepPurple,
              padding: EdgeInsets.symmetric(horizontal: 35, vertical: 20),
            )
          ],
        ),
      ),
    );
  }
}
