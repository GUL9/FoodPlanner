import 'package:flutter/cupertino.dart';

bool isKeyboardActive(BuildContext context) {
  return MediaQuery.of(context).viewInsets.bottom != 0;
}
