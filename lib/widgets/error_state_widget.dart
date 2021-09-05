import 'package:flutter/material.dart';

class ErrorStateWidget extends StatelessWidget {
  final void Function() onTryAgain;

  const ErrorStateWidget({required this.onTryAgain});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.running_with_errors_outlined,
            color: Colors.red,
            size: 100,
          ),
          SizedBox(height: 16),
          Text(
            "Ada masalah saat memuat data",
          ),
          SizedBox(height: 16),
          OutlinedButton(
            onPressed: onTryAgain,
            child: const Text("Coba Lagi"),
          )
        ],
      ),
    );
  }
}
