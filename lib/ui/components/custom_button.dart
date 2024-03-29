import 'package:flutter/material.dart';

import '../../shared/helper/mangers/colors.dart';
import '../../shared/helper/mangers/size_config.dart';
import 'app_text.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    Key? key,
    this.text,
    this.press,
    this.iconData,
    this.width,
    this.raduis,
    this.backgroundColor,
    this.textColor,
    this.borderColor,
    this.height,
  }) : super(key: key);
  final String? text;
  final Function? press;
  final double? width;
  final double? height;
  final double? raduis;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? borderColor;
  final IconData? iconData;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width == null
          ? double.infinity
          : getProportionateScreenHeight(width!),
      height: height == null
          ? getProportionateScreenHeight(60)
          : getProportionateScreenHeight(height!),
      decoration: BoxDecoration(
          border: Border.all(
              color:
                  borderColor == null ? ColorsManger.darkPrimary : borderColor!,
              width: getProportionateScreenHeight(1)),
          color: backgroundColor == null
              ? ColorsManger.darkPrimary
              : backgroundColor,
          borderRadius: BorderRadius.circular(raduis == null
              ? getProportionateScreenHeight(10)
              : getProportionateScreenHeight(raduis!))),
      child: text != null
          ? MaterialButton(
              onPressed: press as void Function(),
              child: AppText(
                color: textColor == null ? Colors.white : textColor,
                text: text!,
                textSize: getProportionateScreenHeight(25.0),
              ),
            )
          : Icon(iconData, color: Colors.white),
    );
  }
}
