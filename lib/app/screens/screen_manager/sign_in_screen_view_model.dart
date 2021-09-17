import 'package:flutter/cupertino.dart';
import 'package:flutter_test_project/model/custom_user.dart';
import 'package:flutter_test_project/services/auth.dart';

class SignInScreenManager {
  SignInScreenManager(this.auth, this.isLoading);
  final Auth auth;

  final ValueNotifier<bool> isLoading;
  //sign user in
  Future<CustomUser?> signInWithGoogle() async {
    isLoading.value = true;
    try {
      var user = await auth.signInWithGoogle();
      return user;
    } catch (e) {
      isLoading.value = false;
      print('Error: ${e.toString()}');
      rethrow;
    }
  }
}
