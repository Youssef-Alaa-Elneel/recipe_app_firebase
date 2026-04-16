import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // الدالة دي بتعمل ملف لليوزر باسم الـ UID بتاعه
  Future<void> _createUserDocument(User user) async {
    final docRef = _firestore.collection('users').doc(user.uid);
    final docSnap = await docRef.get();

    // لو الملف مش موجود (يوزر جديد)، نكريته
    if (!docSnap.exists) {
      await docRef.set({
        'email': user.email,
        'favorites': [], // دي السلة الفاضية اللي هنحط فيها الفيفوريت بعدين
      });
    }
  }

  // 1. إنشاء حساب جديد (Sign Up)
  Future<UserCredential?> signUp(String email, String password) async {
    UserCredential userCred = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    if (userCred.user != null) {
      await _createUserDocument(userCred.user!);
    }
    return userCred;
  }

  // 2. تسجيل دخول (Login)
  Future<UserCredential?> login(String email, String password) async {
    return await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  // Sign in with Google
  Future<UserCredential?> signInWithGoogle() async {
    try {
      await _googleSignIn.initialize(
        serverClientId:
            "1087128469381-80ddph661rd8jumsve7u3k2bpi6bk7bn.apps.googleusercontent.com",
      );
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await _googleSignIn
          .authenticate();
      if (googleUser == null) return null; // User canceled the sign-in

      // Obtain the  auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );
      // Sign in to Firebase with the Google user credential
      UserCredential userCred = await _auth.signInWithCredential(credential);

      // نتأكد إننا نكريتله ملف لو دي أول مرة يدخل بجوجل
      if (userCred.user != null) {
        await _createUserDocument(userCred.user!);
      }
      return userCred;
    } catch (e) {
      print('Error signing in with Google: $e');

      return null;
    }
  }

  // Sign out from Google
  Future<void> signOutGoogle() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }

  // 4. تسجيل خروج (Logout)
  Future<void> logout() async {
    await _googleSignIn.signOut(); // خروج من جوجل
    await _auth.signOut(); // خروج من فايربيز
  }
}
