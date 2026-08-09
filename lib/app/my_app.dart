import '../di/service _locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../presentation/cubits/tasks_cubit.dart';
import 'package:todo_app/presentation/screens/home_screen.dart';


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider<TasksCubit>(
        create: (BuildContext context) =>
        sl<TasksCubit>(),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: HomeScreen(),
        )
    );
  }
}