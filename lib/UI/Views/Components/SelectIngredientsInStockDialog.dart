import 'dart:async';

import 'package:flutter/material.dart';
import 'package:grocerylister/APIs/FirebaseAPI/Ingredients/DataModel/Ingredient.dart';
import 'package:grocerylister/Middleware/States/States.dart';
import 'package:grocerylister/UI/Views/Components/SearchField.dart';
import 'package:grocerylister/Utils/strings.dart';

class SelectIngredientsInStockDialog extends StatefulWidget {
  @override
  _SelectIngredientsInStockDialogState createState() => _SelectIngredientsInStockDialogState();
}

class _SelectIngredientsInStockDialogState extends State<SelectIngredientsInStockDialog> {
  ScrollController _scrollController = ScrollController();
  StreamController _searchResults = StreamController();
  List<Ingredient> _ingredientsNotInStock = [];

  void _checkIngredient(bool isChecked, Ingredient ingredient) => setState(() => ingredient.isInStock = isChecked);

  void _returnCheckedIngredients() {
    var checkedIngredients = <Ingredient>[];
    for (var i in _ingredientsNotInStock) if (i.isInStock) checkedIngredients.add(i);
    Navigator.pop(context, checkedIngredients);
  }

  void _scrollToSearchResult(int index) => _scrollController.jumpTo((index * 63 + index).toDouble());

  Widget _ingredientsList() => Expanded(
      child: ListView.builder(
          controller: _scrollController,
          itemCount: _ingredientsNotInStock.length,
          itemBuilder: (context, index) => Card(
              child: CheckboxListTile(
                  title: Text(_ingredientsNotInStock[index].name, style: Theme.of(context).textTheme.bodyText2),
                  value: _ingredientsNotInStock[index].isInStock,
                  onChanged: (isChecked) => _checkIngredient(isChecked, _ingredientsNotInStock[index])))));

  Widget _okButton() => TextButton(
      child: Text(Strings.ok, style: Theme.of(context).textTheme.button), onPressed: _returnCheckedIngredients);

  @override
  void initState() {
    super.initState();
    _ingredientsNotInStock = ingredientsState.where((i) => !i.isInStock).toList();
    _ingredientsNotInStock.sort((a, b) => a.name.compareTo(b.name));
    _searchResults.stream.listen((searchResult) => _scrollToSearchResult(searchResult['index']));
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        insetPadding: EdgeInsets.all(10),
        content: Container(
            width: 250,
            height: 600,
            child: Column(children: [
              Text(Strings.add_ingredient_toStock, style: Theme.of(context).textTheme.headline2),
              Padding(padding: EdgeInsets.only(bottom: 20)),
              SearchField(
                  searchOptions: _ingredientsNotInStock.map((i) => i.name).toList(), searchResults: _searchResults),
              Padding(padding: EdgeInsets.only(bottom: 20)),
              _ingredientsList(),
              Padding(padding: EdgeInsets.only(bottom: 20)),
              _okButton()
            ])));
  }
}
