import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:shop_smart_user/core/resources/my_validators.dart';

import '../../../../core/resources/assets_manager.dart';
import '../../../../core/widgets/app_name_widget.dart';
import '../../../../core/widgets/text_form_field_widget.dart';

class ForgetPasswordScreen extends StatefulWidget {
  static const routeName = '/ForgetPasswordScreen';

  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  late final TextEditingController _emailController;
  late final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _emailController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    if (mounted) {
      _emailController.dispose();
    }
    super.dispose();
  }

  Future<void> _forgetPasswordFunction() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {}
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const AppNameWidget(
            fontSize: 22,
          ),
          centerTitle: true,
        ),
        body: ListView(
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
          ),
          children: [
            const SizedBox(
              height: 10,
            ),
            Image.asset(
              AssetsManager.forgotPassword,
              width: size.width * 0.6,
              height: size.width * 0.6,
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              "Forgot password",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              "Please enter the email address you'd like your password reset information sent to",
              style: TextStyle(
                fontSize: 14,
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            Form(
              key: _formKey,
              child: TextFormFieldWidget(
                hintText: "youremail@email.com",
                validation: (value) {
                  return MyValidators.emailValidator(value);
                },
                keyboardType: TextInputType.emailAddress,
                isLastInput: true,
                controller: _emailController,
                function: (value) async {
                  await _forgetPasswordFunction();
                  FocusScope.of(context).unfocus();
                },
                prefixIcon: IconlyLight.message,
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () async {
                    await _forgetPasswordFunction();
                  },
                  icon: const Icon(IconlyBold.send),
                  label: const Text(
                    "Request link",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  )),
            )
          ],
        ),
      ),
    );
  }
}
