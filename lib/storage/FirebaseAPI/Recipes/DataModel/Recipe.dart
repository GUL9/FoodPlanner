import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grocerylister/Storage/FirebaseAPI/DataModel.dart';

class Recipe implements DataModel {
  String id;
  String name;

  Recipe({this.id, this.name});

  Recipe.fromDocumentSnapshot(DocumentSnapshot ds)
      : this(id: ds.reference.id, name: (ds.data() as Map<String, dynamic>)['name']);

  Recipe.fromJson(Map<String, dynamic> json) : this(name: json['name']);

  Map<String, dynamic> toJson() => {'name': name};
}
