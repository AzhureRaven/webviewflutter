import 'package:flutter/material.dart';

import '../utilities/constants.dart';

class BasicCard extends StatelessWidget {
  final Widget child;
  final dynamic margin;
  final dynamic radius;

  const BasicCard({
    Key? key,
    required this.child,
    this.margin = "xx_small",
    this.radius = "default"
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(Constants.getOffsetSize(margin)),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Constants.getRoundSize(radius)),
      ),
      child: ClipRRect(
          borderRadius: BorderRadius.circular(Constants.getRoundSize(radius)),
          child: child
      ),
    );
  }
}

class ColoredCard extends StatelessWidget {
  final Widget child;
  final dynamic margin;
  final dynamic radius;
  final Color color;

  const ColoredCard({
    Key? key,
    required this.child,
    this.margin = "xx_small",
    this.radius = "default",
    this.color = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      margin: EdgeInsets.all(Constants.getOffsetSize(margin)),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Constants.getRoundSize(radius)),
      ),
      child: ClipRRect(
          borderRadius: BorderRadius.circular(Constants.getRoundSize(radius)),
          child: child
      ),
    );
  }
}

class InkCard extends StatelessWidget {
  final VoidCallback onTap;
  final Widget child;
  final dynamic offsetRight;
  final dynamic offsetLeft;
  final dynamic offsetBottom;
  final dynamic offsetTop;
  final dynamic radius;
  final dynamic width;
  final dynamic height;
  final bool background;
  final double elevation;

  const InkCard({
    Key? key,
    required this.onTap,
    required this.child,
    this.offsetRight = "small",
    this.offsetBottom = "null",
    this.offsetTop = "null",
    this.offsetLeft = "null",
    this.radius = "default",
    this.width = "normal",
    this.height = "normal",
    this.elevation = 3,
    this.background = false
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: elevation,
      margin: EdgeInsets.only(
        right: Constants.getOffsetSize(offsetRight),
        bottom: Constants.getOffsetSize(offsetBottom),
        left: Constants.getOffsetSize(offsetLeft),
        top: Constants.getOffsetSize(offsetTop),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Constants.getRoundSize(radius)),
      ),
      color: background ? Theme.of(context).colorScheme.background : null,
      child: InkWell(
        borderRadius: BorderRadius.circular(Constants.getRoundSize(radius)),
        onTap: onTap,
        child: Ink(
          height: height != "null" ? Constants.getLengthSize(height):null,
          width: width != "null" ? Constants.getLengthSize(width):null,
          child: ClipRRect(
              borderRadius: BorderRadius.circular(Constants.getRoundSize(radius)),
              child: child
          ),
        ),
      ),
    );
  }
}

class ColoredInkCard extends StatelessWidget {
  final VoidCallback onTap;
  final Widget child;
  final dynamic offsetRight;
  final dynamic offsetLeft;
  final dynamic offsetBottom;
  final dynamic offsetTop;
  final dynamic radius;
  final dynamic width;
  final dynamic height;
  final double elevation;
  final Color color;

  const ColoredInkCard({
    Key? key,
    required this.onTap,
    required this.child,
    this.offsetRight = "small",
    this.offsetBottom = "null",
    this.offsetTop = "null",
    this.offsetLeft = "null",
    this.radius = "default",
    this.width = "normal",
    this.height = "normal",
    this.elevation = 3,
    this.color = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: elevation,
      margin: EdgeInsets.only(
        right: Constants.getOffsetSize(offsetRight),
        bottom: Constants.getOffsetSize(offsetBottom),
        left: Constants.getOffsetSize(offsetLeft),
        top: Constants.getOffsetSize(offsetTop),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Constants.getRoundSize(radius)),
      ),
      color: color,
      child: InkWell(
        borderRadius: BorderRadius.circular(Constants.getRoundSize(radius)),
        onTap: onTap,
        child: Ink(
          height: height != "null" ? Constants.getLengthSize(height):null,
          width: width != "null" ? Constants.getLengthSize(width):null,
          child: ClipRRect(
              borderRadius: BorderRadius.circular(Constants.getRoundSize(radius)),
              child: child
          ),
        ),
      ),
    );
  }
}

class BasicInkWell extends StatelessWidget {
  final VoidCallback onTap;
  final Widget child;
  final dynamic radius;
  final dynamic width;
  final dynamic height;
  final bool background;

  const BasicInkWell({
    Key? key,
    required this.onTap,
    required this.child,
    this.radius = "default",
    this.width = "normal",
    this.height = "normal",
    this.background = false
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(Constants.getRoundSize(radius)),
      onTap: onTap,
      child: Ink(
        height: height != "null" ? Constants.getLengthSize(height):null,
        width: width != "null" ? Constants.getLengthSize(width):null,
        color: background ? Theme.of(context).colorScheme.background : null,
        child: ClipRRect(
            borderRadius: BorderRadius.circular(Constants.getRoundSize(radius)),
            child: child
        ),
      ),
    );
  }
}