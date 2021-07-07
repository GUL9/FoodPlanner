import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grocerylister/Storage/FirebaseAPI/DataModel.dart';

abstract class FirebaseAPI {
  var dbRef;
  Stream stream;

  Future<void> delete(DataModel dataModel) =>
      dbRef.doc(dataModel.reference.id).delete().catchError((error) => print("Failed to delete recipe: $error"));

  Future<DocumentReference> add(DataModel recipe) async {
    return await dbRef
        .add(recipe)
        .catchError((error) => print("Failed to add datamodel: $error") as DocumentReference<DataModel>);
  }

  Future<void> update(DataModel recipe) async {
    return await dbRef
        .doc(recipe.reference.id)
        .update(recipe.toJson())
        .catchError((error) => print("Failed to update recipe: $error") as DocumentReference<DataModel>);
  }

  Future<DocumentReference> save(DataModel recipe) async {
    if (recipe.reference == null) return add(recipe);
    return update(recipe) as DocumentReference;
  }
}
