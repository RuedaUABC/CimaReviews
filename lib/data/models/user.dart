import 'role.dart';  

class User {
  String id;
  String name;
  String email;
  Role role;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
  });
}
