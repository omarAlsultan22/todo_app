import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import '../local/database/database_cubit.dart';
import 'package:flutter/material.dart';


Widget sizeBox() =>
    SizedBox(height: 15.0);



String? validator(String value, String fieldName) {
  if (value.isEmpty) {
    return 'Please enter your $fieldName';
  }
  return null;
}



Widget defaultFormField({
  required TextEditingController controller,
  required TextInputType type,
  String? Function(String?)? validator,
  required IconData prefix,
  required String label,
  VoidCallback? onTap,
}) =>
    TextFormField(
      controller: controller,
      keyboardType: type,
      validator: validator,
      onTap: onTap,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(prefix),
      ),
    );



Widget buildTaskItem(Map model, BuildContext context) =>
  Dismissible(key: Key(model['id'].toString()),
    child: Row(
      children: [
        CircleAvatar(
          radius: 40.0,
          child: Text(model['time']
          ),
        ),
        SizedBox(width: 20.0,),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(model['title'],
                style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold
                ),
              ), SizedBox(width: 20.0,),
              Text(model['date'],
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
              AppCubit.get(context).updateData(
                  status: 'done', id: model['id']);
            },
            icon: Icon(Icons.check_box)),
        IconButton(
            onPressed: () {
              AppCubit.get(context).updateData(
                  status: 'archive', id: model['id']);
            },
            icon: Icon(Icons.archive_outlined)),
      ],
    ), onDismissed: (direction) {
      AppCubit.get(context).deleteData(id: model['id']);
    },
  );



Widget tasksBuilder({
  required List<Map> tasks
}) =>
  ConditionalBuilder(
      condition: tasks.isNotEmpty,
      builder: (context) =>
          ListView.separated(
              itemBuilder: (context, index) =>
                  buildTaskItem(tasks[index], context),
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
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.menu,
                  size: 100.0,
                  color: Colors.grey[300],
                ),
                Text('No Tasks Yet, Please Add Some Tasks',
                  style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey
                  ),
                ),
              ],
            ),
          )
  );


