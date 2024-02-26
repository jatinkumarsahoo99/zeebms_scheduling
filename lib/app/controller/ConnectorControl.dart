import 'dart:convert';
import 'dart:developer';

// import 'package:bms_programming/app/controller/HomeController.dart';
import 'package:dio/dio.dart';
import 'package:dio/dio.dart' as service;
import 'package:get/get.dart';

import '../../widgets/LoadingDialog.dart';
import '../../widgets/Snack.dart';
import '../providers/Aes.dart';
import '../providers/ApiFactory.dart';
import '../providers/Const.dart';
import 'MainController.dart';

class ConnectorControl extends GetConnect {
  late Dio dio;
  String? accessToken = "";

  @override
  void onInit() {
    dio = Dio();
    super.onInit();
  }

  Map<String, dynamic> failedMap = {
    Const.STATUS: Const.FAILED,
    Const.MESSAGE: Const.NETWORK_ISSUE,
  };
  Map<String, dynamic> alreadyMap = {
    Const.STATUS: Const.FAILED,
    Const.MESSAGE: "Already Available",
  };

  updateToken(Function fun) {
    /////TOKEN GENERATE FOR ACCESS APIS => FROM : MS SERVER
    Get.find<ConnectorControl>().POST_CALL_MS_TOKEN(
      employeId:
          Aes.encrypt(Get.find<MainController>().user?.personnelNo ?? "")!,
      fun: (Map<String, dynamic> map) {
        if (map.containsKey("responseprofile") &&
            map["responseprofile"]["access_token"] != null) {
          Get.find<MainController>().user?.token =
              map["responseprofile"]["access_token"];
          Get.find<MainController>()
              .sharedPref
              ?.save("user", Get.find<MainController>().user);
          fun();
        } else {
          // Snack.callError("Unable to acquire access token. Please login again");
          LoadingDialog.showErrorDialog(
              "Unable to acquire access token. Please login again");
        }
      },
      failed: (val) {
        // loginVal.value = 2;
        // Snack.callError("Unable to generate token");
        if (val != null && val.containsKey("responseprofile")) {
          if (val["responseprofile"].containsKey("message")) {
            LoadingDialog.showErrorDialog(
                (val["responseprofile"]["message"]) ??
                    "Some error occurred. Please contact BMS system administrator",
                callback: () {
              // Get.find<HomeController>().logout();
            });
          } else {
            LoadingDialog.showErrorDialog(
                "Some error occurred. Please contact BMS system administrator",
                callback: () {
              // Get.find<HomeController>().logout();
            });
          }
        } else {
          LoadingDialog.showErrorDialog(
              "Some error occurred. Please contact BMS system administrator",
              callback: () {
            // Get.find<HomeController>().logout();
          });
        }
      },
    );
  }

