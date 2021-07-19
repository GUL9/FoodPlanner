import 'package:flutter/material.dart';
import 'package:grocerylister/Storage/FirebaseAPI/APIs.dart';
import 'package:grocerylister/Storage/FirebaseAPI/Recipes/DataModel/Recipe.dart';
import 'package:grocerylister/Styling/Themes/Themes.dart';
import 'package:grocerylister/util/strings.dart';

class SelectRecipeDialog extends StatefulWidget {
  final Recipe _oldRecipe;
  SelectRecipeDialog({Recipe oldRecipe}) : _oldRecipe = oldRecipe;
  @override
  _SelectRecipeDialogState createState() => _SelectRecipeDialogState(oldRecipe: _oldRecipe);
}

class _SelectRecipeDialogState extends State<SelectRecipeDialog> {
  _SelectRecipeDialogState({Recipe oldRecipe}) : _oldRecipe = oldRecipe;
  Recipe _oldRecipe;
  List<Recipe> _recipes = [];
  int _selectedIndex = -1;

  Future<void> _loadRecipes() async {
    var recipes = await recipesAPI.getAll();
    setState(() {
      for (var r in recipes) _recipes.add(r);
    });
  }

  void _selectRecipe(int index) => setState(() => _selectedIndex = index);
  void _returnSelectedRecipe() => Navigator.pop(context, _selectedIndex != -1 ? _recipes[_selectedIndex] : null);

  Widget _recipeList() => Container(
      width: 250,
      height: 500,
      child: ListView.builder(
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
    _loadRecipes().then((_) {
      _selectedIndex = _recipes.indexWhere((recipe) => recipe.id == _oldRecipe.id);
    });
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
              _recipeList(),
              _okButton()
            ])));
  }
}
