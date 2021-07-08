import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:grocerylister/Storage/FirebaseAPI/FirebaseAPI.dart';

import '../APIs.dart';
import 'DataModel/Plan.dart';

class PlansAPI extends FirebaseAPI {
  PlansAPI() {
    this.stream = FirebaseFirestore.instance.collection(PLANS).snapshots();
    this.dbRef = FirebaseFirestore.instance.collection(PLANS).withConverter<Plan>(
        fromFirestore: (snapshot, _) => Plan.fromDocumentSnapshot(snapshot),
        toFirestore: (recipe, _) => recipe.toJson());
  }

  List<Plan> getRecipesFromSnapshot(AsyncSnapshot snapshot) {
    List<Plan> plans = [];
    if (snapshot.hasData) for (DocumentSnapshot ds in snapshot.data.docs) plans.add(Plan.fromDocumentSnapshot(ds));
    return plans;
  }

  Future<Plan> getMostRecentlyCreatedPlan() async {
    return await dbRef.orderBy('created_at').limitToLast(1).get().then((QuerySnapshot s) => s.docs[0].data());
  }
}
