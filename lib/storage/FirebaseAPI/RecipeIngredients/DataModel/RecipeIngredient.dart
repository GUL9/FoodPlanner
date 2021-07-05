import 'package:cloud_firestore/cloud_firestore.dart';

class RecipeIngredient {
  DocumentReference reference;
  DocumentReference recipeReference;
  DocumentReference ingredientReference;

  double quantity;
  String unit;

  RecipeIngredient(
      {DocumentReference reference,
      DocumentReference recipeReference,
      DocumentReference ingredientReference,
      double quantity,
      String unit})
      : this.reference = reference,
        this.recipeReference = recipeReference,
        this.ingredientReference = ingredientReference,
        this.quantity = quantity,
        this.unit = unit;

  asData() => {'recipe': recipeReference, ' ingredient': ingredientReference, 'quantity': quantity, 'unit': unit};
}

RecipeIngredient recipeIngredientFromDocSnap(QueryDocumentSnapshot documentSnapshot) => RecipeIngredient(
    reference: documentSnapshot.reference,
    recipeReference: documentSnapshot['recipe'],
    ingredientReference: documentSnapshot['ingredient'],
    quantity: documentSnapshot['quantity'],
    unit: documentSnapshot['unit']);
