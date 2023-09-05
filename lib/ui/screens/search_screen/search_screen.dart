import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tbib_toast/tbib_toast.dart';
import 'package:hook_atos/layout/cubit/main_cubit.dart';
import 'package:hook_atos/ui/screens/upgrade_screen/update_screen.dart';
import 'package:hook_atos/ui/screens/users_screen/component/custom_user_item.dart';

import '../../../shared/helper/mangers/size_config.dart';
import '../../../shared/helper/methods.dart';
import '../../components/custom_text_form_field.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MainCubit cubit = MainCubit.get(context);
    cubit.getUserData();
    cubit.getLines();
    cubit.getAllType();

    return BlocConsumer<MainCubit, MainState>(
      listener: (context, state) {
 /*       if (state is AddNewCustomerSuccess) {
          Navigator.pop(context);
          Navigator.pop(context);
        } else if (state is AddNewCustomerLoading) {
          showCustomProgressIndicator(context);
        }else if(state is UpdatePageState){
          navigateToAndFinish(context, UpdateScreen());
        }else if(state is PhoneAlreadyHere){
          Navigator.pop(context);
          Toast.show("رقم الهاتف مستخدم بالفعل من قبل ", context,backgroundColor: Colors.red,duration: 3);
        }
 */     },
      builder: (context, state) {


        return SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal:
                getProportionateScreenHeight(10)),
            child: Column(
              children: [
                SizedBox(
                    height:
                    getProportionateScreenHeight(30)),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: CustomTextFormField(
                    hintText: "Search",
                    type: TextInputType.text,
                    onChange: (String? value) {
                      if (value!.isNotEmpty) {
                        MainCubit.get(context).serachQuery(
                            query: value.toLowerCase()
                            as String);
                      }
                    },
                  ),
                ),
                SizedBox(
                    height:
                    getProportionateScreenHeight(10)),
                Expanded(
                    child: ListView.separated(
                        itemBuilder: (context, index) =>
                            CustomUserItem(
                                customerModel:
                                cubit.customerListSeach[
                                index]),
                        separatorBuilder:
                            (context, index) =>
                            SizedBox(
                                height:
                                getProportionateScreenHeight(
                                    10)),
                        itemCount: MainCubit
                            .get(context)
                            .customerListSeach
                            .length))
              ],
            ),
          ),
        );
      },
    );
  }
}
