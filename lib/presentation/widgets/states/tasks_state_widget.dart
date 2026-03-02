import 'initial_state_widget.dart';
import 'package:flutter/material.dart';
import '../../cubits/tasks_cubit.dart';
import '../../../data/models/task_model.dart';
import 'package:todo_app/core/constants/constants_numbers.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';


class TasksStateWidget extends StatelessWidget {
  final List<TaskModel> tasks;

  const TasksStateWidget({required this.tasks, super.key});


  @override
  Widget build(BuildContext context) {
    const one = 1.0;
    return ConditionalBuilder(
        condition: tasks.isNotEmpty,
        builder: (context) =>
            ListView.separated(
                itemBuilder: (context, index) =>
                    _buildTaskItem(tasks[index], context),
                separatorBuilder: (context, index) =>
                    Padding(
                      padding: const EdgeInsetsDirectional.only(
                        start: 20.0,
                      ),
                      child: Container(
                        width: double.infinity,
                        height: one,
                        color: Colors.grey[ConstantsNumbers.threeHundred],
                      ),
                    ),
                itemCount: tasks.length),
        fallback: (context) =>
            InitialStateWidget()
    );
  }


  Widget _buildTaskItem(TaskModel model, BuildContext context) {
    const done = 'done';
    const archive = 'archive';

    const radius = 40.0;
    const sizedBox = SizedBox(width: 20.0);

    return Dismissible(key: Key(model.id.toString()),
      child: Row(
        children: [
          CircleAvatar(
            radius: radius,
            child: Text(model.time
            ),
          ),
          sizedBox,
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(model.title,
                  style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold
                  ),
                ), sizedBox,
                Text(model.date,
                  style: TextStyle(
                      color: Colors.grey
                  ),
                ),
              ],
            ),
          ),
          sizedBox,
          IconButton(
              onPressed: () {
                TasksCubit.get(context).updateData(
                    status: done, id: model.id);
              },
              icon: Icon(Icons.check_box)),
          IconButton(
              onPressed: () {
                TasksCubit.get(context).updateData(
                    status: archive, id: model.id);
              },
              icon: Icon(Icons.archive_outlined)),
        ],
      ), onDismissed: (direction) {
        TasksCubit.get(context).deleteData(id: model.id);
      },
    );
  }
}
