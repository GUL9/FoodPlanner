import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grocerylister/APIs/FirebaseAPI/DataModel.dart';

class Shoppinglist implements DataModel {
  String id;
  String planId;
  bool allIngredientsBought;

  Timestamp createdAt;
  Timestamp lastModifiedAt;

  Shoppinglist({this.id, this.planId, this.createdAt, this.lastModifiedAt, this.allIngredientsBought});
  Shoppinglist.fromDocumentSnapshot(DocumentSnapshot ds)
      : this(
            id: ds.reference.id,
            planId: (ds.data() as Map<String, dynamic>)['planId'],
            createdAt: (ds.data() as Map<String, dynamic>)['createdAt'],
            lastModifiedAt: (ds.data() as Map<String, dynamic>)['lastModifiedAt'],
            allIngredientsBought: (ds.data() as Map<String, dynamic>)['allIngredientsBought']);

  Shoppinglist.fromJson(Map<String, dynamic> json)
      : this(
            planId: json['planId'],
            createdAt: json['createdAt'],
            lastModifiedAt: json['lastModifiedAt'],
            allIngredientsBought: json['allIngredientsBought']);

  Map<String, dynamic> toJson() => {
        'planId': planId,
        'createdAt': createdAt,
        'lastModifiedAt': lastModifiedAt,
        'allIngredientsBought': allIngredientsBought
      };
}
