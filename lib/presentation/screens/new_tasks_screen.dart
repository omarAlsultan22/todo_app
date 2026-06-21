import '../states/tasks_state.dart';
import '../cubits/tasks_cubit.dart';
import 'package:flutter/material.dart';
import '../widgets/lists/list_builder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../widgets/states/error_state_widget.dart';
import '../widgets/states/initial_state_widget.dart';


class NewTasksScreen extends StatelessWidget {
  const NewTasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TasksCubit, TasksState>(
      builder: (context, state) {
        final cubit = TasksCubit.get(context);
        return state.when<Widget>(
            onInitial: () => const InitialStateWidget(),
            onLoading: () => const Center(child: CircularProgressIndicator()),
            onLoaded: (newData, bottomSheetState, messageResult) =>
                ListBuilder(
                  isLocked: false,
                  tasks: newData!.tasks,
                  hasMore: newData.hasMore,
                  messageResult: messageResult,
                  onScroll: () =>
                      cubit.loadMoreData(),
                  updateData: (id, status) =>
                      cubit.updateData(id: id, status: status),
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
