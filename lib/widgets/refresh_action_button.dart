import 'package:flutter/material.dart';

class RefreshActionButton extends StatelessWidget {
  final void Function() onRefresh;
  const RefreshActionButton({Key? key, required this.onRefresh})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.refresh_outlined),
      onPressed: onRefresh,
    );
  }
}
