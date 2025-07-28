import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projekx_app/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';


class LoginController extends GetxController {
  final email = TextEditingController(text: 'test@gmail.com');
  final password = TextEditingController(text: 'ipfmsXHRDsM3uan@');
  RxBool isPasswordVisible = false.obs;
  RxBool isLoading = false.obs;

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void login() async {
  if (email.text.isEmpty || password.text.isEmpty) {
    Get.snackbar("Error", "Please fill in all fields");
    return;
  }

  isLoading.value = true;

  try {
    final rawResponse = await ApiService.post(
      '/mobile_login',
      {
        "email": email.text.trim(),
        "password": password.text.trim(),
      },
    );

    isLoading.value = false;

    final response = jsonDecode(rawResponse.body);
     
    if (response['status'] == "success") { print("Login successful!");
      final data = response['response'];
      final token = data['token'];
      final userId = data['user_id'];

        
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', token);
        await prefs.setString('user_id', userId);

      print("Login successful!");
      print("Token: $token");
      print("user id: $userId");

      Get.snackbar("Success", "Login successful");
      Get.offAllNamed('/bottomnavbar'); 
    } else {
      print(response);
      Get.snackbar("Error", "Login failed. Please try again");
    }
  } catch (e) {
    isLoading.value = false;
    print("Login error: $e");
    Get.snackbar("Error", "Something went wrong. Please try again.");
  }
}

  @override
  void onClose() {
    email.dispose();
    password.dispose();
    super.onClose();
  }
}
