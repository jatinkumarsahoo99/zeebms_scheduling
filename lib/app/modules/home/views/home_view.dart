import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: () {
        // try {
        double s = double.parse("shgggsggg");
        // print("Try??????" + s.toString());
        // }catch(e){
        //   print("Catch ??????"+e.toString());
        // }

      },child: Icon(Icons.cached),),
      body: SizedBox(
        width: Get.width,
        height: Get.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            /*GetBuilder<MainController>(
                id: "userName",
                builder: (control) {
                  print("Update call??????>>>>>"+(Get.find<MainController>().user?.username)!);
                  return */
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "Welcome To BMS",
                style: TextStyle(
                    fontSize: 32,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
            ),
            /*;
                })*/

            Container(
                width: Get.width / 2,
                child: Image.asset("assets/images/welcome1.png")),
            // Align(
            //   alignment: Alignment.bottomCenter,
            //   child: Container(
            //     height: 40,
            //     child: Text("Ⓒ2022 ZEEL | All Right Reserved"),
            //   ),
            // ),
            // Align(
            //   alignment: Alignment.bottomRight,
            //   child: Container(
            //     width: Get.width,
            //     color: Colors.deepPurple,
            //     height: 40,
            //     child: Padding(
            //       padding: EdgeInsets.symmetric(horizontal: 8),
            //       child: Row(
            //         mainAxisSize: MainAxisSize.max,
            //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //         children: [
            //           Text(
            //             "Ⓒ2022 ZEEL | All Right Reserved",
            //             style: TextStyle(color: Colors.white),
            //           ),
            //           Text(
            //             "Version 0.1",
            //             style: TextStyle(color: Colors.white),
            //           ),
            //           Text(
            //             "Best View In Chrome Desktop",
            //             style: TextStyle(color: Colors.white),
            //           ),
            //         ],
            //       ),
            //     ),
            //   ),
            // )

            // Card(
            //   color: Theme.of(context).primaryColor,
            //   child: Padding(
            //     padding: const EdgeInsets.all(16),
            //     child: Text(
            //       "Logged In As ${(Get.find<MainController>().user?.employeeName ?? "").trim()}, Working On POC System",
            //       style: TextStyle(
            //         color: Colors.white,
            //       ),
            //     ),
            //   ),
            // )
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        color: Colors.deepPurple[100],
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Broadcast Management System',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                      text: ' Developed & Maintained by ZEE Enterprise IT'),
                ],
              ),
            ),
            /*Expanded(
              child: Text("Broadcast Management System Developed & Maintained by ZEE Enterprise IT"),
            ),*/
            /* Expanded(
              child: Text(
                "Version - 1.0",
                textAlign: TextAlign.center,
              ),
            ),*/
            const Spacer(),
            // const Text.rich(
            //   TextSpan(
            //     children: [
            //       TextSpan(
            //         text: ' Version for AKS Programming: ',
            //         style: TextStyle(fontWeight: FontWeight.bold),
            //       ),
            //       TextSpan(text: Const.appVersion),
            //     ],
            //   ),
            // )

            /* Expanded(
              child: Text("©2022 - ZeeBMS.com. All Rights Reserved.",
                  textAlign: TextAlign.right),
            ),*/
          ],
        ),
      ),
    );
  }
}
