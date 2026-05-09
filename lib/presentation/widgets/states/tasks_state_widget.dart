import 'initial_state_widget.dart';
import 'package:flutter/material.dart';
import '../../cubits/tasks_cubit.dart';
import '../../../data/models/task_model.dart';
import 'package:todo_app/presentation/constants/ui_sizes.dart';
import 'package:todo_app/presentation/constants/ui_colors.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';


class TasksStateWidget extends StatelessWidget {
  final List<TaskModel> tasks;

  const TasksStateWidget({required this.tasks, super.key});

  static const _spacingHorizontal = SizedBox(width: 20.0);

  @override
  Widget build(BuildContext context) {
    return ConditionalBuilder(
        condition: tasks.isNotEmpty,
        builder: (context) =>
            ListView.separated(
                itemBuilder: (context, index) =>
                    _buildTaskItem(tasks[index], context),
                separatorBuilder: (context, index) =>
                    Padding(
                      padding: const EdgeInsetsDirectional.only(
                        start: UiSizes.padding,
                      ),
                      child: Container(
                        width: double.infinity,
                        height: 1.0,
                        color: UiColors.gery_300,
                      ),
                    ),
                itemCount: tasks.length),
        fallback: (context) =>
            InitialStateWidget()
    );
  }


  Widget _buildTaskItem(TaskModel model, BuildContext context) {
    return Dismissible(key: Key(model.id.toString()),
      child: Row(
        children: [
          CircleAvatar(
            radius: 40.0,
            child: Text(model.time
            ),
          ),
          _spacingHorizontal,
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(model.title,
                  style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold
                  ),
                ), _spacingHorizontal,
                Text(model.date,
                  style: TextStyle(
                      color: UiColors.gery_500
                  ),
                ),
              ],
            ),
          ),
          _spacingHorizontal,
          IconButton(
              onPressed: () {
                TasksCubit.get(context).updateData(
                    status: 'done', id: model.id, context: context);
              },
              icon: Icon(Icons.check_box)),
          IconButton(
              onPressed: () {
                TasksCubit.get(context).updateData(
                    status: 'archive', id: model.id, context: context);
              },
              icon: Icon(Icons.archive_outlined)),
        ],
      ), onDismissed: (direction) {
        TasksCubit.get(context).deleteData(id: model.id, context: context);
      },
    );
  }
}
