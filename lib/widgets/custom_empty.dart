import 'package:flutter/material.dart';
import 'package:empty_widget/empty_widget.dart';

class CustomEmpty extends StatelessWidget {
  const CustomEmpty({Key? key, required this.title, required this.subtitle})
      : super(key: key);
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return EmptyWidget(
      image: null,
      packageImage: PackageImage.Image_3,
      title: title,
      subTitle: subtitle,
      titleTextStyle: const TextStyle(
        fontSize: 22,
        color: Color(0xff9da9c7),
        fontWeight: FontWeight.w500,
      ),
      subtitleTextStyle: const TextStyle(
        fontSize: 14,
        color: Color(0xffabb8d6),
      ),
    );
  }
}
