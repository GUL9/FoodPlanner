import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grocerylister/Storage/FirebaseAPI/DataModel.dart';

abstract class FirebaseAPI {
  var dbRef;
  Stream stream;

  Future<void> delete(DataModel dataModel) async {
    return await dbRef
        .doc(dataModel.id)
        .delete()
        .catchError((error) => stderr.writeln("Failed to delete datamodel: $error"));
  }

  Future<String> add(DataModel dataModel) async {
    var reference = await dbRef.add(dataModel).catchError((error) => stderr.writeln("Failed to add datamodel: $error"));
    return reference.id;
  }

  Future<String> update(DataModel dataModel) async {
    var reference = await dbRef
        .doc(dataModel.id)
        .update(dataModel.toJson())
        .catchError((error) => stderr.writeln("Failed to update dataModel: $error"));
    return reference.id;
  }

  Future<String> save(DataModel dataModel) {
    if (dataModel.id == null) return add(dataModel);
    return update(dataModel);
  }

  Future<DataModel> getFromId(String id) async {
    DataModel ret = await dbRef.doc(id).get().then((DocumentSnapshot ds) {
      if (ds.exists) return ds.data();
    }).catchError((error) => stderr.writeln("Failed to get dataModel: $error"));
    return ret;
  }

  Future<List<DataModel>> getAll() async {
    List<DataModel> dataList = [];
    await dbRef.get().then((QuerySnapshot qs) {
      for (var doc in qs.docs) dataList.add(doc.data());
    }).catchError((error) => stderr.writeln("Failed to get all dataModels: $error"));
    return dataList;
  }
}
