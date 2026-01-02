import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:todo_app/models/task_model.dart';
import 'package:todo_app/shared/components/widgets/states/init_state.dart';
import '../shared/cubit/tasks_cubit.dart';
import 'package:flutter/material.dart';


class TasksLayout extends StatelessWidget {
  final List<TaskModel> tasks;

  const TasksLayout({required this.tasks, super.key});


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
                      padding: EdgeInsetsDirectional.only(
                        start: 20.0,
                      ),
                      child: Container(
                        width: double.infinity,
                        height: 1.0,
                        color: Colors.grey[300],
                      ),
                    ),
                itemCount: tasks.length),
        fallback: (context) =>
            TasksInitStateWidget()
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
          SizedBox(width: 20.0,),
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
                ), SizedBox(width: 20.0,),
                Text(model.date,
                  style: TextStyle(
                      color: Colors.grey
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 20.0,
          ),
          IconButton(
              onPressed: () {
                TasksCubit.get(context).updateData(
                    status: 'done', id: model.id);
              },
              icon: Icon(Icons.check_box)),
          IconButton(
              onPressed: () {
                TasksCubit.get(context).updateData(
                    status: 'archive', id: model.id);
              },
              icon: Icon(Icons.archive_outlined)),
        ],
      ), onDismissed: (direction) {
        TasksCubit.get(context).deleteData(id: model.id);
      },
    );
  }
}
