import 'package:flutter/material.dart';

import '../utilities/constants.dart';
import 'labels.dart';

class ColoredTextButton extends StatelessWidget {
  final String text;
  final dynamic font;
  final dynamic width;
  final dynamic height;
  final dynamic radius;
  final Color color;
  final VoidCallback onPressed;

  const ColoredTextButton({
    Key? key,
    required this.text,
    this.font = "large_x",
    this.width = "medium",
    this.height = "small",
    this.radius = "default",
    this.color = Colors.red,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        minimumSize: Size(Constants.getLengthSize(width), Constants.getLengthSize(height)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Constants.getRoundSize(radius)), // Change this value to adjust the roundness
        ),
      ),
      child: ColoredLabel(
        text: text,
        font: font,
      ),
    );
  }
}