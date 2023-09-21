import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:ionicons/ionicons.dart';
import 'package:shop_smart_user/auth/register/presentation/screens/register_screen.dart';
import 'package:shop_smart_user/core/widgets/bottom_bar_screen.dart';
import 'package:shop_smart_user/core/widgets/error_methods_widget.dart';

class OtherLoginWidget extends StatelessWidget {
  const OtherLoginWidget({super.key});

  Future<void> _googleSignIn({
    required BuildContext context,
  }) async {
    final googleSignIn = GoogleSignIn();
    final googleAccount = await googleSignIn.signIn();
    if (googleAccount != null) {
      final googleAuth = await googleAccount.authentication;
      if (googleAuth.accessToken != null && googleAuth.idToken != null) {
        try {
          final authResults = await FirebaseAuth.instance
              .signInWithCredential(GoogleAuthProvider.credential(
            accessToken: googleAuth.accessToken,
            idToken: googleAuth.idToken,
          ));
          if (authResults.additionalUserInfo!.isNewUser) {
            await FirebaseFirestore.instance
                .collection("users")
                .doc(authResults.user!.uid)
                .set({
              'userId': authResults.user!.uid,
              'userName': authResults.user!.displayName,
              'userImage': authResults.user!.photoURL,
              'userEmail': authResults.user!.email,
              'createdAt': Timestamp.now(),
              'userWish': [],
              'userCart': [],
            });
          }
        } on FirebaseException catch (error) {
          await MyAppErrorMethods.showErrorOrWarningDialog(
              context: context,
              title: "An error has been occurred ${error.message}",
              fct: () {});
        } catch (error) {
          await MyAppErrorMethods.showErrorOrWarningDialog(
              context: context,
              title: "An error has been occurred $error",
              fct: () {});
        }
      }
    }
    Navigator.pushReplacementNamed(context, BottomBarScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "or connect using".toUpperCase(),
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 18,
            // color: Theme.of(context).scaffoldBackgroundColor
          ),
        ),
        const SizedBox(
          height: 16,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 2,
                child: SizedBox(
                  height: kBottomNavigationBarHeight,
                  child: FittedBox(
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        await _googleSignIn(context: context);
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: const Icon(
                        Ionicons.logo_google,
                        color: Colors.red,
                        size: 25,
                      ),
                      label: const Text(
                        "Sign in with google",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: SizedBox(
                  height: kBottomNavigationBarHeight,
                  child: FittedBox(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, BottomBarScreen.routeName);
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        "Guest?",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 16,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Don't have an account? ",
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            TextButton(
              onPressed: () async {
                await Navigator.pushNamed(context, RegisterScreen.routeName);
              },
              child: const Text(
                "Sign up",
                style: TextStyle(
                  fontSize: 20,
                  decoration: TextDecoration.underline,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
