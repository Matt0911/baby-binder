import 'package:baby_binder/constants.dart';
import 'package:baby_binder/widgets/bottom_sheets/text_field_bottom_sheet.dart';
import 'package:flutter/material.dart';

class ChildAvatar extends StatelessWidget {
  const ChildAvatar({
    Key? key,
    required this.childImage,
    required this.childName,
    this.maxRadius = 80,
    this.showName = true,
    this.updateName,
  }) : super(key: key);

  final String childImage;
  final String childName;
  final double maxRadius;
  final bool showName;
  final Function(String)? updateName;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        // crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            backgroundImage: AssetImage(childImage),
            minRadius: 25,
            maxRadius: maxRadius,
          ),
          showName
              ? NameDisplay(
                  childName: childName,
                  updateName: updateName,
                )
              : SizedBox()
        ],
      ),
    );
  }
}

class NameDisplay extends StatelessWidget {
  const NameDisplay({
    Key? key,
    required this.childName,
    required this.updateName,
  }) : super(key: key);

  final String childName;
  final Function(String)? updateName;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.only(top: 8, bottom: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              childName,
              style: TextStyle(fontSize: 20, color: kGreyTextColor),
            ),
            updateName != null
                ? IconButton(
                    onPressed: () async {
                      TextFieldEditResults? results =
                          await showTextFieldBottomSheet(
                        context,
                        'Name',
                        childName,
                      );
                      if (results != null &&
                          results.didSave &&
                          results.value != childName) {
                        print('got ${results.value} from modal');
                        updateName!(results.value!);
                      }
                      // setState(() {
                      //   isEditing = !isEditing;
                      // });
                    },
                    icon: Icon(Icons.edit),
                  )
                : SizedBox()
          ],
        ));
  }
}
