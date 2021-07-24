import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:grocerylister/APIs/FirebaseAPI/FirebaseAPI.dart';
import 'package:grocerylister/APIs/FirebaseAPI/Recipes/DataModel/Recipe.dart';

import '../APIs.dart';

class RecipesAPI extends FirebaseAPI {
  RecipesAPI() {
    this.stream = FirebaseFirestore.instance.collection(RECIPES).snapshots();
    this.dbRef = FirebaseFirestore.instance.collection(RECIPES).withConverter<Recipe>(
        fromFirestore: (snapshot, _) => Recipe.fromDocumentSnapshot(snapshot),
        toFirestore: (recipe, _) => recipe.toJson());
  }

  List<Recipe> getRecipesFromSnapshot(AsyncSnapshot snapshot) {
    List<Recipe> recipes = [];
    if (snapshot.hasData) for (DocumentSnapshot ds in snapshot.data.docs) recipes.add(Recipe.fromDocumentSnapshot(ds));
    return recipes;
  }
}
