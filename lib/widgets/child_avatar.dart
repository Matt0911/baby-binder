import 'package:baby_binder/constants.dart';
import 'package:baby_binder/providers/children_data.dart';
import 'package:flutter/material.dart';

class ChildAvatar extends StatelessWidget {
  const ChildAvatar({
    Key? key,
    required this.child,
    this.maxRadius = 80,
    this.showName = true,
  }) : super(key: key);

  final Child child;
  final double maxRadius;
  final bool showName;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        // crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            backgroundImage: AssetImage(child.image),
            minRadius: 25,
            maxRadius: maxRadius,
          ),
          showName
              ? Container(
                  padding: const EdgeInsets.only(top: 8, bottom: 8),
                  child: Text(
                    child.name,
                    style: TextStyle(fontSize: 20, color: kGreyTextColor),
                  ),
                )
              : SizedBox()
        ],
      ),
    );
  }
}
