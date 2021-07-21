import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grocerylister/Storage/FirebaseAPI/DataModel.dart';

class Ingredient implements DataModel {
  String id;
  String name;
  bool isInStock;

  Ingredient({this.id, this.name, this.isInStock});

  Ingredient.fromDocumentSnapshot(DocumentSnapshot ds)
      : this(
            id: ds.reference.id,
            name: (ds.data() as Map<String, dynamic>)['name'],
            isInStock: (ds.data() as Map<String, dynamic>)['isInStock']);

  Ingredient.fromJson(Map<String, dynamic> json) : this(name: json['name'], isInStock: json['isInStock']);

  Map<String, dynamic> toJson() => {'name': name, 'isInStock': isInStock};
}
