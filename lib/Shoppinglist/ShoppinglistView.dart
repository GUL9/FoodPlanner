import 'dart:async';

import 'package:flutter/material.dart';
import 'package:grocerylister/DataNotifierStreams/DataNotifierStreams.dart';
import 'package:grocerylister/Helpers/ShoppinglistHelper.dart';
import 'package:grocerylister/Storage/FirebaseAPI/APIs.dart';
import 'package:grocerylister/Storage/FirebaseAPI/Ingredients/DataModel/Ingredient.dart';
import 'package:grocerylister/Storage/FirebaseAPI/ShoppinglistIngredients/DataModel/ShoppinglistIngredient.dart';
import 'package:grocerylister/Storage/FirebaseAPI/Shoppinglists/DataModel/Shoppinglist.dart';
import 'package:grocerylister/Navigation/Navigation.dart';
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

  @override
  void initState() {
    super.initState();
    _loadMostRecentShoppinglist()
        .then((_) => shoppinglistNotifierStream.stream.listen((event) => _loadMostRecentShoppinglist()));
  }

  ListView _shoppinglistIngredientsView() => ListView.builder(
      itemCount: _shoppinglistIngredients.length,
      itemBuilder: (context, index) {
        return Card(
          child: CheckboxListTile(
              title: Text(_ingredients[index].name +
                  ": " +
                  _shoppinglistIngredients[index].quantity.toString() +
                  " " +
                  _shoppinglistIngredients[index].unit),
              secondary: IconButton(icon: Icon(Icons.delete), onPressed: null),
              controlAffinity: ListTileControlAffinity.leading,
              activeColor: Colors.green,
              checkColor: Colors.white,
              value: _shoppinglistIngredients[index].isBought,
              onChanged: null),
        );
      });

  FloatingActionButton _addButton() => FloatingActionButton.extended(
        onPressed: null,
        icon: Icon(Icons.add),
        label: Text(Strings.new_ingredient),
        heroTag: null,
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('${widget.destination.title}'), backgroundColor: widget.destination.color),
        backgroundColor: widget.destination.color[100],
        body: Container(
          padding: const EdgeInsets.all(20),
          child: _shoppinglistIngredientsView(),
        ),
        floatingActionButton: _addButton(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat);
  }
}
