import 'app/my_app.dart';
import 'config/bloc_observer.dart';
import 'errors/error_logger.dart';
import 'package:flutter/material.dart';
import 'config/initialization_controller.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/presentation/widgets/build_snack_bar.dart';
import 'package:todo_app/errors/exceptions/components_exception.dart';


void main() async {
  Bloc.observer = MyBlocObserver();
  final initializationController = InitializationController();

  try {
    await initializationController.init();
    runApp(const MyApp());
  }
  on ComponentsException catch (e, stackTrace) {
    final errorLogger = ErrorLogger(exception: e.error, stackTrace: stackTrace);
    final exception = errorLogger.logAndReturn();
    runApp(
        MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Builder(
              builder: (context) =>
                  Scaffold(
                    body: exception.buildErrorWidget(
                      onRetry: () async {
                        try {
                          await initializationController.retryInit();
                          runApp(const MyApp());
                        } catch (e) {
                          BuildSnackBar.show(
                              message: 'Initialization failed',
                              context: context,
                              backgroundColor: Color(0xFFC62828)
                          );
                        }
                      },
                    ),
                  ),
            )
        )
    );
  }
}

