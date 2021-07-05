import 'package:cloud_firestore/cloud_firestore.dart';

class Recipe {
  DocumentReference reference;
  String name;

  Recipe({DocumentReference reference, String name})
      : this.reference = reference,
        this.name = name;
  asData() => {'name': name};
}

Recipe recipeFromDocSnap(QueryDocumentSnapshot recipeSnapshot) =>
    Recipe(reference: recipeSnapshot.reference, name: recipeSnapshot['name']);
