// import 'package:bms/providers/aad/model/config.dart';
import 'package:bms_scheduling/app/controller/MainController.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../data/system_envirtoment.dart';
import 'ApiFactory.dart';

class Const {
  static const String STATUS = "status";
  static const String SUCCESS = "success";
  static const String FAILED = "failure";
  static const String MESSAGE = "message";
  static const String NETWORK_ISSUE = "Network issue";
  static const String SAVED_MSG = "Record Saved Successfully";
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  static String instrumentationKey = getInstrumentKey();
  static const appVersion = '1.0.4';
  static const exportRowsInLocal = 2000;

  static const List<String> firstColumnBlankFormNames = ["frmsearchingKKBMS_View_DroppedSpots"];


  static List<SystemEnviroment> systemEnviroments = [
    SystemEnviroment(value: "Data Migration", url: ""),
    SystemEnviroment(value: "Development", url: ""),
    SystemEnviroment(value: "Testing", url: "https://testing.zee.com"),
    SystemEnviroment(value: "Live", url: "https://live.zee.com"),
    SystemEnviroment(value: "POC", url: "https://poc.zee.com"),
  ];
  static List<SystemEnviroment> contentType = [
    SystemEnviroment(value: "5.1 unmix", url: ""),
    SystemEnviroment(value: "Mix", url: ""),
    SystemEnviroment(value: "Movies", url: ""),
    SystemEnviroment(value: "Seamless", url: ""),
    SystemEnviroment(value: "UnMix", url: ""),
    SystemEnviroment(value: "WEBI-Mix", url: ""),
    SystemEnviroment(value: "WEBI-Unmix", url: ""),
  ];

  static Map<int, String> errorCode = {
    400: "400 - Bad Request",
    403: "403 - Forbidden Access",
    413: "413 - Unable to process large request",
    500: "500 - Something went wrong. Please try again later",
    502: "502 - The request is not completed. Please try again later",
    504: "504 - The request is timed out. Please try again later"
  };


