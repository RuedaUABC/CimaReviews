import '../models/user.dart';
import '../models/session.dart';

class UserRepository {
  Session login(String email, String pass) {
    throw UnimplementedError();
  }

  void logout() {
  }

  User getUser(String id) {
    throw UnimplementedError();
  }

  void registerUser(User u) {
  }
}