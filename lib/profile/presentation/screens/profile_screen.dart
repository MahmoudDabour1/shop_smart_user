import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_smart_user/auth/user/data/models/user_model.dart';
import 'package:shop_smart_user/auth/user/presentation/controller/provider.dart';
import 'package:shop_smart_user/core/widgets/bottom_bar_screen.dart';
import 'package:shop_smart_user/core/widgets/loading_manager.dart';
import 'package:shop_smart_user/providers/theme_provider.dart';
import 'package:shop_smart_user/inner_screens/viewed_recently/presentation/screens/viewed_recently_screen.dart';
import 'package:shop_smart_user/inner_screens/wish_list/presentation/screens/wish_lsit_screen.dart';
import 'package:shop_smart_user/auth/login/presentation/screens/login_screen.dart';
import 'package:shop_smart_user/inner_screens/order/presentation/screens/order_screen.dart';
import 'package:shop_smart_user/profile/presentation/widgets/custom_list_tile.dart';
import '../../../core/resources/assets_manager.dart';
import '../../../core/widgets/app_name_widget.dart';
import '../../../core/widgets/error_methods_widget.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  User? user = FirebaseAuth.instance.currentUser;
  UserModel? userModel;
  bool _isLoading = true;

  @override
  void initState() {
    fetchUserInfo();
    super.initState();

  }

  Future<void> fetchUserInfo() async {
    if (user == null) {
      setState(() {
        _isLoading = false;
      });
      return;
    }
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      userModel = await userProvider.fetchUserInfo();
    } catch (error) {
      await MyAppErrorMethods.showErrorOrWarningDialog(
          context: context,
          title: "An error has been occurred $error",
          fct: () {});
    }finally{
      setState(() {
        _isLoading = false;
      });
    }
  }



  @override
  Widget build(BuildContext context) {
    super.build(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        leading: Image.asset(AssetsManager.shoppingCart),
        title: const AppNameWidget(
          fontSize: 20,
        ),
      ),
      body: LoadingManager(
        isLoading: _isLoading,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 10,
              ),
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
              userModel == null
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
                          userModel!.userName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        Text(
                          userModel!.userEmail,
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
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 24,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "General",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    user == null
                        ? const SizedBox.shrink()
                        : CustomListTile(
                        imagePath: AssetsManager.orderSvg,
                        text: "All Order",
                        function: () async {
                          await Navigator.pushNamed(
                            context,
                            OrderScreen.routeName,
                          );
                        }),
                    user == null
                        ? const SizedBox.shrink()
                        : CustomListTile(
                        imagePath: AssetsManager.wishlistSvg,
                        text: "Wishlist",
                        function: () async {
                          await Navigator.pushNamed(
                            context,
                            WishListScreen.routeName,
                          );
                        }),
                    CustomListTile(
                        imagePath: AssetsManager.recent,
                        text: "Viewed Recently",
                        function: () async {
                          await Navigator.pushNamed(
                            context,
                            ViewedRecentlyScreen.routeName,
                          );
                        }),
                    CustomListTile(
                        imagePath: AssetsManager.address,
                        text: "Address",
                        function: () {}),
                    const Divider(
                      thickness: 1,
                    ),
                    const Text(
                      "Settings",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SwitchListTile(
                      title: Text(
                        themeProvider.getIsDarkTheme ? "Dark Mode" : "Light Mode",
                      ),
                      secondary: Image.asset(
                        AssetsManager.theme,
                        width: 30,
                      ),
                      value: themeProvider.getIsDarkTheme,
                      onChanged: (value) {
                        themeProvider.setDarkTheme(
                          themeValue: value,
                        );
                      },
                    ),
                    const Divider(
                      thickness: 1,
                    ),
                    const Text(
                      "Other",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    CustomListTile(
                        imagePath: AssetsManager.privacy,
                        text: "Privacy&Policy",
                        function: () {}),
                    Center(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        onPressed: () async {
                          if (user == null) {
                            await Navigator.pushNamed(
                              context,
                              LoginScreen.routeName,
                            );
                          } else {
                            MyAppErrorMethods.showErrorOrWarningDialog(
                              context: context,
                              title: "Are you sure?",
                              fct: () async {
                                await FirebaseAuth.instance.signOut();
                                if (!mounted) return;
                                await Navigator.pushNamed(
                                  context,
                                  LoginScreen.routeName,
                                );
                                if (!mounted) return;
                                Navigator.pushNamed(
                                    context, BottomBarScreen.routeName);
                              },
                              isError: false,
                            );
                          }
                        },
                        icon: Icon(user == null ? Icons.login : Icons.logout,
                            color: Colors.white),
                        label: Text(
                          user == null ? "Login" : "Logout",
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
