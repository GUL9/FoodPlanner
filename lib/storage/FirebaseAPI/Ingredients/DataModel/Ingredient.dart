import 'package:cloud_firestore/cloud_firestore.dart';

class Ingredient {
  DocumentReference reference;
  String name;

  Ingredient({DocumentReference reference, String name})
      : this.reference = reference,
        this.name = name;
  asData() => {'name': name};
}

Ingredient ingredientFromDocSnap(QueryDocumentSnapshot ingredientSnapshot) =>
    Ingredient(reference: ingredientSnapshot.reference, name: ingredientSnapshot['name']);
