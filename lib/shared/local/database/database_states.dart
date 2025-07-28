abstract class AppStates {}

class AppInitialState extends AppStates {}

class AppChangeIndexState extends AppStates {}

class AppChangeBottomNavBarState extends AppStates {}

class AppCreateDatabaseState extends AppStates {}

class AppGetDatabaseLoadingState extends AppStates {}

class AppGetDatabaseState extends AppStates {}

class AppInsertDatabaseState extends AppStates {}

class AppUpdateDatabaseState extends AppStates {}

class AppDeleteDatabaseState extends AppStates {}

class AppChangeBottomSheetState extends AppStates {}

class AppErrorState extends AppStates {
  final String error;
  AppErrorState(this.error);
}

class AppErrorDatabaseState extends AppStates {
  final String error;
  AppErrorDatabaseState(this.error);
}