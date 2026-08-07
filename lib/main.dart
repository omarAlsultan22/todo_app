import 'app/my_app.dart';
import 'errors/error_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'data/repositories_impl/local/flutter_secure_storage_repository.dart';


Future<void> main() async {
  final flutterSecureStorage = FlutterSecureStorage();
  final repository = FlutterSecureStorageRepository(
      flutterSecureStorage: flutterSecureStorage);

  try {
    await repository.saveEncryptionKey();
    runApp(const MyApp());
  }
  catch (e, stackTrace) {
    final errorHandler = ErrorHandler(
      error: e,
      stackTrace: stackTrace,
    );
    final exception = errorHandler.handleException();
    runApp(
        MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Scaffold(
            body: exception.buildErrorWidget(
                onRetry: () => runApp(const MyApp())
            ),
          ),
        )
    );
  }
}







