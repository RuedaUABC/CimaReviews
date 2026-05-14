import 'permission.dart';

abstract class Role {
  List<Permission> permissions;

  Role(this.permissions);

  bool hasPermission(Permission p) {
    return permissions.contains(p);
  }
}

class Admin extends Role {
  Admin()
    : super([
        Permission.deleteAnyReview,
        Permission.createBusiness,
        Permission.editAnyBusiness,
        Permission.deleteAnyBusiness,
        Permission.banUser,
        Permission.viewAnalytics,
      ]);
}

class UserRole extends Role {
  UserRole() : super([]);
}

class Moderator extends Role {
  Moderator() : super([Permission.deleteAnyReview, Permission.viewAnalytics]);
}

class Seller extends Role {
  Seller() : super([Permission.createBusiness]);
}
