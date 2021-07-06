// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:grocerylister/Storage/FirebaseAPI/DataModelAdapter.dart';
// import 'package:grocerylister/Storage/FirebaseAPI/Plans/DataModel/Plan.dart';
// import 'package:grocerylister/Storage/FirebaseAPI/Recipes/RecipesAPI.dart';

// class PlanAdapter implements DataModelAdapter {
//   static Plan fromDocSnap(QueryDocumentSnapshot planSnapshot) {
//     List recipeReferences = planSnapshot['recipes'];
//     for (var reference in recipeReferences) {
//       getRecipeFromReference(reference);
//     }
//     return Plan(
//         reference: planSnapshot.reference,
//         createdAt: planSnapshot['created_at'],
//         lastModifiedAt: planSnapshot['last_modified_at'],
//         recipes: planSnapshot['recipes']);
//   }
// }
