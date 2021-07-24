import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grocerylister/APIs/FirebaseAPI/DataModel.dart';

class Shoppinglist implements DataModel {
  String id;
  String planId;

  Timestamp createdAt;
  Timestamp lastModifiedAt;

  Shoppinglist({this.id, this.planId, this.createdAt, this.lastModifiedAt});
  Shoppinglist.fromDocumentSnapshot(DocumentSnapshot ds)
      : this(
            id: ds.reference.id,
            planId: (ds.data() as Map<String, dynamic>)['planId'],
            createdAt: (ds.data() as Map<String, dynamic>)['createdAt'],
            lastModifiedAt: (ds.data() as Map<String, dynamic>)['lastModifiedAt']);

  Shoppinglist.fromJson(Map<String, dynamic> json)
      : this(planId: json['planId'], createdAt: json['createdAt'], lastModifiedAt: json['lastModifiedAt']);

  Map<String, dynamic> toJson() => {'planId': planId, 'createdAt': createdAt, 'lastModifiedAt': lastModifiedAt};
}
