import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grocerylister/Storage/FirebaseAPI/DataModel.dart';

class Plan implements DataModel {
  DocumentReference reference;
  Timestamp createdAt;
  Timestamp lastModifiedAt;

  List<dynamic> recipes;

  Plan({this.reference, this.createdAt, this.lastModifiedAt, this.recipes});

  Plan.fromDocumentSnapshot(DocumentSnapshot ds)
      : this(
            reference: ds.reference,
            createdAt: (ds.data() as Map<String, dynamic>)['created_at'] as Timestamp,
            lastModifiedAt: (ds.data() as Map<String, dynamic>)['last_modified_at'] as Timestamp,
            recipes: (ds.data() as Map<String, dynamic>)['recipes']);

  Plan.fromJson(Map<String, Object> json)
      : this(
            createdAt: json['created_at'] as Timestamp,
            lastModifiedAt: json['last_modified_at'] as Timestamp,
            recipes: (json)['recipes'] as List<DocumentReference>);

  Map<String, Object> toJson() => {'created_at': createdAt, 'last_modified_at': lastModifiedAt, 'recipes': recipes};
}
