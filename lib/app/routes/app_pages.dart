import 'package:get/get.dart';

import '../modules/AsrunImportAdRevenue/bindings/asrun_import_binding.dart';
import '../modules/AuditStatus/bindings/audit_status_binding.dart';
import '../modules/CommercialMaster/bindings/commercial_master_binding.dart';
import '../modules/CommercialMaster/views/commercial_master_view.dart';
import '../modules/EventSecondary/bindings/event_secondary_binding.dart';
import '../modules/EventSecondary/views/event_secondary_view.dart';
import '../modules/FinalAuditReportAfterTelecast/bindings/final_audit_report_after_telecast_binding.dart';
import '../modules/FinalAuditReportBeforeLog/bindings/final_audit_report_before_log_binding.dart';
import '../modules/FpcMismatch/bindings/fpc_mismatch_binding.dart';
import '../modules/FpcMismatch/bindings/fpc_mismatch_binding.dart';
import '../modules/FpcMismatch/views/FpcMismatchView.dart';
import '../modules/ImportDigitextRunOrder/bindings/import_digitext_run_order_binding.dart';
import '../modules/ImportDigitextRunOrder/bindings/import_digitext_run_order_binding.dart';
import '../modules/ImportDigitextRunOrder/views/import_digitext_run_order_view.dart';
import '../modules/LogAdditions/bindings/log_additions_binding.dart';
import '../modules/LogAdditions/views/LogAdditionsView.dart';
import '../modules/MamWorkOrders/bindings/mam_work_orders_binding.dart';
import '../modules/MamWorkOrders/bindings/mam_work_orders_binding.dart';
import '../modules/MamWorkOrders/views/mam_work_orders_view.dart';
import '../modules/PromoMaster/bindings/promo_master_binding.dart';
import '../modules/PromoMaster/controllers/promo_master_controller.dart';
import '../modules/PromoMaster/views/promo_master_view.dart';
import '../modules/RoBooking/bindings/ro_booking_binding.dart';
import '../modules/RoBooking/bindings/ro_booking_binding.dart';
import '../modules/RoBooking/views/ro_booking_view.dart';
import '../modules/RoCancellation/bindings/ro_cancellation_binding.dart';
import '../modules/RoCancellation/bindings/ro_cancellation_binding.dart';
import '../modules/RoCancellation/views/ro_cancellation_view.dart';
import '../modules/RoReschedule/bindings/ro_reschedule_binding.dart';
import '../modules/RosDistribution/bindings/ros_distribution_binding.dart';
import '../modules/SalesAuditExtraSpotsReport/bindings/sales_audit_extra_spots_report_binding.dart';
import '../modules/SalesAuditNew/bindings/sales_audit_new_binding.dart';
import '../modules/SalesAuditNotTelecastReport/bindings/sales_audit_not_telecast_report_binding.dart';
import '../modules/SecondaryEventMaster/bindings/secondary_event_master_binding.dart';
import '../modules/SlideMaster/bindings/slide_master_binding.dart';
import '../modules/SpotPriority/bindings/spot_priority_binding.dart';
import '../modules/StillMaster/bindings/still_master_binding.dart';
import '../modules/TransmissionLog/bindings/transmission_log_binding.dart';
import '../modules/commercial/bindings/commercial_binding.dart';
import '../modules/filler/bindings/filler_binding.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/promos/bindings/promos_binding.dart';
import '../modules/slide/bindings/slide_binding.dart';
import '../providers/AuthGuard1.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  // static const INITIAL = Routes.ROS_DISTRIBUTION +
  static const INITIAL = Routes.STILL_MASTER +
      "?personalNo=kW5Bkf17%2FS5YF7ML28FmVg%3D%3D&loginCode=1BWIoBKeDl7qDSAAhxvXsQ%3D%3D&formName=OI8ukDpPPVN0I2BEXu2h4nuFu%2BZm1ZRpvP8NL4XCXzQ%3D";
  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.SLIDE,
      page: () => AuthGuard1(childName: _Paths.SLIDE),
      binding: SlideBinding(),
    ),
    GetPage(
      name: _Paths.TRANSMISSION_LOG,
      page: () => AuthGuard1(childName: _Paths.TRANSMISSION_LOG),
      binding: TransmissionLogBinding(),
    ),
    GetPage(
      name: _Paths.EVENT_SECONDARY,
      page: () => AuthGuard1(childName: _Paths.EVENT_SECONDARY),
      binding: EventSecondaryBinding(),
    ),
    GetPage(
      name: _Paths.SECONDARY_EVENT_MASTER,
      page: () => AuthGuard1(childName: _Paths.SECONDARY_EVENT_MASTER),
      binding: SecondaryEventMasterBinding(),
    ),
    GetPage(
      name: _Paths.LOG_ADDITIONS,
      page: () => AuthGuard1(childName: _Paths.LOG_ADDITIONS),
      binding: LogAdditionsBinding(),
    ),
    GetPage(
      name: _Paths.MAM_WORK_ORDERS,
      page: () => AuthGuard1(childName: _Paths.MAM_WORK_ORDERS),
      binding: MamWorkOrdersBinding(),
    ),
    GetPage(
      name: _Paths.COMMERCIAL,
      page: () => AuthGuard1(childName: _Paths.COMMERCIAL),
      binding: CommercialBinding(),
    ),
    GetPage(
      name: _Paths.RO_BOOKING,
      page: () => AuthGuard1(childName: _Paths.RO_BOOKING),
      binding: RoBookingBinding(),
    ),
    GetPage(
      name: _Paths.FILLER,
      page: () => AuthGuard1(childName: _Paths.FILLER),
      binding: FillerBinding(),
    ),
    GetPage(
      name: _Paths.PROMOS,
      page: () => AuthGuard1(childName: _Paths.PROMOS),
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
      binding: FpcMismatchBinding(),
    ),
    GetPage(
      name: _Paths.SPOT_PRIORITY,
      page: () => AuthGuard1(childName: _Paths.SPOT_PRIORITY),
      binding: SpotPriorityBinding(),
    ),
    GetPage(
      name: _Paths.RO_CANCELLATION,
      page: () => AuthGuard1(childName: _Paths.RO_CANCELLATION),
      binding: RoCancellationBinding(),
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
      name: _Paths.FINAL_AUDIT_REPORT_BEFORE_LOG,
      page: () => AuthGuard1(
        childName: _Paths.FINAL_AUDIT_REPORT_BEFORE_LOG,
      ),
      binding: FinalAuditReportBeforeLogBinding(),
    ),
    GetPage(
      name: _Paths.FINAL_AUDIT_REPORT_AFTER_TELECAST,
      page: () => AuthGuard1(
        childName: _Paths.FINAL_AUDIT_REPORT_AFTER_TELECAST,
      ),
      binding: FinalAuditReportAfterTelecastBinding(),
    ),
    GetPage(
      name: _Paths.AUDIT_STATUS,
      page: () => AuthGuard1(
        childName: _Paths.AUDIT_STATUS,
      ),
      binding: AuditStatusBinding(),
    ),
    GetPage(
      name: _Paths.ASRUN_IMPORT_AD_REVENUE,
      page: () => AuthGuard1(
        childName: _Paths.ASRUN_IMPORT_AD_REVENUE,
      ),
      binding: AsrunImportBinding(),
    ),
    GetPage(
      name: _Paths.SALES_AUDIT_NOT_TELECAST_REPORT,
      page: () => AuthGuard1(
        childName: _Paths.SALES_AUDIT_NOT_TELECAST_REPORT,
      ),
      binding: SalesAuditNotTelecastReportBinding(),
    ),
    GetPage(
      name: _Paths.SALES_AUDIT_EXTRA_SPOTS_REPORT,
      page: () => AuthGuard1(
        childName: _Paths.SALES_AUDIT_EXTRA_SPOTS_REPORT,
      ),
      binding: SalesAuditExtraSpotsReportBinding(),
    ),
    GetPage(
      name: _Paths.SALES_AUDIT_NEW,
      page: () => AuthGuard1(
        childName: _Paths.SALES_AUDIT_NEW,
      ),
      binding: SalesAuditNewBinding(),
    ),
    GetPage(
      name: _Paths.SLIDE_MASTER,
      page: () => AuthGuard1(
        childName: _Paths.SLIDE_MASTER,
      ),
      binding: SlideMasterBinding(),
    ),
    GetPage(
      name: _Paths.STILL_MASTER,
      page: () => AuthGuard1(
        childName: _Paths.STILL_MASTER,
      ),
      binding: StillMasterBinding(),
    ),
    GetPage(
      name: _Paths.PROMO_MASTER,
      page: () => AuthGuard1(
        childName: _Paths.PROMO_MASTER,
      ),
      binding: PromoMasterBinding(),
    ),
    GetPage(
      name: _Paths.FILLER_MASTER,
      page: () => AuthGuard1(
        childName: _Paths.FILLER_MASTER,
      ),
      binding: PromoMasterBinding(),
    ),
    GetPage(
      name: _Paths.COMMERCIAL_MASTER,
      page: () => const CommercialMasterView(),
      binding: CommercialMasterBinding(),
    ),
  ];
}
