import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grocerylister/Storage/FirebaseAPI/DataModel.dart';

class ShoppinglistIngredient implements DataModel {
  DocumentReference reference;
  DocumentReference shoppinglistReference;
  DocumentReference ingredientReference;

  double quantity;
  String unit;
  bool isBought;

  ShoppinglistIngredient(
      {this.reference, this.shoppinglistReference, this.ingredientReference, this.quantity, this.unit, this.isBought});

  ShoppinglistIngredient.fromDocumentSnapshot(DocumentSnapshot ds)
      : this(
            reference: ds.reference,
            shoppinglistReference: (ds.data() as Map<String, dynamic>)['shoppinglist'] as DocumentReference,
            ingredientReference: (ds.data() as Map<String, dynamic>)['ingredient'] as DocumentReference,
            quantity: (ds.data() as Map<String, dynamic>)['quantity'] as double,
            unit: (ds.data() as Map<String, dynamic>)['unit'] as String,
            isBought: (ds.data() as Map<String, dynamic>)['is_bought'] as bool);

  ShoppinglistIngredient.fromJson(Map<String, Object> json)
      : this(
            shoppinglistReference: json['shoppinglist'] as DocumentReference,
            ingredientReference: json['ingredient'] as DocumentReference,
            quantity: json['quantity'] as double,
            unit: json['unit'] as String,
            isBought: json['is_bought'] as bool);

  Map<String, Object> toJson() => {
        'shoppinglist': shoppinglistReference,
        ' ingredient': ingredientReference,
        'quantity': quantity,
        'unit': unit,
        'is_bought': isBought
      };
}
