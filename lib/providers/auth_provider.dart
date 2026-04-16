import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../data/services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  // فايربيز بيعرف لوحده لو في يوزر متسجل ولا لأ
  bool get isLoggedIn => FirebaseAuth.instance.currentUser != null;

  // الدالة دي بقت بسيطة جداً لأن فايربيز بيحفظ الجلسة أوتوماتيك
  Future<bool> autoLogin() async {
    return isLoggedIn;
  }

  // التسجيل
  Future<void> signUp(String email, String password) async {
    await _authService.signUp(email, password);
    notifyListeners();
  }

  // الدخول
  Future<bool> login(String email, String password) async {
    try {
      await _authService.login(email, password);
      notifyListeners();
      return true;
    } catch (e) {
      return false; // لو الباسوورد غلط أو الحساب مش موجود
    }
  }

  // الدخول بجوجل
  Future<bool> signInWithGoogle() async {
    try {
      final result = await _authService.signInWithGoogle();
      if (result != null) {
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      debugPrint("Google Sign-In Error: $e");
      return false;
    }
  }

  // الخروج
  Future<void> logout() async {
    await _authService.logout();
    notifyListeners();
  }
}
