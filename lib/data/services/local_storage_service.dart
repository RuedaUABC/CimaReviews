import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/session.dart';
import '../models/user.dart';

class LocalStorageService {
  LocalStorageService._();

  static final LocalStorageService instance = LocalStorageService._();
  static const _sessionKey = 'auth_session';
  static const _tokenKey = 'auth_token';

  SharedPreferences? _prefs;
  Session? _session;
  User? _user;
  String? _token;

  Future<void> init() async {
    try {
      _prefs = await SharedPreferences.getInstance();
      await _loadSession();
    } on MissingPluginException {
      _prefs = null;
      _session = null;
      _user = null;
      _token = null;
    }
  }

  Future<void> setToken(String token) async {
    _token = token;
    await _prefs?.setString(_tokenKey, token);
  }

  String? getToken() => _token;

  Future<void> setUser(User user) async {
    _user = user;
  }

  User? getUser() => _user;

  Future<void> setSession(Session session) async {
    _session = session;
    _user = session.user;
    _token = session.token;
    await _prefs?.setString(_sessionKey, jsonEncode(session.toJson()));
    await _prefs?.setString(_tokenKey, session.token);
  }

  Session? getSession() => _session;

  Future<void> clear() async {
    _session = null;
    _user = null;
    _token = null;
    await _prefs?.remove(_sessionKey);
    await _prefs?.remove(_tokenKey);
  }

  Future<void> clearAuthData() => clear();

  Future<void> _loadSession() async {
    _token = _prefs?.getString(_tokenKey);

    final rawSession = _prefs?.getString(_sessionKey);
    if (rawSession == null || rawSession.isEmpty) {
      return;
    }

    try {
      final decoded = jsonDecode(rawSession);
      if (decoded is! Map) {
        return;
      }

      final session = Session.fromJson(Map<String, dynamic>.from(decoded));
      if (!session.isValid()) {
        await clearAuthData();
        return;
      }

      _session = session;
      _user = session.user;
      _token = session.token;
    } on FormatException {
      await clearAuthData();
    } on TypeError {
      await clearAuthData();
    }
  }
}
