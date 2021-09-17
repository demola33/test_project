import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'platform_alert_dialog.dart';
import 'package:meta/meta.dart';

class PlatformExceptionAlertDialog extends PlatformAlertDialog {
  PlatformExceptionAlertDialog({
    Key? key,
    @required String? title,
    @required PlatformException? exception,
    VoidCallback? onPressOk,
    VoidCallback? onPressCancel,
  }) : super(
          key: key,
          title: title,
          content: _message(exception!),
          defaultActionText: 'OK',
          onPressOk: onPressOk,
          onPressCancel: onPressCancel,
        );

  static String? _message(PlatformException exception) {
    return _errors[exception.code] ?? exception.message;
  }

  static final Map<String, String> _errors = {
    // "ERROR_MISSING_GOOGLE_AUTH TOKEN": 'Missing Google Auth Token',
    // "ERROR_ABORTED_BY_USER": 'sign in aborted by user',
    // 'failed_to_recover_auth': 'An error has occurred.',
    // 'user_recoverable_auth': 'An error has occurred.',
    'popup_closed_by_user': 'Canceled by user.',
    'server_error': 'Server Error Encountered, Please try again',
    'network_error':
        'You are not connected to the internet. Make sure your Wi-fi/Mobile Data is connected to the internet and try again.',
  };
}
