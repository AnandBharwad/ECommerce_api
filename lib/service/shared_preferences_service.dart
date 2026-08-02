import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  Future<void> saveLogin(bool value) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool("isLoggedIn", value);
  }

  Future<bool> getLogin() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getBool("isLoggedIn") ?? false;
  }

  Future<void> saveData(String name, String password) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString("userName", name);
    await prefs.setString("password", password);
  }

  Future<void> saveAdminData() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString("adminName", "admin");
    await prefs.setString("adminPassword", "admin123");
  }

  Future<(String?, String?)> getAdminData() async {
    final prefs = await SharedPreferences.getInstance();

    String? admin = prefs.getString("adminName");
    String? password = prefs.getString("adminPassword");

    return (admin, password);
  }

  Future<String?> getUserName() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getString("userName");
  }

  Future<String?> getPassword() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getString("password");
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();

    prefs.setBool("isLoggedIn", false);
  }
}
