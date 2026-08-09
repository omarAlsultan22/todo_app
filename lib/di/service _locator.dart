import 'core/di_core.dart';
import 'package:get_it/get_it.dart';
import 'package:todo_app/di/domains/di_evaluation.dart';


final sl = GetIt.instance;

void setupServiceLocator() {
  // ============ Core ============
  CoreDependencies.register();

  // ============ Domains ============
  TasksDependencies.register();
}