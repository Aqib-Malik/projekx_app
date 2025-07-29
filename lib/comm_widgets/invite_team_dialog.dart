import 'package:flutter/material.dart';
import 'package:flutter_animator/widgets/bouncing_entrances/bounce_in.dart';
import 'package:get/get.dart';
import 'package:projekx_app/comm_widgets/custom_snackbar.dart';
import 'package:projekx_app/common/colors.dart';
import 'package:projekx_app/modules/account_module/account_controler.dart';

class InviteTeamDialog extends StatelessWidget {
  const InviteTeamDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final AccountController accountController = Get.find<AccountController>();

    RxBool isLoading = false.obs;
    Rx<Map<String, dynamic>?> foundUser = Rx<Map<String, dynamic>?>(null);

    return BounceIn(
      child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        insetPadding: const EdgeInsets.all(20),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Invite to Team",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 10),
              const Text(
                "Invite members to your team by searching by email. They must already have a Projekx account.",
                style: TextStyle(fontSize: 13, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
      
              /// Show chip when user found, otherwise TextField
              Obx(() => foundUser.value == null
                  ? TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                        hintText: "Search by email",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        prefixIcon: const Icon(Icons.email_outlined),
                      ),
                      keyboardType: TextInputType.emailAddress,
                    )
                  : Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 6, horizontal: 12),
                        decoration: BoxDecoration(
                          color: Colors.green.shade100,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          foundUser.value?['emailtext_text'] ?? '',
                          style: TextStyle(
                            color: Colors.green.shade800,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    )),
              const SizedBox(height: 20),
      
              Obx(() => SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: isLoading.value
                          ? null
                          : () async {
                              final email = emailController.text.trim();
                              if (email.isEmpty && foundUser.value == null) return;
      
                              final currentUserId = accountController.user.value?.id ?? '';
      
                              if (foundUser.value == null) {
                                // 🔍 Search mode
                                isLoading.value = true;
                                final user = await accountController.searchUserByEmail(email);
                                isLoading.value = false;
      
                                if (user != null) {
                                  final teamList = (user['team_list_user'] as List?) ?? [];
                                  final reqList = (user['request_list_user'] as List?) ?? [];
      
                                  if (teamList.contains(currentUserId)) {
                                    customTopSnackbar(Get.context!, "Already in Team",
        "This user is already part of your team.", SnackbarType.success);
                                    
                                  } else if (reqList.contains(currentUserId)) {
                                    customTopSnackbar(Get.context!, "Already Invited",
       "You have already invited this user.", SnackbarType.success);
                                   
                                  } else {
                                    // ✅ not in team & not invited
                                    foundUser.value = user;
                                    emailController.text = user['emailtext_text'] ?? '';
                                  }
                                } else {


                                   customTopSnackbar(Get.context!,  "Not Found",
                                           "No user found with this email.", SnackbarType.error);
                                }
                              } else {
                                // 📩 Invite mode
                                isLoading.value = true;
                                final targetUserId = foundUser.value?['_id'] ?? '';
                                final success = await accountController.inviteUserByAddingRequestList(
                                  targetUserId,
                                  currentUserId,
                                );
                                isLoading.value = false;
      
                                if (success) {
                                  Get.back();
                                   customTopSnackbar(Get.context!,  "Invited",
                                           "${foundUser.value?['emailtext_text']} has been invited!", SnackbarType.success);
                                 
                                } else {

                                  customTopSnackbar(Get.context!,"Failed",
                                           "Failed to send invitation. Try again.", SnackbarType.error);

                                 
                                }
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: isLoading.value
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : Text(
                              foundUser.value == null ? "Search User" : "Invite",
                              style: const TextStyle(color: Colors.white),
                            ),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