  GETMETHODCALL(
      {required String api,
      required Function fun,
      Function? failed,
      ResponseType? responseType}) async {
    print("<<>>>>>API CALL>>>>>>\n\n\n\n\n\n\n\n\n" + api);
    try {
      service.Response response = await dio.get(api,
          options: Options(
            responseType: responseType,
            headers: {
              "Access-Control-Allow-Origin": "*",
              "Authorization": "Bearer " +
                  ((Get.find<MainController>().user != null)
                      ? Get.find<MainController>().user?.token ?? ""
                      : ""),
              "PersonnelNo": ((Get.find<MainController>().user != null)
                  ? Aes.encrypt(
                      Get.find<MainController>().user?.personnelNo ?? "")
                  : ""),
              "Userid": ((Get.find<MainController>().user != null)
                  ? Aes.encrypt(
                      Get.find<MainController>().user?.logincode ?? "")
                  : "")
            },
          ));
      if (response.statusCode == 200) {
        try {
          fun(response.data);
        } catch (e) {
          print("Message is: " + e.toString());
        }
      } else if (response.statusCode == 500) {
        // print("MI II>>" + response.data);
        if (failed != null) {
          failed(response.data);
        }
      } else if (response.statusCode == 401) {
        print("MI II>>" + response.data);
        if (failed != null) {
          failed(failedMap);
        }
      }
    } on DioError catch (e) {
      if (e.response?.statusCode == 401) {
        updateToken(() {
          GETMETHODCALL(api: api, fun: fun, failed: failed);
        });
      } else if ([400, 403].contains(e.response?.statusCode)) {
        if (Get.isDialogOpen ?? false) {
          Get.back();
        }
        if (e.response?.data is Map && e.response?.data.containsKey("status")) {
          LoadingDialog.showErrorDialog(e.response?.data["status"]);
        }
      } else {
        if (Get.isDialogOpen ?? false) {
          Get.back();
        }
        if (Const.errorCode.containsKey(e.response?.statusCode)) {
          LoadingDialog.showErrorDialog(
              Const.errorCode[e.response?.statusCode] ?? "");
        } else {
          LoadingDialog.showErrorDialog(
              "${e.response?.statusCode.toString()} - Something went wrong please contact support team");
        }

        switch (e.type) {
          case DioErrorType.connectionTimeout:
          case DioErrorType.cancel:
          case DioErrorType.sendTimeout:
          case DioErrorType.receiveTimeout:
          case DioErrorType.unknown:
            failed!(failedMap);
            // Snack.callError("Unauthorised");
            break;
          case DioErrorType.badResponse:
            failed!(e.response?.data ?? "");
        }
      }
    }
  }

  POST_CALL_MS_TOKEN(
      {required Function fun,
      required Function failed,
      required String employeId}) async {
    try {
      /* Map<String, dynamic> map = {
        "grant_type": "client_credentials",
        "client_id": Const.CLIENT_ID,
        "client_secret": Const.CLIENT_SECRET,
        "resource": Const.API_RESOURCE,
      };*/
      Map<String, dynamic> map = {"code": employeId};
      service.Response response = await dio.post(
        ApiFactory.MS_TOKEN_BACKEND,
        data: map,
      );
      if (response.statusCode == 200) {
        try {
          fun(response.data);
          // log("Connector Response" + jsonEncode(response.data));
        } catch (e) {
          print("Message is: " + e.toString());
        }
      } else {
        failed(failedMap);
      }
    } on DioError catch (e) {
      if ([400, 403].contains(e.response?.statusCode)) {
        if (Get.isDialogOpen ?? false) {
          Get.back();
        }
        if (e.response?.data is Map && e.response?.data.containsKey("status")) {
          LoadingDialog.showErrorDialog(e.response?.data["status"]);
        }
      } else {
        if (Get.isDialogOpen ?? false) {
          Get.back();
        }
        if (Const.errorCode.containsKey(e.response?.statusCode)) {
          LoadingDialog.showErrorDialog(
              Const.errorCode[e.response?.statusCode] ?? "");
        } else {
          LoadingDialog.showErrorDialog(
              "${e.response?.statusCode.toString()} - Something went wrong please contact support team");
        }
        switch (e.type) {
          case DioErrorType.connectionTimeout:
          case DioErrorType.cancel:
          case DioErrorType.sendTimeout:
          case DioErrorType.receiveTimeout:
          case DioErrorType.unknown:
            failed(failedMap);
            break;
          case DioErrorType.badResponse:
            failed(e.response?.data);
        }
      }
    }
  }

