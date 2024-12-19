import 'package:get/get.dart';
import 'package:lesehan/app/modules/home/views/Splash_View.dart';
import 'package:lesehan/app/modules/home/views/WelcomeView.dart';
import 'package:lesehan/app/modules/home/views/login_view.dart';
import 'package:lesehan/app/modules/home/views/home_view.dart';
import 'package:lesehan/app/modules/home/views/admin_dashboard.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/older_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = _Paths.SPLASH;

  static final routes = [
    GetPage(
      name: _Paths.SPLASH,
      page: () => SplashView(),
    ),
    GetPage(
      name: _Paths.WELCOME,
      page: () => WelcomeView(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => LoginView(),
    ),
    GetPage(
      name: _Paths.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.ADMIN_DASHBOARD,
      page: () => AdminDashboardView(),
    ),
    GetPage(
      name: _Paths.ORDER_DETAIL,
      page: () => OlderView(),
    ),
  ];
}
