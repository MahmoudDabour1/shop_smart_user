import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shop_smart_user/auth/forget_password/presentation/screens/forget_password_screen.dart';
import 'package:shop_smart_user/core/widgets/bottom_bar_screen.dart';

import '../../../../core/resources/my_validators.dart';
import '../../../../core/widgets/error_methods_widget.dart';

class InputWidget extends StatefulWidget {
  const InputWidget({super.key});

  @override
  State<InputWidget> createState() => _InputWidgetState();
}

class _InputWidgetState extends State<InputWidget> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final FocusNode _emailFocusNode;
  late final FocusNode _passwordFocusNode;
  late final _formKey = GlobalKey<FormState>();
  bool obscureText = true;
  bool isLoading = false;
  final auth = FirebaseAuth.instance;

  Future<void> _loginFct() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {
      try {
        setState(() {
          isLoading = true;
        });
        await auth.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
        Fluttertoast.showToast(
          msg: "Login Successfully",
          toastLength: Toast.LENGTH_SHORT,
          textColor: Colors.white,
        );
        if (!mounted) {
          return;
        }
        Navigator.pushReplacementNamed(
          context,
          BottomBarScreen.routeName,
        );
      } on FirebaseAuthException catch (error) {
        MyAppErrorMethods.showErrorOrWarningDialog(
          context: context,
          title: "An Error has been occurred ${error.message}",
          fct: () {},
        );
      } catch (error) {
        MyAppErrorMethods.showErrorOrWarningDialog(
          context: context,
          title: "An Error has been occurred $error",
          fct: () {},
        );
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _emailFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _emailController,
            focusNode: _emailFocusNode,
            textInputAction: TextInputAction.next,
            validator: (value) {
              return MyValidators.emailValidator(value);
            },
            onFieldSubmitted: (value) {
              FocusScope.of(context).requestFocus(_passwordFocusNode);
            },
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              hintText: "youremail@gmail.com",
              prefixIcon: Icon(
                IconlyLight.message,
              ),
            ),
          ),
          const SizedBox(
            height: 16.0,
          ),
          TextFormField(
            controller: _passwordController,
            focusNode: _passwordFocusNode,
            textInputAction: TextInputAction.done,
            keyboardType: TextInputType.visiblePassword,
            onFieldSubmitted: (value) {
              _loginFct();
            },
            validator: (value) {
              return MyValidators.passwordValidator(value);
            },
            obscureText: obscureText,
            obscuringCharacter: '*',
            decoration: InputDecoration(
                hintText: "**********",
                prefixIcon: const Icon(
                  IconlyLight.lock,
                ),
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      obscureText = !obscureText;
                    });
                  },
                  icon: Icon(
                    obscureText ? Icons.visibility : Icons.visibility_off,
                  ),
                )),
          ),
          const SizedBox(
            height: 16.0,
          ),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () async {
                await Navigator.pushNamed(
                    context, ForgetPasswordScreen.routeName);
              },
              child: const Text(
                "Forgot Password ?",
                style: TextStyle(
                  fontSize: 18,
                  decoration: TextDecoration.underline,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ),
          SizedBox(
            width: double.infinity,
            child:isLoading?const Center(child: CircularProgressIndicator()): ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(12),
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              onPressed: () async {
                await _loginFct();
              },
              child: const Text(
                "Login",
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
