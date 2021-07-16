import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grocerylister/Storage/Units.dart';
import 'package:grocerylister/util/strings.dart';

import 'package:grocerylister/util/util.dart' as utils;
import 'package:grocerylister/util/view/IngredientInputRow.dart';

class IngredientInputContainer extends StatefulWidget {
  @override
  _IngredientInputContainerState createState() => _IngredientInputContainerState();
}

class _IngredientInputContainerState extends State<IngredientInputContainer> {
  TextEditingController nameController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  String unitController = "";

  bool isNewGroceryInputOk(BuildContext context) {
    if (!utils.isInputNameFieldOk(context, nameController.text, "Ingredient")) return false;
    if (!utils.isInputQuantityFieldOk(context, quantityController.text)) return false;
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 127,
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: <Widget>[
          IngredientInputRow(),
          Padding(padding: EdgeInsets.only(bottom: 20)),
          TextButton(
            child: Text(
              Strings.add,
            ),
            onPressed: () {
              if (isNewGroceryInputOk(context))
                Navigator.pop(context, {
                  'name': nameController.text,
                  'quantity': double.tryParse(quantityController.text),
                  'unit': unitController.isEmpty ? Units.unit.asString() : unitController
                });
            },
          ),
        ],
      ),
    );
  }
}
