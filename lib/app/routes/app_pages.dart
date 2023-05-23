import 'package:get/get.dart';

import '../modules/FillerMaster/bindings/filler_master_binding.dart';
import '../modules/FillerMaster/views/filler_master_view.dart';
import '../modules/PromoMaster/bindings/promo_master_binding.dart';
import '../modules/PromoMaster/views/promo_master_view.dart';
import '../modules/SecondaryEventMaster/bindings/secondary_event_master_binding.dart';
import '../modules/SecondaryEventMaster/views/secondary_event_master_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../providers/AuthGuard1.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.FILLER_MASTER +
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
    ),
    GetPage(
      name: _Paths.COMMERCIAL,
      page: () => AuthGuard1(childName: _Paths.COMMERCIAL),
    ),
    GetPage(
      name: _Paths.RO_BOOKING,
      page: () => AuthGuard1(childName: _Paths.RO_BOOKING),
    ),
    GetPage(
      name: _Paths.IMPORT_DIGITEXT_RUN_ORDER,
      page: () => AuthGuard1(childName: _Paths.IMPORT_DIGITEXT_RUN_ORDER),
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
    ),
    GetPage(
      name: _Paths.ROS_DISTRIBUTION,
      page: () => AuthGuard1(childName: _Paths.ROS_DISTRIBUTION),
    ),
    GetPage(
      name: _Paths.FINAL_AUDIT_REPORT_BEFORE_LOG,
      page: () => AuthGuard1(
        childName: _Paths.FINAL_AUDIT_REPORT_BEFORE_LOG,
      ),
    ),
    GetPage(
      name: _Paths.FINAL_AUDIT_REPORT_AFTER_TELECAST,
      page: () => AuthGuard1(
        childName: _Paths.FINAL_AUDIT_REPORT_AFTER_TELECAST,
      ),
    ),
    GetPage(
      name: _Paths.AUDIT_STATUS,
      page: () => AuthGuard1(
        childName: _Paths.AUDIT_STATUS,
      ),
    ),
    GetPage(
      name: _Paths.ASRUN_IMPORT_AD_REVENUE,
      page: () => AuthGuard1(
        childName: _Paths.ASRUN_IMPORT_AD_REVENUE,
      ),
    ),
    GetPage(
      name: _Paths.SALES_AUDIT_NOT_TELECAST_REPORT,
      page: () => AuthGuard1(
        childName: _Paths.SALES_AUDIT_NOT_TELECAST_REPORT,
      ),
    ),
    GetPage(
      name: _Paths.SALES_AUDIT_EXTRA_SPOTS_REPORT,
      page: () => AuthGuard1(
        childName: _Paths.SALES_AUDIT_EXTRA_SPOTS_REPORT,
      ),
    ),
    GetPage(
      name: _Paths.SALES_AUDIT_NEW,
      page: () => AuthGuard1(
        childName: _Paths.SALES_AUDIT_NEW,
      ),
    ),
    GetPage(
      name: _Paths.SLIDE_MASTER,
      page: () => AuthGuard1(
        childName: _Paths.SLIDE_MASTER,
      ),
    ),
    GetPage(
      name: _Paths.STILL_MASTER,
      page: () => AuthGuard1(
        childName: _Paths.STILL_MASTER,
      ),
    ),
    GetPage(
      name: _Paths.SECONDARY_EVENT_MASTER,
      page: () => const SecondaryEventMasterView(),
      binding: SecondaryEventMasterBinding(),
    ),
    GetPage(
      name: _Paths.FILLER_MASTER,
      page: () => const FillerMasterView(),
      binding: FillerMasterBinding(),
    ),
    GetPage(
      name: _Paths.PROMO_MASTER,
      page: () => const PromoMasterView(),
      binding: PromoMasterBinding(),
    ),
  ];
}
