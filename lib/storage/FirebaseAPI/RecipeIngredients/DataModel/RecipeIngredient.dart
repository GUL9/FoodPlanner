import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grocerylister/Storage/FirebaseAPI/DataModel.dart';

class RecipeIngredient implements DataModel {
  DocumentReference reference;
  DocumentReference recipeReference;
  DocumentReference ingredientReference;

  double quantity;
  String unit;

  RecipeIngredient({this.reference, this.recipeReference, this.ingredientReference, this.quantity, this.unit});

  RecipeIngredient.fromDocumentSnapshot(DocumentSnapshot ds)
      : this(
            reference: ds.reference,
            recipeReference: (ds.data() as Map<String, dynamic>)['recipe'] as DocumentReference,
            ingredientReference: (ds.data() as Map<String, dynamic>)['ingredient'] as DocumentReference,
            quantity: (ds.data() as Map<String, dynamic>)['quantity'] as double,
            unit: (ds.data() as Map<String, dynamic>)['unit'] as String);

  RecipeIngredient.fromJson(Map<String, Object> json)
      : this(
            recipeReference: json['recipe'] as DocumentReference,
            ingredientReference: json['ingredient'] as DocumentReference,
            quantity: json['quantity'] as double,
            unit: json['unit'] as String);

  Map<String, Object> toJson() =>
      {'recipe': recipeReference, ' ingredient': ingredientReference, 'quantity': quantity, 'unit': unit};
}
