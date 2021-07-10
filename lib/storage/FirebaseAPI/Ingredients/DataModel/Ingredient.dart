import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grocerylister/Storage/FirebaseAPI/DataModel.dart';

class Ingredient implements DataModel {
  String id;
  String name;

  Ingredient({this.id, this.name});

  Ingredient.fromDocumentSnapshot(DocumentSnapshot ds)
      : this(id: ds.reference.id, name: (ds.data() as Map<String, dynamic>)['name']);

  Ingredient.fromJson(Map<String, dynamic> json) : this(name: json['name']);

  Map<String, dynamic> toJson() => {'name': name};
}
