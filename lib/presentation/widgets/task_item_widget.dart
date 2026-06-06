import '../../data/models/task_model.dart';
import 'package:flutter/material.dart';
import '../constants/ui_colors.dart';


class TaskItemWidget extends StatelessWidget {
  final TaskModel task;
  final VoidCallback? onUpdateDone;
  final VoidCallback? onUpdateArchive;
  final VoidCallback? onDismiss;

  const TaskItemWidget({
    super.key,
    required this.task,
    this.onUpdateDone,
    this.onUpdateArchive,
    this.onDismiss,
  });

  static const _widthValue = 20.0;
  static const _spacingHorizontal = SizedBox(width: _widthValue);

  @override
  Widget build(BuildContext context) {
    return Dismissible(key: Key(task.id.toString()),
        child: Row(
          children: [
            CircleAvatar(
              radius: 40.0,
              child: Text(task.time
              ),
            ),
            _spacingHorizontal,
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(task.title,
                    style: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold
                    ),
                  ), _spacingHorizontal,
                  Text(task.date,
                    style: TextStyle(
                        color: UiColors.primaryGray
                    ),
                  ),
                ],
              ),
            ),
            _spacingHorizontal,
            IconButton(
                onPressed: onUpdateDone,
                icon: Icon(Icons.check_box)),
            IconButton(
                onPressed: onUpdateArchive,
                icon: Icon(Icons.archive_outlined)
            ),
          ],
        ), onDismissed: (direction) => onDismiss.call
    );
  }
}