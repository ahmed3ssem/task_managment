import 'package:flutter/material.dart';

class TextWidget extends StatelessWidget {
  final String text;
  final double fontSize;
  final Color? fontColor;
  final FontWeight? fontWeight;
  final String? fontFamily;
  final int? maxLine;
  final TextOverflow? textOverflow;
  final TextAlign? textAlign;
  final FontStyle? fontStyle;
  final TextDecoration? textDecoration;
  final Color? decorationColor;
  final double? height;
  final TextDecorationStyle? textDecorationStyle;
  final bool? softWrap;

  const TextWidget({
    super.key,
    required this.text,
    required this.fontSize,
    this.fontColor,
    this.fontWeight,
    this.fontFamily,
    this.maxLine,
    this.textOverflow,
    this.textAlign,
    this.fontStyle,
    this.textDecoration,
    this.decorationColor,
    this.height,
    this.textDecorationStyle,
    this.softWrap,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      overflow: textOverflow,
      maxLines: maxLine,
      textAlign: textAlign,
      softWrap: softWrap,
      style: TextStyle(
        fontSize: fontSize,
        color: fontColor,
        fontWeight: fontWeight,
        fontFamily: fontFamily,
        fontStyle: fontStyle,
        decoration: textDecoration,
        decorationColor: decorationColor,
        height: height,
        decorationStyle: textDecorationStyle,
      ),
    );
  }
}
