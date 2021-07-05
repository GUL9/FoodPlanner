import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import 'DataModel/Ingredient.dart';

const String INGREDIENTS = 'ingredients';

Stream ingredientsStream = FirebaseFirestore.instance.collection(INGREDIENTS).snapshots();

List<Ingredient> getIngredientsFromSnapshot(AsyncSnapshot snapshot) {
  List<Ingredient> ingredients = [];
  if (snapshot.hasData) for (var s in snapshot.data.docs) ingredients.add(ingredientFromDocSnap(s));
  return ingredients;
}

Future<void> deleteIngredient(Ingredient ingredient) async {
  await FirebaseFirestore.instance.runTransaction((transaction) async => transaction.delete(ingredient.reference));
}

Future<DocumentReference> _createIngredient(Ingredient ingredient) async {
  DocumentReference newRef = FirebaseFirestore.instance.collection(INGREDIENTS).doc();
  await FirebaseFirestore.instance.runTransaction((transaction) async => transaction.set(newRef, ingredient.asData()));

  return newRef;
}

Future<DocumentReference> _updateIngredient(Ingredient ingredient) async {
  await FirebaseFirestore.instance
      .runTransaction((transaction) async => transaction.update(ingredient.reference, ingredient.asData()));

  return ingredient.reference;
}

Future<DocumentReference> saveIngredient(Ingredient ingredient) async {
  if (ingredient.reference == null) return _createIngredient(ingredient);
  return _updateIngredient(ingredient);
}
