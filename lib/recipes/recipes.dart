import 'dart:async';

import 'package:grocerylister/util/globals.dart' as globals;
import 'package:flutter/material.dart';
import 'package:grocerylister/navigation.dart';
import 'package:grocerylister/recipes/new_recipe.dart';
import 'package:grocerylister/storage/data_model/recipe.dart';
import 'package:grocerylister/storage/storage.dart';
import 'package:grocerylister/util/strings.dart';

class RecipesDestinationState extends State<NavigationDestinationView> {
  List<Recipe> recipes = [];

  @override
  void initState() {
    super.initState();
    loadRecipes();
    globals.recipeStream.stream.listen((savedRecipe){ if(savedRecipe != null) loadRecipes();});
  }

  void loadRecipes() async {
    recipes = await Storage.instance.getRecipes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.destination.color[100],
      appBar: AppBar(
        title: Text('${widget.destination.title}'),
        backgroundColor: widget.destination.color,
      ),
      body: Container(
        padding: const EdgeInsets.all(32.0),
        alignment: Alignment.center,
        child: ListView(
            children: [
              for (int i = 0; i < recipes.length; i++)
                Card(child: ListTile(title: Text(recipes[i].name), trailing: IconButton(icon: Icon(Icons.delete), onPressed: () async {
                  await Storage.instance.deleteRecipeWithId(recipes[i].id);
                  globals.recipeStream.sink.add(null);
                  setState(() {
                    recipes.removeAt(i);
                  });
                },),))
            ]
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => NewRecipeWidget())).then((value) async {
            List<Recipe> tmp = await Storage.instance.getRecipes();
            setState(() {
              recipes = tmp;
            });
          });
        },
        label: Text(Strings.add_recipe),
        icon: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
