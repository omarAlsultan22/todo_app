import '../../cubits/tasks_cubit.dart';
import '../../states/tasks_state.dart';
import 'package:flutter/cupertino.dart';
import '../../widgets/lists/list_builder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../widgets/states/error_state_widget.dart';
import '../../widgets/states/initial_state_widget.dart';
import '../../widgets/states/loading_state_widget.dart';


abstract class BaseTabScreen extends StatelessWidget {
  const BaseTabScreen({super.key});

  int get screenIndex;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TasksCubit, TasksState>(
      buildWhen: (previous, current) => current.currentTabIndex == screenIndex,
      builder: (context, state) {
        final cubit = TasksCubit.get(context);
        return state.when<Widget>(
            onInitial: () => const InitialStateWidget(),
            onLoading: () => const LoadingStateWidget(),
            onLoaded: (newData, bottomSheetState, messageResult) =>
                ListBuilder(
                  isLocked: false,
                  tasks: newData!.tasks,
                  hasMore: newData.hasMore,
                  messageResult: messageResult,
                  onScroll: () =>
                      cubit.loadMoreData(),
                  updateData: (index, id, status) =>
                      cubit.updateData(
                          id: id,
                          index: index,
                          status: status
                      ),
                  deleteData: (id) =>
                      cubit.deleteData(id: id),
                ),
            onError: (error) =>
                ErrorStateWidget(error: error.message,
                    onRetry: () =>
                        cubit.loadMoreData()
                )
        );
      },
    );
  }
}