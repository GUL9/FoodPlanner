import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:grocerylister/Storage/FirebaseAPI/APIs.dart';
import 'package:grocerylister/Storage/FirebaseAPI/FirebaseAPI.dart';
import 'package:grocerylister/Storage/FirebaseAPI/Shoppinglists/DataModel/Shoppinglist.dart';

class ShoppinglistAPI extends FirebaseAPI {
  ShoppinglistAPI() {
    this.stream = FirebaseFirestore.instance.collection(SHOPPINGLISTS).snapshots();
    this.dbRef = FirebaseFirestore.instance.collection(SHOPPINGLISTS).withConverter<Shoppinglist>(
        fromFirestore: (snapshot, _) => Shoppinglist.fromDocumentSnapshot(snapshot),
        toFirestore: (shoppinglist, _) => shoppinglist.toJson());
  }

  List<Shoppinglist> getRecipesFromSnapshot(AsyncSnapshot snapshot) {
    List<Shoppinglist> shoppinglists = [];
    if (snapshot.hasData)
      for (DocumentSnapshot ds in snapshot.data.docs) shoppinglists.add(Shoppinglist.fromDocumentSnapshot(ds));
    return shoppinglists;
  }

  Future<Shoppinglist> getMostRecentlyCreatedShoppinglist() async {
    return await dbRef
        .orderBy('created_at')
        .limitToLast(1)
        .get()
        .then((QuerySnapshot s) => s.docs[0].data())
        .catchError((error) => stderr.writeln("Failed to get most recently created shoppinglist: $error"));
  }
}
