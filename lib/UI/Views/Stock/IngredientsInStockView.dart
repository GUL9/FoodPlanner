import 'dart:async';

import 'package:flutter/material.dart';
import 'package:grocerylister/Middleware/States/States.dart';
import 'package:grocerylister/APIs/FirebaseAPI/Ingredients/DataModel/Ingredient.dart';
import 'package:grocerylister/Middleware/States/StatesHelper.dart';
import 'package:grocerylister/UI/Views/Components/SearchField.dart';
import 'package:grocerylister/UI/Views/Navigation/Navigation.dart';
import 'package:grocerylister/UI/Styling/Themes/Themes.dart';
import 'package:grocerylister/UI/Views/Components/SelectIngredientsInStockDialog.dart';
import 'package:grocerylister/Utils/Loading.dart';
import 'package:grocerylister/Utils/strings.dart';

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
            _ingredientsInStock.sort((a, b) => a.name.compareTo(b.name));
          });
      });

  Future<void> _updateIngredientsInStockAndShoppinglist() async {
    Loader.show(
        context: context,
        showWhile: StatesHelper.updateIngredientsInStock(_ingredientsInStock)
            .then((_) => StatesHelper.updateShoppinglistIngredients()));
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
      label: Text(Strings.add_to_stock),
      icon: Icon(Icons.add),
      shape: Theme.of(context).buttonTheme.shape);

  Widget _saveStockButton() => FloatingActionButton.extended(
      onPressed: _updateIngredientsInStockAndShoppinglist,
      label: Text(Strings.save_stock),
      icon: Icon(Icons.check),
      backgroundColor: affirmative,
      shape: Theme.of(context).buttonTheme.shape);

  Widget _addOrSaveButton() => _isModified ? _saveStockButton() : _addIngredientButton();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('${widget.destination.title}', style: Theme.of(context).textTheme.headline1)),
        body: Container(
            padding: EdgeInsets.symmetric(horizontal: 5),
            child: Column(children: [
              SearchField(
                  searchOptions: _ingredientsInStock.map((i) => i.name).toList(), searchResults: _searchResults),
              Expanded(child: _ingredientsInstockList())
            ])),
        floatingActionButton: _addOrSaveButton(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat);
  }
}
