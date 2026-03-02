import 'package:flutter/material.dart';
import 'package:todo_app/core/constants/constants_numbers.dart';


class InitialStateWidget extends StatelessWidget {
  const InitialStateWidget({super.key});

  @override
  Widget build(BuildContext context) {
    const oneHundred = 100.0;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.menu,
            size: oneHundred,
            color: Colors.grey[ConstantsNumbers.threeHundred],
          ),
          const Text(
            'No Tasks Yet, Please Add Some Tasks',
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}