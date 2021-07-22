import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:grocerylister/Storage/FirebaseAPI/APIs.dart';
import 'package:grocerylister/Storage/FirebaseAPI/Ingredients/DataModel/Ingredient.dart';
import 'package:grocerylister/util/Loading.dart';
import 'package:grocerylister/util/strings.dart';

class SelectIngredientsInStockDialog extends StatefulWidget {
  @override
  _SelectIngredientsInStockDialogState createState() => _SelectIngredientsInStockDialogState();
}

class _SelectIngredientsInStockDialogState extends State<SelectIngredientsInStockDialog> {
  List<Ingredient> _ingredientsNotInStock = [];

  Future<void> _loadIngredientsNotInStock() async {
    var ingredients = await ingredientsAPI.getAllNotInStock();
    setState(() {
      for (var i in ingredients) _ingredientsNotInStock.add(i);
    });
  }

  void _checkIngredient(bool isChecked, Ingredient ingredient) => setState(() => ingredient.isInStock = isChecked);

  Future<void> _updateCheckedIngredients() async {
    for (var i in _ingredientsNotInStock) if (i.isInStock) await ingredientsAPI.update(i);
  }

  void _updateCheckedIngredientsAndReturn() =>
      Loader.show(context: context, showWhile: _updateCheckedIngredients()).then((_) => Navigator.pop(context));

  Widget _recipeList() => Container(
      width: 250,
      height: 500,
      child: ListView.builder(
          itemCount: _ingredientsNotInStock.length,
          itemBuilder: (context, index) => Card(
              child: CheckboxListTile(
                  title: Text(_ingredientsNotInStock[index].name, style: Theme.of(context).textTheme.bodyText2),
                  value: _ingredientsNotInStock[index].isInStock,
                  onChanged: (isChecked) => _checkIngredient(isChecked, _ingredientsNotInStock[index])))));

  Widget _okButton() => TextButton(
      child: Text(Strings.ok, style: Theme.of(context).textTheme.button),
      onPressed: _updateCheckedIngredientsAndReturn);

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance
        .addPostFrameCallback((_) => Loader.show(context: context, showWhile: _loadIngredientsNotInStock()));
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        insetPadding: EdgeInsets.all(10),
        content: Container(
            width: 250,
            height: 600,
            child: Column(children: [
              Text(Strings.select_new_recipe, style: Theme.of(context).textTheme.headline2),
              Padding(padding: EdgeInsets.only(bottom: 20)),
              _recipeList(),
              _okButton()
            ])));
  }
}
