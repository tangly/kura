import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService<T> {
  final String collectionPath;
  final T Function(Map<String, dynamic> data, String documentId) fromJson;
  final Query<T> Function(Query<T> query, String? familyId)? queryBuilder;

  FirestoreService({required this.collectionPath, required this.fromJson, this.queryBuilder});

  FirebaseFirestore get _firestore => FirebaseFirestore.instance;

  CollectionReference<T> get _collection =>
      _firestore.collection(collectionPath).withConverter<T>(
            fromFirestore: (snapshot, _) => fromJson(snapshot.data()!, snapshot.id),
            toFirestore: (value, _) => (value as dynamic).toJson(),
          );

  Future<String> create(T data, [String? id]) async {
    final docRef = _collection.doc(id);
    await docRef.set(data);
    return docRef.id;
  }

  Future<T?> get(String id) async {
    final snapshot = await _collection.doc(id).get();
    return snapshot.data();
  }

  Stream<T?> getStream(String id) {
    return _collection.doc(id).snapshots().map((snapshot) => snapshot.data());
  }

  Future<void> update(String id, Map<String, dynamic> data) {
    return _collection.doc(id).update(data);
  }

  Future<void> delete(String id) {
    return _collection.doc(id).delete();
  }

  Stream<List<T>> getListStream({String? familyId}) {
    Query<T> query = _collection;
    if (familyId != null && queryBuilder != null) {
      query = queryBuilder!(query, familyId);
    }
    return query.snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => doc.data()).toList());
  }
}