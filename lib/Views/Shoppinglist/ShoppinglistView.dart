import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grocerylister/DataNotifierStreams/DataNotifierStreams.dart';
import 'package:grocerylister/Helpers/ShoppinglistHelper.dart';
import 'package:grocerylister/Storage/FirebaseAPI/APIs.dart';
import 'package:grocerylister/Storage/FirebaseAPI/Ingredients/DataModel/Ingredient.dart';
import 'package:grocerylister/Storage/FirebaseAPI/ShoppinglistIngredients/DataModel/ShoppinglistIngredient.dart';
import 'package:grocerylister/Storage/FirebaseAPI/Shoppinglists/DataModel/Shoppinglist.dart';
import 'package:grocerylister/Navigation/Navigation.dart';
import 'package:grocerylister/Styling/Themes/Themes.dart';
import 'package:grocerylister/Views/Components/IngredientInputDialog.dart';
import 'package:grocerylister/util/strings.dart';

class ShoppinglistView extends State<NavigationView> {
  Shoppinglist _shoppinglist;
  List<ShoppinglistIngredient> _shoppinglistIngredients = [];
  List<Ingredient> _ingredients = [];

  Future<void> _loadMostRecentShoppinglist() async {
    var mostRecentShoppinglist = await shoppinglistAPI.getMostRecentlyCreated();
    var mostRecentShoppinglistIngredients =
        await shoppinglistIngredientsAPI.getAllFromShoppinglistId(mostRecentShoppinglist.id);
    var mostRecentIngredients =
        await ShoppinglistHelper.getIngredientsFromShoppinglistIngredients(mostRecentShoppinglistIngredients);
    setState(() {
      _shoppinglist = mostRecentShoppinglist;
      _shoppinglistIngredients = mostRecentShoppinglistIngredients;
      _ingredients = mostRecentIngredients;
    });
  }

  Future<void> _updateShoppinglistFromNewShoppinglistIngredientData(Map<String, String> newIngredientData) async {
    var name = newIngredientData['name'];
    var quantity = double.tryParse(newIngredientData['quantity']);
    var unit = newIngredientData['unit'];

    var ingredient = await ingredientsAPI.getFromName(name);
    if (ingredient == null) {
      ingredient = Ingredient(name: name);
      ingredient.id = await ingredientsAPI.add(ingredient);
    }

    var shoppinglistIngredient =
        _shoppinglistIngredients.firstWhere((si) => si.ingredientId == ingredient.id, orElse: () => null);

    if (shoppinglistIngredient == null) {
      shoppinglistIngredient = ShoppinglistIngredient(
          shoppinglistId: _shoppinglist.id,
          ingredientId: ingredient.id,
          quantity: quantity,
          unit: unit,
          isBought: false);

      shoppinglistIngredient.id = await shoppinglistIngredientsAPI.add(shoppinglistIngredient);
    } else {
      shoppinglistIngredient.quantity += quantity;
      await shoppinglistIngredientsAPI.update(shoppinglistIngredient);
    }

    setState(() => _shoppinglist.lastModifiedAt = Timestamp.now());
    await shoppinglistAPI.update(_shoppinglist);
    await _loadMostRecentShoppinglist();
  }

  void _openNewShoppinglistIngredientDialog() {
    showDialog(context: context, builder: (_) => IngredientInputDialog()).then((newIngredientData) {
      if (newIngredientData != null) _updateShoppinglistFromNewShoppinglistIngredientData(newIngredientData);
    });
  }

  void _checkShoppinglistIngredient(bool isChecked, ShoppinglistIngredient checkedIngredient) {
    setState(() {
      checkedIngredient.isBought = isChecked;
      _shoppinglist.lastModifiedAt = Timestamp.now();
    });
    shoppinglistIngredientsAPI.update(checkedIngredient);
    shoppinglistAPI.update(_shoppinglist);
  }

  void _removeShoppinglistIngredient(int index) {
    shoppinglistIngredientsAPI.delete(_shoppinglistIngredients[index]);
    setState(() {
      _shoppinglistIngredients.removeAt(index);
      _ingredients.removeAt(index);
      _shoppinglist.lastModifiedAt = Timestamp.now();
    });
    shoppinglistAPI.update(_shoppinglist);
  }

  @override
  void initState() {
    super.initState();
    _loadMostRecentShoppinglist()
        .then((_) => shoppinglistNotifierStream.stream.listen((_) => _loadMostRecentShoppinglist()));
  }

  ListView _shoppinglistIngredientsView() => ListView.builder(
      itemCount: _shoppinglistIngredients.length,
      itemBuilder: (context, index) {
        return Card(
          child: CheckboxListTile(
              title: Text(
                _ingredients[index].name +
                    ": " +
                    _shoppinglistIngredients[index].quantity.toString() +
                    " " +
                    _shoppinglistIngredients[index].unit,
                style: Theme.of(context).textTheme.bodyText2,
              ),
              secondary: IconButton(
                  icon: Icon(Icons.delete, color: primary3), onPressed: () => _removeShoppinglistIngredient(index)),
              controlAffinity: ListTileControlAffinity.leading,
              value: _shoppinglistIngredients[index].isBought,
              onChanged: (bool isChecked) => _checkShoppinglistIngredient(isChecked, _shoppinglistIngredients[index])),
        );
      });

  FloatingActionButton _addButton() => FloatingActionButton.extended(
        onPressed: _openNewShoppinglistIngredientDialog,
        icon: Icon(Icons.add),
        label: Text(Strings.new_ingredient),
        heroTag: null,
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('${widget.destination.title}', style: Theme.of(context).textTheme.headline1)),
        body: Container(
          padding: const EdgeInsets.all(20),
          child: _shoppinglistIngredientsView(),
        ),
        floatingActionButton: _addButton(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat);
  }
}
