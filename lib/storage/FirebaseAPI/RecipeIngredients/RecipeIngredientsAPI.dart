import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:grocerylister/Storage/FirebaseAPI/FirebaseAPI.dart';

import '../APIs.dart';
import 'DataModel/RecipeIngredient.dart';

class RecipeIngredientsAPI extends FirebaseAPI {
  RecipeIngredientsAPI() {
    this.stream = FirebaseFirestore.instance.collection(RECIPE_INGREDIENTS).snapshots();
    this.dbRef = FirebaseFirestore.instance.collection(RECIPE_INGREDIENTS).withConverter<RecipeIngredient>(
        fromFirestore: (snapshot, _) => RecipeIngredient.fromDocumentSnapshot(snapshot),
        toFirestore: (recipeIngredient, _) => recipeIngredient.toJson());
  }

  List<RecipeIngredient> getRecipeIngredientsFromSnapshot(AsyncSnapshot snapshot) {
    List<RecipeIngredient> recipeIngredients = [];
    if (snapshot.hasData)
      for (DocumentSnapshot ds in snapshot.data.docs) recipeIngredients.add(RecipeIngredient.fromDocumentSnapshot(ds));
    return recipeIngredients;
  }

  List<RecipeIngredient> getAllFromRecipeReference(DocumentReference recipeReference) {
    List<RecipeIngredient> recipeIngredients = [];
    dbRef.where('recipe', equalTo: recipeReference).get().then((QuerySnapshot qs) {
      for (var doc in qs.docs) recipeIngredients.add(doc.data());
    }).catchError((error) => stderr.writeln("Failed to get all recipeingredients from recipe reference: $error"));
    return recipeIngredients;
  }
}
