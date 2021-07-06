import 'package:flutter/cupertino.dart';
import 'package:grocerylister/Storage/FirebaseAPI/DataModel.dart';

abstract class FirebaseAPI {
  Stream stream;

  static getAllFromSnapshot(AsyncSnapshot snapshot) {}

  static delete(DataModel dataModel) async {}

  static save(DataModel dataModel) async {}
}