  GETMETHODCALL_TOKEN(
      {required String api,
      required String token,
      required Function fun,
      required Function failed}) async {
    print("<<>>>>>API CALL>>>>>>\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n" + api);
    try {
      service.Response response = await dio.get(
        api,
        options: Options(headers: {
          "Authorization": "Bearer " + ((token != null) ? token : ""),
          "PersonnelNo": ((Get.find<MainController>().user != null)
              ? Aes.encrypt(Get.find<MainController>().user?.personnelNo ?? "")
              : ""),
          "Userid": ((Get.find<MainController>().user != null)
              ? Aes.encrypt(Get.find<MainController>().user?.logincode ?? "")
              : "")
        }),
      );
      if (response.statusCode == 200) {
        try {
          fun(response.data);
        } catch (e) {
          print("Message is: " + e.toString());
        }
      } else {
        fun(failedMap);
      }
    } on DioError catch (e) {
      if (e.response?.statusCode == 401) {
        updateToken(() {
          GETMETHODCALL(api: api, fun: fun, failed: failed);
        });
      } else if ([400, 403].contains(e.response?.statusCode)) {
        if (Get.isDialogOpen ?? false) {
          Get.back();
        }
        if (e.response?.data is Map && e.response?.data.containsKey("status")) {
          LoadingDialog.showErrorDialog(e.response?.data["status"]);
        }
      } else {
        if (Get.isDialogOpen ?? false) {
          Get.back();
        }
        if (Const.errorCode.containsKey(e.response?.statusCode)) {
          LoadingDialog.showErrorDialog(
              Const.errorCode[e.response?.statusCode] ?? "");
        } else {
          LoadingDialog.showErrorDialog(
              "${e.response?.statusCode.toString()} - Something went wrong please contact support team");
        }
        switch (e.type) {
          case DioErrorType.connectionTimeout:
          case DioErrorType.cancel:
          case DioErrorType.sendTimeout:
          case DioErrorType.receiveTimeout:
          case DioErrorType.unknown:
            fun(failedMap);
            break;
          case DioErrorType.badResponse:
            fun(e.response?.data);
        }
      }
    }
  }

  POSTMETHOD(
      {required String api,
      dynamic? json,
      required Function fun,
      Function? failed}) async {
    try {
      print("API NAME:>" + api);
      service.Response response = await dio.post(
        api,
        options: Options(headers: {
          "Authorization": "Bearer " +
              ((Get.find<MainController>().user != null)
                  ? Get.find<MainController>().user?.token ?? ""
                  : ""),
          "PersonnelNo": ((Get.find<MainController>().user != null)
              ? Aes.encrypt(Get.find<MainController>().user?.personnelNo ?? "")
              : ""),
          "Userid": ((Get.find<MainController>().user != null)
              ? Aes.encrypt(Get.find<MainController>().user?.logincode ?? "")
              : "")
        }, responseType: ResponseType.json),
        data: (json != null) ? jsonEncode(json) : null,
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        try {
          fun(response.data);
        } catch (e) {
          print("Message is: " + e.toString());
        }
      } else if (response.statusCode == 417) {
        fun(response.data);
      } else {
        print("Message is: >>1");
        fun(failedMap);
      }
    } on DioError catch (e) {
      if (e.response?.statusCode == 401) {
        updateToken(() {
          GETMETHODCALL(api: api, fun: fun, failed: failed);
        });
      } else if ([400, 403].contains(e.response?.statusCode)) {
        if (Get.isDialogOpen ?? false) {
          Get.back();
        }
        if (e.response?.data is Map && e.response?.data.containsKey("status")) {
          LoadingDialog.showErrorDialog(e.response?.data["status"]);
        }
      } else {
        if (Get.isDialogOpen ?? false) {
          Get.back();
        }
        if (Const.errorCode.containsKey(e.response?.statusCode)) {
          LoadingDialog.showErrorDialog(
              Const.errorCode[e.response?.statusCode] ?? "");
        } else {
          LoadingDialog.showErrorDialog(
              "${e.response?.statusCode.toString()} - Something went wrong please contact support team");
        }
        switch (e.type) {
          case DioErrorType.connectionTimeout:
          case DioErrorType.cancel:
          case DioErrorType.sendTimeout:
          case DioErrorType.receiveTimeout:
          case DioErrorType.unknown:
            fun(failedMap);
            break;
          case DioErrorType.badResponse:
            fun(e.response?.data);
        }
      }
    }
  }

