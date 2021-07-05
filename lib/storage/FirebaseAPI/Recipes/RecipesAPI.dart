import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:grocerylister/Storage/FirebaseAPI/Recipes/DataModel/Recipe.dart';

const String RECIPES = 'recipes';

Stream recipesStream = FirebaseFirestore.instance.collection(RECIPES).snapshots();

List<Recipe> getRecipesFromSnapshot(AsyncSnapshot snapshot) {
  List<Recipe> recipes = [];
  if (snapshot.hasData) for (var s in snapshot.data.docs) recipes.add(recipeFromDocSnap(s));
  return recipes;
}

Future<void> deleteRecipe(Recipe recipe) async {
  await FirebaseFirestore.instance.runTransaction((transaction) async => transaction.delete(recipe.reference));
}

Future<DocumentReference> _createRecipe(Recipe recipe) async {
  DocumentReference newRef = FirebaseFirestore.instance.collection(RECIPES).doc();
  await FirebaseFirestore.instance.runTransaction((transaction) async => transaction.set(newRef, recipe.asData()));
  return newRef;
}

Future<DocumentReference> _updateRecipe(Recipe recipe) async {
  await FirebaseFirestore.instance
      .runTransaction((transaction) async => transaction.update(recipe.reference, recipe.asData()));
  return recipe.reference;
}

Future<DocumentReference> saveRecipe(Recipe recipe) async {
  if (recipe.reference == null) return _createRecipe(recipe);
  return _updateRecipe(recipe);
}
