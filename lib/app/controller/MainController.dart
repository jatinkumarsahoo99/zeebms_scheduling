import 'dart:convert';
import 'dart:developer';
import 'dart:html' as html;
// import 'package:html/parser.dart' as html1;

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../widgets/Snack.dart';
import '../data/EnvironmentModel.dart';
import '../data/PermissionModel.dart';
import '../data/rowfilter.dart';
import '../data/user.dart';
import '../providers/Aes.dart';
import '../providers/ApiFactory.dart';
import '../providers/SharedPref.dart';
import '../providers/Utils.dart';
import 'ConnectorControl.dart';

class MainController extends GetxController {
  // RxBool isLoggedIn=false.obs;
  RxnBool isLoggedIn = RxnBool(null);

  // var filters = RxList<RowFilter>([]);
  Map<String, RxList<RowFilter>> filters1 = {};

  // RxInt loginVal = RxInt(0);
  RxInt loginVal = RxInt(0);

  // RxnBool isLoggedIn1= RxnBool(null);
  User? user;
  SharedPref? sharedPref;
  List<PermissionModel>? permissionList = [];
  String formName = "";
  RxBool handShakingDone = RxBool(false);
  EnvironmentModel? environmentModel;

  @override
  void onInit() {
    sharedPref = SharedPref();
    // Utils.callJSToExit(param: "HandShaking");
    super.onInit();
    html.window.onMessage.listen((event) {
      // print("Point>>>"+event.toString());
      print(event.data.toString());
      if (event.origin == ApiFactory.NOTIFY_URL) {
        if (event.data.toString().contains("HandShakeDone")) {
          handShakingDone.value = true;
          print("Handshake Done");
        } else {
          print("Not in error code 2");
        }
      } else {
        print("Not in error code 1");
      }
    });
    print("My Data>>>>"+jsonEncode(environmentModel?.toJson()));
  }


  updateNewToken() {}

  checkServerParams(Function fun) {
    print("checkServerParams() called>>>");
    if (Get.parameters.containsKey("personalNo") &&
        Get.parameters.containsKey("loginCode")) {
      print("Params data are>>>" + jsonEncode(Get.parameters));
      User user1 = User();
      user1.personnelNo = Get.parameters["personalNo"] ?? "";
      // user?.token = Aes.decrypt(Get.parameters["accessToken"]!);
      user1.token = "";
      user1.logincode = Get.parameters["loginCode"];
      user = user1;

      /////TOKEN GENERATE FOR ACCESS APIS => FROM : MS SERVER
      Get.find<ConnectorControl>().POST_CALL_MS_TOKEN(
          employeId: Aes.encrypt(user?.personnelNo ?? "")!,
          fun: (Map<String, dynamic> map) {
            if (map.containsKey("responseprofile") &&
                map["responseprofile"]["access_token"] != null) {
              user?.token = map["responseprofile"]["access_token"];
              log("Here token is ????" + (user?.token ?? ""));

              ////////////////USER ACCESS PERMISSION => FROM : BMS SERVER
              Get.find<ConnectorControl>().GETMETHODCALL(
                  api: ApiFactory.PERMISSION_API + (user?.logincode ?? ""),
                  fun: (List list) {
                    if (list != null && list.isNotEmpty) {
                      sharedPref?.save("PERMISSION_API", list);
                      sharedPref?.save("user", user);
                      sharedPref?.saveBool("isLogin", true);
                      isLoggedIn.value = true;
                      loginVal.value = 1;
                      permissionList!.clear();
                      list.forEach((element) {
                        permissionList?.add(PermissionModel.fromJson(element));
                      });
                      fun(true);
                    } else {
                      loginVal.value = 2;
                      /* Snack.callError(
                          "Sorry we could not proceed forward. Due to not available of Permission Data");*/
                      fun(false);
                    }
                  },
                  failed: (val) {
                    loginVal.value = 2;
                    // Snack.callError("Sorry we could not proceed forward. Due to not available of Permission Data");
                    fun(false);
                  });
              ////////////////USER ACCESS PERMISSION : END
            } else {
              loginVal.value = 2;
              // Snack.callError("Sorry we could not proceed your request forward due to not available of your userID");
              fun(false);
            }
          },
          failed: (val) {
            loginVal.value = 2;
            // Snack.callError("Sorry we could not proceed your request forward due to not available of your userID");
            fun(false);
          });
    }
  }

