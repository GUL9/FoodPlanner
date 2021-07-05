import 'package:flutter/material.dart';
import 'package:grocerylister/Navigation/Navigation.dart';
import 'package:grocerylister/Storage/FirebaseAPI/Recipes/DataModel/Recipe.dart';
import 'package:grocerylister/Storage/FirebaseAPI/Recipes/RecipesAPI.dart';
import 'package:grocerylister/Recipes/NewRecipeView.dart';
import 'package:grocerylister/util/strings.dart';

class RecipesView extends State<NavigationView> {
  List<Recipe> _recipes;

  @override
  void initState() {
    super.initState();
  }

  IconButton _deleteButtonAtIndex(int index) =>
      IconButton(icon: Icon(Icons.delete), onPressed: () => deleteRecipe(_recipes[index]));

  StreamBuilder _recipeListFromStream() => StreamBuilder(
      stream: recipesStream,
      builder: (context, snapshot) {
        _recipes = getRecipesFromSnapshot(snapshot);
        return snapshot.hasData
            ? ListView.builder(
                itemCount: _recipes.length,
                itemBuilder: (context, index) =>
                    Card(child: ListTile(title: Text(_recipes[index].name), trailing: _deleteButtonAtIndex(index))))
            : Text(Strings.loading);
      });

  FloatingActionButton _addNewRecipeButton(BuildContext context) => FloatingActionButton.extended(
      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => NewRecipeView())),
      label: Text(Strings.add_recipe),
      icon: Icon(Icons.add));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: widget.destination.color[100],
        appBar: AppBar(title: Text('${widget.destination.title}'), backgroundColor: widget.destination.color),
        body: _recipeListFromStream(),
        floatingActionButton: _addNewRecipeButton(context),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat);
  }
}
