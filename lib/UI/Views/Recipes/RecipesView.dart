import 'package:flutter/material.dart';
import 'package:grocerylister/APIs/FirebaseAPI/APIs.dart';
import 'package:grocerylister/APIs/FirebaseAPI/Recipes/DataModel/Recipe.dart';
import 'package:grocerylister/UI/Views/Navigation/Navigation.dart';
import 'package:grocerylister/UI/Styling/Themes/Themes.dart';
import 'package:grocerylister/util/strings.dart';

import 'NewRecipeView.dart';

class RecipesView extends State<NavigationView> {
  List<Recipe> _recipes = [];

  @override
  void initState() {
    super.initState();
  }

  IconButton _deleteButtonAtIndex(int index) =>
      IconButton(icon: Icon(Icons.delete, color: primary3), onPressed: () => recipesAPI.delete(_recipes[index]));

  StreamBuilder _recipeListFromStream() => StreamBuilder(
      stream: recipesAPI.stream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) _recipes = recipesAPI.getRecipesFromSnapshot(snapshot);
        return ListView.builder(
            itemCount: _recipes.length,
            itemBuilder: (context, index) => Card(
                child: ListTile(
                    title: Text(_recipes[index].name, style: Theme.of(context).textTheme.bodyText2),
                    trailing: _deleteButtonAtIndex(index))));
      });

  FloatingActionButton _addNewRecipeButton(BuildContext context) => FloatingActionButton.extended(
      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => NewRecipeView())),
      label: Text(Strings.new_recipe),
      icon: Icon(Icons.add),
      shape: Theme.of(context).buttonTheme.shape);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('${widget.destination.title}', style: Theme.of(context).textTheme.headline1)),
        body: Container(
            margin: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 100), child: _recipeListFromStream()),
        floatingActionButton: _addNewRecipeButton(context),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat);
  }
}
