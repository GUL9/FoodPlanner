import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grocerylister/Storage/FirebaseAPI/DataModel.dart';

class ShoppinglistIngredient implements DataModel {
  DocumentReference reference;
  DocumentReference shoppinglistReference;
  DocumentReference ingredientReference;

  double quantity;
  String unit;

  ShoppinglistIngredient(
      {this.reference, this.shoppinglistReference, this.ingredientReference, this.quantity, this.unit});

  ShoppinglistIngredient.fromDocumentSnapshot(DocumentSnapshot ds)
      : this(
            reference: ds.reference,
            shoppinglistReference: (ds.data() as Map<String, dynamic>)['shoppinglist'] as DocumentReference,
            ingredientReference: (ds.data() as Map<String, dynamic>)['ingredient'] as DocumentReference,
            quantity: (ds.data() as Map<String, dynamic>)['quantity'] as double,
            unit: (ds.data() as Map<String, dynamic>)['unit'] as String);

  ShoppinglistIngredient.fromJson(Map<String, Object> json)
      : this(
            shoppinglistReference: json['shoppinglist'] as DocumentReference,
            ingredientReference: json['ingredient'] as DocumentReference,
            quantity: json['quantity'] as double,
            unit: json['unit'] as String);

  Map<String, Object> toJson() =>
      {'shoppinglist': shoppinglistReference, ' ingredient': ingredientReference, 'quantity': quantity, 'unit': unit};
}
