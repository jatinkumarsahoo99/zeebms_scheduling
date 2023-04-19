// import 'package:bms/providers/aad/model/config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

import '../data/system_envirtoment.dart';

class Const {
  static const String STATUS = "status";
  static const String SUCCESS = "success";
  static const String FAILED = "failure";
  static const String MESSAGE = "message";
  static const String NETWORK_ISSUE = "Network issue";
  static const String SAVED_MSG = "Record Saved Successfully";
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  static const instrumentationKey = 'b15b7ae4-ff42-4746-862c-d0c852787f55';
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
}
