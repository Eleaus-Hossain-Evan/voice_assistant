import 'package:flutter/widgets.dart';

import 'package:voice_assistant/palette.dart';

class FeatureBox extends StatelessWidget {
  const FeatureBox({
    Key? key,
    required this.color,
    required this.headerText,
    required this.descriptionText,
  }) : super(key: key);

  final Color color;
  final String headerText;
  final String descriptionText;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 20,
        ).copyWith(left: 15, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              headerText,
              style: const TextStyle(
                color: Palette.blackColor,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            SizedBox(
              height: 3,
            ),
            Text(
              descriptionText,
              style: const TextStyle(
                color: Palette.blackColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
