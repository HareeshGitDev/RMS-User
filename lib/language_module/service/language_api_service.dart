import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../utils/firestore_model.dart';

class LanguageApiService{
  final FirebaseFirestore cloudFirestore = FirebaseFirestore.instance;
  late CollectionReference collectionReference;

  Future<List<FirestoreModel>> fetchLanguagesData(
      {required String language, required String pageName}) async {
    collectionReference =
        cloudFirestore.collection('RMSUser').doc(pageName).collection(language);

    try {
      var data = await collectionReference.get();
      List<FirestoreModel> list= data.docs
          .map((snapshot) =>
          FirestoreModel.fromJson(snapshot.data() as Map<String, dynamic>))
          .toList();
      for (var element in list) {
        log(element.name.toString());
      }
      return list;

    } catch (e) {
      log(e.toString());
    }
    return [];
  }

}