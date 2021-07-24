import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grocerylister/APIs/FirebaseAPI/DataModel.dart';

class ShoppinglistIngredient implements DataModel {
  String id;
  String shoppinglistId;
  String ingredientId;

  double quantity;
  String unit;
  bool isBought;
  bool isExtra;

  ShoppinglistIngredient(
      {this.id, this.shoppinglistId, this.ingredientId, this.quantity, this.unit, this.isBought, this.isExtra});

  ShoppinglistIngredient.fromDocumentSnapshot(DocumentSnapshot ds)
      : this(
            id: ds.reference.id,
            shoppinglistId: (ds.data() as Map<String, dynamic>)['shoppinglistId'],
            ingredientId: (ds.data() as Map<String, dynamic>)['ingredientId'],
            quantity: (ds.data() as Map<String, dynamic>)['quantity'],
            unit: (ds.data() as Map<String, dynamic>)['unit'],
            isBought: (ds.data() as Map<String, dynamic>)['isBought'],
            isExtra: (ds.data() as Map<String, dynamic>)['isExtra']);

  ShoppinglistIngredient.fromJson(Map<String, dynamic> json)
      : this(
            shoppinglistId: json['shoppinglistId'],
            ingredientId: json['ingredientId'],
            quantity: json['quantity'],
            unit: json['unit'],
            isBought: json['isBought'],
            isExtra: json['isExtra']);

  Map<String, dynamic> toJson() => {
        'shoppinglistId': shoppinglistId,
        'ingredientId': ingredientId,
        'quantity': quantity,
        'unit': unit,
        'isBought': isBought,
        'isExtra': isExtra
      };
}
