import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grocerylister/Storage/FirebaseAPI/DataModel.dart';

class Recipe implements DataModel {
  DocumentReference reference;
  String name;

  Recipe({this.reference, this.name});

  Recipe.fromDocumentSnapshot(DocumentSnapshot ds)
      : this(reference: ds.reference, name: (ds.data() as Map<String, dynamic>)['name'] as String);

  Recipe.fromJson(Map<String, Object> json) : this(name: json['name'] as String);

  Map<String, Object> toJson() => {'name': name};
}
