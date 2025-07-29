import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:projekx_app/comm_widgets/custom_snackbar.dart';
import 'dart:convert';
import 'package:projekx_app/common/constants.dart';

import '../../services/api_service.dart';

class SignupController extends GetxController {
  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final email = TextEditingController();
  final company = TextEditingController();
  final password = TextEditingController();
  final confirmPassword = TextEditingController();

  RxBool isPasswordVisible = false.obs;
  RxBool isConfirmVisible = false.obs;

  void togglePasswordVisibility() => isPasswordVisible.value = !isPasswordVisible.value;
  void toggleConfirmVisibility() => isConfirmVisible.value = !isConfirmVisible.value;

  void submit() async {
    if (password.text != confirmPassword.text) {
      
      customTopSnackbar(
                      Get.context!,
                      "Error",
                      "Passwords do not match",
                      SnackbarType.error,
                    );
      return;
    }

    final payload = {
      "email": email.text.trim(),
      "password": password.text,
      "first_name": firstName.text.trim(),
      "last_name": lastName.text.trim(),
      "company": company.text.trim(),
    };

    try {
      final response = await ApiService.post('/mobile_signup', payload);
      final data = jsonDecode(response.body);
print(data);
      if (response.statusCode == 200 && data["response"] != null) {
        customTopSnackbar(
                      Get.context!,
                      "Success",
                      "Account created successfully!",
                      SnackbarType.success,
                    );
      } else {
        print("Signup failed: ${data["message"]}");
        Get.snackbar("Signup Failed", data["message"] ?? "Something went wrong");

        customTopSnackbar(
                      Get.context!,
                      "Success",
                      "Account created successfully!",
                      SnackbarType.error,
                    );
      }
    } catch (e) {
      print("Signup error: $e");
      Get.snackbar("Error", "An error occurred: $e");
    }
  }

  @override
  void onClose() {
    firstName.dispose();
    lastName.dispose();
    email.dispose();
    company.dispose();
    password.dispose();
    confirmPassword.dispose();
    super.onClose();
  }
}