  static const double SIXTY_MIN = 0.9;
  static double THIRTY_MIN = 1;
  static double FIFTEEN_MIN = 2;
  static double TEN_MIN = 3;
  static double FIVE_MIN = 5;
  static double ONE_MIN = 7;



/*
  static String getInstrumentKey() {
    switch (ApiFactory.Enviroment.toLowerCase()) {
      case "prod":
        return "5029c09c-acd8-44e1-83cf-9a34094599a2";
      case "uat":
        return "b15b7ae4-ff42-4746-862c-d0c852787f55";
      case "dev":
        return "e06f192c-13bb-4c3c-8a01-ece4a1a80059";
      default:
        return "e06f192c-13bb-4c3c-8a01-ece4a1a80059";
    }
  }

  static String getBaseLoginAPIUrl() {
    switch (ApiFactory.Enviroment.toLowerCase()) {
      case "prod":
        return "https://api-login-bms.zeeconnect.in";
      case "uat":
        return "https://api-login-bms-uat.zeeconnect.in";
      case "dev":
        return "https://api-login-bms-dev.zeeconnect.in";
      default:
        return "https://api-login-bms-dev.zeeconnect.in";
    }
  }

  static String getBaseCommonAPIUrl() {
    switch (ApiFactory.Enviroment.toLowerCase()) {
      case "prod":
        return "https://api-common-bms.zeeconnect.in";
      case "uat":
        return "https://api-common-bms-uat.zeeconnect.in";
      case "dev":
        return "https://api-common-bms-dev.zeeconnect.in";
      default:
        return "https://api-common-bms-dev.zeeconnect.in";
    }
  }

  static String getBaseProgrammingAPIUrl() {
    switch (ApiFactory.Enviroment.toLowerCase()) {
      case "prod":
        return "https://api-programming-bms.zeeconnect.in";
      case "uat":
        return "https://api-programming-bms-uat.zeeconnect.in";
      case "dev":
        return "https://api-programming-bms-dev.zeeconnect.in";
      default:
        return "";
    }
  }

  static String getBaseAdminAPIUrl() {
    switch (ApiFactory.Enviroment.toLowerCase()) {
      case "prod":
        return "https://api-admin-bms.zeeconnect.in";
      case "uat":
        return "https://api-admin-bms-uat.zeeconnect.in";
      case "dev":
        return "https://api-admin-bms-dev.zeeconnect.in";
      default:
        return "https://api-admin-bms-dev.zeeconnect.in";
    }
  }

  static String getBaseSchedulingAPIUrl() {
    switch (ApiFactory.Enviroment.toLowerCase()) {
      case "prod":
        return "https://api-scheduling-bms.zeeconnect.in";
      case "uat":
        return "https://api-scheduling-bms-uat.zeeconnect.in";
      case "dev":
        return "https://api-scheduling-bms-dev.zeeconnect.in";
      default:
        return "https://api-scheduling-bms-dev.zeeconnect.in";
    }
  }

  static String getWebLoginUrl() {
    switch (ApiFactory.Enviroment.toLowerCase()) {
      case "prod":
        return "https://bms.zeeconnect.in";
      case "uat":
        return "https://app-login-bms-uat.zeeconnect.in";
      case "dev":
        return "https://app-login-bms-dev.zeeconnect.in";
      default:
        return "https://app-login-bms-dev.zeeconnect.in";
    }
  }

  static String getWebCommonUrl() {
    switch (ApiFactory.Enviroment.toLowerCase()) {
      case "prod":
        return "https://home-bms.zeeconnect.in";
      case "uat":
        return "https://app-common-bms-uat.zeeconnect.in";
      case "dev":
        return "https://app-common-bms-dev.zeeconnect.in";
      default:
        return "https://app-common-bms-dev.zeeconnect.in";
    }
  }

  static String getWebProgrammingUrl() {
    switch (ApiFactory.Enviroment.toLowerCase()) {
      case "prod":
        return "https://programming-bms.zeeconnect.in";
      case "uat":
        return "https://app-programming-bms-uat.zeeconnect.in";
      case "dev":
        return "https://app-programming-bms-dev.zeeconnect.in";
      default:
        return "https://app-programming-bms-dev.zeeconnect.in";
    }
  }

  static String getWebAdminUrl() {
    switch (ApiFactory.Enviroment.toLowerCase()) {
      case "prod":
        return "https://admin-bms.zeeconnect.in";
      case "uat":
        return "https://app-admin-bms-uat.zeeconnect.in";
      case "dev":
        return "https://app-admin-bms-dev.zeeconnect.in";
      default:
        return "https://app-admin-bms-dev.zeeconnect.in";
    }
  }
  static String getWebSchedulingUrl() {
    switch (ApiFactory.Enviroment.toLowerCase()) {
      case "prod":
        return "https://scheduling-bms.zeeconnect.in";
      case "uat":
        return "https://app-scheduling-bms-uat.zeeconnect.in";
      case "dev":
        return "https://app-scheduling-bms-dev.zeeconnect.in";
      default:
        return "https://app-scheduling-bms-dev.zeeconnect.in";
    }
  }*/

  static String getInstrumentKey() {
    if(!kDebugMode){
      return Get.find<MainController>().environmentModel?.appInsrtumentationKey??"";
    }
    switch (ApiFactory.Enviroment.toLowerCase()) {
      case "prod":
        return "5029c09c-acd8-44e1-83cf-9a34094599a2";
      case "uat":
        return "b15b7ae4-ff42-4746-862c-d0c852787f55";
      case "dev":
        return "e06f192c-13bb-4c3c-8a01-ece4a1a80059";
      default:
        return "e06f192c-13bb-4c3c-8a01-ece4a1a80059";
    }
  }


  static String getBaseLoginAPIUrl() {
    if(!kDebugMode){
      return Get.find<MainController>().environmentModel?.apiLoginUrl??"";
    }
    switch (ApiFactory.Enviroment.toLowerCase()) {
      case "prod":
        return "https://api-login-bms.zeeconnect.in";
      case "uat":
        return "https://api-login-bms-uat.zeeconnect.in";
      case "dev":
        return "https://api-login-bms-dev.zeeconnect.in";
      default:
        return "https://api-login-bms-dev.zeeconnect.in";
    }
  }

  static String getBaseCommonAPIUrl() {
    if(!kDebugMode){
      return Get.find<MainController>().environmentModel?.apiCommonUrl??"";
    }
    switch (ApiFactory.Enviroment.toLowerCase()) {
      case "prod":
        return "https://api-common-bms.zeeconnect.in";
      case "uat":
        return "https://api-common-bms-uat.zeeconnect.in";
      case "dev":
        return "https://api-common-bms-dev.zeeconnect.in";
      default:
        return "https://api-common-bms-dev.zeeconnect.in";
    }
  }

