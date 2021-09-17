import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test_project/model/custom_user.dart';
import 'package:flutter_test_project/model/level.dart';
import 'package:flutter_test_project/services/database.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Auth {
  final _firebaseAuth = FirebaseAuth.instance;

  CustomUser? _userFromFirebase(User? user) {
    if (user == null) {
      return null;
    }
    return CustomUser(
      uid: user.uid,
      photoUrl: user.photoURL ?? '',
      displayName: user.displayName ?? '',
      email: user.email ?? '',
    );
  }

  Stream<CustomUser?> get authStateChanges {
    Stream<CustomUser?> customUserStream =
        _firebaseAuth.authStateChanges().map(_userFromFirebase);
    return customUserStream;
  }

  Future<CustomUser?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;
        final UserCredential? userCredential =
            await _firebaseAuth.signInWithCredential(
          GoogleAuthProvider.credential(
            accessToken: googleAuth.accessToken,
            idToken: googleAuth.idToken,
          ),
        );
        CustomUser? userProfile = _userFromFirebase(userCredential?.user);
        if (userCredential!.additionalUserInfo!.isNewUser) {
          final level = Level(level: '0');
          await FirestoreDatabase(userProfile!.uid).setLevel(level);
        }
        return userProfile;
      } else {
        throw PlatformException(
          code: "ERROR_ABORTED_BY_USER",
          message: 'sign in aborted by user',
        );
      }
    } on PlatformException catch (e) {
      throw PlatformException(
        code: e.code,
        message: e.message,
      );
    }
  }

  Future<void> signOut() async {
    try {
      await GoogleSignIn().signOut();
      return await _firebaseAuth.signOut();
    } on PlatformException catch (e) {
      throw PlatformException(
        code: e.code,
        message: e.message,
      );
    }
  }
}
