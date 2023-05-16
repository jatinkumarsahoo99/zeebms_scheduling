import 'package:get/get.dart';

import '../modules/EventSecondary/bindings/event_secondary_binding.dart';
import '../modules/EventSecondary/views/event_secondary_view.dart';
import '../modules/FpcMismatch/bindings/fpc_mismatch_binding.dart';
import '../modules/FpcMismatch/views/FpcMismatchView.dart';
import '../modules/ImportDigitextRunOrder/bindings/import_digitext_run_order_binding.dart';
import '../modules/ImportDigitextRunOrder/views/import_digitext_run_order_view.dart';
import '../modules/LogAdditions/bindings/log_additions_binding.dart';
import '../modules/LogAdditions/views/LogAdditionsView.dart';
import '../modules/MamWorkOrders/bindings/mam_work_orders_binding.dart';
import '../modules/MamWorkOrders/views/mam_work_orders_view.dart';
import '../modules/RoBooking/bindings/ro_booking_binding.dart';
import '../modules/RoBooking/views/ro_booking_view.dart';
import '../modules/RoCancellation/bindings/ro_cancellation_binding.dart';
import '../modules/RoCancellation/views/ro_cancellation_view.dart';
import '../modules/SpotPriority/bindings/spot_priority_binding.dart';
import '../modules/SpotPriority/views/SpotPriorityView.dart';
import '../modules/TransmissionLog/bindings/transmission_log_binding.dart';
import '../modules/TransmissionLog/views/TransmissionLogView.dart';
import '../modules/commercial/bindings/commercial_binding.dart';
import '../modules/commercial/views/commercial_view.dart';
import '../modules/filler/bindings/filler_binding.dart';
import '../modules/filler/views/filler_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/promos/bindings/promos_binding.dart';
import '../modules/promos/views/promos_view.dart';
import '../providers/AuthGuard1.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.COMMERCIAL;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.TRANSMISSION_LOG,
      page: () => AuthGuard1(childName: _Paths.TRANSMISSION_LOG),
    ),
    GetPage(
      name: _Paths.LOG_ADDITIONS,
      page: () => AuthGuard1(childName: _Paths.LOG_ADDITIONS),
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
      page: () => AuthGuard1(childName: _Paths.FILLER),
      binding: FillerBinding(),
    ),
    GetPage(
      name: _Paths.PROMOS,
      page: () => PromosView(),
      binding: PromosBinding(),
    ),
    GetPage(
      name: _Paths.IMPORT_DIGITEXT_RUN_ORDER,
      page: () => AuthGuard1(childName: _Paths.IMPORT_DIGITEXT_RUN_ORDER),
      binding: ImportDigitextRunOrderBinding(),
    ),
    GetPage(
      name: _Paths.FPC_MISMATCH,
      page: () => AuthGuard1(childName: _Paths.FPC_MISMATCH),
    ),
    GetPage(
      name: _Paths.SPOT_PRIORITY,
      page: () => SpotPriorityView(),
      binding: SpotPriorityBinding(),
    ),
    GetPage(
      name: _Paths.RO_CANCELLATION,
      page: () => AuthGuard1(childName: _Paths.RO_CANCELLATION),
      binding: RoCancellationBinding(),
    ),
    GetPage(
      name: _Paths.EVENT_SECONDARY,
      page: () => EventSecondaryView(),
      binding: EventSecondaryBinding(),
    ),
  ];

}
