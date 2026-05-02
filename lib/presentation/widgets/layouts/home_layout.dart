import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/constants/app_icons.dart';
import 'package:todo_app/presentation/constants/ui_sizes.dart';
import '../../cubits/tasks_cubit.dart';
import '../form/default_form_field.dart';
import '../../screens/new_tasks_screen.dart';
import '../../screens/done_tasks_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../screens/archived_tasks_screen.dart';
import '../../utils/validators/form_validators.dart';


class HomeLayout extends StatefulWidget {
  final IconData icon;
  final bool isVisible;
  final int currentIndex;

  const HomeLayout({
    required this.currentIndex,
    required this.isVisible,
    required this.icon,
    super.key
  });

  @override
  State<HomeLayout> createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  //texts
  static const task = 'Task';
  static const title = 'Title';
  static const time = 'Time';
  static const date = 'Date';

  //spaces
  static const _spacing = SizedBox(height: 15.0);
  static const _paddingAll = UISizes.padding;

  //sizes
  static const _elevationValue = _paddingAll;

  static const List<String> _screensTitles = [
    "New Tasks",
    "Done Tasks",
    "Archive Tasks"
  ];

  static const List<Widget> _screens = [
    NewTasksScreen(),
    DoneTasksScreen(),
    ArchivedTasksScreen()
  ];

  static const List<BottomNavigationBarItem> _iconsItems = [
    BottomNavigationBarItem(
        icon: Icon(Icons.menu),
        label: "Tasks"),
    BottomNavigationBarItem(
        icon: Icon(Icons.check_circle_outline),
        label: "Done"),
    BottomNavigationBarItem(
        icon: Icon(Icons.archive_outlined),
        label: "Archive")
  ];


  Widget _buildWidget() {
    final cubit = context.read<TasksCubit>();
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(_screensTitles[widget.currentIndex]),
      ),
      body: _screens[widget.currentIndex],
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (widget.isVisible) {
            if (_formKey.currentState!.validate()) {
              cubit.insertData(
                title: _titleController.text,
                time: _timeController.text,
                date: _dateController.text,
              );
            }
          } else {
            _scaffoldKey.currentState
                ?.showBottomSheet(
                  (context) => _buildBottomSheet(cubit),
              elevation: _elevationValue,
            )
                .closed
                .then((value) {
              cubit.toggleBottomSheet(
                  isVisible: false, icon: AppIcons.editIcon);
              _titleController.clear();
              _timeController.clear();
              _dateController.clear();
            });

            cubit.toggleBottomSheet(isVisible: true, icon: Icons.add);
          }
        },
        child: Icon(widget.icon),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: widget.currentIndex,
        onTap: (index) => cubit.changeScreen(index),
        items: _iconsItems,
      ),
    );
  }


  Widget _buildBottomSheet(TasksCubit cubit) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(_paddingAll),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DefaultFormField(
              controller: _titleController,
              type: TextInputType.text,
              validator: (value) => FormValidators.sharedField(value!, title),
              label: '$task $title',
              prefix: Icons.title,
            ),
            _spacing,
            DefaultFormField(
              controller: _timeController,
              type: TextInputType.datetime,
              onTap: () async {
                TimeOfDay? pickedTime = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );
                if (pickedTime != null) {
                  _timeController.text = pickedTime.format(context);
                }
              },
              validator: (value) => FormValidators.sharedField(value!, time),
              label: '$task $time',
              prefix: Icons.watch_later_outlined,
            ),
            _spacing,
            DefaultFormField(
              controller: _dateController,
              type: TextInputType.datetime,
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                );
                if (pickedDate != null) {
                  _dateController.text = DateFormat.yMMMd().format(pickedDate);
                }
              },
              validator: (value) => FormValidators.sharedField(value!, date),
              label: '$task $date',
              prefix: Icons.calendar_today,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildWidget();
  }
}