import 'dart:convert';

import 'package:cimareviews/data/models/role.dart';
import 'package:cimareviews/data/models/session.dart';
import 'package:cimareviews/data/models/user.dart';
import 'package:cimareviews/data/services/local_storage_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('LocalStorageService', () {
    test('persists and reloads auth session', () async {
      SharedPreferences.setMockInitialValues({});
      final storage = LocalStorageService.instance;
      await storage.init();
      await storage.clearAuthData();

      final session = Session(
        token: 'jwt-token',
        user: User(
          id: 'user_1',
          name: 'Ana Garcia',
          email: 'ana@example.com',
          role: Seller(),
        ),
        expiresAt: DateTime.now().add(const Duration(hours: 1)),
      );

      await storage.setSession(session);
      await storage.init();

      expect(storage.getToken(), 'jwt-token');
      expect(storage.getSession()?.isValid(), isTrue);
      expect(storage.getSession()?.user.name, 'Ana Garcia');
      expect(storage.getSession()?.user.role, isA<Seller>());
    });

    test('clears expired stored session during init', () async {
      final expiredSession = Session(
        token: 'expired-token',
        user: User(
          id: 'user_1',
          name: 'Ana Garcia',
          email: 'ana@example.com',
          role: UserRole(),
        ),
        expiresAt: DateTime.now().subtract(const Duration(minutes: 1)),
      );
      SharedPreferences.setMockInitialValues({
        'auth_session': jsonEncode(expiredSession.toJson()),
        'auth_token': 'expired-token',
      });

      final storage = LocalStorageService.instance;
      await storage.init();

      expect(storage.getSession(), isNull);
      expect(storage.getToken(), isNull);
    });
  });
}
