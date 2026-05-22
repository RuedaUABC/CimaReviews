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

Role roleFromApiName(String value) {
  switch (value.toUpperCase()) {
    case 'ADMIN':
      return Admin();
    case 'MODERATOR':
      return Moderator();
    case 'SELLER':
      return Seller();
    case 'CUSTOMER':
    default:
      return UserRole();
  }
}

String roleToApiName(Role role) {
  if (role is Admin) {
    return 'ADMIN';
  }
  if (role is Moderator) {
    return 'MODERATOR';
  }
  if (role is Seller) {
    return 'SELLER';
  }
  return 'CUSTOMER';
}

String roleDisplayName(Role role) {
  if (role is Admin) {
    return 'Administrador';
  }
  if (role is Moderator) {
    return 'Moderador';
  }
  if (role is Seller) {
    return 'Vendedor';
  }
  return 'Cliente';
}
