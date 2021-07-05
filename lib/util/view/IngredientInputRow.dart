import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grocerylister/Storage/units.dart';
import 'package:grocerylister/util/strings.dart';

class IngredientInputRow extends StatefulWidget {
  final TextEditingController _nameController;
  final TextEditingController _quantityController;
  final String _unitController;

  IngredientInputRow({String name, String quantity, String unit})
      : _nameController =
            name != null ? TextEditingController.fromValue(TextEditingValue(text: name)) : TextEditingController(),
        _quantityController = quantity != null
            ? TextEditingController.fromValue(TextEditingValue(text: quantity))
            : TextEditingController(),
        _unitController = unit != null ? unit : "";

  String getName() => _nameController.text;
  String getQuantity() => _quantityController.text;
  String getUnit() => _unitController;

  @override
  _IngredientInputRowState createState() => _IngredientInputRowState(
      nameController: _nameController, quantityController: _quantityController, unitController: _unitController);
}

class _IngredientInputRowState extends State<IngredientInputRow> {
  final TextEditingController _nameController;
  final TextEditingController _quantityController;
  String _unitController;

  _IngredientInputRowState(
      {TextEditingController nameController, TextEditingController quantityController, String unitController})
      : _nameController = nameController,
        _quantityController = quantityController,
        _unitController = unitController;

  TextFormField _nameFormField() => TextFormField(
        controller: _nameController,
        decoration: const InputDecoration(border: OutlineInputBorder(), labelText: Strings.ingredient_name),
      );

  TextFormField _quantityFormField() => TextFormField(
        controller: _quantityController,
        decoration: const InputDecoration(border: OutlineInputBorder(), labelText: Strings.ingredient_quantity),
      );

  void _setUnit(newValue) => setState(() => _unitController = newValue);

  DropdownButtonFormField _unitDropdown() => DropdownButtonFormField(
      decoration: const InputDecoration.collapsed(hintText: Strings.unit),
      value: _unitController.isNotEmpty ? _unitController : Units.unit.asString(),
      onChanged: _setUnit,
      items:
          Units.values.map((unit) => DropdownMenuItem(value: unit.asString(), child: Text(unit.asString()))).toList());

  @override
  Widget build(BuildContext context) {
    return Row(children: <Widget>[
      Expanded(child: _nameFormField()),
      Padding(padding: EdgeInsets.symmetric(horizontal: 5)),
      Expanded(child: _quantityFormField()),
      Padding(padding: EdgeInsets.symmetric(horizontal: 5)),
      Expanded(child: _unitDropdown())
    ]);
  }
}
