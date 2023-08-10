import 'package:flutter/material.dart';

import '../utilities/constants.dart';

class PaddingBox extends StatelessWidget {
  final Widget child;
  final dynamic ver;
  final dynamic hor;

  const PaddingBox({
    Key? key,
    required this.child,
    this.ver = "default",
    this.hor = "regular",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: Constants.getOffsetSize(ver),
        horizontal: Constants.getOffsetSize(hor),
      ),
      child: child,
    );
  }
}

class PaddingBox2 extends StatelessWidget {
  final Widget child;
  final dynamic top;
  final dynamic bottom;
  final dynamic left;
  final dynamic right;

  const PaddingBox2({
    Key? key,
    required this.child,
    this.top = "default",
    this.bottom = "default",
    this.left = "regular",
    this.right = "regular",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: Constants.getOffsetSize(left),
        bottom: Constants.getOffsetSize(bottom),
        right: Constants.getOffsetSize(right),
        top: Constants.getOffsetSize(top),
      ),
      child: child,
    );
  }
}

class GradientBox extends StatelessWidget {
  final Widget child;
  final bool isDark;
  final List<Color> colorsLight;
  final List<Color> colorsDark;
  final dynamic radius;
  final AlignmentGeometry begin;
  final AlignmentGeometry end;

  const GradientBox({
    Key? key,
    required this.child,
    required this.isDark,
    required this.colorsLight,
    required this.colorsDark,
    this.radius = 'default',
    this.begin = Alignment.bottomCenter,
    this.end = Alignment.topCenter,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: begin,
          end: end,
          colors: isDark
              ? colorsDark
              : colorsLight
        ),
        borderRadius: BorderRadius.circular(Constants.getRoundSize(radius)),
      ),
      child: child,
    );
  }
}

