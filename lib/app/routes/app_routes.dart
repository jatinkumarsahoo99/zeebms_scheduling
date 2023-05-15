part of 'app_pages.dart';
// DO NOT EDIT. This is code generated via package:get_cli/get_cli.dart

abstract class Routes {
  Routes._();
  static const HOME = _Paths.HOME;
  static List<String> listRoutes = [];
  static const TRANSMISSION_LOG = _Paths.TRANSMISSION_LOG;
  static const LOG_ADDITIONS = _Paths.LOG_ADDITIONS;
  static const MAM_WORK_ORDERS = _Paths.MAM_WORK_ORDERS;
  static const COMMERCIAL = _Paths.COMMERCIAL;
  static const RO_BOOKING = _Paths.RO_BOOKING;
  static const IMPORT_DIGITEXT_RUN_ORDER = _Paths.IMPORT_DIGITEXT_RUN_ORDER;
  static const FPC_MISMATCH = _Paths.FPC_MISMATCH;
  static const RO_CANCELLATION = _Paths.RO_CANCELLATION;
  static const SPOT_PRIORITY = _Paths.SPOT_PRIORITY;
  static const RO_RESCHEDULE = _Paths.RO_RESCHEDULE;
  static const ROS_DISTRIBUTION = _Paths.ROS_DISTRIBUTION;
  static const FINAL_AUDIT_REPORT_BEFORE_LOG =
      _Paths.FINAL_AUDIT_REPORT_BEFORE_LOG;
  static const FINAL_AUDIT_REPORT_AFTER_TELECAST =
      _Paths.FINAL_AUDIT_REPORT_AFTER_TELECAST;
  static const AUDIT_STATUS = _Paths.AUDIT_STATUS;
}

abstract class RoutesList {
  RoutesList._();
  static List<String> listRoutes = [
    _Paths.HOME,
    _Paths.TRANSMISSION_LOG,
    _Paths.LOG_ADDITIONS,
    _Paths.MAM_WORK_ORDERS,
    _Paths.RO_BOOKING,
    _Paths.FPC_MISMATCH,
    _Paths.COMMERCIAL,
    _Paths.SPOT_PRIORITY,
    _Paths.RO_CANCELLATION,
    _Paths.RO_RESCHEDULE,
    _Paths.ROS_DISTRIBUTION,
    _Paths.IMPORT_DIGITEXT_RUN_ORDER,
  ];
}

abstract class _Paths {
  _Paths._();
  static const HOME = '/home';
  static const TRANSMISSION_LOG = '/frmTransmissionlog';
  static const LOG_ADDITIONS = '/frmAdditions';
  static const MAM_WORK_ORDERS = '/frmMAMWorkOrders';
  static const RO_BOOKING = '/frmROBooking';
  static const IMPORT_DIGITEXT_RUN_ORDER = '/frmBARBRunOrder';
  static const FPC_MISMATCH = '/frmFPCMismatch';
  static const COMMERCIAL = '/frmCommercialScheduling';
  static const RO_CANCELLATION = '/frmROCancellation';
  static const SPOT_PRIORITY = '/frmSpotPriority';
  static const RO_RESCHEDULE = '/frmRoReschedule';
  static const ROS_DISTRIBUTION = '/FrmRosDistribution';
  static const FINAL_AUDIT_REPORT_BEFORE_LOG = '/final-audit-report-before-log';
  static const FINAL_AUDIT_REPORT_AFTER_TELECAST =
      '/final-audit-report-after-telecast';
  static const AUDIT_STATUS = '/audit-status';
}
