import 'package:flutter/material.dart' show Colors;
import 'package:fluttertoast/fluttertoast.dart';

class ShowToast {
  static void showEror(String message) {
    Fluttertoast.showToast(
      msg: message,
      backgroundColor: Colors.red,
      textColor: Colors.white,
    );
  }

  static void showSuccess(String message) {
    Fluttertoast.showToast(
      msg: message,
      backgroundColor: Colors.green,
      textColor: Colors.white,
    );
  }
}
