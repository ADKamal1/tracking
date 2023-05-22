import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hook_atos/layout/main_layout.dart';
import 'package:hook_atos/ui/screens/check_screen/check_screen.dart';
import 'package:tbib_toast/tbib_toast.dart';
import 'package:hook_atos/ui/screens/login_success/login_success_screen.dart';
import '../../../shared/helper/mangers/colors.dart';
import '../../../shared/helper/mangers/constants.dart';
import '../../../shared/helper/mangers/size_config.dart';
import '../../../shared/helper/methods.dart';
import '../../components/app_text.dart';
import '../../components/custom_button.dart';
import '../../components/custom_text_form_field.dart';
import 'cubit/login_cubit.dart';

class LoginScreen extends StatelessWidget {
  var formKey = GlobalKey<FormState>();
  var usernameController = TextEditingController();
  var passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(),
      child: BlocConsumer<LoginCubit, LoginState>(
        listener: (context, state) async {

          if (state is LoginErrorState) {
            Navigator.pop(context);
            showSnackBar(context, state.errorMsg);
          } else if (state is LoginSuccessState) {
            Navigator.pop(context);
            navigateToAndFinish(context, MainLayout());
          } else if (state is LoginLoadingState) {
            showCustomProgressIndicator(context);
          } else if (state is LoginSuccessButBannedState) {
            Navigator.pop(context);
            navigateToAndFinish(context, CheckScreen());
          }else if(state is LoginFromAnthorPhone){

          }
        },
        builder: (context, state) {
          LoginCubit cubit = LoginCubit.get(context);
          return Scaffold(
            backgroundColor: Colors.white,
            body: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: SizeConfigManger.bodyHeight * .25,
                      ),
                      AppText(
                          text: "Welcome",
                          textSize: 35,
                          color: ColorsManger.darkPrimary),
                      AppText(
                          text: "Sign in with your email and password",
                          textSize: 20,
                          color: ColorsManger.darkPrimary),
                      SizedBox(height: getProportionateScreenHeight(20)),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: getProportionateScreenHeight(30.0)),
                        child: Column(
                          children: [
                            CustomTextFormField(
                                controller: usernameController,
                                lableText: 'Username',
                                validate: (String? value) {
                                  if (value!.isEmpty) {
                                    return "Username is Required";
                                  }
                                },
                                type: TextInputType.emailAddress,
                                prefixIcon: 'assets/icons/User.svg'),
                            SizedBox(
                              height: SizeConfigManger.bodyHeight * 0.03,
                            ),
                            CustomTextFormField(
                              controller: passwordController,
                              validate: (value) {
                                if (value.isEmpty) {
                                  return 'Password is Required';
                                }
                              },
                              type: TextInputType.visiblePassword,
                              lableText: 'Password',
                              isPassword: cubit.isPassword,
                              prefixIcon: 'assets/icons/Lock.svg',
                              onSuffixPressed: () {
                                cubit.changePasswordVisibalty();
                              },
                              suffixIcon: cubit.isPassword
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            SizedBox(
                              height: SizeConfigManger.bodyHeight * 0.03,
                            ),
                            CustomButton(
                              text: 'Login',
                              press: () {
                                if (formKey.currentState!.validate()) {
                                  if (passwordController.text.length < 6) {
                                    Toast.show(
                                        "password shoud be 6 char", context,
                                        duration: 3,
                                        backgroundColor: Colors.red);
                                  } else {
                                    LoginCubit.get(context).signInUser(
                                        username: usernameController.text,
                                        password: passwordController.text);
                                  }
                                }
                              },
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
