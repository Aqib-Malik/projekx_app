class ProjectModel {
  final String id;
  final String name;
  final String description;
  final String logoUrl;
  final int votesQty;
  final String status;
  final List<String> userIds;   // <-- new field

  ProjectModel({
    required this.id,
    required this.name,
    required this.description,
    required this.logoUrl,
    required this.votesQty,
    required this.status,
    required this.userIds,      // <-- add here
  });

  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    return ProjectModel(
      id: json['_id'],
      name: json['name_text'] ?? '',
      description: _stripBBCode(json['description_text'] ?? ''),
      logoUrl: json['logo_image'] != null
          ? (json['logo_image'].toString().startsWith('//')
              ? "https:${json['logo_image']}"
              : json['logo_image'])
          : '',
      votesQty: json['votesqty_number'] ?? 0,
      status: json['status_option_status'] ?? '',
      userIds: (json['users_list_user'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }

  static String _stripBBCode(String input) {
    final regex = RegExp(r"\[.*?\]");
    return input.replaceAll(regex, '');
  }
}
