import 'package:baby_binder/constants.dart';
import 'package:flutter/material.dart';

class ChildAvatar extends StatelessWidget {
  const ChildAvatar({
    Key? key,
    required this.imageUrl,
    required this.name,
    this.maxRadius = 80,
  }) : super(key: key);

  final double maxRadius;
  final String imageUrl;
  final String name;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        // crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            backgroundImage: AssetImage(imageUrl),
            minRadius: 25,
            maxRadius: maxRadius,
          ),
          Container(
            padding: const EdgeInsets.only(top: 8, bottom: 8),
            child: Text(
              name,
              style: TextStyle(fontSize: 20, color: kGreyTextColor),
            ),
          )
        ],
      ),
    );
  }
}
