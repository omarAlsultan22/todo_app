import '../cubits/tasks_cubit.dart';
import '../states/tasks_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/presentation/widgets/layouts/home_layout.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TasksCubit, TasksState>(
        builder: (context, state) {
          final cubit = TasksCubit.get(context);

          return HomeLayout(
            currentIndex: state.currentTabIndex,
            insertData: ({
              required title,
              required time,
              required date,
              required context}) =>
                cubit.insertData(
                    time: time,
                    date: date,
                    title: title,
                ),
            bottomSheetState: state.bottomSheetState,
            onChange: (index) => cubit.changeScreen(index: index),
            toggleBottomSheet: (isVisible) =>
                cubit.toggleBottomSheet(isVisible: isVisible),
          );
        }
    );
  }
}
