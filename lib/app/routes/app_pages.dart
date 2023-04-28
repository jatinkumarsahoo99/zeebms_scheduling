import 'package:get/get.dart';

import '../modules/LogAdditions/bindings/log_additions_binding.dart';
import '../modules/LogAdditions/views/log_additions_view.dart';
import '../modules/MamWorkOrders/bindings/mam_work_orders_binding.dart';
import '../modules/MamWorkOrders/views/mam_work_orders_view.dart';
import '../modules/RoBooking/bindings/ro_booking_binding.dart';
import '../modules/RoBooking/views/ro_booking_view.dart';
import '../modules/TransmissionLog/bindings/transmission_log_binding.dart';
import '../modules/TransmissionLog/views/TransmissionLogView.dart';
import '../modules/commercial/bindings/commercial_binding.dart';
import '../modules/commercial/views/commercial_view.dart';
import '../modules/filler/bindings/filler_binding.dart';
import '../modules/filler/views/filler_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  //static const INITIAL = Routes.RO_BOOKING;
  //static const INITIAL = Routes.TRANSMISSION_LOG;
  static const INITIAL = Routes.FILLER;

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
    GetPage(
      name: _Paths.COMMERCIAL,
      page: () => CommercialView(),
      binding: CommercialBinding(),
    ),
    GetPage(
      name: _Paths.RO_BOOKING,
      page: () => const RoBookingView(),
      binding: RoBookingBinding(),
    ),
    GetPage(
      name: _Paths.FILLER,
      page: () => FillerView(),
      binding: FillerBinding(),
    ),
  ];
}
