import 'package:get/get.dart';
import 'package:projekx_app/modules/account_module/account_controler.dart';

class AccountBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AccountController());
  }
}
