import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:grocerylister/Storage/FirebaseAPI/Plans/DataModel/PlanAdapter.dart';

import '../APIs.dart';
import 'DataModel/Plan.dart';

Stream plansStream = FirebaseFirestore.instance.collection(PLANS).snapshots();

// List<Plan> getPlansFromSnapshot(AsyncSnapshot snapshot) {
//   List<Plan> plans = [];
//   if (snapshot.hasData)
//     for (var s in snapshot.data.docs) {
//       plans.add((PlanAdapter.fromDocSnap(s)));
//     }
//   return plans;
// }

Future<void> deletePlan(Plan plan) async {
  await FirebaseFirestore.instance.runTransaction((transaction) async => transaction.delete(plan.reference));
}

Future<DocumentReference> _createPlan(Plan plan) async {
  DocumentReference newRef = FirebaseFirestore.instance.collection(PLANS).doc();
  await FirebaseFirestore.instance.runTransaction((transaction) async => transaction.set(newRef, plan.asData()));

  return newRef;
}

Future<DocumentReference> _updatePlan(Plan plan) async {
  await FirebaseFirestore.instance
      .runTransaction((transaction) async => transaction.update(plan.reference, plan.asData()));

  return plan.reference;
}

Future<DocumentReference> savePlan(Plan plan) async {
  if (plan.reference == null) return _createPlan(plan);
  return _updatePlan(plan);
}
