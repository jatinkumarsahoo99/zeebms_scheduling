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
}

abstract class RoutesList {
  RoutesList._();
  static List<String> listRoutes = [
    _Paths.HOME,
    _Paths.TRANSMISSION_LOG,
    _Paths.LOG_ADDITIONS,
    _Paths.MAM_WORK_ORDERS,
  ];
}

abstract class _Paths {
  _Paths._();
  static const HOME = '/home';
  static const TRANSMISSION_LOG = '/transmission-log';
  static const LOG_ADDITIONS = '/log-additions';
  static const MAM_WORK_ORDERS = '/mam-work-orders';
  static const COMMERCIAL = '/commercial';
  static const RO_BOOKING = '/ro-booking';
  static const FILLER = '/filler';
}
