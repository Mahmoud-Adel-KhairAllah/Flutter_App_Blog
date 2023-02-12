import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ToastCustom{
  
  static showToast({required BuildContext context,String? content}) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content:  Text(content!),
        // action: SnackBarAction(label: 'UNDO', onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
  }

}