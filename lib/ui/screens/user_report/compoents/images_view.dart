import 'package:flutter/material.dart';

import '../../../../shared/helper/mangers/constants.dart';

class ImageViewPage extends StatelessWidget {
  String image;

  ImageViewPage(this.image);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      height: double.infinity,
      width: double.infinity,
      decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
              image: image != ConstantsManger.DEFULT
                  ? NetworkImage(image)
                  : AssetImage('assets/images/att.jpg') as ImageProvider)),
    ));
  }
}
