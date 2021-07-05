import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:grocerylister/Storage/FirebaseAPI/RecipeIngredients/DataModel/RecipeIngredient.dart';

const String RECIPE_INGREDIENTS = 'recipe_ingredients';

Stream recipeIngredientsStream = FirebaseFirestore.instance.collection(RECIPE_INGREDIENTS).snapshots();

List<RecipeIngredient> getRecipeIngredientsFromSnapshot(AsyncSnapshot snapshot) {
  List<RecipeIngredient> recipeIngredients = [];
  if (snapshot.hasData) for (var s in snapshot.data.docs) recipeIngredients.add(recipeIngredientFromDocSnap(s));
  return recipeIngredients;
}

Future<void> deleteRecipeIngredient(RecipeIngredient recipeIngredient) async {
  await FirebaseFirestore.instance
      .runTransaction((transaction) async => transaction.delete(recipeIngredient.reference));
}

Future<DocumentReference> _createRecipeIngredient(RecipeIngredient recipeIngredient) async {
  DocumentReference newRef = FirebaseFirestore.instance.collection(RECIPE_INGREDIENTS).doc();
  await FirebaseFirestore.instance
      .runTransaction((transaction) async => transaction.set(newRef, recipeIngredient.asData()));

  return newRef;
}

Future<DocumentReference> _updateRecipeIngredient(RecipeIngredient recipeIngredient) async {
  await FirebaseFirestore.instance
      .runTransaction((transaction) async => transaction.update(recipeIngredient.reference, recipeIngredient.asData()));

  return recipeIngredient.reference;
}

Future<DocumentReference> saveRecipeIngredient(RecipeIngredient recipeIngredient) async {
  if (recipeIngredient.reference == null) return _createRecipeIngredient(recipeIngredient);

  return _updateRecipeIngredient(recipeIngredient);
}
