import 'package:flutter/widgets.dart';
import 'base/main_app_sub_state.dart';
import '../../data/models/category_data.dart';
import '../../errors/exceptions/base/app_exception.dart';
import '../../data/models/ChangeBottomSheetStateModel.dart';


class TasksState {
  final BottomSheetState? bottomSheetState;
  final Map<int, CategoryData> tabsData;
  final MainAppSubState subState;
  final List<String>? statusList;
  final int currentTabIndex;

  const TasksState({
    required this.bottomSheetState,
    required this.currentTabIndex,
    required this.tabsData,
    required this.subState,
    this.statusList
  });

  CategoryData? get currentTabData => tabsData[currentTabIndex];

  bool get productsIsEmpty => currentTabData!.productsIsEmpty;

  bool get hasMore => currentTabData!.hasMore;

  int get length => currentTabData!.length;

  int get offset => currentTabData!.offset;

  IconData get icon => bottomSheetState!.icon;

  bool get isVisible => bottomSheetState!.isVisible;

  String get status => statusList![currentTabIndex];

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

    MainAppSubState? subState,
    int? currentTabIndex,
  }) {
    return TasksState(
      subState: subState ?? this.subState,
      tabsData: tabsData ?? this.tabsData,

      bottomSheetState: bottomSheetState ?? this.bottomSheetState,
      currentTabIndex: currentTabIndex ?? this.currentTabIndex,
    );
  }

  R when<R>({
    required R Function() onInitial,
    required R Function() onLoading,
    required R Function(CategoryData?) onLoaded,
    required R Function(AppException) onError,
  }) {
    return subState.when(
        onInitial: onInitial,
        onLoading: onLoading,
        onLoaded: () => onLoaded(currentTabData),
        onError: (failure) => onError(failure)
    );
  }
}