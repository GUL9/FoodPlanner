import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grocerylister/Storage/FirebaseAPI/DataModel.dart';

class RecipeIngredient implements DataModel {
  String id;
  String recipeId;
  String ingredientId;

  double quantity;
  String unit;

  RecipeIngredient({this.id, this.recipeId, this.ingredientId, this.quantity, this.unit});

  RecipeIngredient.fromDocumentSnapshot(DocumentSnapshot ds)
      : this(
            id: ds.reference.id,
            recipeId: (ds.data() as Map<String, dynamic>)['recipeId'],
            ingredientId: (ds.data() as Map<String, dynamic>)['ingredientId'],
            quantity: (ds.data() as Map<String, dynamic>)['quantity'],
            unit: (ds.data() as Map<String, dynamic>)['unit']);

  RecipeIngredient.fromJson(Map<String, dynamic> json)
      : this(
            recipeId: json['recipeId'],
            ingredientId: json['ingredientId'],
            quantity: json['quantity'],
            unit: json['unit']);

  Map<String, dynamic> toJson() =>
      {'recipeId': recipeId, 'ingredientId': ingredientId, 'quantity': quantity, 'unit': unit};
}
