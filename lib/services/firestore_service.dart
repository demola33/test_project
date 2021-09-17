import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FirestoreService {
  FirestoreService._();
  static final instance = FirestoreService._();

  Future<void> setData({
    @required String? path,
    @required Map<String, dynamic>? data,
  }) async {
    try {
      final reference = FirebaseFirestore.instance.doc(path!);
      await reference.set(data!);
    } catch (e) {
      print('SetError: ${e.toString()}');
    }
  }

  Future<T> getData<T>({
    @required String? path,
    required T Function(Map<String, dynamic>? data) builder,
  }) async {
    final DocumentReference<Map<String, dynamic>> reference =
        FirebaseFirestore.instance.doc(path!);
    final snapshots = await reference.get();
    final data = builder(snapshots.data());
    return data;
  }
}
