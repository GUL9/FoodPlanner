import 'package:cloud_firestore/cloud_firestore.dart';

class Recipe {
  DocumentReference reference;
  String name;

  Recipe({this.reference, this.name});

  Recipe.fromDocumentSnapshot(DocumentSnapshot ds)
      : this(reference: ds.reference, name: (ds.data() as Map<String, dynamic>)['name'] as String);

  Recipe.fromJson(Map<String, Object> json)
      : this(reference: json['reference'] as DocumentReference, name: json['name'] as String);

  Map<String, Object> toJson() => {'name': name};
}
