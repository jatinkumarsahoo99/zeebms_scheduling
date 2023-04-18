import 'dart:convert';
import 'dart:developer';
import 'dart:html' as html;
// import 'package:html/parser.dart' as html1;

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../widgets/Snack.dart';
import '../data/PermissionModel.dart';
import '../data/rowfilter.dart';
import '../data/user.dart';
import '../providers/Aes.dart';
import '../providers/ApiFactory.dart';
import '../providers/SharedPref.dart';
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

  @override
  void onInit() {
    sharedPref = SharedPref();
    // checkSession();
    // checkSessionFromParams();
    super.onInit();
  }

  checkSession2() async {
    dynamic fetchData = await sharedPref?.getKey("user");
    if (fetchData != null) {
      loginVal.value = 1;
    } else {
      if (html.window.location.href.contains("code")) {
        print("Location is>>>" + html.window.location.href);
        List<String> list = html.window.location.href.split("?");
        Map<String, dynamic> _result = Uri.splitQueryString(list[1]);
        print("\n\n\nThe log is>>>" + jsonEncode(_result));

        //////////////////////////////////////////////////////////////
        /*   // LoadingDialog.call();
        /////TOKEN FOR ACCESS MS USER => FROM : MS SERVER
        Get.find<ConnectorControl>().GETMETHOD_USER_TOKEN(
            code: _result["code"],
            fun: (Map<String, dynamic> map) {
              if (map.containsKey("access_token")) {
                print("Token?>>>>>>" + jsonEncode(map));
                TokenData tokenData = TokenData.fromJson(map);
                User user1 = User();
                user1.tokenData = tokenData;
                user1.refreshToken = tokenData.refreshToken;
                user1.token = tokenData.accessToken;

                /////USER DETAILS FROM MS AD => FROM : MS SERVER
                Get.find<ConnectorControl>().GETMETHODCALL_TOKEN(
                  api: ApiFactory.MS_GRAPH_USER_DETAILS,
                  token: tokenData.accessToken!,
                  fun: (Map<String, dynamic> map) {
                    if (map.containsKey("employeeId")) {
                      print("User Info>>>>>>" + jsonEncode(map));
                      user1.employeeName = map["displayName"];
                      user1.personnelNo = map["mobilePhone"];
                      user1.loginName = map["givenName"];
                      user1.employeeId = map["employeeId"];
                      user1.jobTitle = map["jobTitle"];
                      user1.msId = map["id"];
                      user = user1;*/
        //////////////////////////////////////////////////////////////

        Get.find<ConnectorControl>().POSTMETHOD_WITHOUT_TOKEN(
            api: ApiFactory.MS_PROFILE,
            json: {
              "code": _result["code"].toString(),
              "redirectUrl": ApiFactory.AZURE_REDIRECT_UI,
            },
            fun: (Map<String, dynamic> map) {
              if (map.containsKey("responseprofile")) {
                User user1 = User();
                user1.personnelNo = map["responseprofile"]["employeeId"] ?? "";
                user1.employeeId = map["responseprofile"]["employeeId"] ?? "";

                user1.mailId = map["responseprofile"]["mail"] ?? '';
                user1.username = map["responseprofile"]["givenName"] ?? '';
                user1.jobTitle = map["responseprofile"]["jobTitle"] ?? '';
                user = user1;

                /////TOKEN GENERATE FOR ACCESS APIS => FROM : MS SERVER
                Get.find<ConnectorControl>().POST_CALL_MS_TOKEN(
                    employeId: Aes.encrypt(user?.personnelNo ?? "")!,
                    fun: (Map<String, dynamic> map) {
                      if (map.containsKey("responseprofile") &&
                          map["responseprofile"]["access_token"] != null) {
                        user?.token = map["responseprofile"]["access_token"];
                        log("Here token is ????" + (user?.token ?? ""));

                        /////USER DETAILS API => FROM : BMS SERVER
                        Get.find<ConnectorControl>().GETMETHODCALL(
                            api: ApiFactory.USER_INFO,
                            fun: (Map<String, dynamic> map) {
                              if (map.containsKey("logincode")) {
                                user?.logincode = map["logincode"];

                                ////////////////USER ACCESS PERMISSION => FROM : BMS SERVER
                                Get.find<ConnectorControl>().GETMETHODCALL(
                                    api: ApiFactory.PERMISSION_API +
                                        (user?.logincode ?? ""),
                                    fun: (List list) {
                                      if (list != null && list.isNotEmpty) {
                                        sharedPref?.save(
                                            "PERMISSION_API", list);
                                        sharedPref?.save("user", user);
                                        sharedPref?.saveBool("isLogin", true);
                                        isLoggedIn.value = true;
                                        loginVal.value = 1;
                                        Get.offAllNamed("/dashboard");
                                      } else {
                                        loginVal.value = 2;
                                        Snack.callError(
                                            "Sorry we could not proceed forward. Due to not available of Permission Data");
                                      }
                                    },
                                    failed: (val) {
                                      loginVal.value = 2;
                                      Snack.callError(
                                          "Sorry we could not proceed forward. Due to not available of Permission Data");
                                    });
                                ////////////////USER ACCESS PERMISSION : END
                              } else {
                                loginVal.value = 2;
                                Snack.callError(
                                    "Sorry we could not proceed forward. Due to not available of user details");
                              }
                            },
                            failed: (val) {
                              loginVal.value = 2;
                              Snack.callError(
                                  "Sorry we could not proceed forward. Due to not available of user details");
                            });
                        /////USER DETAILS API : END
                      } else {
                        loginVal.value = 2;
                        Snack.callError(
                            "Sorry we could not proceed your request forward due to not available of your userID");
                      }
                    },
                    failed: (val) {
                      loginVal.value = 2;
                      Snack.callError(
                          "Sorry we could not proceed your request forward due to not available of your userID");
                    });
              } else {
                loginVal.value = 2;
                Snack.callError(
                    "Sorry we could not proceed forward due to not available valid auth code");
              }
            });

//////////////////////////////////////////////////////////////
        /*} else {
                      // Get.back();
                      loginVal.value = 2;
                      Snack.callError(
                          "Sorry we could not proceed forward due to not available of AD User Details");
                    }
                  },
                );
              } else {
                // Get.back();
                loginVal.value = 2;
                Snack.callError("Sorry we could not proceed forward due to not available of MS token");
              }
            },

            failed: (val) {
              // Get.back();
              loginVal.value = 2;
              Snack.callError("Sorry we could not proceed forward due to not available valid auth code");
            });*/
        //////////////////////////////////////////////////////////////
      } else {
        isLoggedIn.value = false;
        print("checkSession2() method call");
        loginVal.value = 2;
      }
    }
  }

  updateNewToken() {}

  checkSession() async {
    print("Check Session Initiated");
    SharedPreferences preferences = await SharedPreferences.getInstance();
    bool isLoginMain = await preferences.getBool('isLogin') ?? false;
    dynamic fetchData = await sharedPref?.getKey("user");
    dynamic fetchPermission = await sharedPref?.getKey("PERMISSION_API");
    if (fetchData != null) {
      dynamic value = jsonDecode(fetchData);
      print("Value from SharedPref" + jsonEncode(value));
      user = User.fromJson(value);
      print("Value from UserModel>>" + jsonEncode(user?.toJson()));
      print("html.window.location.href" + html.window.location.href);
      isLoggedIn.value = isLoginMain;
      loginVal.value = 1;
    }
    if (fetchPermission != null) {
      List value = jsonDecode(fetchPermission);
      permissionList!.clear();
      value.forEach((element) {
        permissionList?.add(PermissionModel.fromJson(element));
      });
    }

    if (Get.parameters.containsKey("personalNo")) {
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
                    } else {
                      loginVal.value = 2;
                      Snack.callError(
                          "Sorry we could not proceed forward. Due to not available of Permission Data");
                    }
                  },
                  failed: (val) {
                    loginVal.value = 2;
                    Snack.callError(
                        "Sorry we could not proceed forward. Due to not available of Permission Data");
                  });
              ////////////////USER ACCESS PERMISSION : END
            } else {
              loginVal.value = 2;
              Snack.callError(
                  "Sorry we could not proceed your request forward due to not available of your userID");
            }
          },
          failed: (val) {
            loginVal.value = 2;
            Snack.callError(
                "Sorry we could not proceed your request forward due to not available of your userID");
          });
    }
  }

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
