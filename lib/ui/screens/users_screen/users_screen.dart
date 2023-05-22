import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tbib_toast/tbib_toast.dart';
import 'package:hook_atos/layout/cubit/main_cubit.dart';
import 'package:hook_atos/shared/helper/mangers/size_config.dart';
import 'package:hook_atos/ui/components/app_text.dart';
import 'package:hook_atos/ui/screens/upgrade_screen/update_screen.dart';
import 'package:hook_atos/ui/screens/users_screen/component/custom_user_item.dart';

import '../../../shared/helper/methods.dart';

class UserScreen extends StatelessWidget {
  const UserScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MainCubit.get(context).getAllCustomers();
    return Builder(builder: (context) {
      return BlocConsumer<MainCubit, MainState>(
        listener: (context, state) {
          if (state is AddNewCustomerSuccess) {
            Navigator.pop(context);
            Navigator.pop(context);
          } else if (state is AddNewCustomerLoading) {
            showCustomProgressIndicator(context);
          }else if(state is UpdatePageState){
            navigateToAndFinish(context,const UpdateScreen());
          }else if(state is PhoneAlreadyHere){
            Navigator.pop(context);
            Toast.show("رقم الهاتف مستخدم بالفعل من قبل ", context,backgroundColor: Colors.red,duration: 3);
          }
        },
        builder: (context, state) {
          return MainCubit.get(context).customersList.isEmpty
              ? Center(
                  child: AppText(text: "No Customers Yet"),
                )
              : ListView.separated(
                  itemBuilder: (context, index) {
                    return CustomUserItem(
                        customerModel: MainCubit.get(context).customersList[index]);
                  },
                  separatorBuilder: (context, index) =>
                      SizedBox(height: SizeConfigManger.bodyHeight * .01),
                  itemCount: MainCubit.get(context).customersList.length);
        },
      );
    });
  }
}
