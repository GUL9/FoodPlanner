import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grocerylister/UI/Views/Components/IngredientInputRow.dart';
import 'package:grocerylister/Utils/strings.dart';

class IngredientInputDialog extends StatefulWidget {
  @override
  _IngredientInputDialogState createState() => _IngredientInputDialogState();
}

class _IngredientInputDialogState extends State<IngredientInputDialog> {
  IngredientInputRow _inputRow = IngredientInputRow();

  void _returnNewShoppinglistIngredientData() {
    if (_inputRow.isInputOk(context))
      Navigator.pop(
          context, {'name': _inputRow.getName(), 'quantity': _inputRow.getQuantity(), 'unit': _inputRow.getUnit()});
  }

  TextButton _okButton() => TextButton(
        child: Text(Strings.ok, style: Theme.of(context).textTheme.button),
        onPressed: _returnNewShoppinglistIngredientData,
        style: Theme.of(context).textButtonTheme.style,
      );

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        insetPadding: EdgeInsets.all(0),
        content: Container(
          height: 165,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text(Strings.new_ingredient, style: Theme.of(context).textTheme.headline2),
              Padding(padding: EdgeInsets.only(bottom: 15)),
              _inputRow,
              Padding(padding: EdgeInsets.only(bottom: 15)),
              _okButton(),
            ],
          ),
        ));
  }
}