  static String getBaseProgrammingAPIUrl() {
    if(!kDebugMode){
      return Get.find<MainController>().environmentModel?.apiProgrammingUrl??"";
    }
    switch (ApiFactory.Enviroment.toLowerCase()) {
      case "prod":
        return "https://api-programming-bms.zeeconnect.in";
      case "uat":
        return "https://api-programming-bms-uat.zeeconnect.in";
      case "dev":
        return "https://api-programming-bms-dev.zeeconnect.in";
      default:
        return "";
    }
  }

  static String getBaseAdminAPIUrl() {
    if(!kDebugMode){
      return Get.find<MainController>().environmentModel?.apiAdminUrl??"";
    }
    switch (ApiFactory.Enviroment.toLowerCase()) {
      case "prod":
        return "https://api-admin-bms.zeeconnect.in";
      case "uat":
        return "https://api-admin-bms-uat.zeeconnect.in";
      case "dev":
        return "https://api-admin-bms-dev.zeeconnect.in";
      default:
        return "https://api-admin-bms-dev.zeeconnect.in";
    }
  }

  static String getBaseSchedulingAPIUrl() {
    if(!kDebugMode){
      return Get.find<MainController>().environmentModel?.apiSchedulingUrl??"";
    }
    switch (ApiFactory.Enviroment.toLowerCase()) {
      case "prod":
        return "https://api-scheduling-bms.zeeconnect.in";
      case "uat":
        return "https://api-scheduling-bms-uat.zeeconnect.in";
      case "dev":
        return "https://api-scheduling-bms-dev.zeeconnect.in";
      default:
        return "https://api-scheduling-bms-dev.zeeconnect.in";
    }
  }

  static String getWebLoginUrl() {
    if(!kDebugMode){
      return Get.find<MainController>().environmentModel?.appLoginUrl??"";
    }
    switch (ApiFactory.Enviroment.toLowerCase()) {
      case "prod":
        return "https://bms.zeeconnect.in";
      case "uat":
        return "https://app-login-bms-uat.zeeconnect.in";
      case "dev":
        return "https://app-login-bms-dev.zeeconnect.in";
      default:
        return "https://app-login-bms-dev.zeeconnect.in";
    }
  }

  static String getWebCommonUrl() {
    if(!kDebugMode){
      return Get.find<MainController>().environmentModel?.appCommonUrl??"";
    }
    switch (ApiFactory.Enviroment.toLowerCase()) {
      case "prod":
        return "https://home-bms.zeeconnect.in";
      case "uat":
        return "https://app-common-bms-uat.zeeconnect.in";
      case "dev":
        return "https://app-common-bms-dev.zeeconnect.in";
      default:
        return "https://app-common-bms-dev.zeeconnect.in";
    }
  }

  static String getWebProgrammingUrl() {
    if(!kDebugMode){
      return Get.find<MainController>().environmentModel?.appProgrammingUrl??"";
    }
    switch (ApiFactory.Enviroment.toLowerCase()) {
      case "prod":
        return "https://programming-bms.zeeconnect.in";
      case "uat":
        return "https://app-programming-bms-uat.zeeconnect.in";
      case "dev":
        return "https://app-programming-bms-dev.zeeconnect.in";
      default:
        return "https://app-programming-bms-dev.zeeconnect.in";
    }
  }

  static String getWebAdminUrl() {
    if(!kDebugMode){
      return Get.find<MainController>().environmentModel?.appAdminUrl??"";
    }
    switch (ApiFactory.Enviroment.toLowerCase()) {
      case "prod":
        return "https://admin-bms.zeeconnect.in";
      case "uat":
        return "https://app-admin-bms-uat.zeeconnect.in";
      case "dev":
        return "https://app-admin-bms-dev.zeeconnect.in";
      default:
        return "https://app-admin-bms-dev.zeeconnect.in";
    }
  }
  static String getWebSchedulingUrl() {
    if(!kDebugMode){
      return Get.find<MainController>().environmentModel?.appSchedulingUrl??"";
    }
    switch (ApiFactory.Enviroment.toLowerCase()) {
      case "prod":
        return "https://scheduling-bms.zeeconnect.in";
      case "uat":
        return "https://app-scheduling-bms-uat.zeeconnect.in";
      case "dev":
        return "https://app-scheduling-bms-dev.zeeconnect.in";
      default:
        return "https://app-scheduling-bms-dev.zeeconnect.in";
    }
  }
}
