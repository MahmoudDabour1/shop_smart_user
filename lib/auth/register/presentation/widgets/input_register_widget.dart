import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shop_smart_user/core/widgets/bottom_bar_screen.dart';
import '../../../../core/resources/my_validators.dart';
import '../../../../core/widgets/error_methods_widget.dart';
import '../../../../core/widgets/text_form_field_widget.dart';
import 'package:shop_smart_user/auth/register/presentation/widgets/pick_image_widget.dart';

class InputRegisterWidget extends StatefulWidget {
  const InputRegisterWidget({super.key});

  @override
  State<InputRegisterWidget> createState() => _InputRegisterWidgetState();
}

class _InputRegisterWidgetState extends State<InputRegisterWidget> {
  late final TextEditingController _nameController,
      _emailController,
      _passwordController,
      _confirmPasswordController;

  late final FocusNode _nameFocusNode,
      _emailFocusNode,
      _passwordFocusNode,
      _confirmPasswordFocusNode;
  late final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  final auth = FirebaseAuth.instance;
  String? userImageUrl;

  @override
  void initState() {
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    _nameFocusNode = FocusNode();
    _emailFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();
    _confirmPasswordFocusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nameFocusNode.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    super.dispose();
  }

  XFile? _pickedImage;

  Future<void> _registerFct() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (_pickedImage == null) {
      MyAppErrorMethods.showErrorOrWarningDialog(
          context: context, title: "Please Select Image", fct: () {});
      return;
    }
    if (isValid) {
      _formKey.currentState!.save();

      try {
        setState(() {
          isLoading = true;
        });
        final ref = FirebaseStorage.instance
            .ref()
            .child("usersImages")
            .child('${_emailController.text.trim()}.jpg');
        await ref.putFile(File(_pickedImage!.path));
        userImageUrl = await ref.getDownloadURL();

        await auth.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
        User? user = auth.currentUser;
        final uid = user!.uid;
        await FirebaseFirestore.instance.collection("users").doc(uid).set({
          'userId': uid,
          'userName': _nameController.text,
          'userImage': userImageUrl,
          'userEmail': _emailController.text.toLowerCase(),
          'createdAt': Timestamp.now(),
          'userWish': [],
          'userCart': [],
        });
        Fluttertoast.showToast(
          msg: "An account has been created",
          toastLength: Toast.LENGTH_SHORT,
          textColor: Colors.white,
        );
        if (!mounted) return;
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

  Future<void> localImagePicker() async {
    final ImagePicker picker = ImagePicker();
    await MyAppErrorMethods.imagePickerDialog(
      context: context,
      cameraFct: () async {
        _pickedImage = await picker.pickImage(source: ImageSource.camera);
        setState(() {});
      },
      galleryFct: () async {
        _pickedImage = await picker.pickImage(source: ImageSource.gallery);
        setState(() {});
      },
      removeFct: () {
        setState(() {
          _pickedImage = null;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Center(
            child: SizedBox(
              height: size.width * 0.3,
              width: size.width * 0.3,
              child: PickImageWidget(
                function: () async {
                  await localImagePicker();
                },
                pickImage: _pickedImage,
              ),
            ),
          ),
          TextFormFieldWidget(
              hintText: "userName",
              controller: _nameController,
              focusNode: _nameFocusNode,
              function: (value) {
                FocusScope.of(context).requestFocus(_emailFocusNode);
              },
              prefixIcon: Icons.person_2_outlined,
              validation: MyValidators.nameValidator),
          TextFormFieldWidget(
            hintText: "youremail@gmail.com",
            controller: _emailController,
            focusNode: _emailFocusNode,
            function: (value) {
              FocusScope.of(context).requestFocus(_passwordFocusNode);
            },
            prefixIcon: IconlyLight.message,
            validation: MyValidators.emailValidator,
            keyboardType: TextInputType.emailAddress,
          ),
          TextFormFieldWidget(
            hintText: "Password",
            controller: _passwordController,
            focusNode: _passwordFocusNode,
            function: (value) {
              FocusScope.of(context).requestFocus(_confirmPasswordFocusNode);
            },
            prefixIcon: IconlyLight.lock,
            validation: MyValidators.passwordValidator,
            keyboardType: TextInputType.visiblePassword,
            isPassword: true,
          ),
          TextFormFieldWidget(
            hintText: "Repeat Password",
            controller: _confirmPasswordController,
            focusNode: _confirmPasswordFocusNode,
            function: (value) async {
              FocusScope.of(context).requestFocus(_emailFocusNode);
              await _registerFct();
            },
            prefixIcon: IconlyLight.lock,
            validation: (value) {
              return MyValidators.confirmPasswordValidator(
                  value: value, password: _passwordController.text);
            },
            isLastInput: true,
            isPassword: true,
            keyboardType: TextInputType.visiblePassword,
          ),
          const SizedBox(
            height: 30.0,
          ),
          isLoading
              ? const CircularProgressIndicator()
              : SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(12),
                      backgroundColor:
                          Theme.of(context).scaffoldBackgroundColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    onPressed: () async {
                      await _registerFct();
                    },
                    child: const Text(
                      "Sign in",
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
