import 'permission.dart';

abstract class Role {
  List<Permission> permissions;

  Role(this.permissions);

  bool hasPermission(Permission p) {
    return permissions.contains(p);
  }
}

class Admin extends Role {
  Admin() : super([
    Permission.DELETE_ANY_REVIEW,
    Permission.CREATE_BUSINESS,
    Permission.EDIT_ANY_BUSINESS,
    Permission.DELETE_ANY_BUSINESS,
    Permission.BAN_USER,
    Permission.VIEW_ANALYTICS,
  ]);
}