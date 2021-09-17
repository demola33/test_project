import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test_project/app/screens/screen_manager/sign_in_screen_view_model.dart';
import 'package:flutter_test_project/common/platform_exception_alert_dialog.dart';
import 'package:flutter_test_project/services/auth.dart';
import 'package:provider/provider.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({Key? key, @required this.manager, required this.isLoading})
      : super(key: key);
  final SignInScreenManager? manager;
  final bool isLoading;

  static Widget create(BuildContext context) {
    var auth = Provider.of<Auth>(context);
    return ChangeNotifierProvider<ValueNotifier<bool>>(
      create: (context) => ValueNotifier(false),
      child: Consumer<ValueNotifier<bool>>(
        builder: (_, _isLoading, __) => Provider(
          create: (_) => SignInScreenManager(auth, _isLoading),
          child: Consumer<SignInScreenManager>(
            builder: (_, manager, __) =>
                SignInPage(manager: manager, isLoading: _isLoading.value),
          ),
        ),
      ),
    );
  }

  void _showSignInError(BuildContext context, PlatformException exception) {
    PlatformExceptionAlertDialog(
      title: 'Sign in failed',
      exception: exception,
    ).show(context);
  }

  Future<void> _signInWithGoogle(BuildContext context) async {
    try {
      await manager?.signInWithGoogle();
    } on PlatformException catch (exception) {
      if (exception.code != "ERROR_ABORTED_BY_USER") {
        _showSignInError(context, exception);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Color.fromRGBO(66, 150, 152, 0.8),
              Color.fromRGBO(255, 228, 115, 1),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Welcome',
                style: Theme.of(context).textTheme.bodyText1,
              ),
              Text(
                'Login to continue to app',
                style: Theme.of(context).textTheme.bodyText2,
              ),
              const SizedBox(height: 30),
              if (isLoading) const LinearProgressIndicator(),
              ElevatedButton(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset('assets/images/google-logo.png'),
                    Text(
                      'Sign in with Google',
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                    Opacity(
                      opacity: 0.0,
                      child: Image.asset('assets/images/google-logo.png'),
                    )
                  ],
                ),
                onPressed: () => _signInWithGoogle(context),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
