part of 'app_pages.dart';

abstract class Routes {
  Routes._();
  static const SPLASH = _Paths.SPLASH;
  static const WELCOME = _Paths.WELCOME;
  static const LOGIN = _Paths.LOGIN;
  static const HOME = _Paths.HOME;
  static const ADMIN_DASHBOARD = _Paths.ADMIN_DASHBOARD;
  static const ORDER_DETAIL = _Paths.ORDER_DETAIL;
}

abstract class _Paths {
  _Paths._();
  static const SPLASH = '/splash';
  static const WELCOME = '/welcome';
  static const LOGIN = '/login';
  static const HOME = '/home';
  static const ADMIN_DASHBOARD = '/admin-dashboard';
  static const ORDER_DETAIL = '/order-detail';
}