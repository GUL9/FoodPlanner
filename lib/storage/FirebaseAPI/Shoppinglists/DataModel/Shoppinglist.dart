import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grocerylister/Storage/FirebaseAPI/DataModel.dart';

class Shoppinglist implements DataModel {
  DocumentReference reference;
  DocumentReference planReference;

  Shoppinglist({this.reference, this.planReference});
  Shoppinglist.fromDocumentSnapshot(DocumentSnapshot ds)
      : this(reference: ds.reference, planReference: (ds.data() as Map<String, dynamic>)['plan']);

  Shoppinglist.fromJson(Map<String, Object> json) : this(planReference: json['plan']);

  Map<String, Object> toJson() => {'plan': planReference};
}
