import 'LoadingDialog.dart';

class Snack {
  static call(title) {
    LoadingDialog.callInfoMessage(title);
    // return Get.snackbar(title, "",
    //     maxWidth: Get.width * 0.3,
    //     duration: Duration(seconds: 7),
    //     snackPosition: SnackPosition.TOP,
    //     backgroundColor: Colors.deepPurple,
    //     titleText: Padding(
    //       padding: const EdgeInsets.only(top: 4),
    //       child: Text(
    //         title,
    //         style: const TextStyle(
    //             fontWeight: FontWeight.w400, color: Colors.white),
    //       ),
    //     ),
    //     messageText: const Text(
    //       "",
    //       style: TextStyle(fontSize: 1, color: Colors.white),
    //     ),
    //     mainButton: TextButton(
    //         onPressed: () {
    //           Get.back();
    //         },
    //         child: const Text(
    //           "Ok",
    //           style: TextStyle(color: Colors.white),
    //         )),
    //     padding: const EdgeInsets.only(left: 20, top: 15, bottom: 10),
    //     margin: const EdgeInsets.only(top: 10));
    // return Get.showSnackbar(GetSnackBar(title: title,));
  }

  static callError(title, {double? widthRatio, Function? callback}) {
    LoadingDialog.showErrorDialog(title, callback: callback);
    // Get.defaultDialog(
    //   title: "",
    //   titleStyle: TextStyle(fontSize: 1),
    //   content: Column(
    //     mainAxisAlignment: MainAxisAlignment.center,
    //     children: [
    //       Icon(
    //         CupertinoIcons.info,
    //         color: Colors.red,
    //         size: 55,
    //       ),
    //       SizedBox(height: 20),
    //       Text(
    //         title,
    //         style: TextStyle(color: Colors.red, fontSize: SizeDefine.labelSize),
    //       )
    //     ],
    //   ),
    //   radius: 10,
    //   confirm: TextButton(
    //       onPressed: () {
    //         Get.back();
    //       },
    //       child: Text("Ok")),
    //   contentPadding: EdgeInsets.only(
    //       left: SizeDefine.popupMarginHorizontal,
    //       right: SizeDefine.popupMarginHorizontal,
    //       bottom: 16),
    // );
    // return Get.snackbar(title, "",
    //     maxWidth: Get.width * (widthRatio??0.3),
    //     animationDuration: Duration(milliseconds: 600),
    //     snackPosition: SnackPosition.TOP,
    //     backgroundColor: Colors.red,
    //     duration: Duration(seconds: 9),
    //     titleText: Padding(
    //       padding: const EdgeInsets.only(top: 4),
    //       child: Text(
    //         title,
    //         style: const TextStyle(
    //             fontWeight: FontWeight.w400, color: Colors.white),
    //       ),
    //     ),
    //     messageText: const Text(
    //       "",
    //       style: TextStyle(fontSize: 1, color: Colors.white),
    //     ),
    //     mainButton: TextButton(
    //         onPressed: () {
    //           Get.back();
    //         },
    //         child: const Text(
    //           "Ok",
    //           style: TextStyle(color: Colors.white),
    //         )),
    //     padding: const EdgeInsets.only(left: 20, top: 15, bottom: 10),
    //     margin: const EdgeInsets.only(top: 10));
    // return Get.showSnackbar(GetSnackBar(title: title,));
  }

  static callSuccess(title, {Function()? callback}) {
    LoadingDialog.callDataSaved(callback: callback, msg: title);
    // return Get.snackbar(title, "",
    //     maxWidth: Get.width * 0.3,
    //     snackPosition: SnackPosition.TOP,
    //     backgroundColor: Colors.green[400],
    //     titleText: Padding(
    //       padding: const EdgeInsets.only(top: 4),
    //       child: Text(
    //         title,
    //         style: const TextStyle(
    //             fontWeight: FontWeight.w400, color: Colors.white),
    //       ),
    //     ),
    //     duration: Duration(seconds: 7),
    //     messageText: const Text(
    //       "",
    //       style: TextStyle(fontSize: 1, color: Colors.white),
    //     ),
    //     mainButton: TextButton(
    //         onPressed: () {
    //           Get.back();
    //           callback;
    //         },
    //         child: const Text(
    //           "Ok",
    //           style: TextStyle(color: Colors.white),
    //         )),
    //     padding: const EdgeInsets.only(left: 20, top: 15, bottom: 10),
    //     margin: const EdgeInsets.only(top: 10));
    // return Get.showSnackbar(GetSnackBar(title: title,));
  }
}
/*class Snack {
  static call(title) {
    Get.defaultDialog(
      title: "",
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
            title,
            style: TextStyle(
                color: Colors.black, fontSize: SizeDefine.popupTxtSize),
          )
        ],
      ),
      radius: 10,
      confirm: MaterialButton(
          autofocus: true,
          onPressed: () {
            Get.back();
          },
          child: Text("OK")),
      contentPadding: EdgeInsets.only(
          left: SizeDefine.popupMarginHorizontal,
          right: SizeDefine.popupMarginHorizontal,
          bottom: 16),
    );
    // return Get.showSnackbar(GetSnackBar(title: title,));
  }

  static callError(title, {double? widthRatio}) {
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
            title,
            style: TextStyle(color: Colors.red, fontSize: SizeDefine.labelSize),
          )
        ],
      ),
      radius: 10,
      confirm: TextButton(
          onPressed: () {
            Get.back();
          },
          child: Text("OK")),
      contentPadding: EdgeInsets.only(
          left: SizeDefine.popupMarginHorizontal,
          right: SizeDefine.popupMarginHorizontal,
          bottom: 16),
    );
    // return Get.snackbar(title, "",
    //     maxWidth: Get.width * (widthRatio??0.3),
    //     animationDuration: Duration(milliseconds: 600),
    //     snackPosition: SnackPosition.TOP,
    //     backgroundColor: Colors.red,
    //     duration: Duration(seconds: 9),
    //     titleText: Padding(
    //       padding: const EdgeInsets.only(top: 4),
    //       child: Text(
    //         title,
    //         style: const TextStyle(
    //             fontWeight: FontWeight.w400, color: Colors.white),
    //       ),
    //     ),
    //     messageText: const Text(
    //       "",
    //       style: TextStyle(fontSize: 1, color: Colors.white),
    //     ),
    //     mainButton: TextButton(
    //         onPressed: () {
    //           Get.back();
    //         },
    //         child: const Text(
    //           "Ok",
    //           style: TextStyle(color: Colors.white),
    //         )),
    //     padding: const EdgeInsets.only(left: 20, top: 15, bottom: 10),
    //     margin: const EdgeInsets.only(top: 10));
    // return Get.showSnackbar(GetSnackBar(title: title,));
  }

  static callSuccess(title, {Function()? callback}) {
    return Get.snackbar(title, "",
        maxWidth: Get.width * 0.3,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green[400],
        titleText: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            title,
            style: const TextStyle(
                fontWeight: FontWeight.w400, color: Colors.white),
          ),
        ),
        duration: Duration(seconds: 7),
        messageText: const Text(
          "",
          style: TextStyle(fontSize: 1, color: Colors.white),
        ),
        mainButton: TextButton(
            onPressed: () {
              Get.back();
              callback;
            },
            child: const Text(
              "OK",
              style: TextStyle(color: Colors.white),
            )),
        padding: const EdgeInsets.only(left: 20, top: 15, bottom: 10),
        margin: const EdgeInsets.only(top: 10));
    // return Get.showSnackbar(GetSnackBar(title: title,));
  }
}*/
