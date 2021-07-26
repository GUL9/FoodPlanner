import 'dart:async';

import 'package:flutter/material.dart';
import 'package:grocerylister/APIs/FirebaseAPI/Recipes/DataModel/Recipe.dart';
import 'package:grocerylister/Middleware/States/States.dart';
import 'package:grocerylister/UI/Styling/Themes/Themes.dart';
import 'package:grocerylister/UI/Views/Components/SearchField.dart';
import 'package:grocerylister/Utils/strings.dart';

class SelectRecipeDialog extends StatefulWidget {
  final Recipe _oldRecipe;
  SelectRecipeDialog({Recipe oldRecipe}) : _oldRecipe = oldRecipe;
  @override
  _SelectRecipeDialogState createState() => _SelectRecipeDialogState(oldRecipe: _oldRecipe);
}

class _SelectRecipeDialogState extends State<SelectRecipeDialog> {
  _SelectRecipeDialogState({Recipe oldRecipe}) : _oldRecipe = oldRecipe;

  List<Recipe> _recipes = [];
  Recipe _oldRecipe;
  int _selectedIndex = -1;

  ScrollController _scrollController = ScrollController();
  StreamController _searchResults = StreamController();

  void _selectRecipe(int index) => setState(() => _selectedIndex = index);
  void _returnSelectedRecipe() => Navigator.pop(context, _selectedIndex != -1 ? _recipes[_selectedIndex] : null);
  void _scrollToSearchResult(int index) => _scrollController.jumpTo((index * 63 + index).toDouble());

  Widget _recipeList() => Expanded(
      child: ListView.builder(
          controller: _scrollController,
          itemCount: _recipes.length,
          itemBuilder: (context, index) => Card(
              color: _selectedIndex == index ? neutral2 : neutral,
              shape: RoundedRectangleBorder(
                  side: BorderSide(width: 3, color: _selectedIndex == index ? primary3 : neutral),
                  borderRadius: BorderRadius.circular(5)),
              child: ListTile(
                  title: Text(_recipes[index].name, style: Theme.of(context).textTheme.bodyText2),
                  onTap: () => _selectRecipe(index)))));

  Widget _okButton() => TextButton(
      child: Text(
        Strings.ok,
        style: Theme.of(context).textTheme.button,
      ),
      onPressed: _returnSelectedRecipe);

  @override
  void initState() {
    super.initState();
    _recipes = recipesState;
    _recipes.sort((a, b) => a.name.compareTo(b.name));
    _selectedIndex = _recipes.indexWhere((recipe) => recipe.id == _oldRecipe.id);
    _searchResults.stream.listen((searchResult) => _scrollToSearchResult(searchResult['index']));
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        insetPadding: EdgeInsets.all(10),
        content: Container(
            width: 250,
            height: 600,
            child: Column(children: [
              Text(Strings.select_new_recipe, style: Theme.of(context).textTheme.headline2),
              Padding(padding: EdgeInsets.only(bottom: 20)),
              SearchField(searchOptions: _recipes.map((r) => r.name).toList(), searchResults: _searchResults),
              Padding(padding: EdgeInsets.only(bottom: 20)),
              _recipeList(),
              Padding(padding: EdgeInsets.only(bottom: 20)),
              _okButton()
            ])));
  }
}
