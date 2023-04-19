import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../app/providers/Const.dart';
import '../app/providers/SizeDefine.dart';
import 'FormButton.dart';

class LoadingDialog {
  static call() {
    Get.defaultDialog(
      title: "",
      titleStyle: TextStyle(fontSize: 1),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Please Wait"),
          SizedBox(
            width: 20,
          ),
          CircularProgressIndicator()
        ],
      ),
      radius: 10,
    );
  }

  callwithCancel() {
    //TODO timer for longer dailog
    Get.defaultDialog(
      title: "",
      titleStyle: TextStyle(fontSize: 1),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Please Wait"),
          SizedBox(
            width: 20,
          ),
          CircularProgressIndicator()
        ],
      ),
      radius: 10,
    );
  }

  static callDataSaved({Function? callback, String? msg}) {
    Get.defaultDialog(
      title: "",
      titleStyle: TextStyle(fontSize: 1),
      content: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            CupertinoIcons.check_mark_circled_solid,
            color: Colors.green,
            size: 55,
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            msg ?? Const.SAVED_MSG,
            style: TextStyle(color: Colors.green, fontSize: SizeDefine.popupTxtSize),
          )
        ],
      ),
      radius: 10,
      confirm: DailogCloseButton(
        autoFocus: true,
        callback: () {
          Get.back();
          callback!();
        },
        btnText: "Ok",
        iconDataM: Icons.done,
      ),
      /*confirm: MaterialButton(
        autofocus: true,
        onPressed: () {
          Get.back();
          callback!();
        },
        child: Text(
          "OK",
          style: TextStyle(color: Colors.black),
        ),
      ),*/
      contentPadding: EdgeInsets.only(left: SizeDefine.popupMarginHorizontal, right: SizeDefine.popupMarginHorizontal, bottom: 16),
    );
    /* Get.defaultDialog(
      title: "",
      titleStyle: const TextStyle(fontSize: 1),
      content: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            CupertinoIcons.check_mark_circled_solid,
            color: Colors.green,
            size: 55,
          ),
          const SizedBox(height: 20),
          Text(
            msg ?? Const.SAVED_MSG,
            style: TextStyle(
                color: Colors.green, fontSize: SizeDefine.popupTxtSize),
          )
        ],
      ),
      radius: 10,
      confirm: TextButton(
        onPressed: () {
          Get.back();
          callback!();
        },
        autofocus: true,
        child: const Text(
          "OK",
          style: TextStyle(color: Colors.black),
        ),
      ),
      contentPadding: EdgeInsets.only(
        left: SizeDefine.popupMarginHorizontal,
        right: SizeDefine.popupMarginHorizontal,
        bottom: 16,
      ),
    );*/
  }

  static showErrorDialog(String msg, {Function? callback}) {
    Get.defaultDialog(
      title: "",
      titleStyle: const TextStyle(fontSize: 1),
      content: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 55),
          const SizedBox(height: 10),
          Text(
            msg,
            style: TextStyle(color: Colors.black, fontSize: SizeDefine.popupTxtSize),
          )
        ],
      ),
      radius: 10,
      confirm: DailogCloseButton(
        autoFocus: true,
        callback: () {
          Get.back();
          callback!();
        },
        btnText: "OK",
      )
      /*,confirm: MaterialButton(
        onPressed: () {
          Get.back();
          callback!();
        },
        autofocus: true,
        child: const Text(
          "OK",
          style: TextStyle(color: Colors.black),
        ),
      )*/
      ,
      contentPadding: EdgeInsets.only(
        left: SizeDefine.popupMarginHorizontal,
        right: SizeDefine.popupMarginHorizontal,
        bottom: 16,
      ),
    );
  }

  static callDataSavedMessage(String value, {Function()? callback}) {
    Get.defaultDialog(
      title: "",
      titleStyle: TextStyle(fontSize: 1),
      content: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            CupertinoIcons.check_mark_circled_solid,
            color: Colors.green,
            size: 55,
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            value,
            style: TextStyle(color: Colors.green, fontSize: SizeDefine.popupTxtSize),
          )
        ],
      ),
      radius: 10,
      confirm: DailogCloseButton(
        autoFocus: true,
        callback: () {
          Get.back();
          if (callback != null) {
            callback();
          }
        },
        btnText: "OK",
      ),
      /*confirm: MaterialButton(
          autofocus: true,
          onPressed: () {
            Get.back();
          },
          child: Text(
            "OK",
            style: TextStyle(color: Colors.black),
          )),*/
      contentPadding: EdgeInsets.only(left: SizeDefine.popupMarginHorizontal, right: SizeDefine.popupMarginHorizontal, bottom: 16),
    );
  }

  static callInfoMessage(String value) {
    Get.defaultDialog(
      title: "",
      barrierDismissible: true,
      titleStyle: TextStyle(fontSize: 1),
      content: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            CupertinoIcons.info,
            color: Colors.black,
            size: 55,
          ),
          const SizedBox(height: 20),
          Text(
            value,
            style: TextStyle(color: Colors.black, fontSize: SizeDefine.popupTxtSize),
          )
        ],
      ),
      radius: 10,
      confirm: DailogCloseButton(
        autoFocus: true,
        callback: () {
          Get.back();
          // callback!();
        },
        btnText: "OK",
      ),
      /*confirm: MaterialButton(
          autofocus: true,
          onPressed: () {
            Get.back();
          },
          child: Text("OK")),*/
      contentPadding: EdgeInsets.only(left: SizeDefine.popupMarginHorizontal, right: SizeDefine.popupMarginHorizontal, bottom: 16),
    );
  }

  static callErrorMessage(String value) {
    Get.defaultDialog(
      title: "",
      titleStyle: const TextStyle(fontSize: 1),
      content: Expanded(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                CupertinoIcons.info,
                color: Colors.red,
                size: 55,
              ),
              const SizedBox(height: 20),
              Text(
                value,
                style: TextStyle(color: Colors.red, fontSize: SizeDefine.popupTxtSize),
              )
            ],
          ),
        ),
      ),
      radius: 10,
      /*confirm: MaterialButton(
          autofocus: true,
          onPressed: () {
            Get.back();
          },
          child: const Text("Ok")),*/
      confirm: DailogCloseButton(
        focusNode: FocusNode(
            canRequestFocus: true,
            onKeyEvent: ((node, event) {
              if (event.physicalKey == PhysicalKeyboardKey.enter) {
                Get.back();
              }

              if (event.physicalKey == PhysicalKeyboardKey.space) {
                Get.back();
              }
              if (event.physicalKey == PhysicalKeyboardKey.escape) {
                Get.back();
              }

              return KeyEventResult.handled;
            })),
        autoFocus: true,
        callback: () {
          Get.back();
          // callback!();
        },
        btnText: "OK",
      ),
      contentPadding: EdgeInsets.only(
        left: SizeDefine.popupMarginHorizontal,
        right: SizeDefine.popupMarginHorizontal,
        bottom: 16,
      ),
    );
  }

  static callErrorMessage1({required String msg}) {
    Get.defaultDialog(
      title: "",
      titleStyle: TextStyle(fontSize: 1),
      content: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            CupertinoIcons.info,
            color: Colors.red,
            size: 55,
          ),
          SizedBox(height: 20),
          Text(
            msg,
            style: TextStyle(color: Colors.red, fontSize: SizeDefine.labelSize),
          )
        ],
      ),
      radius: 10,
      confirm: DailogCloseButton(
        autoFocus: true,
        callback: () {
          Get.back();
          // callback!();
        },
        btnText: "OK",
      ),
      /*confirm: TextButton(
          onPressed: () {
            Get.back();
          },
          child: Text("Ok")),*/
      contentPadding: EdgeInsets.only(left: SizeDefine.popupMarginHorizontal, right: SizeDefine.popupMarginHorizontal, bottom: 16),
    );
  }

  static delete(String title, Function? confirm, {String? deleteTitle, String? deleteCancel, Function? cancel}) {
    Get.defaultDialog(
      title: "",
      titleStyle: TextStyle(fontSize: 1),
      content: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            CupertinoIcons.info,
            color: Colors.red,
            size: 55,
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            title,
            style: TextStyle(color: Colors.red, fontSize: SizeDefine.popupTxtSize),
            textAlign: TextAlign.center,
          )
        ],
      ),
      radius: 10,
      confirm: DailogCloseButton(
        autoFocus: false,
        callback: () {
          Get.back();
          if (cancel != null) {
            cancel();
          }
          // confirm!();
        },
        btnText: deleteCancel ?? "No",
      ),
      /*confirm: MaterialButton(
          onPressed: () {
            Get.back();
            confirm!();
          },
          child: Text(deleteTitle ?? "Delete")),*/
      /* cancel: MaterialButton(
          onPressed: () {
            Get.back();
          },
          child: Text(deleteCancel ?? "Cancel")), */
      cancel: DailogCloseButton(
        autoFocus: true,
        callback: () {
          Get.back();
          confirm!();
        },
        btnText: deleteTitle ?? "Yes",
      ),
      contentPadding: EdgeInsets.only(left: SizeDefine.popupMarginHorizontal, right: SizeDefine.popupMarginHorizontal, bottom: 16),
    );
  }

  static recordExists(String title, Function? confirm, {String? deleteTitle, String? deleteCancel}) {
    Get.defaultDialog(
      title: "",
      titleStyle: TextStyle(fontSize: 1),
      content: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            CupertinoIcons.question_circle_fill,
            color: Colors.blueAccent,
            size: 55,
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            title,
            style: TextStyle(color: Colors.blueAccent, fontSize: SizeDefine.popupTxtSize),
            textAlign: TextAlign.center,
          )
        ],
      ),
      radius: 10,
      /*confirm: MaterialButton(
          onPressed: () {
            Get.back();
            confirm!();
          },
          child: Text(deleteTitle ?? "Yes")),*/
      confirm: DailogCloseButton(
          autoFocus: false,
          callback: () {
            Get.back();
          },
          btnText: deleteCancel ?? "No"),
      cancel: DailogCloseButton(
          autoFocus: true,
          callback: () {
            Get.back();
            confirm!();
          },
          btnText: deleteTitle ?? "Yes"),
      /*cancel: MaterialButton(
          onPressed: () {
            Get.back();
          },
          autofocus: true,
          child: Text(deleteCancel ?? "No")),*/
      contentPadding: EdgeInsets.only(left: SizeDefine.popupMarginHorizontal, right: SizeDefine.popupMarginHorizontal, bottom: 16),
    );
  }

  static modify(String title, Function? confirm, Function? cancel, {String? deleteTitle, String? cancelTitle}) {
    Get.defaultDialog(
      title: "",
      titleStyle: TextStyle(fontSize: 1),
      content: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            CupertinoIcons.check_mark_circled_solid,
            color: Colors.green,
            size: 55,
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            title,
            style: TextStyle(color: Colors.green, fontSize: SizeDefine.popupTxtSize),
            textAlign: TextAlign.center,
          )
        ],
      ),
      radius: 10,
      /*confirm: MaterialButton(
          onPressed: () {
            Get.back();
            confirm!();
          },
          child: Text(deleteTitle ?? "Delete")),*/
      confirm: DailogCloseButton(
          autoFocus: false,
          callback: () {
            Get.back();
            cancel!();
          },
          btnText: cancelTitle ?? "Cancel"),
      /*cancel: MaterialButton(
          onPressed: () {
            Get.back();
            cancel!();
          },
          child: Text(cancelTitle ?? "Cancel")),*/
      cancel: DailogCloseButton(
          autoFocus: true,
          callback: () {
            Get.back();
            confirm!();
          },
          btnText: deleteTitle ?? "Delete"),
      contentPadding: EdgeInsets.only(left: SizeDefine.popupMarginHorizontal, right: SizeDefine.popupMarginHorizontal, bottom: 16),
    );
  }

  static callDataDeleted([String? msg]) {
    Get.defaultDialog(
      title: "",
      titleStyle: TextStyle(fontSize: 1),
      content: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            CupertinoIcons.check_mark_circled_solid,
            color: Colors.green,
            size: 55,
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            msg ?? "Data Deleted Successfully",
            style: TextStyle(color: Colors.green, fontSize: SizeDefine.popupTxtSize),
          )
        ],
      ),
      radius: 10,
      /*confirm: TextButton(
          onPressed: () {
            Get.back();
          },
          child: Text("Ok")),*/
      confirm: DailogCloseButton(
          autoFocus: true,
          callback: () {
            Get.back();
            // cancel!();
          },
          btnText: "OK"),
      contentPadding: EdgeInsets.only(left: SizeDefine.popupMarginHorizontal, right: SizeDefine.popupMarginHorizontal, bottom: 16),
    );
  }

  static callExitForm(fun) {
    Get.defaultDialog(
      title: "",
      titleStyle: TextStyle(fontSize: 1),
      content: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            CupertinoIcons.question,
            color: Colors.yellow[900],
            size: 55,
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            "Are you sure you want to exit this form?",
            style: TextStyle(color: Colors.green, fontSize: SizeDefine.popupTxtSize),
          ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
      radius: 10,
      confirm: FormButton(
          callback: () {
            Get.back();
          },
          btnText: "No"),
      cancel: FormButton(
          callback: () {
            Get.back();
            fun();
          },
          btnText: "Yes"),
      contentPadding: EdgeInsets.only(left: SizeDefine.popupMarginHorizontal, right: SizeDefine.popupMarginHorizontal, bottom: 16),
    );
  }
}
