import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_smart_user/auth/user/presentation/controller/provider.dart';
import 'package:shop_smart_user/core/widgets/error_methods_widget.dart';

import '../../../auth/user/data/models/user_model.dart';

class UserInformationWidget extends StatefulWidget {
  const UserInformationWidget({super.key, required this.data});
  final Future<void>? data;

  @override
  State<UserInformationWidget> createState() => _UserInformationWidgetState();
}

class _UserInformationWidgetState extends State<UserInformationWidget> {
  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    UserModel? userModel;

    return Column(
      children: [
        Visibility(
            visible: user == null ? true : false,
            child: const Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "please login to have ultimate access",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            )),
        user == null
            ? const SizedBox.shrink()
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context).cardColor,
                        border: Border.all(
                          width: 3,
                          color: Theme.of(context).colorScheme.background,
                        ),
                        image:  DecorationImage(
                          image: NetworkImage(
                            userModel!.userImage,
                          ),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                     Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userModel.userName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        Text(
                          userModel.userEmail,
                          style: const TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
      ],
    );
  }
}
