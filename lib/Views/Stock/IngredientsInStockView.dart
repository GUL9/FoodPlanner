import 'package:flutter/material.dart';
import 'package:grocerylister/Helpers/ShoppinglistHelper.dart';
import 'package:grocerylister/Navigation/Navigation.dart';
import 'package:grocerylister/States/DataNotifierStreams/DataNotifierStreams.dart';
import 'package:grocerylister/Storage/FirebaseAPI/APIs.dart';
import 'package:grocerylister/Storage/FirebaseAPI/Ingredients/DataModel/Ingredient.dart';
import 'package:grocerylister/Styling/Themes/Themes.dart';
import 'package:grocerylister/Views/Components/SelectIngredientsInStockDialog.dart';
import 'package:grocerylister/util/Loading.dart';
import 'package:grocerylister/util/strings.dart';

class IngredientsInStockView extends State<NavigationView> {
  bool _isModified = false;
  List<Ingredient> _ingredientsInStock = [];

  void _checkIngredientInStock(bool isChecked, Ingredient ingredientToUncheck) {
    setState(() {
      _isModified = true;
      ingredientToUncheck.isInStock = isChecked;
    });
  }

  void _openSelectIngredientsInStockDialog() =>
      showDialog(context: context, builder: (_) => SelectIngredientsInStockDialog()).then((ingredientsToAddInStock) {
        setState(() {
          _isModified = true;
          _ingredientsInStock.addAll(ingredientsToAddInStock);
        });
      });

  Future<void> _updateIngredientsInStockAndShoppinglist() async {
    for (var i in _ingredientsInStock) await ingredientsAPI.update(i);
    var latestPlan = await plansAPI.getMostRecentlyCreatedPlan();
    var shoppinglist = await ShoppinglistHelper.updateShoppinglistFromPlan(latestPlan);
    shoppinglistNotifierStream.sink.add(shoppinglist);
    stockNotifierStream.sink.add(null);
    setState(() => _isModified = false);
  }

  Future<void> _loadIngredientsInStock() async {
    var ingredientsInStock = await ingredientsAPI.getAllInStock();
    setState(() => _ingredientsInStock = ingredientsInStock);
  }

  @override
  void initState() {
    super.initState();
    _loadIngredientsInStock().then((_) => stockNotifierStream.stream.listen((_) => _loadIngredientsInStock()));
  }

  Widget _ingredientsInstockList() => ListView.builder(
      itemCount: _ingredientsInStock.length,
      itemBuilder: (context, index) => Card(
              child: CheckboxListTile(
            title: Text(_ingredientsInStock[index].name, style: Theme.of(context).textTheme.bodyText2),
            value: _ingredientsInStock[index].isInStock,
            controlAffinity: ListTileControlAffinity.leading,
            onChanged: (isChecked) => _checkIngredientInStock(isChecked, _ingredientsInStock[index]),
          )));

  Widget _addIngredientButton() => FloatingActionButton.extended(
      onPressed: _openSelectIngredientsInStockDialog,
      label: Text(Strings.add_ingredient),
      icon: Icon(Icons.add),
      shape: Theme.of(context).buttonTheme.shape);

  Widget _saveStockButton() => FloatingActionButton.extended(
      onPressed: () => Loader.show(context: context, showWhile: _updateIngredientsInStockAndShoppinglist()),
      label: Text(Strings.save_stock),
      icon: Icon(Icons.check),
      backgroundColor: affirmative,
      shape: Theme.of(context).buttonTheme.shape);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('${widget.destination.title}', style: Theme.of(context).textTheme.headline1)),
        body: Container(
            margin: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 100), child: _ingredientsInstockList()),
        floatingActionButton: _isModified ? _saveStockButton() : _addIngredientButton(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat);
  }
}
