import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:hook_atos/shared/helper/mangers/colors.dart';
import 'package:hook_atos/ui/components/app_text.dart';
import 'package:hook_atos/ui/components/custom_button.dart';
import 'package:tbib_toast/tbib_toast.dart';

import '../../../../layout/cubit/main_cubit.dart';
import '../../../../shared/helper/icon_broken.dart';
import '../../../../shared/helper/mangers/size_config.dart';
import '../../../components/custom_text_form_field.dart';

class CustomBottomSheetDesign extends StatefulWidget {
  MainCubit cubit;

  CustomBottomSheetDesign(this.cubit);

  @override
  State<CustomBottomSheetDesign> createState() =>
      _CustomBottomSheetDesignState();
}

class _CustomBottomSheetDesignState extends State<CustomBottomSheetDesign> {
  var name = TextEditingController();
  var phone = TextEditingController();
  var note = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(getProportionateScreenHeight(10)),
          child: Center(
            child: Column(
              children: [
                CustomTextFormField(
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
                SizedBox(
                  height: SizeConfigManger.bodyHeight * .015,
                ),
                CustomTextFormField(
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
                SizedBox(
                  height: SizeConfigManger.bodyHeight * .015,
                ),
                CustomTextFormField(
                  controller: note,
                  type: TextInputType.text,
                  lableText: "notes",
                  validate: (String? value) {
                    if (value!.isEmpty) {
                      return "Note is Required";
                    }
                  },
                ),
                SizedBox(
                  height: SizeConfigManger.bodyHeight * .015,
                ),
                InkWell(
                  onTap: () async {
                    chooseUserImage();
                    await widget.cubit.setUpPermissions(start: false);
                  },
                  child: Container(
                      height: SizeConfigManger.bodyHeight * .2,
                      width: SizeConfigManger.bodyHeight * .2,
                      child: userImage == null
                          ? Icon(
                              IconBroken.Image_2,
                              size: SizeConfigManger.bodyHeight * .15,
                            )
                          : Image.file(
                              userImage!,
                              height: double.infinity,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            )),
                ),
                SizedBox(
                  height: SizeConfigManger.bodyHeight * .03,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: getProportionateScreenHeight(20)),
                  child: CustomButton(
                      press: () {
                        if (userImage == null) {
                          Toast.show("Image is Required", context,
                              backgroundColor: Colors.red, duration: 3);
                        } else {
                          if (formKey.currentState!.validate()) {
                            widget.cubit.addCustomer(
                              line: "",
                                speciality: "",
                                dist: "",
                                classy: "",
                                image: userImage!,
                                name: name.text,
                                phone: phone.text,
                                lat: widget.cubit.locationData!.latitude ?? 0,
                                lon: widget.cubit.locationData!.longitude ?? 0
                            ,
                            states: false);
                          }
                        }
                      },
                      text: "Add Customer"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  File? userImage;

  void chooseUserImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        maxHeight: 480,
        maxWidth: 640,
        imageQuality: 30);
    if (image != null) {
      _cropImage(image: image.path);
    }
  }


  Future _cropImage({required String image})async{

    CroppedFile ? croppedFile = await ImageCropper().cropImage(
      sourcePath: image,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9
      ],
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: ColorsManger.darkPrimary,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        IOSUiSettings(
          title: 'Cropper',
        ),
      ],
    );
    setState(() {
      userImage = File(croppedFile!.path);
    });
  }

}
