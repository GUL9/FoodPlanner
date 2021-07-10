import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grocerylister/Storage/FirebaseAPI/DataModel.dart';

class Plan implements DataModel {
  String id;
  Timestamp createdAt;
  Timestamp lastModifiedAt;

  List<dynamic> recipes;

  Plan({this.id, this.createdAt, this.lastModifiedAt, this.recipes});

  Plan.fromDocumentSnapshot(DocumentSnapshot ds)
      : this(
            id: ds.reference.id,
            createdAt: (ds.data() as Map<String, dynamic>)['createdAt'],
            lastModifiedAt: (ds.data() as Map<String, dynamic>)['lastModifiedAt'],
            recipes: (ds.data() as Map<String, dynamic>)['recipes']);

  Plan.fromJson(Map<String, dynamic> json)
      : this(createdAt: json['createdAt'], lastModifiedAt: json['lastModifiedAt'], recipes: (json)['recipes']);

  Map<String, dynamic> toJson() => {'createdAt': createdAt, 'lastModifiedAt': lastModifiedAt, 'recipes': recipes};
}
