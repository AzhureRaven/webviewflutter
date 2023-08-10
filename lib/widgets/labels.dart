import 'package:flutter/material.dart';
import '../utilities/constants.dart';

class BasicLabel extends StatelessWidget {
  final String text;
  final dynamic offset;
  final dynamic font;
  final FontWeight fontWeight;
  final TextAlign textAlign;
  final String? fontFamily;

  const BasicLabel({Key? key,
    required this.text,
    this.offset = "x_small",
    this.font = "regular",
    this.fontWeight = FontWeight.normal,
    this.textAlign = TextAlign.start,
    this.fontFamily
  }):super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: Constants.getOffsetSize(offset)),
      child: Text(
        text,
        style: TextStyle(
          fontSize: Constants.getFontSize(font),
          fontWeight: fontWeight,
          fontFamily: fontFamily
        ),
        textAlign: textAlign,
      ),
    );
  }
}

class ColoredLabel extends StatelessWidget {
  final String text;
  final dynamic offset;
  final dynamic font;
  final FontWeight fontWeight;
  final TextAlign textAlign;
  final String? fontFamily;
  final Color color;

  const ColoredLabel({Key? key,
    required this.text,
    this.offset = "x_small",
    this.font = "regular",
    this.fontWeight = FontWeight.normal,
    this.textAlign = TextAlign.start,
    this.fontFamily,
    this.color = Colors.white,
  }):super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: Constants.getOffsetSize(offset)),
      child: Text(
        text,
        style: TextStyle(
            fontSize: Constants.getFontSize(font),
            fontWeight: fontWeight,
            color: color,
            fontFamily: fontFamily
        ),
        textAlign: textAlign,
      ),
    );
  }
}