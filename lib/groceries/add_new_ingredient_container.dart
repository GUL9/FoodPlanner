import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grocerylister/storage/units.dart';
import 'package:grocerylister/util/strings.dart';

import 'package:grocerylister/util/util.dart' as utils;

class AddNewIngredientContainer extends StatefulWidget {
  @override
  _AddNewIngredientContainerState createState() => _AddNewIngredientContainerState();
}

class _AddNewIngredientContainerState extends State<AddNewIngredientContainer> {
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
          Row(children: <Widget>[
            Expanded(
              child: TextFormField(
                controller: nameController,
                decoration: const InputDecoration(border: OutlineInputBorder(), labelText: Strings.ingredient_name),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 5),
            ),
            Expanded(
              child: TextFormField(
                controller: quantityController,
                decoration: const InputDecoration(border: OutlineInputBorder(), labelText: Strings.ingredient_quantity),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 5),
            ),
            Expanded(
              child: DropdownButtonFormField(
                decoration: const InputDecoration.collapsed(),
                hint: Text(Strings.unit),
                value: unitController == "" ? Strings.unit.toLowerCase() : unitController,
                onChanged: (newValue) {
                  setState(() {
                    unitController = newValue;
                  });
                },
                items: Unit.values.map((unit) {
                  return DropdownMenuItem(
                    value: unit.unitToString(),
                    child: Text(unit.unitToString()),
                  );
                }).toList(),
              ),
            ),
          ]),
          Padding(padding: EdgeInsets.only(bottom: 20)),
          TextButton(
            child: Text(
              Strings.add,
              style: TextStyle(fontSize: 20, color: Colors.amber),
            ),
            onPressed: () {
              if(isNewGroceryInputOk(context))
                Navigator.pop(context, {'name': nameController.text, 'quantity': double.tryParse(quantityController.text), 'unit': unitController.isEmpty ? Unit.unit.unitToString(): unitController});
            },
          ),
        ],
      ),
    );
  }
}
