import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:grocerylister/Storage/FirebaseAPI/FirebaseAPI.dart';

import '../APIs.dart';
import 'DataModel/ShoppinglistIngredient.dart';

class ShoppinglistIngredientsAPI extends FirebaseAPI {
  ShoppinglistIngredientsAPI() {
    this.stream = FirebaseFirestore.instance.collection(SHOPPINGLIST_INGREDIENTS).snapshots();
    this.dbRef = FirebaseFirestore.instance.collection(SHOPPINGLIST_INGREDIENTS).withConverter<ShoppinglistIngredient>(
        fromFirestore: (snapshot, _) => ShoppinglistIngredient.fromDocumentSnapshot(snapshot),
        toFirestore: (shoppinglistIngredient, _) => shoppinglistIngredient.toJson());
  }

  List<ShoppinglistIngredient> getAllFromSnapshot(AsyncSnapshot snapshot) {
    List<ShoppinglistIngredient> shoppinglistIngredients = [];
    if (snapshot.hasData)
      for (DocumentSnapshot ds in snapshot.data.docs)
        shoppinglistIngredients.add(ShoppinglistIngredient.fromDocumentSnapshot(ds));
    return shoppinglistIngredients;
  }

  Future<List<ShoppinglistIngredient>> getAllFromShoppinglistId(String shoppinglistId) async {
    List<ShoppinglistIngredient> shoppinglistIngredients = [];
    await dbRef.where('shoppinglistId', isEqualTo: shoppinglistId).get().then((QuerySnapshot qs) {
      for (var doc in qs.docs) shoppinglistIngredients.add(doc.data());
    }).catchError((error) => stderr.writeln("Failed to get shoppinglist ingredients from shoppinglist id: $error"));
    return shoppinglistIngredients;
  }

  Future<void> deleteAllfromShoppinglistId(String shoppinglistId) async {
    await dbRef.where('shoppinglistId', isEqualTo: shoppinglistId).get().then((QuerySnapshot qs) {
      for (var doc in qs.docs) delete(doc.data());
    }).catchError((error) => stderr.writeln("Failed to remove all shoppinglist ingredients from id $error"));
  }
}
