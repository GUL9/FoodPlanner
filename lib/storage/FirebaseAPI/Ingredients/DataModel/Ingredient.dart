import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grocerylister/Storage/FirebaseAPI/DataModel.dart';

class Ingredient implements DataModel {
  DocumentReference reference;
  String name;

  Ingredient({this.reference, this.name});

  Ingredient.fromDocumentSnapshot(DocumentSnapshot ds)
      : this(reference: ds.reference, name: (ds.data() as Map<String, dynamic>)['name'] as String);

  Ingredient.fromJson(Map<String, Object> json) : this(name: json['name'] as String);

  Map<String, Object> toJson() => {'name': name};
}
