import 'package:flutter_test_project/model/level.dart';
import 'package:flutter_test_project/services/api_path.dart';
import 'package:flutter_test_project/services/firestore_service.dart';

abstract class Database {
  Future<void> setLevel(Level level);
  Future<Level> getLevel();
}

class FirestoreDatabase {
  FirestoreDatabase(this.uid);
  final String uid;
  final _service = FirestoreService.instance;

  Future<void> setLevel(Level level) async => await _service.setData(
        path: ApiPath.level(uid),
        data: level.toMap(),
      );

  Future<Level> getLevel() => _service.getData(
        path: ApiPath.level(uid),
        builder: (data) => Level.fromMap(data!),
      );
}
