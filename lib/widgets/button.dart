import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get.dart';

import '../app/providers/SizeDefine.dart';

class Button {
  static Widget primaryElevatedButton(
      {required String hintTxt, required VoidCallback callback}) {
    // var data = 0.obs;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: SizeDefine.paddingHorizontal),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.deepPurple[100]!,
            spreadRadius: 10,
            blurRadius: 20,
          ),
        ],
      ),
      child: ElevatedButton(
        child: Container(
            width: double.infinity,
            height: 50,
            child: Center(child: Text(hintTxt))),
        onPressed: callback,
        style: ElevatedButton.styleFrom(
          primary: Colors.deepPurple,
          onPrimary: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
    );
  }

  static Widget buttonWrapper({
    required VoidCallback save,
    required VoidCallback proceed,
  }) {
    return Container();
  }

  static Widget button(
      {required String hintTxt, required VoidCallback callback}) {
    // var data = 0.obs;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: SizeDefine.paddingHorizontal),
      width: SizeDefine.widthInputField,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.deepPurple[100]!,
            spreadRadius: 10,
            blurRadius: 20,
          ),
        ],
      ),
      child: ElevatedButton(
        child: Container(
            width: double.infinity,
            height: 50,
            child: Center(child: Text(hintTxt))),
        onPressed: callback,
        style: ElevatedButton.styleFrom(
          primary: Colors.deepPurple,
          onPrimary: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      ),
    );
  }

  static Widget buttonPopup(
      {required String hintTxt,
      required VoidCallback callback,
      bool isConflict = false,
      bool isSmall = false}) {
    // var data = 0.obs;
    return ElevatedButton(
      child: Container(
          width: Get.width * 0.07,
          height: isSmall ? 18 : 40,
          child: Center(
              child: Text(
            hintTxt,
            // style: TextStyle(fontSize: isSmall ? 14 : 18),
          ))),
      onPressed: callback,
      style: ElevatedButton.styleFrom(
        primary: isConflict ? Colors.red : Colors.deepPurple,
        onPrimary: isConflict ? Colors.black : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }

  static Widget addButton(
    Function function,
  ) {
    return InkWell(
      onTap: () {
        function();
      },
      child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(19),
            color: Colors.green,
          ),
          padding: EdgeInsets.symmetric(horizontal: 13, vertical: 5),
          child: Row(
            children: [
              Text(
                "Add",
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
              SizedBox(
                width: 3,
              ),
              Icon(
                Icons.add_circle_outline,
                color: Colors.white,
                size: 18,
              )
            ],
          )),
    );
  }
}
