import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:grocerylister/Storage/FirebaseAPI/FirebaseAPI.dart';

import '../APIs.dart';
import 'DataModel/Ingredient.dart';

class IngredientsAPI extends FirebaseAPI {
  IngredientsAPI() {
    this.stream = FirebaseFirestore.instance.collection(INGREDIENTS).snapshots();
    this.dbRef = FirebaseFirestore.instance.collection(INGREDIENTS).withConverter(
        fromFirestore: (snapshot, _) => Ingredient.fromDocumentSnapshot(snapshot),
        toFirestore: (ingredient, _) => ingredient.toJson());
  }

  List<Ingredient> getIngredientsFromSnapshot(AsyncSnapshot snapshot) {
    List<Ingredient> ingredients = [];
    if (snapshot.hasData)
      for (DocumentSnapshot ds in snapshot.data.docs) ingredients.add(Ingredient.fromDocumentSnapshot(ds));
    return ingredients;
  }
}
