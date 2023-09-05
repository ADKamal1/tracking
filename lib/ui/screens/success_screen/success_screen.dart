
import 'package:flutter/material.dart';import 'package:flutter/services.dart';
import 'package:hook_atos/layout/main_layout.dart';
import 'package:hook_atos/shared/helper/methods.dart';
import 'package:hook_atos/ui/components/custom_button.dart';
import 'package:hook_atos/ui/screens/line_visits/lineVisits.dart';
import 'package:hook_atos/ui/screens/search_screen/search_screen.dart';


class SuccessScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light); // 1
    return Scaffold(
      backgroundColor: Color.fromRGBO(254, 254, 255, 1),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/success.png',
              height: 196.57,
              width: 245.18,
            ),
            SizedBox(
              height: 56.3,
            ),
            Container(
              height: 110,
              width: 275,
              child: Column(
                children: [
                  Text(
                    'Thank you',
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Text(
                    'Your visit add successfully',

                    textAlign: TextAlign.center,
                  )
                ],
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child:CustomButton(
          height: 50,
          width: 327,
          text: 'Continue',
          press: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => MainLayout(),));
          },
        ),
      ),
    );
  }
}
