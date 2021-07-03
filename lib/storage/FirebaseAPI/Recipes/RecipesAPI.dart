import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:grocerylister/Storage/FirebaseAPI/Recipes/DataModel/Recipe.dart';

Stream recipesStream = FirebaseFirestore.instance.collection('recipes').snapshots();

List<Recipe> getRecipesFromSnapshot(AsyncSnapshot snapshot) {
  List<Recipe> recipes = [];
  if (snapshot.hasData) for (var s in snapshot.data.docs) recipes.add(recipeFromDocSnap(s));
  return recipes;
}

Future<void> deleteRecipe(Recipe recipe) async {
  await FirebaseFirestore.instance.runTransaction((transaction) async => transaction.delete(recipe.reference));
}
