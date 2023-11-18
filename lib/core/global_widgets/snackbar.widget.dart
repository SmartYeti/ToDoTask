import 'package:flutter/material.dart';

class SnackBarUtils {
  static void defualtSnackBar(String? message, BuildContext context) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    final SnackBar snackBar = SnackBar(content: Text(message ?? ''));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);

    
  }
}
