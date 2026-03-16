import 'app/my_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'data/repositories_impl/local/flutter_secure_storage_repository.dart';


void main() {
  final flutterSecureStorage = FlutterSecureStorage();
  final repository = FlutterSecureStorageRepository(
      flutterSecureStorage: flutterSecureStorage);
  repository.saveEncryptionKey();
  runApp(const MyApp());
}







