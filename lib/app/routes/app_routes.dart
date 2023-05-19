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
  static const FILLER = _Paths.FILLER;
  static const PROMOS = _Paths.PROMOS;
  static const IMPORT_DIGITEXT_RUN_ORDER = _Paths.IMPORT_DIGITEXT_RUN_ORDER;
  static const FPC_MISMATCH = _Paths.FPC_MISMATCH;
  static const RO_CANCELLATION = _Paths.RO_CANCELLATION;
  static const SPOT_PRIORITY = _Paths.SPOT_PRIORITY;
  static const EVENT_SECONDARY = _Paths.EVENT_SECONDARY;
  static const SLIDE = _Paths.SLIDE;
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
    _Paths.COMMERCIAL
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
  static const COMMERCIAL = '/commercial';
  //static const RO_BOOKING = '/ro-booking';
  static const FILLER = '/filler';
  static const PROMOS = '/promos';
  static const RO_CANCELLATION = '/ro-cancellation';
  static const SPOT_PRIORITY = '/frmSpotPriority';
  static const EVENT_SECONDARY = '/event-secondary';
  static const SLIDE = '/slide';
}
