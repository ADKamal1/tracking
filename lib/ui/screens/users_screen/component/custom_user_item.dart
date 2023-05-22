import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hook_atos/layout/cubit/main_cubit.dart';
import 'package:hook_atos/model/customers_model.dart';
import 'package:hook_atos/shared/helper/mangers/constants.dart';
import 'package:hook_atos/shared/helper/methods.dart';
import 'package:hook_atos/ui/screens/user_old_visits/user_old_visits.dart';
import '../../../../shared/helper/mangers/size_config.dart';
import '../../../components/app_text.dart';

class CustomUserItem extends StatelessWidget {
  CustomerModel customerModel;

  CustomUserItem({required this.customerModel});

  @override
  Widget build(BuildContext context) {
    MainCubit cubit= MainCubit.get(context);
    return InkWell(
      onTap: () {
        navigateTo(
            context,
            UserOldVisitsScreen(
                customerModel,

            ));
      },
      child: Padding(
        padding:
            EdgeInsets.symmetric(horizontal: getProportionateScreenHeight(10)),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: Colors.grey,
              )),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    height: SizeConfigManger.bodyHeight * 0.13,
                    width: SizeConfigManger.bodyHeight * 0.13,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: customerModel.image == ConstantsManger.DEFULT
                                ? AssetImage("assets/images/defult_image.png")
                                : NetworkImage(customerModel.image!.toString())
                                    as ImageProvider)),
                  ),
                ),
                SizedBox(
                  width: getProportionateScreenHeight(10.0),
                ),
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: getProportionateScreenHeight(10),
                      ),
                      AppText(
                        text: '${customerModel.name}',
                        textSize: 20,
                        maxLines: 3,
                        fontWeight: FontWeight.bold,
                      ),
                      SizedBox(
                        height: getProportionateScreenHeight(30),
                      ),
                      AppText(text: "${customerModel.phone}"),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
