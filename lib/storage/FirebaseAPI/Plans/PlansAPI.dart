import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:grocerylister/Storage/FirebaseAPI/FirebaseAPI.dart';

import '../APIs.dart';
import 'DataModel/Plan.dart';

class PlansAPI extends FirebaseAPI {
  PlansAPI() {
    this.stream = FirebaseFirestore.instance.collection(PLANS).snapshots();
    this.dbRef = FirebaseFirestore.instance.collection(RECIPES).withConverter<Plan>(
        fromFirestore: (snapshot, _) => Plan.fromDocumentSnapshot(snapshot),
        toFirestore: (recipe, _) => recipe.toJson());
  }

  List<Plan> getRecipesFromSnapshot(AsyncSnapshot snapshot) {
    List<Plan> recipes = [];
    if (snapshot.hasData) for (DocumentSnapshot ds in snapshot.data.docs) recipes.add(Plan.fromDocumentSnapshot(ds));
    return recipes;
  }
}
