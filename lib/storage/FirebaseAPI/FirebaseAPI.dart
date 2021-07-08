import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grocerylister/Storage/FirebaseAPI/DataModel.dart';

abstract class FirebaseAPI {
  var dbRef;
  Stream stream;

  Future<void> delete(DataModel dataModel) async =>
      await dbRef.doc(dataModel.reference.id).delete().catchError((error) => print("Failed to delete recipe: $error"));

  Future<DocumentReference> add(DataModel dataModel) async => await dbRef
      .add(dataModel)
      .catchError((error) => print("Failed to add datamodel: $error") as DocumentReference<DataModel>);

  Future<void> update(DataModel dataModel) async => await dbRef
      .doc(dataModel.reference.id)
      .update(dataModel.toJson())
      .catchError((error) => print("Failed to update dataModel: $error") as DocumentReference<DataModel>);

  Future<DocumentReference> save(DataModel dataModel) {
    if (dataModel.reference == null) return add(dataModel);
    return update(dataModel) as Future<DocumentReference>;
  }

  Future<DataModel> getFromReference(DocumentReference reference) async {
    DataModel ret = await dbRef.doc(reference.id).get().then((DocumentSnapshot ds) {
      if (ds.exists) return ds.data();
    }).catchError((error) => print("Failed to get dataModel: $error"));
    return ret;
  }

  Future<List<DataModel>> getAll() async {
    List<DataModel> dataList = [];
    await dbRef.get().then((QuerySnapshot qs) {
      for (var doc in qs.docs) dataList.add(doc.data());
    });
    return dataList;
  }
}
