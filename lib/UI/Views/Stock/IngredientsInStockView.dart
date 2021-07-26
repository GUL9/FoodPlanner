import 'dart:async';

import 'package:flutter/material.dart';
import 'package:grocerylister/Middleware/States/States.dart';
import 'package:grocerylister/APIs/FirebaseAPI/Ingredients/DataModel/Ingredient.dart';
import 'package:grocerylister/Middleware/States/StatesHelper.dart';
import 'package:grocerylister/UI/Views/Components/SearchField.dart';
import 'package:grocerylister/UI/Views/Navigation/Navigation.dart';
import 'package:grocerylister/UI/Styling/Themes/Themes.dart';
import 'package:grocerylister/UI/Views/Components/SelectIngredientsInStockDialog.dart';
import 'package:grocerylister/util/Loading.dart';
import 'package:grocerylister/util/strings.dart';

class IngredientsInStockView extends State<NavigationView> {
  bool _isModified = false;
  StreamController _searchResults = StreamController();
  ScrollController _scrollController = ScrollController();
  List<Ingredient> _ingredientsInStock = [];

  void _checkIngredientInStock(bool isChecked, Ingredient ingredientToUncheck) {
    setState(() {
      _isModified = true;
      ingredientToUncheck.isInStock = isChecked;
    });
  }

  void _openSelectIngredientsInStockDialog() =>
      showDialog(context: context, builder: (_) => SelectIngredientsInStockDialog()).then((ingredientsToAddInStock) {
        if ((ingredientsToAddInStock as List<Ingredient>).isNotEmpty)
          setState(() {
            _isModified = true;
            _ingredientsInStock.addAll(ingredientsToAddInStock);
          });
      });

  Future<void> _updateIngredientsInStockAndShoppinglist() async {
    Loader.show(
        context: context,
        showWhile:
            StatesHelper.updateIngredientsInStock(_ingredientsInStock).then((_) => StatesHelper.updateShoppinglist()));
    setState(() => _isModified = false);
  }

  void _scrollToSearchResult(int index) => _scrollController.jumpTo((index * 63 + index).toDouble());

  void _loadAndListenToState() {
    _ingredientsInStock = ingredientsState.where((i) => i.isInStock).toList();
    setState(() => _ingredientsInStock.sort((a, b) => a.name.compareTo(b.name)));

    ingredientsNotifierStream.stream.listen((ingredients) {
      _ingredientsInStock = ingredientsState.where((i) => i.isInStock).toList();
      setState(() => _ingredientsInStock.sort((a, b) => a.name.compareTo(b.name)));
    });
  }

  @override
  void initState() {
    super.initState();
    _loadAndListenToState();
    _searchResults.stream.listen((searchResult) => _scrollToSearchResult(searchResult['index']));
  }

  Widget _ingredientsInstockList() => ListView.builder(
      controller: _scrollController,
      itemCount: _ingredientsInStock.length,
      itemBuilder: (context, index) => Card(
              child: CheckboxListTile(
            title: Text(_ingredientsInStock[index].name, style: Theme.of(context).textTheme.bodyText2),
            value: _ingredientsInStock[index].isInStock,
            onChanged: (isChecked) => _checkIngredientInStock(isChecked, _ingredientsInStock[index]),
          )));

  Widget _addIngredientButton() => FloatingActionButton.extended(
      onPressed: _openSelectIngredientsInStockDialog,
      label: Text(Strings.add_ingredient),
      icon: Icon(Icons.add),
      shape: Theme.of(context).buttonTheme.shape);

  Widget _saveStockButton() => FloatingActionButton.extended(
      onPressed: _updateIngredientsInStockAndShoppinglist,
      label: Text(Strings.save_stock),
      icon: Icon(Icons.check),
      backgroundColor: affirmative,
      shape: Theme.of(context).buttonTheme.shape);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('${widget.destination.title}', style: Theme.of(context).textTheme.headline1)),
        body: Container(
            margin: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 100),
            child: Column(children: [
              SearchField(
                  searchOptions: _ingredientsInStock.map((i) => i.name).toList(), searchResults: _searchResults),
              Padding(padding: EdgeInsets.only(bottom: 30)),
              Expanded(child: _ingredientsInstockList())
            ])),
        floatingActionButton: _isModified ? _saveStockButton() : _addIngredientButton(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat);
  }
}
