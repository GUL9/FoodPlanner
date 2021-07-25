import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grocerylister/Middleware/States/States.dart';
import 'package:grocerylister/APIs/FirebaseAPI/APIs.dart';
import 'package:grocerylister/APIs/FirebaseAPI/Ingredients/DataModel/Ingredient.dart';
import 'package:grocerylister/APIs/FirebaseAPI/ShoppinglistIngredients/DataModel/ShoppinglistIngredient.dart';
import 'package:grocerylister/APIs/FirebaseAPI/Shoppinglists/DataModel/Shoppinglist.dart';
import 'package:grocerylister/Middleware/States/StatesHelper.dart';
import 'package:grocerylister/UI/Views/Navigation/Navigation.dart';
import 'package:grocerylister/UI/Styling/Themes/Themes.dart';
import 'package:grocerylister/UI/Views/Components/IngredientInputDialog.dart';
import 'package:grocerylister/util/Loading.dart';
import 'package:grocerylister/util/strings.dart';

class ShoppinglistView extends State<NavigationView> {
  Shoppinglist _shoppinglist;
  List<ShoppinglistIngredient> _shoppinglistIngredients = [];
  List<Ingredient> _ingredients = [];

  void _openNewShoppinglistIngredientDialog() {
    showDialog(context: context, builder: (_) => IngredientInputDialog()).then((newIngredientData) {
      if (newIngredientData != null)
        Loader.show(
            context: context, showWhile: StatesHelper.updateShoppinglistFromJsonIngredientData(newIngredientData));
    });
  }

  void _checkShoppinglistIngredient(bool isChecked, ShoppinglistIngredient checkedIngredient) {
    setState(() {
      checkedIngredient.isBought = isChecked;
      _shoppinglist.lastModifiedAt = Timestamp.now();
    });
    shoppinglistIngredientsAPI.update(checkedIngredient);
    shoppinglistsAPI.update(_shoppinglist);
  }

  void _removeShoppinglistIngredient(int index) {
    shoppinglistIngredientsAPI.delete(_shoppinglistIngredients[index]);
    setState(() {
      _shoppinglistIngredients.removeAt(index);
      _ingredients.removeAt(index);
      _shoppinglist.lastModifiedAt = Timestamp.now();
    });
    shoppinglistsAPI.update(_shoppinglist);
  }

  void _loadAndListenToState() {
    setState(() {
      _shoppinglist = currentShoppinglistState;
      _shoppinglistIngredients = currentShoppinglistIngredientsState;
      _ingredients = ingredientsState;
    });

    shoppinglistNotifierStream.stream.listen((_) => setState(() => _shoppinglist = currentShoppinglistState));
    shoppinglistIngredientsNotifierStream.stream.listen((_) => setState(() {
          _shoppinglistIngredients = currentShoppinglistIngredientsState;
          _ingredients = currentIngredientsInShoppinglistState;
        }));
  }

  @override
  void initState() {
    super.initState();
    _loadAndListenToState();
  }

  ListView _shoppinglistIngredientsView() => ListView.builder(
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
              onChanged: (bool isChecked) => _checkShoppinglistIngredient(isChecked, _shoppinglistIngredients[index])),
        );
      });

  FloatingActionButton _addButton() => FloatingActionButton.extended(
        onPressed: _openNewShoppinglistIngredientDialog,
        icon: Icon(Icons.add),
        label: Text(Strings.new_ingredient),
        shape: Theme.of(context).buttonTheme.shape,
        heroTag: null,
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('${widget.destination.title}', style: Theme.of(context).textTheme.headline1)),
        body: Container(
          padding: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 100),
          child: _shoppinglistIngredientsView(),
        ),
        floatingActionButton: _addButton(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat);
  }
}
