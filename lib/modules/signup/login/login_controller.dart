import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projekx_app/comm_widgets/custom_snackbar.dart';
import 'package:projekx_app/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginController extends GetxController {
  final email = TextEditingController(text: 'test2@gmail.com');
  final password = TextEditingController(text: 'ipfmsXHRDsM3uan@');
  RxBool isPasswordVisible = false.obs;
  RxBool isLoading = false.obs;

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void login() async {
    if (email.text.isEmpty || password.text.isEmpty) {
      customTopSnackbar(
        Get.context!,
        "Error",
        "Please fill in all fields",
        SnackbarType.error,
      );
      return;
    }

    isLoading.value = true;

    try {
      final rawResponse = await ApiService.post('/mobile_login', {
        "email": email.text.trim(),
        "password": password.text.trim(),
      });

      isLoading.value = false;

      final response = jsonDecode(rawResponse.body);

      if (response['status'] == "success") {
        print("Login successful!");
        final data = response['response'];
        final token = data['token'];
        final userId = data['user_id'];

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', token);
        await prefs.setString('user_id', userId);

        print("Login successful!");
        print("Token: $token");
        print("user id: $userId");

        customTopSnackbar(
          Get.context!,
          "Success",
          "Login successful",
          SnackbarType.success,
        );
        Get.offAllNamed('/bottomnavbar');
      } else {
        print(response);

        customTopSnackbar(
          Get.context!,
          "Error",
          "Login failed. Please try again",
          SnackbarType.error,
        );
      }
    } catch (e) {
      isLoading.value = false;
      print("Login error: $e");
      customTopSnackbar(
        Get.context!,
        "Error",
        "Something went wrong. Please try again.",
        SnackbarType.error,
      );
    }
  }

  @override
  void onClose() {
    email.dispose();
    password.dispose();
    super.onClose();
  }
}
