import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SVGImageWidget extends StatelessWidget {
  final String image;
  final double height;
  final double width;
  final BoxFit boxFit;
  final Color? color;
  const SVGImageWidget({
    super.key,
    this.color,
    required this.image,
    required this.width,
    required this.height,
    this.boxFit = BoxFit.contain,
  });

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(image, height: height, width: width, fit: boxFit);
  }
}
