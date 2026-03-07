import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import '../../cubits/tasks_cubit.dart';
import '../form/default_form_field.dart';
import '../../screens/new_tasks_screen.dart';
import '../../screens/done_tasks_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../screens/archived_tasks_screen.dart';
import '../../utils/validators/form_validators.dart';
import 'package:todo_app/core/constants/app_constants.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';


class HomeLayout extends StatefulWidget {
  const HomeLayout({super.key});

  @override
  State<HomeLayout> createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();


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
    final state = cubit.state;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(_screensTitles[state.currentIndex]),
      ),
      body: ConditionalBuilder(
        condition: !state.isLoading,
        builder: (context) => _screens[state.currentIndex],
        fallback: (context) => const Center(child: CircularProgressIndicator()),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (state.isVisible) {
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
              elevation: 20.0,
            )
                .closed
                .then((value) {
              cubit.toggleBottomSheet(isVisible: false, icon: AppConstants.editIcon);
              _titleController.clear();
              _timeController.clear();
              _dateController.clear();
            });

            cubit.toggleBottomSheet(isVisible: true, icon: Icons.add);
          }
        },
        child: Icon(state.icon),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: state.currentIndex,
        onTap: (index) => cubit.changeIndex(index),
        items: _iconsItems,
      ),
    );
  }


  Widget _buildBottomSheet(TasksCubit cubit) {
    const task = 'Task';
    const title = 'Title';
    const time = 'Time';
    const date = 'Date';
    const Widget vSmall = SizedBox(height: 15.0);
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(20.0),
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
            vSmall,
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
            vSmall,
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