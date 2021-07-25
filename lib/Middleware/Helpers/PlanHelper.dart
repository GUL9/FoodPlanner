import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grocerylister/APIs/FirebaseAPI/APIs.dart';
import 'package:grocerylister/APIs/FirebaseAPI/Plans/DataModel/Plan.dart';
import 'package:grocerylister/APIs/FirebaseAPI/Recipes/DataModel/Recipe.dart';

class PlanHelper {
  static Future<Plan> generateNewPlan(List<Recipe> recipes) async {
    var sevenRandomRecipes = [];
    for (var i = 0; i < 7; i++) {
      var index = Random().nextInt(recipes.length);
      sevenRandomRecipes.add(recipes[index]);
    }

    var now = Timestamp.now();
    var newRecipes = sevenRandomRecipes.map((r) => r.id).toList();
    var newPlan = Plan(createdAt: now, lastModifiedAt: now, recipes: newRecipes);
    newPlan.id = await plansAPI.add(newPlan);

    return newPlan;
  }

  static Future<List<Recipe>> getRecipesFromPlan(Plan plan) async {
    List<Recipe> recipes = [];
    for (String recipeId in plan.recipes) {
      Recipe recipe = await recipesAPI.getFromId(recipeId);
      recipes.add(recipe);
    }
    return recipes;
  }
}
