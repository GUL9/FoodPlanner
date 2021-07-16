import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grocerylister/Storage/Units.dart';
import 'package:grocerylister/util/InputValidator.dart';
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
        _unitController = unit != null ? unit : Units.unit.asString();

  bool isInputOk(BuildContext context) =>
      InputValidator.isIngredientNameFieldOk(context, _nameController.text) &&
      InputValidator.isQuantityFieldOk(context, _quantityController.text);

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
        style: Theme.of(context).textTheme.bodyText2,
        controller: _nameController,
        decoration: InputDecoration(labelText: Strings.name),
      );

  TextFormField _quantityFormField() => TextFormField(
        style: Theme.of(context).textTheme.bodyText2,
        controller: _quantityController,
        decoration: InputDecoration(labelText: Strings.ingredient_quantity),
      );

  void _setUnit(newValue) => setState(() => _unitController = newValue);

  Container _unitDropdown() => Container(
      height: 60,
      decoration: ShapeDecoration(shape: RoundedRectangleBorder()),
      child: DropdownButtonFormField(
          decoration: InputDecoration(labelText: Strings.unit),
          value: _unitController.isNotEmpty ? _unitController : Units.unit.asString(),
          onChanged: _setUnit,
          items: Units.values
              .map((unit) => DropdownMenuItem(
                  value: unit.asString(), child: Text(unit.asString(), style: Theme.of(context).textTheme.bodyText2)))
              .toList()));

  @override
  Widget build(BuildContext context) {
    return Row(children: <Widget>[
      Expanded(child: _nameFormField()),
      Padding(padding: EdgeInsets.symmetric(horizontal: 3)),
      Expanded(child: _quantityFormField()),
      Padding(padding: EdgeInsets.symmetric(horizontal: 3)),
      Expanded(child: _unitDropdown())
    ]);
  }
}
