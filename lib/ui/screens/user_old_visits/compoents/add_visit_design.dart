// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:hook_atos/ui/screens/user_old_visits/cubit/user_visits_cubit.dart';
// import 'package:tbib_toast/tbib_toast.dart';
//
// import '../../../../shared/helper/icon_broken.dart';
// import '../../../../shared/helper/mangers/size_config.dart';
// import '../../../components/app_text.dart';
// import '../../../components/custom_button.dart';
// import '../../../components/custom_text_form_field.dart';
//
// class CustomBottomAddVist extends StatefulWidget {
//   UserVisitsCubit cubit;
//   double userLat;
//   double userLon;
//   String name;
//   String phone;
//   File userImage;
//
//   CustomBottomAddVist(
//       this.cubit, this.userLat, this.userLon, this.phone, this.name,this.userImage);
//
//   @override
//   State<CustomBottomAddVist> createState() => _CustomBottomAddVistState();
// }
//
// class _CustomBottomAddVistState extends State<CustomBottomAddVist> {
//   var location = TextEditingController();
//   var note = TextEditingController();
//   var formKey = GlobalKey<FormState>();
//
//   @override
//   Widget build(BuildContext context) {
//     return Form(
//       key: formKey,
//       child: SingleChildScrollView(
//         child: Padding(
//           padding: EdgeInsets.all(getProportionateScreenHeight(10)),
//           child: Center(
//             child: Column(
//               children: [
//
//                 CustomTextFormField(
//                   controller: note,
//                   type: TextInputType.text,
//                   lableText: "notes",
//                   validate: (String? value) {
//                     if (value!.isEmpty) {
//                       return "Note is Required";
//                     }
//                   },
//                 ),
//                 SizedBox(
//                   height: SizeConfigManger.bodyHeight * .015,
//                 ),
//                 InkWell(
//                   onTap: ()async {
//                     chooseUserImage();
//                     await widget.cubit.setUpPermissions();
//                   },
//                   child: Container(
//                       height: SizeConfigManger.bodyHeight * .2,
//                       width: SizeConfigManger.bodyHeight * .2,
//                       child: userImage == null
//                           ? Icon(
//                               IconBroken.Image_2,
//                               size: SizeConfigManger.bodyHeight * .15,
//                             )
//                           : Image.file(
//                               userImage!,
//                               height: double.infinity,
//                               width: double.infinity,
//                               fit: BoxFit.cover,
//                             )),
//                 ),
//                 SizedBox(
//                   height: SizeConfigManger.bodyHeight * .03,
//                 ),
//                 Padding(
//                   padding: EdgeInsets.symmetric(
//                       horizontal: getProportionateScreenHeight(20)),
//                   child: CustomButton(
//                       press: () {
//                         if (userImage == null) {
//                           Toast.show("Image is Required", context, backgroundColor: Colors.red, duration: 3);
//                         } else {
//                           if (formKey.currentState!.validate()) {
//
//                               widget.cubit.addVisitUser(
//                                 userName: widget.name,
//
//
//                                   phone: widget.phone,
//                                   name: widget.name,
//                                   image:widget.userImage,
//                                   orginalLat: widget.userLat,
//                                   orginalLong: widget.userLon,
//                                   line: "",
//                                   classy: "",
//                                   specilty: "",
//                                   dist:"",
//                                 dateTime: "",
//                                 timeOfDay: "",
//                               );
//                             }
//                         }
//                       },
//                       text: "Add Visit"),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   File? userImage;
//
//
//   void chooseUserImage() async {
//     final ImagePicker _picker = ImagePicker();
//     final XFile? image = await _picker.pickImage(
//         source: ImageSource.camera,
//         maxHeight: 480,
//         maxWidth: 640,
//         imageQuality: 30);
//     if (image != null) {
//       userImage = File(image.path);
//       setState(() {});
//     }
//   }
// }
