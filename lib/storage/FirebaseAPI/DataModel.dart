import 'package:cloud_firestore/cloud_firestore.dart';

abstract class DataModel {
  DocumentReference reference;

  Map<String, Object> toJson();
}
