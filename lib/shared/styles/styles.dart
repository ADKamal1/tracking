import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../helper/mangers/colors.dart';

class ThemeManger {
  static ThemeData setLightTheme() {
    return ThemeData(
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        selectedItemColor: ColorsManger.darkPrimary,
        unselectedItemColor: Colors.grey,
      ),
      appBarTheme: AppBarTheme(
        color: ColorsManger.darkPrimary,
        iconTheme: IconThemeData(
          color: Colors.grey,
        ),
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: ColorsManger.darkPrimary,
          statusBarIconBrightness: Brightness.light,
        ),
      ),
      colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: ColorsManger.darkPrimary,
          primary: ColorsManger.darkPrimary),
    );
  }
}
