import 'package:flutter/material.dart';

import '../utilities/constants.dart';

class Gap extends StatelessWidget {
  final dynamic width;
  final dynamic height;

  const Gap({Key? key, this.width = "null", this.height = "null"}):super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Constants.getOffsetSize(height),
      width: Constants.getOffsetSize(width),
    );
  }
}

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}

class BasicBadge extends StatelessWidget {
  final String notif;
  final Widget child;
  const BasicBadge({Key? key, required this.notif, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Badge(isLabelVisible: notif != "0", label: Text(notif,style: const TextStyle(color: Colors.white)), child: child);
  }
}