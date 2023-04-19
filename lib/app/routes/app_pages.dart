import 'package:get/get.dart';

import '../modules/LogAdditions/bindings/log_additions_binding.dart';
import '../modules/LogAdditions/views/log_additions_view.dart';
import '../modules/MamWorkOrders/bindings/mam_work_orders_binding.dart';
import '../modules/MamWorkOrders/views/mam_work_orders_view.dart';
import '../modules/TransmissionLog/bindings/transmission_log_binding.dart';
import '../modules/TransmissionLog/views/transmission_log_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.TRANSMISSION_LOG;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.TRANSMISSION_LOG,
      page: () => TransmissionLogView(),
      binding: TransmissionLogBinding(),
    ),
    GetPage(
      name: _Paths.LOG_ADDITIONS,
      page: () => LogAdditionsView(),
      binding: LogAdditionsBinding(),
    ),
    GetPage(
      name: _Paths.MAM_WORK_ORDERS,
      page: () => MamWorkOrdersView(),
      binding: MamWorkOrdersBinding(),
    ),
  ];
}
