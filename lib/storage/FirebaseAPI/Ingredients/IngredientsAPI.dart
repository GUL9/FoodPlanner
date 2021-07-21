import 'dart:io';

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

  Future<Ingredient> getFromName(String name) async {
    return await dbRef.where('name', isEqualTo: name).limit(1).get().then((QuerySnapshot qs) {
      if (qs.docs.isEmpty)
        return null;
      else
        return qs.docs.first.data();
    }).catchError((error) => stderr.writeln("Failed to get ingredient from name $error"));
  }

  Future<List<Ingredient>> getAllInStock() async {
    var ingredientsInStock = [];
    await dbRef.where('isInStock', isEqualTo: true).get().then((QuerySnapshot qs) {
      for (var doc in qs.docs) ingredientsInStock.add(doc.data());
    }).catchError((error) => stderr.writeln("Failed to get ingredients in stock $error"));
    return ingredientsInStock;
  }

  List<Ingredient> getAllFromSnapshot(AsyncSnapshot snapshot) {
    List<Ingredient> ingredients = [];
    if (snapshot.hasData)
      for (DocumentSnapshot ds in snapshot.data.docs) ingredients.add(Ingredient.fromDocumentSnapshot(ds));
    return ingredients;
  }

  List<Ingredient> getAllInStockFromSnapshot(AsyncSnapshot snapshot) {
    List<Ingredient> ingredients = [];
    if (snapshot.hasData)
      for (DocumentSnapshot ds in snapshot.data.docs)
        if ((ds.data() as Map<String, dynamic>)['isInStock']) ingredients.add(Ingredient.fromDocumentSnapshot(ds));
    return ingredients;
  }
}
