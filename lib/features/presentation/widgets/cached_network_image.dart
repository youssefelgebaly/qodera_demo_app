import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CachedNetworkImageCustom extends StatelessWidget {
  final String url;
  final double height;
  final double width;
  final double? shimmerHeight;
  final double? shimmerWidth;
  final double boarder;
  final BoxFit? boxFit;

  const CachedNetworkImageCustom({
    super.key,
    required this.url,
    this.height = 100,
    this.width = double.infinity,
    this.shimmerHeight = 100,
    this.shimmerWidth = double.infinity,
    this.boarder = 10.0,
    this.boxFit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(boarder),
      child: CachedNetworkImage(
        height: height,
        width: width,
        fit: boxFit,
        imageUrl: url,
        placeholder: (context, url) => Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            clipBehavior: Clip.none,
            height: shimmerHeight,
            width: shimmerWidth,
            decoration: const BoxDecoration(color: Colors.black12),
          ),
        ),
        errorWidget: (context, url, error) => Container(
          color: Colors.grey[200]!,
          child: Icon(
            Icons.image_rounded,
            color: const Color.fromARGB(255, 87, 82, 82),
            size: 30,
          ),
        ),
      ),
    );
  }
}
