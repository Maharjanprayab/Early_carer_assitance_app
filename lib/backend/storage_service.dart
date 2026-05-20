import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  StorageService({
    FirebaseAuth? auth,
    FirebaseStorage? storage,
  })  : _auth = auth ?? FirebaseAuth.instance,
        _storage = storage ?? FirebaseStorage.instance;

  final FirebaseAuth _auth;
  final FirebaseStorage _storage;

  Future<String> uploadPortfolioImage({
    required File imageFile,
    required String projectId,
  }) async {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception('User must be logged in.');
    }

    final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';

    final ref = _storage
        .ref()
        .child('portfolio_uploads')
        .child(user.uid)
        .child(projectId)
        .child(fileName);

    final uploadTask = await ref.putFile(
      imageFile,
      SettableMetadata(contentType: 'image/jpeg'),
    );

    return uploadTask.ref.getDownloadURL();
  }

  Future<void> deleteFileByUrl(String fileUrl) async {
    if (fileUrl.trim().isEmpty) {
      return;
    }

    final ref = _storage.refFromURL(fileUrl);
    await ref.delete();
  }
}