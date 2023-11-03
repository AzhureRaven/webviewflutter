import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/account.dart';

class SecuredStorage extends ChangeNotifier {
  // Static instance
  static final SecuredStorage _instance = SecuredStorage._internal();
  factory SecuredStorage() => _instance;
  SecuredStorage._internal();

  late FlutterSecureStorage _storage;
  // preference keys
  static const _ACC_KEY = 'acc';
  static const _USER_KEY = 'user';
  static const _PASS_KEY = 'pass';
  static const _EXP_KEY = 'exp';
  // runtime variables
  String _user = '';
  String _pass = '';
  late DateTime _exp;
  Account? data;
  // constants
  static const _MILLISECOND = 86400000;
  static const _EXP_LENGTH = 3 * _MILLISECOND; // 3 days

  Future<void> initialize() async {
    _storage = const FlutterSecureStorage();
    _user = await _storage.read(key: _USER_KEY) ?? '';
    _pass = await _storage.read(key: _PASS_KEY) ?? '';
    data = await _getAccount();
    _exp = DateTime.fromMillisecondsSinceEpoch(int.parse(await _storage.read(key: _EXP_KEY) ?? '0'));
    checkExpiry();
  }

  bool isEmpty() {
    return data == null;
  }

  String getPass(){
    return _pass;
  }

  Future<void> setSession(String username, String password, Account account) async {
    data = account;
    _user = username;
    _pass = password;
    _exp = DateTime.now().add(Duration(milliseconds: _EXP_LENGTH));

    await _storage.write(key: _USER_KEY, value: _user);
    await _storage.write(key: _PASS_KEY, value: _pass);
    await _setAccount(account);
    await _storage.write(key: _EXP_KEY, value: _exp.millisecondsSinceEpoch.toString());
  }

  Future<void> changePassword(String password) async {
    _pass = password;
    await _storage.write(key: _PASS_KEY, value: _pass);
  }

  Future<void> removeSession() async {
    await _storage.deleteAll();
    _user = '';
    _pass = '';
    _exp = DateTime.fromMillisecondsSinceEpoch(0);
    data = null;
  }

  Future<void> checkExpiry() async {
    if (DateTime.now().isAfter(_exp)) await removeSession();
  }

  _setAccount(Account account) async {
    final json = jsonEncode(account.toJson());
    await _storage.write(key: _ACC_KEY, value: json);
  }

  Future<Account?> _getAccount() async {
    final json = await _storage.read(key: _ACC_KEY);
    if (json != null) {
      return Account.fromJson(jsonDecode(json));
    } else {
      return null;
    }
  }
}
