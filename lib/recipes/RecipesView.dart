import 'package:flutter/material.dart';
import 'package:grocerylister/Navigation/Navigation.dart';
import 'package:grocerylister/recipes/new_recipe.dart';
import 'package:grocerylister/storage/data_model/recipe.dart';
import 'package:grocerylister/storage/storage.dart';
import 'package:grocerylister/util/strings.dart';

class RecipesView extends State<NavigationView> {
  List<Recipe> _recipes = [];

  @override
  void initState() {
    super.initState();
  }

  void loadRecipes() async {
    _recipes = await Storage.instance.getRecipes();
  }

  AppBar _appBar() => AppBar(
        title: Text('${widget.destination.title}'),
        backgroundColor: widget.destination.color,
      );

  IconButton _deleteButtonAtIndex(int index) => IconButton(
      icon: Icon(Icons.delete),
      onPressed: () => setState(() => _recipes.removeAt(index)));

  Container _listContainer() => Container(
        padding: const EdgeInsets.all(32.0),
        alignment: Alignment.center,
        child: ListView(children: [
          for (int i = 0; i < _recipes.length; i++)
            Card(
                child: ListTile(
              title: Text(_recipes[i].name),
              trailing: _deleteButtonAtIndex(i),
            ))
        ]),
      );

  FloatingActionButton _addNewRecipeButton() => FloatingActionButton.extended(
        onPressed: () => Navigator.push(context,
            MaterialPageRoute(builder: (context) => NewRecipeWidget())),
        label: Text(Strings.add_recipe),
        icon: Icon(Icons.add),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.destination.color[100],
      appBar: _appBar(),
      body: _listContainer(),
      floatingActionButton: _addNewRecipeButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
