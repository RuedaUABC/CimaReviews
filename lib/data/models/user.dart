import 'role.dart';

class User {
  String id;
  String name;
  String email;
  Role role;
  List<Role> roles;
  DateTime? createdAt;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    List<Role>? roles,
    this.createdAt,
  }) : roles = roles ?? [role];

  factory User.fromJson(Map<String, dynamic> json) {
    final rawRoles = json['roles'];
    final parsedRoles = rawRoles is List
        ? rawRoles.map((role) => roleFromApiName(role.toString())).toList()
        : <Role>[UserRole()];

    return User(
      id: json['id'].toString(),
      name: json['name'].toString(),
      email: json['email'].toString(),
      role: parsedRoles.isEmpty ? UserRole() : parsedRoles.first,
      roles: parsedRoles.isEmpty ? <Role>[UserRole()] : parsedRoles,
      createdAt: DateTime.tryParse(json['created_at']?.toString() ?? ''),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'roles': roles.map(roleToApiName).toList(),
      if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
    };
  }
}
