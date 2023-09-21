import 'package:flutter/material.dart';
import 'package:shop_smart_user/auth/login/presentation/widgets/input_login_widget.dart';
import 'package:shop_smart_user/auth/login/presentation/widgets/other_login_wigdet.dart';

import '../../../../core/widgets/app_name_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  static const routeName = '/LoginScreen';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: const Scaffold(
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 60.0,
                ),
                Center(child: AppNameWidget()),
                SizedBox(
                  height: 16.0,
                ),
                Text(
                  "Welcome Back",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                  ),
                ),
                Text(
                  "Let's get you logged in so you can start exploring.",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                SizedBox(
                  height: 16.0,
                ),
                InputWidget(),
                SizedBox(
                  height: 16,
                ),
                OtherLoginWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
