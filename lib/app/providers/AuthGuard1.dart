import 'dart:html' as w;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:bms_scheduling/app/controller/MainController.dart';
import 'package:bms_scheduling/app/modules/EventSecondary/views/event_secondary_view.dart';
import 'package:bms_scheduling/app/modules/FillerMaster/views/filler_master_view.dart';
import 'package:bms_scheduling/app/modules/FinalAuditReportAfterTelecast/views/final_audit_report_after_telecast_view.dart';
import 'package:bms_scheduling/app/modules/FinalAuditReportBeforeLog/views/final_audit_report_before_log_view.dart';
import 'package:bms_scheduling/app/modules/FpcMismatch/views/FpcMismatchView.dart';
import 'package:bms_scheduling/app/modules/ImportDigitextRunOrder/views/import_digitext_run_order_view.dart';
import 'package:bms_scheduling/app/modules/LogConvert/views/log_convert_view.dart';
import 'package:bms_scheduling/app/modules/MamWorkOrders/views/mam_work_orders_view.dart';
import 'package:bms_scheduling/app/modules/PromoTypeMaster/views/promo_type_master_view.dart';
import 'package:bms_scheduling/app/modules/RoBooking/views/ro_booking_view.dart';
import 'package:bms_scheduling/app/modules/RoCancellation/views/ro_cancellation_view.dart';
import 'package:bms_scheduling/app/modules/RoReschedule/views/ro_reschedule_view.dart';
import 'package:bms_scheduling/app/modules/RosDistribution/views/ros_distribution_view.dart';
import 'package:bms_scheduling/app/modules/SalesAuditExtraSpotsReport/views/sales_audit_extra_spots_report_view.dart';
import 'package:bms_scheduling/app/modules/SalesAuditNotTelecastReport/views/SalesAuditNotTelecastReportView.dart';
import 'package:bms_scheduling/app/modules/SchedulePromos/views/SchedulePromoView.dart';
import 'package:bms_scheduling/app/modules/SecondaryEventMaster/views/secondary_event_master_view.dart';
import 'package:bms_scheduling/app/modules/SecondaryEventTemplateMaster/views/secondary_event_template_master_view.dart';
import 'package:bms_scheduling/app/modules/SponserTypeMaster/views/sponser_type_master_view.dart';
import 'package:bms_scheduling/app/modules/SpotPositionTypeMaster/views/spot_position_type_master_view.dart';
import 'package:bms_scheduling/app/modules/commercial/views/commercial_view.dart';
import 'package:bms_scheduling/app/modules/filler/views/filler_view.dart';
import 'package:bms_scheduling/app/modules/material_id_search/views/material_id_search_view.dart';

import '../../widgets/LoadingScreen.dart';
import '../../widgets/NoDataFoundPage.dart';
import '../modules/AsrunImportAdRevenue/views/AsrunImportAdRevenueView.dart';
import '../modules/AuditStatus/views/audit_status_view.dart';
import '../modules/BrandMaster/views/brand_master_view.dart';
import '../modules/ComingUpMenu/views/coming_up_menu_view.dart';
import '../modules/ComingUpNextMenu/views/coming_up_next_menu_view.dart';
import '../modules/ComingUpTomorrowMenu/views/coming_up_tomorrow_menu_view.dart';
import '../modules/CommercialTapeMaster/views/commercial_master_view.dart';
import '../modules/CommonSearch/views/common_search_view.dart';
import '../modules/CreativeTagOn/views/creative_tag_on_view.dart';
import '../modules/DSeriesSpecification/views/DSeriesSpecificationView.dart';
import '../modules/DateWiseErrorSpots/views/date_wise_error_spots_view.dart';
import '../modules/DateWiseFillerReport/views/date_wise_filler_report_view.dart';
import '../modules/EuropeCommercialImportStatus/views/EuropeCommercialImportStatusView.dart';
import '../modules/EuropeDropSpots/views/EuropeDropSpotsView.dart';
import '../modules/ExtraSpotsWithRemark/views/extra_spots_with_remark_view.dart';
import '../modules/InventoryStatusReport/views/inventory_status_report_view.dart';
import '../modules/LanguageMaster/views/language_master_view.dart';
import '../modules/LogAdditions/views/LogAdditionsView.dart';
import '../modules/ManageChannelInventory/views/manage_channel_inventory_view.dart';
import '../modules/NewShortContentForm/views/new_short_content_form_view.dart';
import '../modules/PromoMaster/views/promo_master_view.dart';
import '../modules/ROImport/views/r_o_import_view.dart';
import '../modules/SalesAuditNew/views/SalesAuditNewView.dart';
import '../modules/ShortContentBulkImport/views/short_content_bulk_import_view.dart';
import '../modules/SlideMaster/views/slide_master_view.dart';
import '../modules/SpotPriority/views/SpotPriorityView.dart';
import '../modules/StillMaster/views/still_master_view.dart';
import '../modules/TransmissionLog/views/TransmissionLogView.dart';
import '../modules/home/views/home_view.dart';
import '../modules/slide/views/slide_view.dart';
import '../routes/app_pages.dart';

