import 'package:flutter/material.dart';


class ErrorStateWidget extends StatelessWidget {
  final String? error;
  final VoidCallback? onRetry;

  const ErrorStateWidget({
    super.key,
    this.error,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50.0),
              child: Text('Error: $error'),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: onRetry,
              child: const Text('Retry'),
            ),
          ],
      ),
    );
  }
}