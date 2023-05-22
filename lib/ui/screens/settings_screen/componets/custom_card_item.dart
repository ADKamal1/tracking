import 'package:flutter/material.dart';
import 'package:hook_atos/ui/components/app_text.dart';

import '../../../../shared/helper/mangers/size_config.dart';

class CardItem extends StatelessWidget {
  IconData prefix;
  String title;
  String detials;

  CardItem({required this.prefix, required this.title, required this.detials});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: getProportionateScreenWidth(14),
          vertical: getProportionateScreenHeight(16),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(
              prefix,
              size: getProportionateScreenHeight(30.0),
              color: Colors.blue,
            ),
            SizedBox(width: getProportionateScreenWidth(25)),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                AppText(
                  text: '${title}',
                  textSize: 16,
                  color: Colors.grey,
                ),
                SizedBox(height: getProportionateScreenHeight(5)),
                AppText(text: '${detials}')
              ],
            ),
          ],
        ),
      ),
    );
  }
}
