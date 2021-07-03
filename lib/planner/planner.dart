import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:grocerylister/Navigation/Navigation.dart';
import 'package:grocerylister/storage/data_model/ingredient.dart';
import 'package:grocerylister/storage/data_model/plan.dart';
import 'package:grocerylister/storage/data_model/recipe.dart';
import 'package:grocerylister/storage/data_model/recipe_ingredient.dart';
import 'package:grocerylister/storage/data_model/shopping_list.dart';
import 'package:grocerylister/util/strings.dart';
import 'package:grocerylister/storage/storage.dart';

import 'package:grocerylister/util/globals.dart' as globals;
import 'package:grocerylister/util/view/select_recipe_container.dart';

class PlannerDestinationState extends State<NavigationView> {
  Plan currentPlan =
      Plan(null, null, [null, null, null, null, null, null, null]);

  String _dayFromIndex(int index) {
    if (index == 0) return Strings.monday;
    if (index == 1) return Strings.tuesday;
    if (index == 2) return Strings.wednesday;
    if (index == 3) return Strings.thursday;
    if (index == 4) return Strings.friday;
    if (index == 5) return Strings.saturday;
    if (index == 6) return Strings.sunday;

    return "";
  }

  @override
  void initState() {
    super.initState();
    _loadPlan();
    globals.recipeStream.stream.listen((savedRecipe) {
      if (savedRecipe == null) _loadPlan();
    });
  }

  Future<void> _loadPlan() async {
    Plan plan = await Storage.instance.getLatestPlan();
    if (plan == null)
      setState(() {
        currentPlan = Plan(UniqueKey().hashCode, null,
            [null, null, null, null, null, null, null]);
      });
    else
      setState(() {
        currentPlan = plan;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.destination.title}'),
        backgroundColor: widget.destination.color,
      ),
      backgroundColor: widget.destination.color[100],
      body: Container(
        padding: const EdgeInsets.all(32.0),
        alignment: Alignment.center,
        child: ReorderableListView(
          onReorder: (oldIndex, newIndex) async {
            _moveRecipeToAnotherDay(oldIndex, newIndex);
            await Storage.instance.insertPlan(currentPlan);
          },
          children: [
            for (int i = 0; i < currentPlan.recipes.length; i++)
              Card(
                key: ValueKey(UniqueKey()),
                child: Column(
                  children: <Widget>[
                    Text(_dayFromIndex(i)),
                    ListTile(
                      leading: Icon(Icons.fastfood),
                      title: currentPlan.recipes[i] == null
                          ? Text("")
                          : Text(currentPlan.recipes[i].name),
                      trailing: IconButton(
                        icon: Icon(Icons.swap_horiz),
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text(Strings.select_new_recipe),
                                  content: SelectRecipeContainer(),
                                );
                              }).then((newRecipe) async {
                            if (newRecipe != null) {
                              setState(() {
                                currentPlan.recipes[i] = newRecipe;
                              });
                              await Storage.instance.insertPlan(currentPlan);
                            }
                          });
                        },
                      ),
                    )
                  ],
                ),
              )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          List<Recipe> recipes = await Storage.instance.getRecipes();

          _generateFoodPlan(recipes);

          Plan savedPlan = await _savePlan();

          globals.planStream.sink.add(savedPlan);
        },
        label: Text(Strings.generate_food_plan),
        icon: Icon(Icons.insert_emoticon),
        heroTag: null,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  void _moveRecipeToAnotherDay(int oldIndex, int newIndex) {
    var old = currentPlan.recipes[oldIndex].copy();
    setState(() {
      currentPlan.recipes.removeAt(oldIndex);
      if (oldIndex < newIndex)
        currentPlan.recipes.insert(newIndex - 1, old);
      else
        currentPlan.recipes.insert(newIndex, old);
    });
  }

  List<RecipeIngredient> _squash(List<RecipeIngredient> list) {
    list.sort((RecipeIngredient a, RecipeIngredient b) {
      int diff = a.ingredient.name.compareTo(b.ingredient.name);
      if (diff == 0) {
        return a.unit.compareTo(b.unit);
      }
      return diff;
    });

    List toRemove = [];
    List toAdd = [];
    List toBeSquashed = [];

    int i = 0;
    while (i + 1 < list.length) {
      Set ingredientsWithSameNameAndUnit = Set();
      int j = i;
      while (j + 1 < list.length &&
          list[j].ingredient.name == list[j + 1].ingredient.name &&
          list[j].unit == list[j + 1].unit) {
        ingredientsWithSameNameAndUnit.add(list[j]);
        ingredientsWithSameNameAndUnit.add(list[j + 1]);
        j++;
      }
      if (ingredientsWithSameNameAndUnit.isNotEmpty)
        toBeSquashed.add(ingredientsWithSameNameAndUnit);
      i = i == j ? i + 1 : j;
    }

    for (Set sames in toBeSquashed) {
      double newQuantity = 0;
      Recipe recipe = sames.first.recipe;
      Ingredient ingredient = sames.first.ingredient;
      String unit = sames.first.unit;

      for (RecipeIngredient item in sames) {
        newQuantity += item.quantity;
        toRemove.add(item);
      }

      toAdd.add(RecipeIngredient(
          UniqueKey().hashCode, recipe, ingredient, unit, newQuantity));
    }

    for (RecipeIngredient item in toRemove) list.remove(item);
    for (RecipeIngredient item in toAdd) list.add(item);

    return list;
  }

  Future<Plan> _savePlan() async {
    await Storage.instance.insertPlan(currentPlan);

    List<RecipeIngredient> ingredients = [];

    for (Recipe recipe in currentPlan.recipes) {
      List<RecipeIngredient> tmpList =
          await Storage.instance.getRecipeIngredientsForRecipeWithId(recipe.id);
      for (RecipeIngredient tmp in tmpList) ingredients.add(tmp);
    }

    ingredients = _squash(ingredients);
    for (RecipeIngredient recipeIngredient in ingredients)
      await Storage.instance.insertShoppinglistEntry(ShoppingListEntry(
          UniqueKey().hashCode,
          DateTime.now().toString(),
          currentPlan,
          recipeIngredient.ingredient,
          recipeIngredient.unit,
          recipeIngredient.quantity,
          false));

    return currentPlan;
  }

  void _generateFoodPlan(List<Recipe> recipes) {
    if (recipes.isNotEmpty) {
      List<int> chosenIndexes = [];
      for (int i = 0; i < 7; i++) {
        int index;
        while (
            chosenIndexes.contains(index = Random().nextInt(recipes.length)) &&
                chosenIndexes.length < recipes.length) {
          index = Random().nextInt(recipes.length);
        }
        setState(() {
          currentPlan.recipes[i] = recipes[index];
        });
        chosenIndexes.add(index);
      }
      setState(() {
        currentPlan.id = UniqueKey().hashCode;
        currentPlan.date = DateTime.now().toString();
      });
    }
  }
}
