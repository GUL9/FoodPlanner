import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grocerylister/util/strings.dart';

class InputValidator {
  static bool isIngredientNameFieldOk(BuildContext context, String name) {
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(Strings.missing_ingredient_name)));
      return false;
    }
    return true;
  }

  static bool isRecipeNameFieldOk(BuildContext context, String name) {
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(Strings.missing_recipe_name)));
      return false;
    }
    return true;
  }

  static bool isQuantityFieldOk(BuildContext context, String quantity) {
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
}

String indexToDayString(int index) {
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