class AuthGuard1 extends StatefulWidget {
  final String childName;

  AuthGuard1({required this.childName}) {
    assert(this.childName != null);
  }

  @override
  State<AuthGuard1> createState() => _AuthGuard1State();
}

class _AuthGuard1State extends State<AuthGuard1> with WidgetsBindingObserver {
  @override
  void initState() {
    print("Auth guard init");
    super.initState();
    if (kIsWeb) {
      w.window.addEventListener('focus', onFocus);
      w.window.addEventListener('blur', onBlur);
    } else {
      WidgetsBinding.instance.addObserver(this);
    }
  }

  @override
  void dispose() {
    print("Auth guard dispose");
    if (kIsWeb) {
      w.window.removeEventListener('focus', onFocus);
      w.window.removeEventListener('blur', onBlur);
    } else {
      WidgetsBinding.instance.removeObserver(this);
    }
    super.dispose();
  }

  void onFocus(w.Event e) {
    didChangeAppLifecycleState(AppLifecycleState.resumed);
  }

  void onBlur(w.Event e) {
    didChangeAppLifecycleState(AppLifecycleState.paused);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        // --
        print('Resumed');
        Get.focusScope?.requestFocus();
        // FocusScope.of(Get.context!).requestFocus();

        break;
      case AppLifecycleState.inactive:
        // --
        // print('Inactive');
        break;
      case AppLifecycleState.paused:
        // --
        print('Paused');
        // FocusScope.of(Get.context!).unfocus();
        Get.focusScope?.unfocus();
        break;
      case AppLifecycleState.detached:
        // --
        // print('Detached');
        break;
    }
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
          switch (widget.childName) {
            case Routes.HOME:
              currentWidget = HomeView();
              break;
            case Routes.SHORT_CONTENT_BULK_IMPORT:
              currentWidget = ShortContentBulkImportView();
              break;
            case Routes.SLIDE:
              currentWidget = SlideView();
              break;
            case Routes.R_O_IMPORT:
              currentWidget = const ROImportView();
              break;
            case Routes.MATERIAL_ID_SEARCH:
              currentWidget = MaterialIdSearchView();
              break;
            case Routes.EVENT_SECONDARY:
              currentWidget = EventSecondaryView();
              break;
            case Routes.SPONSER_TYPE_MASTER:
              currentWidget = SponserTypeMasterView();
              break;
            case Routes.SPOT_POSITION_TYPE_MASTER:
              currentWidget = SpotPositionTypeMasterView();
              break;
            case Routes.SECONDARY_EVENT_TEMPLATE_MASTER:
              currentWidget = SecondaryEventTemplateMasterView();
              break;
            case Routes.LOG_CONVERT:
              currentWidget = LogConvertView();
              break;
            case Routes.NEW_SHORT_CONTENT_FORM:
              currentWidget = NewShortContentFormView();
              break;
            case Routes.PROMO_TYPE_MASTER:
              currentWidget = PromoTypeMasterView();
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
            case Routes.SCHEDULE_PROMO:
              currentWidget = SchedulePromoView();
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
            case Routes.BRAND_MASTER:
              currentWidget = BrandMasterView();
              break;
            case Routes.COMING_UP_MENU:
              currentWidget = ComingUpMenuView();
              break;
            case Routes.COMING_UP_NEXT_MENU:
              currentWidget = ComingUpNextMenuView();
              break;
            case Routes.COMING_UP_TOMORROW_MENU:
              currentWidget = ComingUpTomorrowMenuView();
              break;
            case Routes.DATE_WISE_ERROR_SPOTS:
              currentWidget = DateWiseErrorSpotsView();
              break;
            case Routes.DATE_WISE_FILLER_REPORT:
              currentWidget = DateWiseFillerReportView();
              break;
            case Routes.CREATIVE_TAG_ON:
              currentWidget = CreativeTagOnView();
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
            case Routes.EXTRA_SPOTS_WITH_REMARK:
              currentWidget = const ExtraSpotsWithRemarkView();
              break;
            case Routes.INVENTORY_STATUS_REPORT:
              currentWidget = InventoryStatusReportView();
              break;
            case Routes.MANAGE_CHANNEL_INVENTORY:
              currentWidget = const ManageChannelInvemtoryView();
              break;
            case Routes.LANGUAGE_MASTER:
              currentWidget = const LanguageMasterView();
              break;
            case Routes.D_SERIES_SPECIFICATION:
              currentWidget = DSeriesSpecificationView();
              break;
            case Routes.EUROPE_RUNNING_ORDER_STATUS:
              currentWidget = EuropeCommercialImportStatusView();
              break;
            case Routes.EUROPE_DROP_SPOTS:
              currentWidget = EuropeDropSpotsView();
              break;
            case Routes.DROPPED_SPOTS:
              currentWidget = SearchPage(
                  key: const Key("DroppedSpot"),
                  screenName: "Dropped Spot",
                  strViewName: "BMS_View_DroppedSpots");
              break;
            case Routes.DAILY_FPC_STATUS:
              currentWidget = SearchPage(
                  key: const Key("DailyFpcStatus"),
                  screenName: "Daily Fpc Status",
                  strViewName: "Bms_View_DailyFpc");
              break;
            ////////////////////////////////////
            case Routes.GENERATE_BOOKING_ACTIVITY:
              currentWidget = SearchPage(
                  key: const Key("GENERATE_BOOKING_ACTIVITY"),
                  screenName: "Generate Booking Activity",
                  strViewName: "BMS_view_BookingDetail");
              break;
            case Routes.PERIODIC_DEAL_UTILIZATION:
              currentWidget = SearchPage(
                  key: const Key("PERIODIC_DEAL_UTILIZATION"),
                  screenName: "Periodic Deal Utilization",
                  strViewName: "BMS_DealUtilPeriodic");
              break;
            case Routes.SPOT_DISTRIBUTION:
              currentWidget = SearchPage(
                  key: const Key("SPOT_DISTRIBUTION"),
                  screenName: "Spot Distribution",
                  strViewName: "Bms_rpt_ShowRosBucket");
              break;
            case Routes.TELECAST_SPOTS_WITH_PROGRAM_INFO:
              currentWidget = SearchPage(
                  key: const Key("TELECAST_SPOTS_WITH_PROGRAM_INFO"),
                  screenName: "Teleacast Spots With Program Info",
                  strViewName: "BMS_BreakTimeWithprogram");
              break;
            case Routes.TRANSMISSION_LOG_SEARCH:
              currentWidget = SearchPage(
                  key: const Key("TRANSMISSION_LOG_SEARCH"),
                  screenName: "Transmission Log Search",
                  strViewName: "BMS_VTransmissionLog");
              break;
            case Routes.VIDEOCON_LOG:
              currentWidget = SearchPage(
                  key: const Key("VIDEOCON_LOG"),
                  screenName: "Videocon Log",
                  strViewName: "Dish_VideoconLog");
              break;
            case Routes.ASRUN_SEARCH_REPORT:
              currentWidget = SearchPage(
                  key: const Key("ASRUN_SEARCH_REPORT"),
                  screenName: "Asrun Search Report",
                  strViewName: "bms_view_asrunsearch");
              break;
            case Routes.CUE_TONE_BREAK_DURATION:
              currentWidget = SearchPage(
                  key: const Key("CUE_TONE_BREAK_DURATION"),
                  screenName: "Cue Tone Break Duration",
                  strViewName: "BMS_CueToneBreakDuration");
              break;
            case Routes.DATEWISE_COMMERCIAL_LOG:
              currentWidget = SearchPage(
                  key: const Key("DATEWISE_COMMERCIAL_LOG"),
                  screenName: "Datewise Commercial Log",
                  strViewName: "BMS_Commerciallog");
              break;
            case Routes.DEAL_UTILIZATION:
              currentWidget = SearchPage(
                  key: const Key("DEAL_UTILIZATION"),
                  screenName: "Deal Utilization",
                  strViewName: "BMS_view_DealUtil");
              break;
            case Routes.MOVIE_SCHEDULE_REPORT:
              currentWidget = SearchPage(
                  key: const Key("MOVIE_SCHEDULE_REPORT"),
                  screenName: "Movie Schedule Report",
                  strViewName: "FPC_MovieListing");
              break;
            ///////////////////New Forms////////////////////////
            case Routes.AUTO_ID_COMMERCIAL_REPORT:
              currentWidget = SearchPage(
                  key: const Key("AUTO_ID_COMMERCIAL_REPORT"),
                  screenName: "Auto ID Commercial Report",
                  strViewName: "BMS_Sp_Commercial_AUTOID_Report");
              break;
            case Routes.AUTO_ID_FILLER_REPORT:
              currentWidget = SearchPage(
                  key: const Key("AUTO_ID_FILLER_REPORT"),
                  screenName: "Auto ID Filler Report",
                  strViewName: "BMS_Sp_Filler_AUTOID_Report");
              break;
            case Routes.AUTO_ID_PROMOS_REPORT:
              currentWidget = SearchPage(
                  key: const Key("AUTO_ID_PROMOS_REPORT"),
                  screenName: "Auto ID Promos Report",
                  strViewName: "BMS_Sp_Promos_AUTOID_Report",
              );
              break;
            case Routes.AUTO_ID_STING_REPORT:
              currentWidget = SearchPage(
                  key: const Key("AUTO_ID_STING_REPORT"),
                  screenName: "Auto ID Sting Report",
                  strViewName: "BMS_Sp_Sting_AUTOID_Report");
              break;
            ///////////////////////////
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
