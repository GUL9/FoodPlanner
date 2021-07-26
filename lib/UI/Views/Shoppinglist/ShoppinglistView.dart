import 'dart:async';

import 'package:flutter/material.dart';
import 'package:grocerylister/Middleware/Helpers/ShoppinglistHelper.dart';
import 'package:grocerylister/Middleware/States/States.dart';
import 'package:grocerylister/APIs/FirebaseAPI/Ingredients/DataModel/Ingredient.dart';
import 'package:grocerylister/APIs/FirebaseAPI/ShoppinglistIngredients/DataModel/ShoppinglistIngredient.dart';
import 'package:grocerylister/APIs/FirebaseAPI/Shoppinglists/DataModel/Shoppinglist.dart';
import 'package:grocerylister/Middleware/States/StatesHelper.dart';
import 'package:grocerylister/UI/Views/Components/SearchField.dart';
import 'package:grocerylister/UI/Views/Navigation/Navigation.dart';
import 'package:grocerylister/UI/Styling/Themes/Themes.dart';
import 'package:grocerylister/UI/Views/Components/IngredientInputDialog.dart';
import 'package:grocerylister/Utils/Loading.dart';
import 'package:grocerylister/Utils/strings.dart';

class ShoppinglistView extends State<NavigationView> {
  Shoppinglist _shoppinglist;
  List<ShoppinglistIngredient> _shoppinglistIngredients = [];
  List<Ingredient> _ingredients = [];

  ScrollController _scrollController = ScrollController();
  StreamController _searchResults = StreamController();

  void _openNewShoppinglistIngredientDialog() {
    showDialog(context: context, builder: (_) => IngredientInputDialog()).then((newIngredientData) {
      if (newIngredientData != null)
        Loader.show(
            context: context, showWhile: StatesHelper.updateShoppinglistFromJsonIngredientData(newIngredientData));
    });
  }

  void _completeShoppinglist() => Loader.show(context: context, showWhile: StatesHelper.completeShoppinglist());

  void _checkShoppinglistIngredient(bool isChecked, ShoppinglistIngredient checkedIngredient) {
    setState(() => checkedIngredient.isBought = isChecked);
    StatesHelper.updateShoppinglistIngredient(checkedIngredient);
  }

  void _removeShoppinglistIngredient(int index) {
    StatesHelper.removeShoppinglistIngredient(_shoppinglistIngredients[index]);
    setState(() {
      _shoppinglistIngredients.removeAt(index);
      _ingredients.removeAt(index);
    });
  }

  void _arrangeShoppinglistByIngredients() {
    var arrangedShoppinglist = <ShoppinglistIngredient>[];
    for (var i in _ingredients) {
      var shoppinglistIngredient = _shoppinglistIngredients.singleWhere((si) => si.ingredientId == i.id, orElse: null);
      arrangedShoppinglist.add(shoppinglistIngredient);
    }
    setState(() => _shoppinglistIngredients = arrangedShoppinglist);
  }

  bool _isNoShoppinglistOrCompleted() {
    if (_shoppinglist == null)
      return true;
    else if (_shoppinglist.allIngredientsBought) return true;

    return false;
  }

  void _loadAndListenToState() {
    setState(() {
      _shoppinglist = currentShoppinglistState;

      _ingredients = currentIngredientsInShoppinglistState;
      _ingredients.sort((a, b) => a.name.compareTo(b.name));

      _shoppinglistIngredients = currentShoppinglistIngredientsState;
      _arrangeShoppinglistByIngredients();
    });

    shoppinglistNotifierStream.stream.listen((_) => setState(() => _shoppinglist = currentShoppinglistState));
    shoppinglistIngredientsNotifierStream.stream.listen((_) => setState(() {
          _shoppinglistIngredients = currentShoppinglistIngredientsState;
          _ingredients = currentIngredientsInShoppinglistState;

          _ingredients.sort((a, b) => a.name.compareTo(b.name));
          _arrangeShoppinglistByIngredients();
        }));
  }

  void _scrollToSearchResult(int index) => _scrollController.jumpTo((index * 63 + index).toDouble());

  @override
  void initState() {
    super.initState();
    _loadAndListenToState();

    _searchResults.stream.listen((searchResult) => _scrollToSearchResult(searchResult['index']));
  }

  Widget _shoppinglistIngredientsView() => Expanded(
      child: ListView.builder(
          controller: _scrollController,
          itemCount: _shoppinglistIngredients.length,
          itemBuilder: (context, index) {
            return Card(
              child: CheckboxListTile(
                  title: Text(
                    "${_shoppinglistIngredients[index].quantity.toString()} ${_shoppinglistIngredients[index].unit} ${_ingredients[index].name}",
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                  secondary: IconButton(
                      icon: Icon(Icons.delete, color: primary3), onPressed: () => _removeShoppinglistIngredient(index)),
                  controlAffinity: ListTileControlAffinity.leading,
                  value: _shoppinglistIngredients[index].isBought,
                  onChanged: (bool isChecked) =>
                      _checkShoppinglistIngredient(isChecked, _shoppinglistIngredients[index])),
            );
          }));

  Widget _addButton() => FloatingActionButton.extended(
        onPressed: _openNewShoppinglistIngredientDialog,
        icon: Icon(Icons.add),
        label: Text(Strings.add_to_shoppinglist),
        shape: Theme.of(context).buttonTheme.shape,
        heroTag: null,
      );

  Widget _completeShoppinglistButton() => FloatingActionButton.extended(
      onPressed: _completeShoppinglist,
      icon: Icon(Icons.check),
      label: Text(Strings.compelte_shoppinglist),
      shape: Theme.of(context).buttonTheme.shape,
      heroTag: null);

  Widget _addOrCompleteButton() => ShoppinglistHelper.isAllIngredientsChecked(_shoppinglistIngredients)
      ? _completeShoppinglistButton()
      : _addButton();

  Widget _emptyShoppinglistText() => Expanded(child: Center(child: Text(Strings.empty_shoppinglist)));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('${widget.destination.title}', style: Theme.of(context).textTheme.headline1)),
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 5),
          child: Column(children: [
            SearchField(searchOptions: _ingredients.map((i) => i.name).toList(), searchResults: _searchResults),
            _isNoShoppinglistOrCompleted() ? _emptyShoppinglistText() : _shoppinglistIngredientsView()
          ]),
        ),
        floatingActionButton: _isNoShoppinglistOrCompleted() ? null : _addOrCompleteButton(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat);
  }
}
