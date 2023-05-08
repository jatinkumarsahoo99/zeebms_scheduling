import 'dart:ui';
import 'package:azure_application_insights/azure_application_insights.dart';
import 'package:bms_scheduling/app/providers/Aes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_strategy/url_strategy.dart';
import 'app/providers/BinderData.dart';
import 'app/providers/Logger.dart';
import 'app/providers/theme.dart';
import 'app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    // Logger.sendError(error: details,stackTrace: details.stack,severity: Severity.critical);
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    // Logger.sendError(error: error,severity: Severity.warning,stackTrace: stack);
    return true;
  };
  setPathUrlStrategy();
  print("Aes dec>>>"+(Aes.decrypt("kW5Bkf17/S5YF7ML28FmVg==")??""));
  runApp(
    GetMaterialApp(
      title: "Zee BMS",
      initialBinding: BinderData(),
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      debugShowCheckedModeBanner: false,
      theme: primaryThemeData,
      transitionDuration: Duration.zero,
      defaultTransition: Transition.noTransition,
      unknownRoute: AppPages.routes[0],
      enableLog: true,
      logWriterCallback: Logger.write,
    ),
  );
}
