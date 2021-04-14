import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grocerylister/storage/units.dart';
import 'package:grocerylister/util/strings.dart';

import 'package:grocerylister/util/util.dart' as utils;

class IngredientInputRow extends StatefulWidget {

  final TextEditingController _nameController;
  final TextEditingController _quantityController;
  final String _unitController;

  IngredientInputRow({TextEditingController nameController, TextEditingController quantityController, String unitController}) : _nameController = nameController, _quantityController = quantityController, _unitController = unitController;

  @override
  _IngredientInputRowState createState() => _IngredientInputRowState(nameController: _nameController, quantityController: _quantityController, unitController: _unitController);
}

class _IngredientInputRowState extends State<IngredientInputRow> {
  TextEditingController _nameController;
  TextEditingController _quantityController;
  String _unitController;
  _IngredientInputRowState({TextEditingController nameController, TextEditingController quantityController, String unitController}) : _nameController = nameController, _quantityController = quantityController, _unitController = unitController;

  @override
  Widget build(BuildContext context) {
    return Row(children: <Widget>[
            Expanded(
              child: TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(border: OutlineInputBorder(), labelText: Strings.ingredient_name),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 5),
            ),
            Expanded(
              child: TextFormField(
                controller: _quantityController,
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
                value: _unitController == "" ? Unit.unit.unitToString() : _unitController,
                onChanged: (newValue) {
                  setState(() {
                    _unitController = newValue;
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
          ]);
  }
}
