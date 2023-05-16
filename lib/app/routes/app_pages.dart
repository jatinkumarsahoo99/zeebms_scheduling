import 'package:get/get.dart';

import '../modules/AsrunImportAdRevenue/views/AsrunImportAdRevenueView.dart';
import '../modules/ImportDigitextRunOrder/bindings/import_digitext_run_order_binding.dart';
import '../modules/MamWorkOrders/bindings/mam_work_orders_binding.dart';
import '../modules/RoBooking/bindings/ro_booking_binding.dart';
import '../modules/RoBooking/views/ro_booking_view.dart';
import '../modules/RoCancellation/bindings/ro_cancellation_binding.dart';
import '../modules/RoReschedule/bindings/ro_reschedule_binding.dart';
import '../modules/RosDistribution/bindings/ros_distribution_binding.dart';
import '../modules/SalesAuditExtraSpotsReport/bindings/sales_audit_extra_spots_report_binding.dart';
import '../modules/SalesAuditExtraSpotsReport/views/sales_audit_extra_spots_report_view.dart';
import '../modules/SalesAuditNew/bindings/sales_audit_new_binding.dart';
import '../modules/SalesAuditNew/views/sales_audit_new_view.dart';
import '../modules/SalesAuditNotTelecastReport/bindings/sales_audit_not_telecast_report_binding.dart';
import '../modules/SalesAuditNotTelecastReport/views/SalesAuditNotTelecastReportView.dart';
import '../modules/SpotPriority/bindings/spot_priority_binding.dart';
import '../modules/SpotPriority/views/SpotPriorityView.dart';
import '../modules/commercial/bindings/commercial_binding.dart';
import '../modules/commercial/views/commercial_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../providers/AuthGuard1.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.MAM_WORK_ORDERS +
      "?personalNo=AqoF3cvt1PCPIKM8FfPwag%3D%3D&loginCode=gsS2oEkuYKzI9aXanDqobQ%3D%3D&formName=a4Lfy%2FGb5Roxo9vLiBCqSQ%3D%3D";

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
      page: () => AuthGuard1(childName: _Paths.MAM_WORK_ORDERS),
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
      page: () => AuthGuard1(childName: _Paths.SPOT_PRIORITY),
      // binding: SpotPriorityBinding(),
    ),
    GetPage(
      name: _Paths.RO_CANCELLATION,
      page: () => AuthGuard1(childName: _Paths.RO_CANCELLATION),
      // binding: RoCancellationBinding(),
    ),
    GetPage(
      name: _Paths.RO_RESCHEDULE,
      page: () => AuthGuard1(childName: _Paths.RO_RESCHEDULE),
      binding: RoRescheduleBinding(),
    ),
    GetPage(
      name: _Paths.ROS_DISTRIBUTION,
      page: () => AuthGuard1(childName: _Paths.ROS_DISTRIBUTION),
      binding: RosDistributionBinding(),
    ),
    GetPage(
      name: _Paths.ASRUN_IMPORT_AD_REVENUE,
      page: () => AsrunImportAdRevenueView(),
      // binding: AsrunImportBinding(),
    ),
    GetPage(
      name: _Paths.SALES_AUDIT_NOT_TELECAST_REPORT,
      page: () => SalesAuditNotTelecastReportView(),
      binding: SalesAuditNotTelecastReportBinding(),
    ),
    GetPage(
      name: _Paths.SALES_AUDIT_EXTRA_SPOTS_REPORT,
      page: () => SalesAuditExtraSpotsReportView(),
      binding: SalesAuditExtraSpotsReportBinding(),
    ),
    GetPage(
      name: _Paths.SALES_AUDIT_NEW,
      page: () => SalesAuditNewView(),
      binding: SalesAuditNewBinding(),
    ),
  ];
}
