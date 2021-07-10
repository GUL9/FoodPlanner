import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grocerylister/Navigation/Navigation.dart';
import 'package:grocerylister/Storage/FirebaseAPI/APIs.dart';
import 'package:grocerylister/Storage/FirebaseAPI/Plans/DataModel/Plan.dart';
import 'package:grocerylister/Storage/FirebaseAPI/Recipes/DataModel/Recipe.dart';
import 'package:grocerylister/Storage/FirebaseAPI/ShoppinglistIngredients/DataModel/ShoppinglistIngredient.dart';
import 'package:grocerylister/Storage/FirebaseAPI/Shoppinglists/DataModel/Shoppinglist.dart';
import 'package:grocerylister/util/strings.dart';
import 'package:grocerylister/util/util.dart';

class PlanView extends State<NavigationView> {
  Plan _currentPlan;
  List<Recipe> _currentRecipes = [];
  bool _isModified = false;

  void _swapRecipeOrder(int oldIndex, int newIndex) => setState(() {
        _isModified = true;

        if (oldIndex < newIndex) newIndex -= 1;
        var recipe = _currentRecipes.removeAt(oldIndex);
        _currentRecipes.insert(newIndex, recipe);
      });

  void _generateNewPlanAndShoppinglist() {
    _generateNewPlan();
    _generateNewShoppinglistFromCurrentPlan();
  }

  Future<void> _generateNewPlan() async {
    // var allRecipes = await recipesAPI.getAll();
    // var planRecipes = [];
    // for (var i = 0; i < 7; i++) {
    //   var index = Random().nextInt(allRecipes.length);
    //   planRecipes.add(allRecipes[index]);
    // }
    // var now = Timestamp.now();
    // var newRecipes = planRecipes.map((r) => r.reference).toList();
    // var newPlan = Plan(createdAt: now, lastModifiedAt: now, recipes: newRecipes);
    // newPlan.reference = await plansAPI.add(newPlan);

    // setState(() => _currentPlan = newPlan);
  }

  Future<void> _generateNewShoppinglistFromCurrentPlan() async {
    // var now = Timestamp.now();
    // var shoppinglist = Shoppinglist(planReference: _currentPlan.reference, createdAt: now, lastModifiedAt: now);
    // shoppinglist.reference = await shoppinglistAPI.add(shoppinglist);

    // for (var recipe in _currentRecipes) {
    //   var recipeIngredients = await recipeIngredientsAPI.getAllFromRecipeReference(recipe.reference);
    //   for (var recipeIngredient in recipeIngredients) {
    //     await shoppinglistIngredientsAPI.add(ShoppinglistIngredient(
    //         shoppinglistReference: shoppinglist.reference,
    //         ingredientReference: recipeIngredient.ingredientReference,
    //         quantity: recipeIngredient.quantity,
    //         unit: recipeIngredient.unit,
    //         isBought: false));
    //   }
    // }
  }

  Future<void> _savePlan() async {
    // setState(() {
    //   _currentPlan.recipes = _currentRecipes.map((r) => r.reference).toList();
    //   _currentPlan.lastModifiedAt = Timestamp.now();
    // });
    // await plansAPI.update(_currentPlan);
  }

  Future<void> _loadMostRecentPlan() async {
    Plan plan = await plansAPI.getMostRecentlyCreatedPlan();
    List<Recipe> recipes = [];
    for (DocumentReference reference in plan.recipes) {
      Recipe recipe = await recipesAPI.getFromReference(reference);
      recipes.add(recipe);
    }
    setState(() {
      _currentPlan = plan;
      _currentRecipes = recipes;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadMostRecentPlan();
  }

  ReorderableListView _planRecipeList() => ReorderableListView.builder(
      onReorder: _swapRecipeOrder,
      itemCount: _currentRecipes.length,
      itemBuilder: (context, index) => Card(
          key: ValueKey(_currentRecipes[index]),
          child: ListTile(
              leading: Text(indexToDayString(index), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
              title: Text(_currentRecipes[index].name))));

  FloatingActionButton _newPlanButton() => FloatingActionButton.extended(
        onPressed: _generateNewPlanAndShoppinglist,
        icon: Icon(Icons.add),
        label: Text(Strings.new_plan),
        heroTag: null,
      );

  FloatingActionButton _savePlanButton() => FloatingActionButton.extended(
        onPressed: _savePlan,
        icon: Icon(Icons.check),
        label: Text(Strings.save_plan),
        heroTag: null,
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${widget.destination.title}'), backgroundColor: widget.destination.color),
      backgroundColor: widget.destination.color[100],
      body: Container(padding: const EdgeInsets.all(20), child: _planRecipeList()),
      floatingActionButton: _isModified ? _savePlanButton() : _newPlanButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
