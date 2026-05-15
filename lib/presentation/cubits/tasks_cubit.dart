import '../states/tasks_state.dart';
import '../constants/ui_strings.dart';
import 'package:flutter/material.dart';
import '../../errors/error_handler.dart';
import '../../data/models/category_data.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/constants/app_icons.dart';
import '../../domain/useCases/useCase_operations.dart';
import '../../domain/repositories/data_repository.dart';
import '../../errors/exceptions/base/app_exception.dart';
import '../../data/models/ChangeBottomSheetStateModel.dart';
import 'package:todo_app/presentation/constants/ui_sizes.dart';
import 'package:todo_app/presentation/states/app_sub_states.dart';


class TasksCubit extends Cubit<TasksState> {
  final GetTasksUseCase _useCase;
  final DataRepository _repository;

  static const int _initialTabIndex = 0;
  static const int _initialTabCount = 3;

  TasksCubit({
    required GetTasksUseCase useCase,
    required DataRepository repository,
  })
      : _useCase = useCase,
        _repository = repository,
        super(TasksState(currentTabIndex: _initialTabIndex,
          tabsData: {
            for (var i = _initialTabIndex; i < _initialTabCount; i++)
              i: const CategoryData()
          },
          subState: InitialState(),
          statusList: UiStrings.statusList,
          bottomSheetState: const BottomSheetState()));

  static TasksCubit get(context) => BlocProvider.of(context);

  static const _limit = UiSizes.defaultPageSize;

  void _showMessage({
    required AppException error,
    required BuildContext context
  }) =>
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error.toString())));

  Future<void> _loadTasks(String status) async {
    final tasks = await _useCase.execute(
        limit: _limit,
        status: status,
        offset: state.offset + _limit
    );
    emit(
        state.updateTab(state.currentTabIndex, tasks)
            .copyWith(subState: SuccessState()));
  }

  Future<void> changeScreen(int index) async {
    emit(state.copyWith(currentTabIndex: index));
    if (!state.productsIsEmpty) return;

    emit(state.copyWith(subState: LoadingState()));

    try {
      await _loadTasks(state.status);
    }
    catch (e, stackTrace) {
      final errorHandler = ErrorHandler(
          error: e,
          stackTrace: stackTrace
      );
      final exception = errorHandler.handleException();
      emit(state.copyWith(subState: ErrorState(failure: exception)));
    }
  }

  Future<void> insertData({
    required String title,
    required String time,
    required String date,
    required BuildContext context
  }) async {
    try {
      await _repository.insertToDatabase(
          title: title,
          time: time,
          date: date
      ).then((_) {
        if (state.length < _limit) {
          _loadTasks(state.status);
        }
      });
    }
    catch (e, stackTrace) {
      final errorHandler = ErrorHandler(
          error: e,
          stackTrace: stackTrace
      );
      final exception = errorHandler.handleException();
      _showMessage(error: exception, context: context);
    }
  }

  Future<void> loadMoreData(String status) async {
    if (!state.hasMore) return;
    try {
      await _loadTasks(status);
    }
    catch (e) {
      Future.delayed(const Duration(seconds: 3), () {
        loadMoreData(status);
      });
    }
  }

  void updateData({
    required int id,
    required String status,
    required BuildContext context
  }) {
    try {
      _repository.updateInDatabase(status: status, id: id).then((_) async {
        await loadMoreData(status);
      });
    }
    catch (e, stackTrace) {
      final errorHandler = ErrorHandler(
          error: e,
          stackTrace: stackTrace
      );
      final exception = errorHandler.handleException();
      _showMessage(error: exception, context: context);
    }
  }

  void deleteData({
    required int id,
    required BuildContext context,
  }) {
    try {
      _repository.deleteFromDatabase(id: id);
    }
    catch (e, stackTrace) {
      final errorHandler = ErrorHandler(
          error: e,
          stackTrace: stackTrace
      );
      final exception = errorHandler.handleException();
      _showMessage(error: exception, context: context);
    }
  }

  void toggleBottomSheet({
    required bool isVisible,
    required IconData icon
  }) {
    final bottomSheetState = BottomSheetState(
      isVisible: isVisible,
      icon: isVisible ? AppIcons.editIcon : Icons.close,
    );
    emit(state.copyWith(bottomSheetState: bottomSheetState));
  }
}