  GET_METHOD_WITH_PARAM(
      {required String api,
      Map<String, dynamic>? json,
      required Function fun,
      Function? failed}) async {
    try {
      print("API NAME:>" + api);
      service.Response response = await dio.get(api,
          options: Options(headers: {
            "Access-Control-Allow-Origin": "*",
            "Authorization": "Bearer " +
                ((Get.find<MainController>().user != null)
                    ? Get.find<MainController>().user?.token ?? ""
                    : ""),
            "PersonnelNo": ((Get.find<MainController>().user != null)
                ? Aes.encrypt(
                    Get.find<MainController>().user?.personnelNo ?? "")
                : ""),
            "Userid": ((Get.find<MainController>().user != null)
                ? Aes.encrypt(Get.find<MainController>().user?.logincode ?? "")
                : "")
          }, responseType: ResponseType.json),
          // data: (json != null) ? jsonEncode(json) : null,
          queryParameters: (json != null) ? json : null);
      if (response.statusCode == 200 || response.statusCode == 201) {
        try {
          fun(response.data);
        } catch (e) {
          print("Message is: " + e.toString());
        }
      } else if (response.statusCode == 417) {
        fun(response.data);
      } else {
        print("Message is: >>1");
        fun(failedMap);
      }
    } on DioError catch (e) {
      if (e.response?.statusCode == 401) {
        updateToken(() {
          GETMETHODCALL(api: api, fun: fun, failed: failed);
        });
      } else if ([400, 403].contains(e.response?.statusCode)) {
        if (Get.isDialogOpen ?? false) {
          Get.back();
        }
        if (e.response?.data is Map && e.response?.data.containsKey("status")) {
          LoadingDialog.showErrorDialog(e.response?.data["status"]);
        }
      } else {
        if (Get.isDialogOpen ?? false) {
          Get.back();
        }
        if (Const.errorCode.containsKey(e.response?.statusCode)) {
          LoadingDialog.showErrorDialog(
              Const.errorCode[e.response?.statusCode] ?? "");
        } else {
          LoadingDialog.showErrorDialog(
              "${e.response?.statusCode.toString()} - Something went wrong please contact support team");
        }
        switch (e.type) {
          case DioErrorType.connectionTimeout:
          case DioErrorType.cancel:
          case DioErrorType.sendTimeout:
          case DioErrorType.receiveTimeout:
          case DioErrorType.unknown:
            fun(failedMap);
            break;
          case DioErrorType.badResponse:
            fun(e.response?.data);
        }
      }
    }
  }

  DELETEMETHOD(
      {required String api,
      dynamic json,
      required Function fun,
      Function? failed}) async {
    try {
      print("API NAME:>" + api);
      service.Response response = await dio.delete(
        api,
        options: Options(headers: {
          "Authorization":
              "Bearer ${(Get.find<MainController>().user != null) ? Get.find<MainController>().user?.token ?? "" : ""}",
          "PersonnelNo": ((Get.find<MainController>().user != null)
              ? Aes.encrypt(Get.find<MainController>().user?.personnelNo ?? "")
              : ""),
          "Userid": ((Get.find<MainController>().user != null)
              ? Aes.encrypt(Get.find<MainController>().user?.logincode ?? "")
              : ""),
          "FormName": ((Get.find<MainController>().formName != null)
              ? Get.find<MainController>().formName ?? ""
              : "")
        }, responseType: ResponseType.json),
        data: (json != null) ? jsonEncode(json) : null,
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        try {
          fun(response.data);
        } catch (e) {
          print("Message is: " + e.toString());
        }
      } else if (response.statusCode == 417) {
        fun(response.data);
      } else {
        print("Message is: >>1");
        fun(failedMap);
      }
    } on DioError catch (e) {
      if (e.response?.statusCode == 401) {
        updateToken(() {
          GETMETHODCALL(api: api, fun: fun, failed: failed);
        });
      } else if ([400, 403].contains(e.response?.statusCode)) {
        if (Get.isDialogOpen ?? false) {
          Get.back();
        }
        if (e.response?.data is Map && e.response?.data.containsKey("status")) {
          LoadingDialog.showErrorDialog(e.response?.data["status"]);
        }
      } else {
        if (Get.isDialogOpen ?? false) {
          Get.back();
        }
        if (Const.errorCode.containsKey(e.response?.statusCode)) {
          LoadingDialog.showErrorDialog(
              Const.errorCode[e.response?.statusCode] ?? "");
        } else {
          LoadingDialog.showErrorDialog(
              "${e.response?.statusCode.toString()} - Something went wrong please contact support team");
        }
        switch (e.type) {
          case DioErrorType.connectionTimeout:
          case DioErrorType.cancel:
          case DioErrorType.sendTimeout:
          case DioErrorType.receiveTimeout:
          case DioErrorType.unknown:
            fun(failedMap);
            break;
          case DioErrorType.badResponse:
            fun(e.response?.data);
        }
      }
    }
  }

