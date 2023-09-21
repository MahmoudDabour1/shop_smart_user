import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shop_smart_user/auth/register/presentation/widgets/input_register_widget.dart';
import 'package:shop_smart_user/auth/register/presentation/widgets/pick_image_widget.dart';

import '../../../../core/widgets/app_name_widget.dart';
import '../../../../core/widgets/error_methods_widget.dart';

class RegisterScreen extends StatefulWidget {
  static const routeName = '/RegisterScreen';

  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  XFile? _pickedImage;



  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          leading: const Icon(
            Icons.arrow_back_ios_new,
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(child: AppNameWidget()),
                const SizedBox(
                  height: 16.0,
                ),
                const Text(
                  "Welcome Back",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                  ),
                ),
                const Text(
                  "Sign up now to receive special offers and updates from our app.",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                // Center(
                //   child: SizedBox(
                //     height: size.width * 0.3,
                //     width: size.width * 0.3,
                //     child: PickImageWidget(
                //       function: () async {
                //         await localImagePicker();
                //       },
                //       pickImage: _pickedImage,
                //     ),
                //   ),
                // ),
                const InputRegisterWidget(),
                const SizedBox(
                  height: 50,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
