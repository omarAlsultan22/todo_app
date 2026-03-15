import 'app/my_app.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/data/repository_impl/local/encryption_keys_store.dart';


void main() {
  EncryptionKeysStore.saveEncryptionKey();
  runApp(const MyApp());
}







