import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import '../shared/local/database/database_states.dart';
import '../shared/local/database/database_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../shared/components/components.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


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


  void statesListener(AppStates state) {
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


  Widget _buildWidget(AppCubit cubit, AppStates state) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text(cubit.titles[cubit.currentIndex]),
      ),
      body: ConditionalBuilder(
        condition: state is! AppGetDatabaseLoadingState,
        builder: (context) => cubit.screens[cubit.currentIndex],
        fallback: (context) => const Center(child: CircularProgressIndicator()),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (cubit.isBottomSheetShown) {
            if (formKey.currentState!.validate()) {
              cubit.insertToDatabase(
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
              cubit.changeBottomSheetState(isShow: false, icon: Icons.edit);
            });

            cubit.changeBottomSheetState(isShow: true, icon: Icons.add);
          }
        },
        child: Icon(cubit.fabIcon),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: cubit.currentIndex,
        onTap: (index) => cubit.changeIndex(index),
        items: cubit.items,
      ),
    );
  }


  Widget _buildBottomSheet(AppCubit cubit) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(20.0),
      child: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            defaultFormField(
              controller: titleController,
              type: TextInputType.text,
              validator: (value) => validator(value!, 'Title'),
              label: 'Task Title',
              prefix: Icons.title,
            ),
            const SizedBox(height: 15.0),
            defaultFormField(
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
              validator: (value) => validator(value!, 'Time'),
              label: 'Task Time',
              prefix: Icons.watch_later_outlined,
            ),
            const SizedBox(height: 15.0),
            defaultFormField(
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
              validator: (value) => validator(value!, 'Date'),
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
    return BlocProvider<AppCubit>(
      create: (BuildContext context) =>
      AppCubit()
        ..createDatabase(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {
          statesListener(state);
        },
        builder: (context, state) {
          var cubit = AppCubit.get(context);
          return _buildWidget(cubit, state);
        },
      ),
    );
  }
}