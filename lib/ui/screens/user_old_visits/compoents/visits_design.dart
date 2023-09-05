import 'package:flutter/material.dart';
import 'package:hook_atos/shared/helper/mangers/colors.dart';
import 'package:hook_atos/shared/helper/mangers/constants.dart';

import '../../../../model/customers_model.dart';
import '../../../../shared/helper/mangers/size_config.dart';
import '../../../components/app_text.dart';

class VisitsDesign extends StatelessWidget {
  CustomerModel customerModel;

  VisitsDesign(this.customerModel);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: InkWell(
        onTap: () {
          //  navigateTo(context, UserOldVisitsScreen(customerModel.phone ?? ""));
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child:
           Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: SizeConfigManger.bodyHeight * 0.20,
                  width: SizeConfigManger.bodyHeight * 0.20,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.black54),
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: customerModel.image == ConstantsManger.DEFULT
                              ? AssetImage("assets/images/defult_image.png")
                              : NetworkImage('${customerModel.image}') as ImageProvider)),
                ),
                SizedBox(
                  width: getProportionateScreenHeight(10.0),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: getProportionateScreenHeight(10),
                      ),

                         AppText(
                          text: '${customerModel.time}',
                          textSize: 25.0,
                          maxLines: 3,
                          color: customerModel.isMocking == true
                              ? Colors.red
                              : Colors.black,
                          fontWeight: FontWeight.bold,

                        ),


                      SizedBox(
                        height: getProportionateScreenHeight(30),
                      ),
                      AppText(maxLines: 1,
                        text: "${customerModel.note}",
                        color: customerModel.isMocking == true
                            ? Colors.red
                            : Colors.black,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

    );
  }
}
