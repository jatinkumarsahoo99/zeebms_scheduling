import 'package:bms_scheduling/app/controller/MainController.dart';
import 'package:bms_scheduling/app/modules/EventSecondary/views/event_secondary_view.dart';
import 'package:bms_scheduling/app/modules/FillerMaster/views/filler_master_view.dart';
import 'package:bms_scheduling/app/modules/FinalAuditReportAfterTelecast/views/final_audit_report_after_telecast_view.dart';
import 'package:bms_scheduling/app/modules/FinalAuditReportBeforeLog/views/final_audit_report_before_log_view.dart';
import 'package:bms_scheduling/app/modules/FpcMismatch/views/FpcMismatchView.dart';
import 'package:bms_scheduling/app/modules/ImportDigitextRunOrder/views/import_digitext_run_order_view.dart';
import 'package:bms_scheduling/app/modules/MamWorkOrders/views/mam_work_orders_view.dart';
import 'package:bms_scheduling/app/modules/RoBooking/views/ro_booking_view.dart';
import 'package:bms_scheduling/app/modules/RoCancellation/views/ro_cancellation_view.dart';
import 'package:bms_scheduling/app/modules/SecondaryEventMaster/views/secondary_event_master_view.dart';
import 'package:bms_scheduling/app/modules/commercial/views/commercial_view.dart';
import 'package:bms_scheduling/app/modules/filler/views/filler_view.dart';
import 'package:bms_scheduling/app/modules/RoReschedule/views/ro_reschedule_view.dart';
import 'package:bms_scheduling/app/modules/RosDistribution/views/ros_distribution_view.dart';
import 'package:bms_scheduling/app/modules/SalesAuditExtraSpotsReport/views/sales_audit_extra_spots_report_view.dart';
import 'package:bms_scheduling/app/modules/SalesAuditNotTelecastReport/views/SalesAuditNotTelecastReportView.dart';
import 'package:bms_scheduling/app/modules/promos/views/promos_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../widgets/LoadingScreen.dart';
import '../../widgets/NoDataFoundPage.dart';
import '../modules/AsrunImportAdRevenue/views/AsrunImportAdRevenueView.dart';
import '../modules/AuditStatus/views/audit_status_view.dart';
import '../modules/CommercialMaster/views/commercial_master_view.dart';
import '../modules/LogAdditions/views/LogAdditionsView.dart';
import '../modules/PromoMaster/views/promo_master_view.dart';
import '../modules/SalesAuditNew/views/sales_audit_new_view.dart';
import '../modules/SlideMaster/views/slide_master_view.dart';
import '../modules/SpotPriority/views/SpotPriorityView.dart';
import '../modules/StillMaster/views/still_master_view.dart';
import '../modules/TransmissionLog/views/TransmissionLogView.dart';
import '../modules/commercial/views/commercial_view.dart';
import '../modules/home/views/home_view.dart';
import '../modules/slide/views/slide_view.dart';
import '../routes/app_pages.dart';

class AuthGuard1 extends StatelessWidget {
  final String childName;

  AuthGuard1({required this.childName}) {
    assert(this.childName != null);
  }

  Widget? currentWidget;

  @override
  Widget build(BuildContext context) {
    return GetX<MainController>(
      init: Get.find<MainController>(),
      // init: MainController(),
      initState: (c) {
        // Get.find<MainController>().checkSession2();
        Get.find<MainController>().checkSessionFromParams();
      },
      builder: (controller) {
        print("Login value>>" + controller.loginVal.value.toString());
        if (controller.loginVal.value == 1) {
          switch (childName) {
            case Routes.HOME:
              currentWidget = HomeView();
              break;
            case Routes.SLIDE:
              currentWidget = SlideView();
              break;
            case Routes.EVENT_SECONDARY:
              currentWidget = EventSecondaryView();
              break;
            case Routes.SECONDARY_EVENT_MASTER:
              currentWidget = SecondaryEventMasterView();
              break;
            case Routes.TRANSMISSION_LOG:
              currentWidget = TransmissionLogView();
              break;
            case Routes.RO_CANCELLATION:
              currentWidget = RoCancellationView();
              break;
            case Routes.LOG_ADDITIONS:
              currentWidget = LogAdditionsView();
              break;
            case Routes.FPC_MISMATCH:
              currentWidget = FpcMismatchView();
              break;
            case Routes.RO_RESCHEDULE:
              currentWidget = RoRescheduleView();
              break;
            case Routes.ROS_DISTRIBUTION:
              currentWidget = RosDistributionView();
              break;
            case Routes.IMPORT_DIGITEXT_RUN_ORDER:
              currentWidget = ImportDigitextRunOrderView();
              break;
            case Routes.FILLER:
              currentWidget = FillerView();
              break;
            case Routes.PROMOS:
              currentWidget = PromosView();
              break;
            case Routes.COMMERCIAL:
              currentWidget = CommercialView();
              break;
            case Routes.MAM_WORK_ORDERS:
              currentWidget = MamWorkOrdersView();
              break;
            case Routes.SPOT_PRIORITY:
              currentWidget = SpotPriorityView();
              break;
            case Routes.RO_CANCELLATION:
              currentWidget = RoCancellationView();
              break;
            case Routes.COMMERCIAL:
              currentWidget = CommercialView();
              break;
            case Routes.RO_BOOKING:
              currentWidget = RoBookingView();
              break;
            case Routes.FINAL_AUDIT_REPORT_BEFORE_LOG:
              currentWidget = FinalAuditReportBeforeLogView();
              break;
            case Routes.FINAL_AUDIT_REPORT_AFTER_TELECAST:
              currentWidget = FinalAuditReportAfterTelecastView();
              break;
            case Routes.AUDIT_STATUS:
              currentWidget = AuditStatusView();
              break;
            case Routes.ASRUN_IMPORT_AD_REVENUE:
              currentWidget = AsrunImportAdRevenueView();
              break;
            case Routes.SALES_AUDIT_NOT_TELECAST_REPORT:
              currentWidget = SalesAuditNotTelecastReportView();
              break;
            case Routes.SALES_AUDIT_EXTRA_SPOTS_REPORT:
              currentWidget = SalesAuditExtraSpotsReportView();
              break;
            case Routes.SALES_AUDIT_NEW:
              currentWidget = SalesAuditNewView();
              break;
            case Routes.SLIDE_MASTER:
              currentWidget = SlideMasterView();
              break;
            case Routes.STILL_MASTER:
              currentWidget = StillMasterView();
              break;
            case Routes.PROMO_MASTER:
              currentWidget = PromoMasterView();
              break;
            case Routes.FILLER_MASTER:
              currentWidget = FillerMasterView();
              break;
            case Routes.COMMERCIAL_MASTER:
              currentWidget = CommercialMasterView();
              break;
            default:
              currentWidget = const NoDataFoundPage();
          }
          // currentWidget = child;
        } else if (controller.loginVal.value == 2) {
          currentWidget = const NoDataFoundPage();
        } else {
          currentWidget = const LoadingScreen();
        }
        return currentWidget!;
      },
    );
  }
}
