import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test_project/common/platform_widget.dart';

class PlatformAlertDialog extends PlatformWidget {
  final String? title;
  final dynamic content;
  final String? defaultActionText;
  final String? cancelActionText;
  final VoidCallback? onPressOk;
  final VoidCallback? onPressCancel;

  const PlatformAlertDialog({
    Key? key,
    @required this.title,
    @required this.content,
    this.onPressOk,
    this.onPressCancel,
    this.cancelActionText,
    @required this.defaultActionText,
    exception,
  })  : assert(title != null),
        assert(content != null),
        assert(defaultActionText != null),
        super(key: key);

  Future<bool?> show(BuildContext context) async {
    return Platform.isIOS
        ? await showCupertinoDialog<bool>(
            context: context,
            builder: (context) => this,
          )
        : await showDialog<bool>(
            context: context,
            barrierDismissible: false,
            builder: (context) => this,
          );
  }

  @override
  Widget buildCupertinoWidget(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(
        title!,
      ),
      content: Text(
        content,
      ),
      actions: _buildActions(context),
    );
  }

  @override
  Widget buildMaterialWidget(BuildContext context) {
    return AlertDialog(
      title: Text(
        title!,
      ),
      content: Text(
        content,
      ),
      actions: _buildActions(context),
    );
  }

  List<Widget> _buildActions(BuildContext context) {
    final actions = <Widget>[];
    if (cancelActionText != null) {
      actions.add(PlatformAlertDialogAction(
        press: onPressCancel ?? () => Navigator.of(context).pop(false),
        child: Text(
          cancelActionText!,
        ),
      ));
    }
    actions.add(PlatformAlertDialogAction(
      press: onPressOk ?? () => Navigator.of(context).pop(true),
      child: Text(
        defaultActionText!,
      ),
    ));
    return actions;
  }
}

class PlatformAlertDialogAction extends PlatformWidget {
  final Widget? child;
  final VoidCallback? press;

  const PlatformAlertDialogAction({
    Key? key,
    @required this.child,
    @required this.press,
  }) : super(key: key);

  @override
  Widget buildCupertinoWidget(BuildContext context) {
    return CupertinoDialogAction(
      child: child!,
      onPressed: press,
    );
  }

  @override
  Widget buildMaterialWidget(BuildContext context) {
    return TextButton(
      child: child!,
      onPressed: press,
    );
  }
}