  POSTMETHOD_FORMDATA(
      {required String api,
      required dynamic json,
      int? timeout = 36000,
      required Function fun}) async {
    try {
      service.Response response = await dio.post(api,
          data: json,
          options: Options(
              receiveTimeout: Duration(milliseconds: timeout!),
              sendTimeout: Duration(milliseconds: timeout!),
              headers: {
                // "accept-language": (AppData.selectedLanguage=="English")?"en":"ar",
                'Content-Type': 'application/json',
                "Authorization": "Bearer " +
                    ((Get.find<MainController>().user != null)
                        ? Get.find<MainController>().user?.token ?? ""
                        : ""),

                "PersonnelNo": ((Get.find<MainController>().user != null)
                    ? Aes.encrypt(
                        Get.find<MainController>().user?.personnelNo ?? "")
                    : ""),
                "Userid": ((Get.find<MainController>().user != null)
                    ? Aes.encrypt(
                        Get.find<MainController>().user?.logincode ?? "")
                    : "")
              },
              responseType: ResponseType.json));
      if (response.statusCode == 200 || response.statusCode == 201) {
        try {
          // print("RESPONSE CALL>>>>" + JsonEncoder().convert(response.data).toString());
          fun(response.data);
        } catch (e) {
          print("Message is: " + e.toString());
        }
      } else if (response.statusCode == 417) {
        fun(response.data);
      } else {
        print("Message is: >>1");
        fun(failedMap);
      }
    } on DioError catch (e) {
      if (e.response?.statusCode == 401) {
        updateToken(() {
          POSTMETHOD_FORMDATA(api: api, json: json, fun: fun, timeout: timeout);
        });
      } else if ([400, 403].contains(e.response?.statusCode)) {
        if (Get.isDialogOpen ?? false) {
          Get.back();
        }
        if (e.response?.data is Map && e.response?.data.containsKey("status")) {
          LoadingDialog.showErrorDialog(e.response?.data["status"]);
        }
      } else {
        if (Get.isDialogOpen ?? false) {
          Get.back();
        }
        if (Const.errorCode.containsKey(e.response?.statusCode)) {
          LoadingDialog.showErrorDialog(
              Const.errorCode[e.response?.statusCode] ?? "");
        } else {
          LoadingDialog.showErrorDialog(
              "${e.response?.statusCode.toString()} - Something went wrong please contact support team");
        }

        switch (e.type) {
          case DioErrorType.connectionTimeout:
          case DioErrorType.cancel:
          case DioErrorType.sendTimeout:
          case DioErrorType.receiveTimeout:
          case DioErrorType.unknown:
            fun(failedMap);
            break;
          case DioErrorType.badResponse:
            fun(e.response?.data);
        }
      }
    }
  }

