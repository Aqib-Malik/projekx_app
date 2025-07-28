import 'package:get/get.dart';
import 'package:projekx_app/modules/account_module/account_screen.dart';
import 'package:projekx_app/modules/account_module/zccount_binding.dart';
import 'package:projekx_app/modules/project_module/project_binding.dart';
import 'package:projekx_app/modules/project_module/project_list_view.dart';
import 'package:projekx_app/modules/signup/getstarted/getstarted_view.dart';
import 'package:projekx_app/modules/signup/login/login_binding.dart';
import 'package:projekx_app/modules/signup/login/login_view.dart';
import '../modules/signup/signup_view.dart';
import '../modules/signup/signup_binding.dart';

class AppPages {
   static const initial = '/getStarted';

  static final routes = [
    
    GetPage(
      name: '/account',
      page: () => AccountView(),
      binding: AccountBinding(),
    ),
    GetPage(
      name: '/projects',
      page: () => ProjectListView(),
      binding: ProjectBinding(),
    ),
    GetPage(
      name: '/getStarted',
      page: () => const GetStartedView(), 
    ),
    GetPage(
      name: '/signup',
      page: () => SignupView(),
      binding: SignupBinding(),
    ),
    GetPage(
      name: '/login',
      page: () => LoginView(),
      binding: LoginBinding(),
    ),
  ];
}
