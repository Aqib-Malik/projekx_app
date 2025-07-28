import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:projekx_app/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountController extends GetxController {
  Rx<UserModel?> user = Rx<UserModel?>(null);
  RxList<UserModel> myTeam = <UserModel>[].obs;
  RxList<UserModel> invitesReceived = <UserModel>[].obs;
  var total_projec = ''.obs;
  var total_tasks = 0.obs;

  @override
  void onInit() {
    super.onInit();
    getCurrentUser();
  }

  Future<void> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('user_id') ?? '';
    if (userId.isNotEmpty) {
      await fetchUser(userId);
    } else {
      print('⚠ No user_id found in SharedPreferences');
    }
  }

  Future<void> fetchUser(String userId) async {
    final url = Uri.parse('https://projekx.bubbleapps.io/api/1.1/obj/user/$userId');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)['response'];
        user.value = UserModel.fromJson(data);

        List<dynamic> teamIds = data['team_list_user'] ?? [];
        List<dynamic> requestIds = data['request_list_user'] ?? [];

        await fetchUsersByIds(teamIds, isTeam: true);
        await fetchUsersByIds(requestIds, isTeam: false);
      } else {
        print('❌ Failed to fetch user. Status: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error fetching user: $e');
    }
  }

  Future<void> fetchUsersByIds(List<dynamic> ids, {required bool isTeam}) async {
    final prefs = await SharedPreferences.getInstance();
    final apiKey = prefs.getString('auth_token') ?? '';

    if (ids.isEmpty || apiKey.isEmpty) {
      print('ℹ Nothing to fetch or missing token');
      if (isTeam) myTeam.clear(); else invitesReceived.clear();
      return;
    }

    List<UserModel> fetchedUsers = [];
    for (var id in ids) {
      final url = Uri.parse('https://projekx.bubbleapps.io/api/1.1/obj/user/$id');
      try {
        final response = await http.get(url, headers: {
          'Authorization': 'Bearer $apiKey',
          'Content-Type': 'application/json',
        });
        if (response.statusCode == 200) {
          final data = jsonDecode(response.body)['response'];
          fetchedUsers.add(UserModel.fromJson(data));
        } else {
          print('❌ Failed to fetch user by id: $id');
        }
      } catch (e) {
        print('❌ Error fetching user by id: $e');
      }
    }

    if (isTeam) {
      myTeam.assignAll(fetchedUsers);
    } else {
      invitesReceived.assignAll(fetchedUsers);
    }
  }

  /// ✅ Accept invite: remove sender from request_list_user, add sender to our team, and add our id to sender's team
  Future<bool> acceptInvite(String senderUserId) async {
    final prefs = await SharedPreferences.getInstance();
    final apiKey = prefs.getString('auth_token') ?? '';
    final currentUserId = prefs.getString('user_id') ?? '';
    if (apiKey.isEmpty || currentUserId.isEmpty) return false;

    try {
      /// Step 1: fetch current user to get request_list_user & team_list_user
      final urlCurrent = Uri.parse('https://projekx.bubbleapps.io/api/1.1/obj/user/$currentUserId');
      final resCurrent = await http.get(urlCurrent);
      if (resCurrent.statusCode != 200) return false;
      final currentData = jsonDecode(resCurrent.body)['response'];
      List<String> requests = List<String>.from(currentData['request_list_user'] ?? []);
      List<String> team = List<String>.from(currentData['team_list_user'] ?? []);

      requests.remove(senderUserId);
      if (!team.contains(senderUserId)) team.add(senderUserId);

      /// Step 2: PATCH current user
      await http.patch(
        urlCurrent,
        headers: {'Authorization': 'Bearer $apiKey', 'Content-Type': 'application/json'},
        body: jsonEncode({
          'request_list_user': requests,
          'team_list_user': team,
        }),
      );

      /// Step 3: fetch sender user to get team_list_user
      final urlSender = Uri.parse('https://projekx.bubbleapps.io/api/1.1/obj/user/$senderUserId');
      final resSender = await http.get(urlSender);
      if (resSender.statusCode != 200) return false;
      final senderData = jsonDecode(resSender.body)['response'];
      List<String> senderTeam = List<String>.from(senderData['team_list_user'] ?? []);

      if (!senderTeam.contains(currentUserId)) senderTeam.add(currentUserId);

      /// Step 4: PATCH sender user
      await http.patch(
        urlSender,
        headers: {'Authorization': 'Bearer $apiKey', 'Content-Type': 'application/json'},
        body: jsonEncode({
          'team_list_user': senderTeam,
        }),
      );

      print('✅ Invite accepted');
      await getCurrentUser(); // refresh UI
      return true;
    } catch (e) {
      print('❌ Error accepting invite: $e');
      return false;
    }
  }

  /// ✅ Reject invite: remove sender id from request_list_user
  Future<bool> rejectInvite(String senderUserId) async {
    final prefs = await SharedPreferences.getInstance();
    final apiKey = prefs.getString('auth_token') ?? '';
    final currentUserId = prefs.getString('user_id') ?? '';
    if (apiKey.isEmpty || currentUserId.isEmpty) return false;

    try {
      /// Fetch current user to get request_list_user
      final url = Uri.parse('https://projekx.bubbleapps.io/api/1.1/obj/user/$currentUserId');
      final res = await http.get(url);
      if (res.statusCode != 200) return false;
      final data = jsonDecode(res.body)['response'];
      List<String> requests = List<String>.from(data['request_list_user'] ?? []);
      requests.remove(senderUserId);

      /// PATCH updated list
      await http.patch(
        url,
        headers: {'Authorization': 'Bearer $apiKey', 'Content-Type': 'application/json'},
        body: jsonEncode({'request_list_user': requests}),
      );

      print('✅ Invite rejected');
      await getCurrentUser(); // refresh UI
      return true;
    } catch (e) {
      print('❌ Error rejecting invite: $e');
      return false;
    }
  }
  /// Search user by email using constraints
  Future<Map<String, dynamic>?> searchUserByEmail(String email) async {
    final prefs = await SharedPreferences.getInstance();
    final apiKey = prefs.getString('auth_token') ?? ''; // dynamically stored token

    if (apiKey.isEmpty) {
      print('⚠ No auth_token found in SharedPreferences');
      return null;
    }

    final url = Uri.parse(
      'https://projekx.bubbleapps.io/api/1.1/obj/user'
      '?constraints=[{"key":"emailtext_text","constraint_type":"equals","value":"$email"}]'
    );

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $apiKey',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)['response']['results'];
        if (data != null && data.isNotEmpty) {
          print('✅ User found: ${data[0]}');
          return data[0];
        } else {
          print('⚠ User not found with email: $email');
        }
      } else {
        print('❌ Failed to search user. Status: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error searching user: $e');
    }

    return null;
  }



  Future<bool> sendInviteToUser(String searchedUserId) async {
  final prefs = await SharedPreferences.getInstance();
  final apiKey = prefs.getString('auth_token') ?? '';
  final currentUserId = prefs.getString('user_id') ?? '';

  if (apiKey.isEmpty || currentUserId.isEmpty) {
    print('⚠ auth_token or user_id missing');
    return false;
  }

  final url = Uri.parse('https://projekx.bubbleapps.io/api/1.1/obj/user/$searchedUserId');

  try {
    final response = await http.patch(
      url,
      headers: {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "request_list_user": [currentUserId]
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 204) {
      print('✅ Invite sent successfully');
      return true;
    } else {
      print('❌ Failed to send invite. Status: ${response.statusCode}');
      return false;
    }
  } catch (e) {
    print('❌ Error sending invite: $e');
    return false;
  }
}



/// Patch request: add currentUserId to searched user's request_list_user
Future<bool> inviteUserByAddingRequestList(String targetUserId, String currentUserId) async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final apiKey = prefs.getString('auth_token') ?? '';

    final url = Uri.parse('https://projekx.bubbleapps.io/api/1.1/obj/user/$targetUserId');

    final body = jsonEncode({
      "request_list_user": [currentUserId]
    });

    final response = await http.patch(
      url,
      headers: {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
      },
      body: body,
    );

    if (response.statusCode == 204) {
      print('✅ Invitation sent.');
      return true;
    } else {
      print('❌ Failed to invite. Status: ${response.statusCode}');
    }
  } catch (e) {
    print('❌ Error sending invite: $e');
  }
  return false;
}



/// Fetch user by id for viewing details (used in team member dialog)
Future<UserModel?> fetchUserById(String userId) async {
  try {
    final url = Uri.parse('https://projekx.bubbleapps.io/api/1.1/obj/user/$userId');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['response'];
      return UserModel.fromJson(data);
    } else {
      print('❌ Failed to fetch user by id. Status: ${response.statusCode}');
    }
  } catch (e) {
    print('❌ Error fetching user by id: $e');
  }
  return null;
}



}