  POSTMETHOD_FORMDATAWITHTYPE(
      {required String api,
      required dynamic json,
      int? timeout = 36000,
      required Function fun,
      Function? failed}) async {
    try {
      service.Response response = await dio.post(api,
          data: json,
          options: Options(
              receiveTimeout: Duration(milliseconds: timeout!),
              sendTimeout: Duration(milliseconds: timeout!),
              headers: {
                // "accept-language": (AppData.selectedLanguage=="English")?"en":"ar",
                'Content-Type': 'application/json',
                "Authorization": "Bearer " +
                    ((Get.find<MainController>().user != null)
                        ? Get.find<MainController>().user?.token ?? ""
                        : ""),

                "PersonnelNo": ((Get.find<MainController>().user != null)
                    ? Aes.encrypt(
                        Get.find<MainController>().user?.personnelNo ?? "")
                    : ""),
                "Userid": ((Get.find<MainController>().user != null)
                    ? Get.find<MainController>().user?.logincode ?? ""
                    : "")
              },
              responseType: ResponseType.json));
      if (response.statusCode == 200 || response.statusCode == 201) {
        try {
          // print("RESPONSE CALL>>>>" + JsonEncoder().convert(response.data).toString());
          fun(response.data);
        } catch (e) {
          if (failed != null) {
            failed();
          }
          print("Message is: " + e.toString());
        }
      } else if (response.statusCode == 417) {
        fun(response.data);
      } else {
        print("Message is: >>1");
        fun(failedMap);
      }
    } on DioError catch (e) {
      if (failed != null) {
        failed();
      }
      if (e.response?.statusCode == 401) {
        updateToken(() {
          POSTMETHOD_FORMDATA(api: api, json: json, fun: fun, timeout: timeout);
        });
      } else if ([400, 403].contains(e.response?.statusCode)) {
        if (Get.isDialogOpen ?? false) {
          Get.back();
        }
        if (e.response?.data is Map && e.response?.data.containsKey("status")) {
          LoadingDialog.showErrorDialog(e.response?.data["status"]);
        }
      } else {
        if (Get.isDialogOpen ?? false) {
          Get.back();
        }
        if (Const.errorCode.containsKey(e.response?.statusCode)) {
          LoadingDialog.showErrorDialog(
              Const.errorCode[e.response?.statusCode] ?? "");
        } else {
          LoadingDialog.showErrorDialog(
              "${e.response?.statusCode.toString()} - Something went wrong please contact support team");
        }
        switch (e.type) {
          case DioErrorType.connectionTimeout:
          case DioErrorType.cancel:
          case DioErrorType.sendTimeout:
          case DioErrorType.receiveTimeout:
          case DioErrorType.unknown:
            fun(failedMap);
            break;
          case DioErrorType.badResponse:
            fun(e.response?.data);
        }
      }
    }
  }

  POSTMETHOD_FORMDATA_HEADER(
      {required String api,
      required dynamic json,
      int? timeout = 36000,
      required Function fun}) async {
    try {
      service.Response response = await dio.post(api,
          data: json,
          options: Options(
              receiveTimeout: Duration(milliseconds: timeout!),
              sendTimeout: Duration(milliseconds: timeout),
              headers: {
                // "accept-language": (AppData.selectedLanguage=="English")?"en":"ar",
                'Content-Type': 'application/json',
                "Authorization": "Bearer " +
                    ((Get.find<MainController>().user != null)
                        ? Get.find<MainController>().user?.token ?? ""
                        : ""),

                "PersonnelNo": ((Get.find<MainController>().user != null)
                    ? Aes.encrypt(
                        Get.find<MainController>().user?.personnelNo ?? "")
                    : ""),
                "Userid": ((Get.find<MainController>().user != null)
                    ? Aes.encrypt(
                        Get.find<MainController>().user?.logincode ?? "")
                    : ""),
                "FormName": ((Get.find<MainController>().formName != null)
                    ? Get.find<MainController>().formName ?? ""
                    : "")
              },
              responseType: ResponseType.json));
      if (response.statusCode == 200 || response.statusCode == 201) {
        try {
          // print("RESPONSE CALL>>>>" + JsonEncoder().convert(response.data).toString());
          fun(response.data);
        } catch (e) {
          print("Message is: " + e.toString());
        }
      } else if (response.statusCode == 417) {
        fun(response.data);
      } else if (response.statusCode == 504) {
        fun("Server timeout. Please try again later");
      } else {
        print("Message is: >>1");
        fun(failedMap);
      }
    } on DioError catch (e) {
      if (e.response?.statusCode == 401) {
        updateToken(() {
          POSTMETHOD_FORMDATA(api: api, json: json, fun: fun, timeout: timeout);
        });
      } else if ([400, 403].contains(e.response?.statusCode)) {
        if (Get.isDialogOpen ?? false) {
          Get.back();
        }
        if (e.response?.data is Map && e.response?.data.containsKey("status")) {
          LoadingDialog.showErrorDialog(e.response?.data["status"]);
        }
      } else {
        if (Get.isDialogOpen ?? false) {
          Get.back();
        }
        if (Const.errorCode.containsKey(e.response?.statusCode)) {
          LoadingDialog.showErrorDialog(
              Const.errorCode[e.response?.statusCode] ?? "");
        } else {
          LoadingDialog.showErrorDialog(
              "${e.response?.statusCode.toString()} - Something went wrong please contact support team");
        }
        switch (e.type) {
          case DioErrorType.connectionTimeout:
          case DioErrorType.cancel:
          case DioErrorType.sendTimeout:
          case DioErrorType.receiveTimeout:
          case DioErrorType.unknown:
          case DioErrorType.connectionError:
            fun("Server timeout. Please try again later");
            break;
          case DioErrorType.badResponse:
            fun(e.response?.data);
            break;
          default:
            fun("Server timeout. Please try again later");
            break;
        }
      }
    }
  }

