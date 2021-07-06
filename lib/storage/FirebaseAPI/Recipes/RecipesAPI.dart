import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:grocerylister/Storage/FirebaseAPI/FirebaseAPI.dart';
import 'package:grocerylister/Storage/FirebaseAPI/Recipes/DataModel/Recipe.dart';

import '../APIs.dart';

class RecipesAPI implements FirebaseAPI {
  Stream stream = FirebaseFirestore.instance.collection(RECIPES).snapshots();
  final dbRef = FirebaseFirestore.instance.collection(RECIPES).withConverter<Recipe>(
      fromFirestore: (snapshot, _) => Recipe.fromJson(snapshot.data()), toFirestore: (recipe, _) => recipe.toJson());

  List<Recipe> getRecipesFromSnapshot(AsyncSnapshot snapshot) {
    List<Recipe> recipes = [];
    if (snapshot.hasData) for (DocumentSnapshot ds in snapshot.data.docs) recipes.add(Recipe.fromDocumentSnapshot(ds));
    return recipes;
  }

  Future<void> deleteRecipe(Recipe recipe) =>
      dbRef.doc(recipe.reference.id).delete().catchError((error) => print("Failed to delete recipe: $error"));

  Future<DocumentReference> addRecipe(Recipe recipe) async {
    return await dbRef
        .add(recipe)
        .catchError((error) => print("Failed to add recipe: $error") as DocumentReference<Recipe>);
  }

  Future<void> updateRecipe(Recipe recipe) async {
    return await dbRef
        .doc(recipe.reference.id)
        .update(recipe.toJson())
        .catchError((error) => print("Failed to update recipe: $error") as DocumentReference<Recipe>);
  }

  Future<DocumentReference> saveRecipe(Recipe recipe) async {
    if (recipe.reference == null) return addRecipe(recipe);
    return updateRecipe(recipe) as DocumentReference;
  }
}
