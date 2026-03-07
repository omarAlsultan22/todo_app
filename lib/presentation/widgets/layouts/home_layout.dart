import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/core/constants/app_constants.dart';
import '../../cubits/tasks_cubit.dart';
import '../form/default_form_field.dart';
import '../../screens/new_tasks_screen.dart';
import '../../screens/done_tasks_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../screens/archived_tasks_screen.dart';
import '../../utils/validators/form_validators.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';


class HomeLayout extends StatefulWidget {
  const HomeLayout({super.key});

  @override
  State<HomeLayout> createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final TextEditingController dateController = TextEditingController();


  static const List<String> screensTitles = [
    "New Tasks",
    "Done Tasks",
    "Archive Tasks"
  ];

  static const List<Widget> screens = [
    NewTasksScreen(),
    DoneTasksScreen(),
    ArchivedTasksScreen()
  ];

  static const List<BottomNavigationBarItem> iconsItems = [
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
      key: scaffoldKey,
      appBar: AppBar(
        title: Text(screensTitles[state.currentIndex]),
      ),
      body: ConditionalBuilder(
        condition: !state.isLoading,
        builder: (context) => screens[state.currentIndex],
        fallback: (context) => const Center(child: CircularProgressIndicator()),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (state.isVisible) {
            if (formKey.currentState!.validate()) {
              cubit.insertData(
                title: titleController.text,
                time: timeController.text,
                date: dateController.text,
              );
            }
          } else {
            scaffoldKey.currentState
                ?.showBottomSheet(
                  (context) => _buildBottomSheet(cubit),
              elevation: 20.0,
            )
                .closed
                .then((value) {
              cubit.toggleBottomSheet(isVisible: false, icon: AppConstants.editIcon);
              titleController.clear();
              timeController.clear();
              dateController.clear();
            });

            cubit.toggleBottomSheet(isVisible: true, icon: Icons.add);
          }
        },
        child: Icon(state.icon),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: state.currentIndex,
        onTap: (index) => cubit.changeIndex(index),
        items: iconsItems,
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
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DefaultFormField(
              controller: titleController,
              type: TextInputType.text,
              validator: (value) => FormValidators.sharedField(value!, title),
              label: '$task $title',
              prefix: Icons.title,
            ),
            vSmall,
            DefaultFormField(
              controller: timeController,
              type: TextInputType.datetime,
              onTap: () async {
                TimeOfDay? pickedTime = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );
                if (pickedTime != null) {
                  timeController.text = pickedTime.format(context);
                }
              },
              validator: (value) => FormValidators.sharedField(value!, time),
              label: '$task $time',
              prefix: Icons.watch_later_outlined,
            ),
            vSmall,
            DefaultFormField(
              controller: dateController,
              type: TextInputType.datetime,
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                );
                if (pickedDate != null) {
                  dateController.text = DateFormat.yMMMd().format(pickedDate);
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