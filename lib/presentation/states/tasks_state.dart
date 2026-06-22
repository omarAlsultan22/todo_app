import 'app_sub_states.dart';
import '../constants/ui_strings.dart';
import 'base/main_app_sub_state.dart';
import '../../data/models/category_data.dart';
import 'package:todo_app/data/models/task_model.dart';
import '../../errors/exceptions/base/app_exception.dart';
import 'package:todo_app/data/models/message_result.dart';
import '../../data/models/ChangeBottomSheetStateModel.dart';


class TasksState {
  final BottomSheetState? bottomSheetState;
  final Map<int, CategoryData> tabsData;
  final MessageResult messageResult;
  final MainAppSubState subState;
  final List<String> statusesList;
  final int currentTabIndex;

  const TasksState({
    required this.bottomSheetState,
    required this.currentTabIndex,
    required this.messageResult,
    required this.statusesList,
    required this.tabsData,
    required this.subState,
  });

  factory TasksState.initial(){
    return TasksState(
        currentTabIndex: 0,
        tabsData: {
          for (var i = 0; i < 3; i++)
            i: const CategoryData()
        },
        subState: InitialState(),
        statusesList: UiStrings.statusList,
        messageResult: MessageResult.initial(),
        bottomSheetState: const BottomSheetState()
    );
  }

  CategoryData? get currentTabData => tabsData[currentTabIndex];

  bool get tasksIsNotEmpty => currentTabData!.productsIsNotEmpty;

  List<TaskModel> get tasks => currentTabData!.tasks;

  bool get hasMore => currentTabData!.hasMore;

  int get length => currentTabData!.length;

  int get offset => currentTabData!.offset;

  String get status => statusesList[currentTabIndex];

  CategoryData? getTabData(int index) {
    return tabsData[index];
  }

  List<TaskModel> insertTaskByPosition(int position, List<TaskModel> tasks,
      TaskModel newTask) {
    final tasksModels = tasks;
    if(tasksModels.isEmpty){
      tasksModels.add(newTask);
    }
    else {
      tasksModels.insert(position, newTask);
    }
    return tasksModels;
  }

  CategoryData deleteTask(int id) {
    final tasksModels = List<TaskModel>.from(tasks);
    if (tasksModels.length < 2) {
      tasksModels.clear();
    }
    else {
      tasksModels.removeWhere((e) => e.id == id);
    }
    return CategoryData(
        tasks: tasksModels,
        hasMore: hasMore,
        offset: offset
    );
  }

  TasksState updateTab(int index, CategoryData newTabData) {
    return copyWith(
        tabsData: {
          ...tabsData,
          index: newTabData,
        }
    );
  }

  TasksState copyWith({
    BottomSheetState? bottomSheetState,
    Map<int, CategoryData>? tabsData,
    MessageResult? messageResult,
    List<String>? statusesList,
    MainAppSubState? subState,
    int? currentTabIndex,
  }) {
    return TasksState(
        subState: subState ?? this.subState,
        tabsData: tabsData ?? this.tabsData,
        statusesList: statusesList ?? this.statusesList,
        messageResult: messageResult ?? this.messageResult,
        currentTabIndex: currentTabIndex ?? this.currentTabIndex,
        bottomSheetState: bottomSheetState ?? this.bottomSheetState
    );
  }

  R when<R>({
    required R Function() onInitial,
    required R Function() onLoading,
    required R Function(CategoryData?, BottomSheetState?, MessageResult) onLoaded,
    required R Function(AppException) onError,
  }) {
    return subState.when(
        onInitial: onInitial,
        onLoading: onLoading,
        onLoaded: () =>
            onLoaded(currentTabData, bottomSheetState, messageResult),
        onError: (failure) => onError(failure)
    );
  }
}