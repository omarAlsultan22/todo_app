import '../task_item_widget.dart';
import 'package:flutter/material.dart';
import '../states/initial_state_widget.dart';
import '../../../data/models/task_model.dart';
import '../../../data/models/message_result.dart';
import 'package:todo_app/presentation/constants/ui_sizes.dart';
import 'package:todo_app/presentation/constants/ui_colors.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';


class ListBuilder extends StatefulWidget {
  bool isLocked;
  final bool hasMore;
  final List<TaskModel> tasks;
  final VoidCallback onScroll;
  final MessageResult messageResult;
  final Function ({
  required int id,
  required String status,
  required BuildContext context
  }) updateData;
  final Function ({
  required int id,
  required BuildContext context
  }) deleteData;

  ListBuilder({
    super.key,
    required this.tasks,
    required this.hasMore,
    required this.onScroll,
    required this.isLocked,
    required this.updateData,
    required this.deleteData,
    required this.messageResult
  });

  @override
  State<ListBuilder> createState() => _ListBuilderState();
}

class _ListBuilderState extends State<ListBuilder> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScrollData);
  }

  @override
  void didUpdateWidget(covariant ListBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.messageResult.message != null) {
      _showMessageResult(widget.messageResult);
    }
    setState((){});
  }

  void _onScrollData() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 50.0 &&
        widget.hasMore && !widget.isLocked) {
      widget.isLocked = true;
      widget.onScroll();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _scrollController.removeListener(_onScrollData);
    super.dispose();
  }

  void _showMessageResult(MessageResult messageResult) {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(messageResult.message!),
            backgroundColor: messageResult.color!)
    );
  }

  Widget _listBuilder({
    final bool? hasMore,
    required List<TaskModel> tasks,
    ScrollController? scrollController
  }) {
    return ConditionalBuilder(
        condition: widget.tasks.isNotEmpty,
        builder: (context) =>
            ListView.separated(
                controller: scrollController,
                itemBuilder: (context, index) {
                  if (index < tasks.length) {
                    _buildTaskItem(widget.tasks[index], context);
                  }
                  return Center(
                    child: hasMore!
                        ? const CircularProgressIndicator() :
                    const SizedBox(),
                  );
                },
                separatorBuilder: (context, index) =>
                    Padding(
                      padding: const EdgeInsetsDirectional.only(
                        start: UiSizes.padding,
                      ),
                      child: Container(
                        width: double.infinity,
                        height: 1.0,
                        color: UiColors.lightGrey,
                      ),
                    ),
                itemCount: tasks.length + 1),
        fallback: (context) =>
            InitialStateWidget()
    );
  }

  @override
  Widget build(BuildContext context) {
    return _listBuilder(
        tasks: widget.tasks,
        hasMore: widget.hasMore,
        scrollController: _scrollController
    );
  }

  Widget _buildTaskItem(TaskModel model, BuildContext context) {
    return TaskItemWidget(
      task: model,
      onUpdateDone: () {
        widget.updateData(
          status: 'done',
          id: model.id,
          context: context,
        );
      },
      onUpdateArchive: () {
        widget.updateData(
          status: 'archive',
          id: model.id,
          context: context,
        );
      },
      onDismiss: () {
        widget.deleteData(
          id: model.id,
          context: context,
        );
      },
    );
  }
}
