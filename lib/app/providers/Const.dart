// import 'package:bms/providers/aad/model/config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

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

  static const double SIXTY_MIN = 0.9;
  static double THIRTY_MIN = 1;
  static double FIFTEEN_MIN = 2;
  static double TEN_MIN = 3;
  static double FIVE_MIN = 5;
  static double ONE_MIN = 7;




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

  static String getClientId() {
    switch (ApiFactory.Enviroment.toLowerCase()) {
      case "prod":
        return "8303749b-8c0f-457e-a24a-09749a37f738";
      case "uat":
        return "2ca12c97-56b5-46ab-a600-da6019f94439";
      case "dev":
        return "2ca12c97-56b5-46ab-a600-da6019f94439";
      default:
        return "2ca12c97-56b5-46ab-a600-da6019f94439";
    }
  }

  static String getBaseLoginAPIUrl() {
    switch (ApiFactory.Enviroment.toLowerCase()) {
      case "prod":
        return "https://api-login.bms.zeeconnect.in";
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
        return "https://api-common.bms.zeeconnect.in";
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
        return "https://api-programming.bms.zeeconnect.in";
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
        return "https://api-admin.bms.zeeconnect.in";
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
        return "https://api-scheduling.bms.zeeconnect.in";
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
        return "https://home.bms.zeeconnect.in";
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
        return "https://programming.zeeconnect.in";
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
        return "https://admin.zeeconnect.in";
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
        return "https://scheduling.zeeconnect.in";
      case "uat":
        return "https://app-scheduling-bms-uat.zeeconnect.in";
      case "dev":
        return "https://app-scheduling-bms-dev.zeeconnect.in";
      default:
        return "https://app-scheduling-bms-dev.zeeconnect.in";
    }
  }
}
