import 'package:flutter/material.dart';
import 'package:flutter_test_project/app/screens/home_screen.dart';
import 'package:flutter_test_project/app/screens/sign_in_screen.dart';
import 'package:flutter_test_project/model/custom_user.dart';
import 'package:flutter_test_project/services/auth.dart';
import 'package:flutter_test_project/services/database.dart';
import 'package:provider/provider.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<CustomUser?>(
      stream: context.read<Auth>().authStateChanges,
      builder: (context, snapshot) {
        CustomUser? user = snapshot.data;
        if (user == null) {
          return SignInPage.create(context);
        }
        return MultiProvider(
          providers: [
            Provider.value(value: user),
            Provider<FirestoreDatabase>(
              create: (_) => FirestoreDatabase(user.uid),
            )
          ],
          child: HomePage.create(context),
        );
      },
    );
  }
}
