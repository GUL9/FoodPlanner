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

  List<ShoppinglistIngredient> getShoppinglistIngredientsFromSnapshot(AsyncSnapshot snapshot) {
    List<ShoppinglistIngredient> shoppinglistIngredients = [];
    if (snapshot.hasData)
      for (DocumentSnapshot ds in snapshot.data.docs)
        shoppinglistIngredients.add(ShoppinglistIngredient.fromDocumentSnapshot(ds));
    return shoppinglistIngredients;
  }
}
