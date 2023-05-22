import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../shared/helper/mangers/colors.dart';
import '../../shared/helper/mangers/size_config.dart';
import 'package:flutter_svg/svg.dart';

class CustomTextFormField extends StatelessWidget {
  bool isPassword;
  TextInputType? type;
  dynamic validate;
  dynamic onTap;
  dynamic onChange;
  dynamic onSuffixPressed;
  var controller;
  IconData? suffixIcon;
  String? lableText;
  String? hintText;
  String? prefixIcon;
  Color? prefixIconColor;
  bool? isEnable;
  List<TextInputFormatter>? limits;
  int? maxLines;

  CustomTextFormField(
      {this.isPassword = false,
      this.type = TextInputType.text,
      this.validate,
      this.onChange,
      this.limits,
      this.onTap,
      this.maxLines = 1,
      this.suffixIcon,
      this.onSuffixPressed,
      this.controller,
      this.isEnable = true,
      this.lableText,
      this.prefixIconColor,
      this.hintText,
      this.prefixIcon});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(getProportionateScreenHeight(10.0))),
      child: TextFormField(
        inputFormatters: limits,
        controller: controller,
        obscureText: isPassword == true ? true : false,
        keyboardType: type,
        enabled: isEnable,
        maxLines: maxLines,
        validator: validate,
        onChanged: onChange,
        onTap: onTap,
        decoration: InputDecoration(
          labelText: lableText,
          hintText: hintText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          suffixIcon: IconButton(
            icon: Icon(suffixIcon),
            onPressed: onSuffixPressed,
          ),
          prefixIcon: prefixIcon == null
              ? null
              : Padding(
                  padding: EdgeInsets.all(10),
                  child: SvgPicture.asset(
                    prefixIcon!,
                    height: getProportionateScreenHeight(20.0),
                    width: getProportionateScreenHeight(20.0),
                  ),
                ),
        ),
      ),
    );
  }
}
