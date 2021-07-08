import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grocerylister/Storage/FirebaseAPI/DataModel.dart';

class Shoppinglist implements DataModel {
  DocumentReference reference;
  DocumentReference planReference;

  Timestamp createdAt;
  Timestamp lastModifiedAt;

  Shoppinglist({this.reference, this.planReference, this.createdAt, this.lastModifiedAt});
  Shoppinglist.fromDocumentSnapshot(DocumentSnapshot ds)
      : this(
            reference: ds.reference,
            planReference: (ds.data() as Map<String, dynamic>)['plan'],
            createdAt: (ds.data() as Map<String, dynamic>)['created_at'],
            lastModifiedAt: (ds.data() as Map<String, dynamic>)['last_modified_at']);

  Shoppinglist.fromJson(Map<String, Object> json)
      : this(planReference: json['plan'], createdAt: json['created_at'], lastModifiedAt: json['last_modified_at']);

  Map<String, Object> toJson() => {'plan': planReference, 'created_at': createdAt, 'last_modified_at': lastModifiedAt};
}