  checkSessionFromParams() {
    // print("html.window.top?." + (html.window.top.toString() ?? ""));
    // print("html.window.document?." + (html.window.document.toString() ?? ""));
    // print("html.window.location.href?." + (html.window.location.href.toString() ?? ""));
    // print("html.window.top?.location?????" + (html.window.top?.location.toString() ?? ""));
    if (kDebugMode ||
        (html.window.top !=
            html.window
                .self /*&& html.window.top?.location.toString().contains("app-common-bms-dev.zeeconnect.in") ?? false*/)) {
      print("checkServerParams() called>>>");
      if (Get.parameters.containsKey("personalNo") &&
          Get.parameters.containsKey("loginCode")) {
        print("Params data are>>>" + jsonEncode(Get.parameters));
        User user1 = User();
        user1.personnelNo = Uri.decodeComponent(
            Aes.decrypt(Get.parameters["personalNo"] ?? "") ?? "");
        user1.token = "";
        user1.logincode = Uri.decodeComponent(
            Aes.decrypt(Get.parameters["loginCode"] ?? "") ?? "");
        user = user1;
        formName = Uri.decodeComponent(
            Aes.decrypt(Get.parameters["formName"] ?? "") ?? "");
        print("After extract Form name is>>>>" + formName);

        print("After convert data is>>>" + (user1.personnelNo ?? ""));

        /////TOKEN GENERATE FOR ACCESS APIS => FROM : MS SERVER
        Get.find<ConnectorControl>().POST_CALL_MS_TOKEN(
            employeId: Aes.encrypt(user?.personnelNo ?? "")!,
            fun: (Map<String, dynamic> map) {
              if (map.containsKey("responseprofile") &&
                  map["responseprofile"]["access_token"] != null) {
                user?.token = map["responseprofile"]["access_token"];
                log("Here token is ????" + (user?.token ?? ""));

                ////////////////USER ACCESS PERMISSION => FROM : BMS SERVER
                Get.find<ConnectorControl>().GETMETHODCALL(
                    api: ApiFactory.PERMISSION_API + (user?.logincode ?? ""),
                    fun: (List list) {
                      if (list != null && list.isNotEmpty) {
                        list.forEach((element) {
                          permissionList
                              ?.add(PermissionModel.fromJson(element));
                        });
                        sharedPref?.save("PERMISSION_API", list);
                        sharedPref?.save("user", user);
                        sharedPref?.saveBool("isLogin", true);
                        isLoggedIn.value = true;
                        loginVal.value = 1;
                        // fun(true);
                      } else {
                        loginVal.value = 2;
                        /* Snack.callError(
                          "Sorry we could not proceed forward. Due to not available of Permission Data");*/
                        // fun(false);
                      }
                    },
                    failed: (val) {
                      loginVal.value = 2;
                      // Snack.callError("Sorry we could not proceed forward. Due to not available of Permission Data");
                      // fun(false);
                    });
                ////////////////USER ACCESS PERMISSION : END
              } else {
                loginVal.value = 2;
                // Snack.callError("Sorry we could not proceed your request forward due to not available of your userID");
                // fun(false);
              }
            },
            failed: (val) {
              loginVal.value = 2;
              // Snack.callError("Sorry we could not proceed your request forward due to not available of your userID");
              // fun(false);
            });
      }
    } else {
      loginVal.value = 2;
    }
  }

  updateValue(data) {
    log("Update My Data>>>>");
    // update(['mainController']);
    isLoggedIn.value = data;
  }
}
