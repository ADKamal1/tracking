import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:hook_atos/shared/helper/mangers/size_config.dart';
import 'package:hook_atos/ui/components/app_text.dart';
import 'package:hook_atos/ui/screens/upgrade_screen/cubit/update_cubit.dart';

class UpdateScreen extends StatelessWidget {
  const UpdateScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
      UpdateCubit()
        ..getLink(),
      child: BlocConsumer<UpdateCubit, UpdateState>(
        listener: (context, state) {},
        builder: (context, state) {
          return state is GetLinkLoading
              ? Center(
            child: CircularProgressIndicator(),
          )
              : Scaffold(
            body: SafeArea(
              child: Center(
                child: Column(
                  children: [
                    SizedBox(height: SizeConfigManger.bodyHeight * .2),
                    AppText(
                      text: "Please Update to continue with App",
                      fontWeight: FontWeight.bold,
                      textSize: 22,
                    ),
                    Image.asset("assets/images/update.png",
                        fit: BoxFit.cover,
                        height: SizeConfigManger.bodyHeight * .3,
                        width: SizeConfigManger.bodyHeight * .3),
                    AppText(
                      maxLines: 5,
                      text: "من فضلك قم بتحديث التطبيق لإستكمال العمل اذا لم تحصل علي نسخة التطبيق الخاصة بك من فضلك قم بالتواصل معانا عن طريق الواتس اب وطلب التطبيق ",
                      textSize: 18,
                      align: TextAlign.center,
                    ),
                    SizedBox(height: SizeConfigManger.bodyHeight * .04),

                    InkWell(
                      onTap: (){
                        _launchWhatsapp();
                      },
                      child: Container(
                        width:SizeConfigManger.bodyHeight * .1 ,
                        height:SizeConfigManger.bodyHeight * .1 ,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage('assets/icons/whatslogo.png')
                          ),
                        ),
                      ),
                    )

                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  _launchWhatsapp() async {
    var whatsapp = "1068002437";
    var whatUrl = 'https://wa.me/${20}$whatsapp?text=أهلا بك من فضلك أريد النسخه الاحدث من التطبيق   ';
    await launchUrl(Uri.parse(whatUrl), mode: LaunchMode.externalApplication);
  }

}
