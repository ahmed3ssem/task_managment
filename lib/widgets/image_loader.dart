import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_project_structure/widgets/loading_item.dart';
import 'package:flutter_project_structure/widgets/svg_image_widget.dart';

class ImageLoader extends StatefulWidget {
  final String imageUrl;
  final double? height;
  final double? width;
  final BoxFit? fit;
  final BorderRadius? borderRadius; // New parameter

  const ImageLoader({
    super.key,
    required this.imageUrl,
    this.height,
    this.width,
    this.fit,
    this.borderRadius,
  });

  @override
  State<ImageLoader> createState() => ImageLoaderState();
}

class ImageLoaderState extends State<ImageLoader>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  Animation<double>? animation;

  @override
  initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat(reverse: true);
    animation = CurvedAnimation(parent: _controller, curve: Curves.linear);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget loadDefault() {
    return ClipRRect(
      borderRadius:
          widget.borderRadius ?? BorderRadius.zero, // Apply borderRadius here
      child: CachedNetworkImage(
        imageUrl: widget.imageUrl,
        height: widget.height ?? ScreenUtil().setHeight(100),
        width: widget.width ?? ScreenUtil().setWidth(100),
        fit: widget.fit ?? BoxFit.contain,
        placeholder: (context, url) => const LoadingItem(),
        errorWidget: (context, url, error) => Container(
          padding: const EdgeInsets.all(4),
          child: SVGImageWidget(
            image: "",
            width: widget.width ?? ScreenUtil().setWidth(100),
            height: widget.height ?? ScreenUtil().setHeight(100),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius:
            widget.borderRadius ?? BorderRadius.zero, // Apply borderRadius here
      ),
      child: loadDefault(),
    );
  }
}
