import 'package:get/get.dart';

import '../modules/ImportDigitextRunOrder/bindings/import_digitext_run_order_binding.dart';
import '../modules/ImportDigitextRunOrder/views/import_digitext_run_order_view.dart';
import '../modules/LogAdditions/bindings/log_additions_binding.dart';
import '../modules/LogAdditions/views/log_additions_view.dart';
import '../modules/MamWorkOrders/bindings/mam_work_orders_binding.dart';
import '../modules/MamWorkOrders/views/mam_work_orders_view.dart';
import '../modules/RoBooking/bindings/ro_booking_binding.dart';
import '../modules/RoBooking/views/ro_booking_view.dart';
import '../modules/TransmissionLog/bindings/transmission_log_binding.dart';
import '../modules/TransmissionLog/views/TransmissionLogView.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../providers/AuthGuard1.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.IMPORT_DIGITEXT_RUN_ORDER;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.TRANSMISSION_LOG,
      // page: () => TransmissionLogView(),
      page: () => AuthGuard1(childName: _Paths.TRANSMISSION_LOG),
      // binding: TransmissionLogBinding(),
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
    GetPage(
      name: _Paths.RO_BOOKING,
      page: () => const RoBookingView(),
      binding: RoBookingBinding(),
    ),
    GetPage(
      name: _Paths.IMPORT_DIGITEXT_RUN_ORDER,
      page: () => const ImportDigitextRunOrderView(),
      binding: ImportDigitextRunOrderBinding(),
    ),
  ];
}