  GET_METHOD_CALL_HEADER(
      {required String api,
      // required String formName,
      required Function fun,
      Function? failed,
      ResponseType? responseType}) async {
    print("<<>>>>>API CALL>>>>>>\n\n\n\n\n\n\n\n\n" + api);
    try {
      service.Response response = await dio.get(api,
          options: Options(
            responseType: responseType,
            headers: {
              "Access-Control-Allow-Origin": "*",
              "Authorization": "Bearer " +
                  ((Get.find<MainController>().user != null)
                      ? Get.find<MainController>().user?.token ?? ""
                      : ""),
              "PersonnelNo": ((Get.find<MainController>().user != null)
                  ? Aes.encrypt(
                      Get.find<MainController>().user?.personnelNo ?? "")
                  : ""),
              "Userid": ((Get.find<MainController>().user != null)
                  ? Aes.encrypt(
                      Get.find<MainController>().user?.logincode ?? "")
                  : ""),
              "FormName": ((Get.find<MainController>().formName != null)
                  ? Get.find<MainController>().formName ?? ""
                  : "")
            },
          ));
      if (response.statusCode == 200) {
        try {
          fun(response.data);
        } catch (e) {
          print("Message is: " + e.toString());
        }
      } else if (response.statusCode == 500) {
        print("MI II>>" + response.data);
        if (failed != null) {
          failed(response.data);
        }
      } else if (response.statusCode == 401) {
        print("MI II>>" + response.data);
        if (failed != null) {
          failed(failedMap);
        }
      }
    } on DioError catch (e) {
      if (e.response?.statusCode == 401) {
        updateToken(() {
          GETMETHODCALL(api: api, fun: fun, failed: failed);
        });
      } else if ([400, 403].contains(e.response?.statusCode)) {
        if (Get.isDialogOpen ?? false) {
          Get.back();
        }
        if (e.response?.data is Map && e.response?.data.containsKey("status")) {
          LoadingDialog.showErrorDialog(e.response?.data["status"]);
        }
      } else {
        if (Get.isDialogOpen ?? false) {
          Get.back();
        }
        if (Const.errorCode.containsKey(e.response?.statusCode)) {
          LoadingDialog.showErrorDialog(
              Const.errorCode[e.response?.statusCode] ?? "");
        } else {
          LoadingDialog.showErrorDialog(
              "${e.response?.statusCode.toString()} - Something went wrong please contact support team");
        }

        switch (e.type) {
          case DioErrorType.connectionTimeout:
          case DioErrorType.cancel:
          case DioErrorType.sendTimeout:
          case DioErrorType.receiveTimeout:
          case DioErrorType.unknown:
            failed!(failedMap);
            // Snack.callError("Unauthorised");
            break;
          case DioErrorType.badResponse:
            failed!(e.response?.data ?? "");
        }
      }
    }
  }
}
