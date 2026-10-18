import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:todo_app/domain/services/tasks_data_source.dart';
import 'package:todo_app/domain/repositories/tasks_repository.dart';
import 'package:todo_app/domain/repositories/encryption_keys_repository.dart';


class TasksRepositoryImpl implements TasksRepository {
  final TasksDataSource _dataSource;
  final EncryptionKeysRepository _encryptionKeysRepository;

  TasksRepositoryImpl({
    required TasksDataSource dataSource,
    required EncryptionKeysRepository encryptionKeysRepository,
  })  : _dataSource = dataSource,
        _encryptionKeysRepository = encryptionKeysRepository;

  @override
  Future<void> createDatabase(VoidCallback onLoad) async {
    final password = await _encryptionKeysRepository.getEncryptionKey();
    await _dataSource.createDatabase(password: password, onLoad: onLoad);
  }

  @override
  Future<Map<String, Object?>> insertToDatabase({
    required String title,
    required String time,
    required String date,
  }) async {
      return await _dataSource.insertToDatabase(
        title: title,
        time: time,
        date: date,
      );
  }

  @override
  Future<int> getTaskPosition({
    required String date,
    required String time,
    required String status,
  }) async {
      return await _dataSource.getTaskPosition(
        date: date,
        time: time,
        status: status,
      );
  }

  @override
  Future<List<Map<String, Object?>>> getDataFromDatabase({
    required int limit,
    required int offset,
    required String status,
  }) async {
      return await _dataSource.getDataFromDatabase(
        limit: limit,
        offset: offset,
        status: status,
      );
  }

  @override
  Future<Map<String, Object?>> updateInDatabase({
    required String status,
    required int id,
  }) async {
      return await _dataSource.updateInDatabase(status: status, id: id);
  }

  @override
  Future<void> deleteFromDatabase({required int id}) async {
      await _dataSource.deleteFromDatabase(id: id);
  }
}