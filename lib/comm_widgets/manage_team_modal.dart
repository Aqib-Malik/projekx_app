import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projekx_app/comm_widgets/empty_state_widget.dart';
import 'package:projekx_app/comm_widgets/user_tile.dart';
import 'package:projekx_app/common/colors.dart';
import 'package:projekx_app/modules/account_module/account_controler.dart';
import 'package:projekx_app/models/user.dart';

class ManageTeamModal extends StatefulWidget {
  const ManageTeamModal({super.key});

  @override
  State<ManageTeamModal> createState() => _ManageTeamModalState();
}

class _ManageTeamModalState extends State<ManageTeamModal> {
  @override
  Widget build(BuildContext context) {
    final AccountController controller = Get.find<AccountController>();

    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Manage Team',
                style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600,fontSize: 24),
              ),
              const SizedBox(height: 16),
        
              DefaultTabController(
                length: 2,
                child: Expanded(
                  child: Column(
                    children: [
                      TabBar(
                        labelColor: AppColors.primary,
                        unselectedLabelColor: Colors.grey,
                        indicatorColor: AppColors.primary,
                        tabs: const [
                          Tab(text: 'My Team'),
                          Tab(text: 'Invite Received'),
                        ],
                      ),
                      const SizedBox(height: 12),
        
                      Expanded(
                        child: TabBarView(
                          children: [
                            /// My Team Tab
                            Obx(() => controller.myTeam.isEmpty
                                ? buildEmptyState(context,'No team members yet.')
                                : ListView.builder(
                                    itemCount: controller.myTeam.length,
                                    itemBuilder: (context, index) {
                                      UserModel user = controller.myTeam[index];
                                      return buildUserTile(user);
                                    },
                                  )),
        
                            /// Invite Received Tab
                            // Inside TabBarView > inviteReceived tab
        Obx(() => controller.invitesReceived.isEmpty
            ? buildEmptyState(context,'No invites received yet.')
            : ListView.builder(
          itemCount: controller.invitesReceived.length,
          itemBuilder: (context, index) {
            final user = controller.invitesReceived[index];
            return _buildInviteCard(user, controller);
            //  Card(
            //   margin: const EdgeInsets.symmetric(vertical: 6),
            //   child: ListTile(
            //     leading: CircleAvatar(
            //       backgroundImage: user.avatarUrl != null ? NetworkImage(user.avatarUrl!) : null,
            //       child: user.avatarUrl == null ? const Icon(Icons.person) : null,
            //     ),
            //     title: Text(user.name),
            //     subtitle: Text(user.email),
            //     trailing: Wrap(
            //       spacing: 8,
            //       children: [
            //         IconButton(
            //           icon: const Icon(Icons.check_circle, color: Colors.green),
            //           onPressed: () async {
            //             await controller.acceptInvite(user.id);
            //           },
            //         ),
            //         IconButton(
            //           icon: const Icon(Icons.cancel, color: Colors.red),
            //           onPressed: () async {
            //             await controller.rejectInvite(user.id);
            //           },
            //         ),
            //       ],
            //     ),
            //   ),
            // );
          },
        ))
        
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

 /// Invite card with Accept / Reject buttons
Widget _buildInviteCard(UserModel user,controller) {
  return Card(
    elevation: 2,
    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 26,
            backgroundImage: user.avatarUrl != null
                ? NetworkImage(user.avatarUrl!)
                : null,
            backgroundColor: Colors.grey.shade200,
            child:  Icon(Icons.person, color: Colors.grey, size: 26)
               
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  user.email,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Row(
            children: [
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: Colors.green.shade50,
                  foregroundColor: Colors.green.shade700,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  textStyle: const TextStyle(fontSize: 12),
                ),
                onPressed: ()async {
                 await controller.acceptInvite(user.id);
                },
                icon: const Icon(Icons.check, size: 16),
                label: const Text("Accept"),
              ),
              const SizedBox(width: 8),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: Colors.red.shade50,
                  foregroundColor: Colors.red.shade700,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  textStyle: const TextStyle(fontSize: 12),
                ),
                onPressed: ()async {
                  await controller.rejectInvite(user.id);
                },
                icon: const Icon(Icons.close, size: 16),
                label: const Text("Reject"),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

}
