import 'dart:async';

import 'package:flutter/material.dart';
import 'package:grocerylister/APIs/FirebaseAPI/Recipes/DataModel/Recipe.dart';
import 'package:grocerylister/Middleware/States/States.dart';
import 'package:grocerylister/Middleware/States/StatesHelper.dart';
import 'package:grocerylister/UI/Views/Components/SearchField.dart';
import 'package:grocerylister/UI/Views/Navigation/Navigation.dart';
import 'package:grocerylister/UI/Styling/Themes/Themes.dart';
import 'package:grocerylister/Utils/strings.dart';

import 'NewRecipeView.dart';

class RecipesView extends State<NavigationView> {
  List<Recipe> _recipes = [];

  ScrollController _scrollController = ScrollController();
  StreamController _searchResults = StreamController();

  void _loadAndListenToState() {
    setState(() {
      _recipes = recipesState;
      _recipes.sort((a, b) => a.name.compareTo(b.name));
    });

    recipesNotifierStream.stream.listen((_) => setState(() {
          _recipes = recipesState;
          _recipes.sort((a, b) => a.name.compareTo(b.name));
        }));
  }

  void _scrollToSearchResult(int index) => _scrollController.jumpTo((index * 63 + index).toDouble());

  Widget _deleteButtonAtIndex(int index) => IconButton(
      icon: Icon(Icons.delete, color: primary3), onPressed: () => StatesHelper.removeRecipe(_recipes[index]));

  Widget _recipeListFromStream() => Expanded(
      child: ListView.builder(
          controller: _scrollController,
          itemCount: _recipes.length,
          itemBuilder: (context, index) => Card(
              child: ListTile(
                  title: Text(_recipes[index].name, style: Theme.of(context).textTheme.bodyText2),
                  trailing: _deleteButtonAtIndex(index)))));

  Widget _addNewRecipeButton(BuildContext context) => FloatingActionButton.extended(
      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => NewRecipeView())),
      label: Text(Strings.new_recipe),
      icon: Icon(Icons.add),
      shape: Theme.of(context).buttonTheme.shape);

  @override
  void initState() {
    super.initState();
    _loadAndListenToState();
    _searchResults.stream.listen((searchResult) => _scrollToSearchResult(searchResult['index']));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('${widget.destination.title}', style: Theme.of(context).textTheme.headline1)),
        body: Container(
            margin: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 100),
            child: Column(children: [
              SearchField(searchOptions: _recipes.map((r) => r.name).toList(), searchResults: _searchResults),
              Padding(padding: EdgeInsets.only(bottom: 20)),
              _recipeListFromStream(),
            ])),
        floatingActionButton: _addNewRecipeButton(context),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat);
  }
}
