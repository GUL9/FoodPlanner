import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grocerylister/Storage/FirebaseAPI/DataModel.dart';
import 'package:grocerylister/Storage/FirebaseAPI/Recipes/DataModel/Recipe.dart';

class Plan implements DataModel {
  DocumentReference reference;
  Timestamp createdAt;
  Timestamp lastModifiedAt;

  List<Recipe> recipes;

  Plan({
    this.reference,
    this.createdAt,
    this.lastModifiedAt,
    this.recipes,
  });

  asData() => {
        'created_at': createdAt,
        'last_modified_at': lastModifiedAt,
        'recipes': recipes.map((r) => r.reference).toList()
      };
}
