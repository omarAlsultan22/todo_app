import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:todo_app/core/widgets/form/default_form_field.dart';
import '../../data/repository_impl/local/database_repository.dart';
import '../../core/utils/validators/form_validators.dart';
import 'package:todo_app/core/widgets/app_spacers.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../screens/archived_tasks_screen.dart';
import '../screens/done_tasks_screen.dart';
import '../screens/new_tasks_screen.dart';
import 'package:flutter/material.dart';
import '../cubits/tasks_cubit.dart';
import 'package:intl/intl.dart';
import '../states/states.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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


  void statesListener(TasksStates state) {
    if (state is AppInsertDatabaseState) {
      Navigator.pop(context);
      titleController.clear();
      timeController.clear();
      dateController.clear();
    } else if (state is AppErrorDatabaseState) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${state.error}')),
      );
    }
  }


  Widget _buildWidget(TasksCubit cubit, TasksStates state) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text(screensTitles[state.currentIndex]),
      ),
      body: ConditionalBuilder(
        condition: state is! AppGetDatabaseLoadingState,
        builder: (context) => screens[state.currentIndex],
        fallback: (context) => const Center(child: CircularProgressIndicator()),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (state.bottomSheetState!.isVisible) {
            if (formKey.currentState!.validate()) {
              cubit.repository.insertToDatabase(
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
              cubit.toggleBottomSheet(isVisible: false, icon: Icons.edit);
            });

            cubit.toggleBottomSheet(isVisible: true, icon: Icons.add);
          }
        },
        child: Icon(state.bottomSheetState!.icon),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: state.currentIndex,
        onTap: (index) => cubit.changeIndex(index),
        items: iconsItems,
      ),
    );
  }


  Widget _buildBottomSheet(TasksCubit cubit) {
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
              validator: (value) => FormValidators.sharedField(value!, 'Title'),
              label: 'Task Title',
              prefix: Icons.title,
            ),
            AppSpacers.vSmall,
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
              validator: (value) => FormValidators.sharedField(value!, 'Time'),
              label: 'Task Time',
              prefix: Icons.watch_later_outlined,
            ),
            AppSpacers.vSmall,
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
              validator: (value) => FormValidators.sharedField(value!, 'Date'),
              label: 'Task Date',
              prefix: Icons.calendar_today,
            ),
          ],
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return BlocProvider<TasksCubit>(
      create: (BuildContext context) =>
          TasksCubit(TasksRepository()
            ..createDatabase()),
      child: BlocConsumer<TasksCubit, TasksStates>(
        listener: (context, state) {
          statesListener(state);
        },
        builder: (context, state) {
          var cubit = TasksCubit.get(context);
          return _buildWidget(cubit, state);
        },
      ),
    );
  }
}