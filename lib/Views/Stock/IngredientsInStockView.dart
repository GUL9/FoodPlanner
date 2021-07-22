import 'package:flutter/material.dart';
import 'package:grocerylister/Navigation/Navigation.dart';
import 'package:grocerylister/Storage/FirebaseAPI/APIs.dart';
import 'package:grocerylister/Storage/FirebaseAPI/Ingredients/DataModel/Ingredient.dart';
import 'package:grocerylister/Views/Components/SelectIngredientsInStockDialog.dart';
import 'package:grocerylister/util/strings.dart';

class IngredientsInStockView extends State<NavigationView> {
  List<Ingredient> _ingredientsInStock = [];

  void _uncheckIngredientInStock(Ingredient ingredientToUncheck) {
    setState(() => ingredientToUncheck.isInStock = false);
    ingredientsAPI.update(ingredientToUncheck);
  }

  void _openSelectInredientsInStockDialog() =>
      showDialog(context: context, builder: (_) => SelectIngredientsInStockDialog());

  @override
  void initState() {
    super.initState();
  }

  Widget _ingredientsInstockListFromStream() => StreamBuilder(
      stream: ingredientsAPI.stream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active)
          _ingredientsInStock = ingredientsAPI.getAllInStockFromSnapshot(snapshot);
        return ListView.builder(
            itemCount: _ingredientsInStock.length,
            itemBuilder: (context, index) => Card(
                    child: CheckboxListTile(
                  title: Text(_ingredientsInStock[index].name, style: Theme.of(context).textTheme.bodyText2),
                  value: _ingredientsInStock[index].isInStock,
                  controlAffinity: ListTileControlAffinity.leading,
                  onChanged: (_) => _uncheckIngredientInStock(_ingredientsInStock[index]),
                )));
      });

  Widget _addIngredientButton(BuildContext context) => FloatingActionButton.extended(
      onPressed: _openSelectInredientsInStockDialog,
      label: Text(Strings.add_ingredient),
      icon: Icon(Icons.add),
      shape: Theme.of(context).buttonTheme.shape);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('${widget.destination.title}', style: Theme.of(context).textTheme.headline1)),
        body: Container(
            margin: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 100),
            child: _ingredientsInstockListFromStream()),
        floatingActionButton: _addIngredientButton(context),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat);
  }
}
