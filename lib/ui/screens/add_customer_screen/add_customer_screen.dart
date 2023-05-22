import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hook_atos/animation/faidAnimation.dart';
import 'package:hook_atos/layout/cubit/main_cubit.dart';
import 'package:hook_atos/model/LineModel.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:tbib_toast/tbib_toast.dart';

import '../../../shared/helper/icon_broken.dart';
import '../../../shared/helper/mangers/size_config.dart';
import '../../../shared/helper/methods.dart';
import '../../components/custom_button.dart';
import '../../components/custom_text_form_field.dart';
import '../upgrade_screen/update_screen.dart';
import '../user_old_visits/cubit/user_visits_cubit.dart';

class AddCustomerScreen extends StatefulWidget {
  @override
  State<AddCustomerScreen> createState() => _AddCustomerScreenState();
}

class _AddCustomerScreenState extends State<AddCustomerScreen> {
  var name = TextEditingController();
  var phone = TextEditingController();
  var note = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  void initState() {

    // TODO: implement initState
  }
   String? selectedName;
   Line? fullLine;
   String?  selectedClassy;

  String?  selectedSpicality;


  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MainCubit, MainState>(
      listener: (context, state) {
        if (state is AddNewCustomerSuccess) {
          Navigator.pop(context);
          Navigator.pop(context);
        } else if (state is AddNewCustomerLoading) {
          showCustomProgressIndicator(context);
        }
        // else if (state is UpdatePageState) {
        //   navigateToAndFinish(context, UpdateScreen());
        // }
        else if (state is PhoneAlreadyHere) {
          Navigator.pop(context);
          Toast.show("رقم الهاتف مستخدم بالفعل من قبل ", context,
              backgroundColor: Colors.red, duration: 3);
        } else if (state is ShowCatchError) {
          print(state.error);
          Navigator.pop(context);
          Toast.show(state.error, context,
              backgroundColor: Colors.red, duration: 3);
        } else if (state is ShowNetWORKError) {
          Navigator.pop(context);
          Toast.show(state.error, context,
              backgroundColor: Colors.red, duration: 3);
        }
      },
      builder: (context, state) {
        MainCubit cubit = MainCubit.get(context);
        List<String> linesName = cubit.linesNames;
        //  List<DropdownMenuItem<String>> linesNames = linesName
        //      .map((name) => DropdownMenuItem(
        //            value: name,
        //            child: Text(name),
        //          ))
        //      .toList();
        //  print(linesName);
        return Scaffold(

          body: SafeArea(
            child: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(getProportionateScreenHeight(10)),
                  child: Center(
                    child: Column(

                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        SizedBox(
                          height: SizeConfigManger.bodyHeight * .05,
                        ),
                        FadeAnimation(
                          0.5, InkWell(
                            onTap: () async {
                              chooseCustomerImage();
                              await cubit.setUpPermissions(start: false);
                            },
                            child: SizedBox(
                                height: SizeConfigManger.bodyHeight * .3,
                                width: SizeConfigManger.bodyHeight * .3,
                                child: customerImage == null
                                    ? Icon(
                                  IconBroken.Image_2,
                                  size: SizeConfigManger.bodyHeight * .15,
                                )
                                    : Image.file(
                                  customerImage!,
                                  height: double.infinity,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                )),
                          ),
                        ),
                        SizedBox(
                          height: SizeConfigManger.bodyHeight * .015,
                        ),
                        FadeAnimation(
                         1, CustomTextFormField(
                            controller: name,
                            type: TextInputType.text,
                            lableText: "username",
                            prefixIcon: 'assets/icons/User.svg',
                            validate: (String? value) {
                              if (value!.isEmpty) {
                                return "Username is Required";
                              }
                            },
                          ),
                        ),
                        SizedBox(
                          height: SizeConfigManger.bodyHeight * .015,
                        ),
                        FadeAnimation(
                          1.5, CustomTextFormField(
                            controller: phone,
                            type: TextInputType.phone,
                            lableText: "Phone Number",
                            prefixIcon: 'assets/icons/Phone.svg',
                            validate: (String? value) {
                              if (value!.isEmpty) {
                                return "Phone is Required";
                              }
                            },
                          ),
                        ),
                        // CustomTextFormField(
                        //   controller: note,
                        //   type: TextInputType.text,
                        //   lableText: "notes",
                        //   validate: (String? value) {
                        //     if (value!.isEmpty) {
                        //       return "Note is Required";
                        //     }
                        //   },
                        // ),
                        // SizedBox(
                        //   height: SizeConfigManger.bodyHeight * .02,
                        // ),
                        //
                        //  DropdownButton<String>(
                        //   value: _selectedName,
                        //   items: linesNames,
                        //   onChanged: ( value) {
                        //     setState(() {
                        //       _selectedName = value;
                        //     });
                        //   },
                        //
                        //   hint:Text(_selectedName??'Line Name'),
                        // ),


                        FadeAnimation(
                         1.7, Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 30),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                DropdownButton<String>(
                                  items: linesName.toSet().map((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      selectedName = value;
                                      fullLine = cubit.lines.firstWhere((
                                          element) =>
                                      element.name == selectedName);
                                      selectedClassy = null;
                                      selectedSpicality = null;
                                    });
                                  },
                                  value: selectedName,

                                  hint: Text("selected Line"),
                                ),

                                SizedBox(
                                  height: SizeConfigManger.bodyHeight * .02,
                                ),
                                FadeAnimation(
                                  1.8, Builder(
                                      builder: (context) {
                                        return DropdownButton<String>(
                                          items: fullLine?.classification.toSet()
                                              .map((String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(value),
                                            );
                                          }).toList(),
                                          onChanged: (value) {
                                            setState(() {
                                              selectedClassy = value;
                                            });
                                          },
                                          value: selectedClassy,

                                          hint: Text("class      "),
                                        );
                                      }
                                  ),
                                ),
                                // SizedBox(
                                //   height: SizeConfigManger.bodyHeight * .02,
                                // ),
                                // Builder(
                                //     builder: (context) {
                                //       return DropdownButton<String>(
                                //         items: fullLine?.distribution.toSet()
                                //             .map((String value) {
                                //           return DropdownMenuItem<String>(
                                //             value: value,
                                //             child: Text(value),
                                //           );
                                //         }).toList(),
                                //         onChanged: (value) {
                                //           setState(() {
                                //             selectedDis = value;
                                //           });
                                //         },
                                //         value: selectedDis,
                                //
                                //         hint: Text("Distruibutors"),
                                //       );
                                //     }
                                // ),
                                SizedBox(
                                  height: SizeConfigManger.bodyHeight * .02,
                                ),
                                FadeAnimation(
                                 1.9, Builder(
                                      builder: (context) {
                                        return DropdownButton<String>(
                                          items: fullLine?.speciality.toSet().map((
                                              String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(value),
                                            );
                                          }).toList(),
                                          onChanged: (value) {
                                            setState(() {
                                              selectedSpicality = value;
                                            });
                                          },

                                          value: selectedSpicality,

                                          hint: Text("Specialities"),
                                        );
                                      }
                                  ),
                                ),
                                SizedBox(
                                  height: SizeConfigManger.bodyHeight * .02,
                                ),
                              ],
                            ),
                          ),
                        ),
                        state is LoadingState
                            ? const Center(
                          child: CircularProgressIndicator(),
                        )
                            : FadeAnimation(
                              2.1, Padding(
                          padding: EdgeInsets.symmetric(
                                horizontal:
                                getProportionateScreenHeight(20)),
                          child: CustomButton(

                                press: () async {
                                  UserVisitsCubit userVisitsCubit = UserVisitsCubit
                                      .get(context);
                                  if (customerImage == null) {
                                    Toast.show("Image is Required", context,
                                        backgroundColor: Colors.red,
                                        duration: 3);
                                  }
                                  else if (selectedClassy == null ||
                                      selectedName == null ||
                                      selectedSpicality == null) {
                                    Toast.show(
                                        "complete your selections", context,
                                        backgroundColor: Colors.red,
                                        duration: 3);
                                  }
                                  else {
                                    if (formKey.currentState!.validate()) {
                                      cubit.addCustomer(
                                          image: customerImage!,
                                          name: name.text,
                                          phone: phone.text,
                                          classy: selectedClassy ?? "",
                                          dist:  "",
                                          speciality: selectedSpicality ?? "",
                                          line: selectedName ?? "",
                                          lat: cubit
                                              .locationData!.latitude ??
                                              0.0,
                                          lon: cubit.locationData!
                                              .longitude ??
                                              0.0,

                                        states: false,

                                      );
                                      // userVisitsCubit.addVisitUser(
                                      //
                                      //
                                      //   userName: name.text,
                                      //   name: name.text,
                                      //   phone: phone.text,
                                      //
                                      //   image: customerImage!.uri.toString(),
                                      //   orginalLat: cubit
                                      //       .locationData!.latitude ?? 0.0,
                                      //   orginalLong:
                                      //   cubit.locationData!
                                      //       .longitude ??
                                      //       0.0,
                                      //   line: selectedName ?? "",
                                      //   classy: selectedClassy ?? "",
                                      //   specilty: selectedSpicality ?? "",
                                      //   dist: selectedDis ?? "",
                                      //   timeOfDay: DateFormat('dd/MM/yyyy')
                                      //       .format(DateTime.now())
                                      //       .toString(),
                                      //   dateTime: DateTime.now().toString(),
                                      //   states: false,
                                      //
                                      //
                                      // );
                                    }
                                  }
                                },
                                text: "Add Customer"),
                        ),
                            ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  File? customerImage;

  void chooseCustomerImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        maxHeight: 480,
        maxWidth: 640,
        imageQuality: 30);
    if (image != null) {
      customerImage = File(image.path);
      setState(() {});
    }
  }

}
