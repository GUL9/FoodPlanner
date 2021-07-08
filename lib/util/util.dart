import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grocerylister/util/strings.dart';

bool isInputNameFieldOk(BuildContext context, String name, String nameType) {
  if (name.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(nameType + Strings.name_missing)));
    return false;
  }
  return true;
}

bool isInputQuantityFieldOk(BuildContext context, String quantity) {
  if (quantity.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(Strings.missing_quantity)));
    return false;
  }
  if (double.tryParse(quantity) == null) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(Strings.invalid_quantity)));
    return false;
  }
  return true;
}

String indexToDay(int index) {
  switch (index) {
    case 0:
      return Strings.monday + ": ";
    case 1:
      return Strings.tuesday + ": ";
    case 2:
      return Strings.wednesday + ": ";
    case 3:
      return Strings.thursday + ": ";
    case 4:
      return Strings.friday + ": ";
    case 5:
      return Strings.saturday + ": ";
    case 6:
      return Strings.sunday + ": ";
    default:
      return "";
  }
}
