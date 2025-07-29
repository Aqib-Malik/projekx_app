import 'package:get/get.dart';
import 'package:projekx_app/modules/account_module/account_screen.dart';
import 'package:projekx_app/modules/account_module/zccount_binding.dart';
import 'package:projekx_app/modules/bottom_nav_bar/bottom_nav_bar.dart';
import 'package:projekx_app/modules/project_module/project_binding.dart';
import 'package:projekx_app/modules/project_module/project_list_view.dart';
import 'package:projekx_app/modules/signup/getstarted/getstarted_view.dart';
import 'package:projekx_app/modules/signup/login/login_binding.dart';
import 'package:projekx_app/modules/signup/login/login_view.dart';
import 'package:projekx_app/modules/task_module/my_tasks.dart';
import 'package:projekx_app/modules/task_module/task_binding.dart';
import '../modules/signup/signup_view.dart';
import '../modules/signup/signup_binding.dart';

class AppPages {
   static const initial = '/getStarted';

  static final routes = [

        GetPage(
      name: '/bottomnavbar',
      page: () => MyBottomNavBar(),
    ),
       GetPage(
      name: '/mytask',
      page: () => MyTasksView(),
      binding: TaskBinding(),
    ),
    
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
