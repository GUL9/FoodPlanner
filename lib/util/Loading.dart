import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grocerylister/Views/Components/LoadingDialog.dart';

class Loader {
  static Future<dynamic> show({BuildContext context, Future showWhile}) {
    return showDialog(barrierDismissible: false, context: context, builder: (_) => LoadingDialog(showWhile: showWhile));
  }
}
