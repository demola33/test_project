// ignore_for_file: unnecessary_getters_setters

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test_project/model/level.dart';
import 'package:flutter_test_project/services/auth.dart';
import 'package:flutter_test_project/services/database.dart';
import 'package:provider/provider.dart';

class HomeScreenViewModel extends ChangeNotifier {
  int _userLevel = 0;

  //check if level is less <= 0
  bool _invalidValue() {
    if (_userLevel <= 0) {
      return true;
    }
    return false;
  }

  // a setter for the level
  set level(int value) {
    _userLevel = value;
  }

  //a getter for the level
  int get level {
    return _userLevel;
  }

  // increase the level
  void incrementLevel(BuildContext context) {
    _userLevel += 1;
    notifyListeners();
  }

  // decrease the level
  void decrementLevel(BuildContext context) {
    if (_invalidValue()) {
      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(
            const SnackBar(content: Text('Level cannot be negative!')));
    } else {
      _userLevel -= 1;
      notifyListeners();
    }
  }

  // save current level
  void submit(BuildContext context) async {
    final database = Provider.of<FirestoreDatabase>(context, listen: false);
    final level = Level(level: _userLevel.toString());
    try {
      await database.setLevel(level).whenComplete(() {
        ScaffoldMessenger.of(context)
          ..removeCurrentSnackBar()
          ..showSnackBar(const SnackBar(content: Text('Saved Successfully!')));
      });
    } catch (e) {
      print('SubmitErr: ${e.toString()}');
    }
  }

  // sign current user out
  Future<void> signOut(BuildContext context) async {
    final auth = context.read<Auth>();
    try {
      await auth.signOut();
    } catch (e) {
      print('Error: ${e.toString()}');
      rethrow;
    }
  }
}
