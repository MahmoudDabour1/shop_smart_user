import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_smart_user/auth/user/presentation/controller/provider.dart';
import 'package:shop_smart_user/cart/presentation/screens/cart_screen.dart';
import 'package:shop_smart_user/core/resources/theme_data.dart';
import 'package:shop_smart_user/home/presentation/screens/home_screen.dart';
import 'package:shop_smart_user/inner_screens/order/presentation/controller/provider.dart';
import 'package:shop_smart_user/inner_screens/wish_list/presentation/controller/provider.dart';
import 'package:shop_smart_user/products_details/presentation/controller/provider.dart';
import 'package:shop_smart_user/providers/theme_provider.dart';
import 'package:shop_smart_user/auth/forget_password/presentation/screens/forget_password_screen.dart';
import 'package:shop_smart_user/inner_screens/order/presentation/screens/order_screen.dart';
import 'package:shop_smart_user/products_details/presentation/screens/products_details_screen.dart';
import 'package:shop_smart_user/inner_screens/viewed_recently/presentation/screens/viewed_recently_screen.dart';
import 'package:shop_smart_user/inner_screens/wish_list/presentation/screens/wish_lsit_screen.dart';
import 'package:shop_smart_user/auth/login/presentation/screens/login_screen.dart';
import 'package:shop_smart_user/auth/register/presentation/screens/register_screen.dart';
import 'package:shop_smart_user/search/presentation/screens/search_screen.dart';

import 'cart/presentation/controller/provider.dart';
import 'core/widgets/bottom_bar_screen.dart';
import 'inner_screens/viewed_recently/presentation/controller/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FutureBuilder(
        future: Firebase.initializeApp(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          } else if (snapshot.hasError) {
            return Scaffold(
              body: Center(
                child: SelectableText(
                  "An error has been occurred ${snapshot.error}",
                ),
              ),
            );
          }
          return MultiProvider(
            providers: [
              ChangeNotifierProvider(
                create: (_) => ThemeProvider(),
              ),
              ChangeNotifierProvider(
                create: (_) => ProductProvider(),
              ),
              ChangeNotifierProvider(
                create: (_) => CartProvider(),
              ),
              ChangeNotifierProvider(
                create: (_) => WishListProvider(),
              ),
              ChangeNotifierProvider(
                create: (_) => ViewedRecentlyProvider(),
              ),
              ChangeNotifierProvider(
                create: (_) => UserProvider(),
              ),
              ChangeNotifierProvider(
                create: (_) => OrderProvider(),
              ),
            ],
            child: Consumer<ThemeProvider>(
                builder: (context, themeProvider, child) {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'Shop Smart',
                theme: Styles.themeData(
                    isDarkTheme: themeProvider.getIsDarkTheme,
                    context: context),
                home: const BottomBarScreen(),
                routes: {
                  ProductDetailsScreen.routeName: (context) =>
                      const ProductDetailsScreen(),
                  WishListScreen.routeName: (context) => WishListScreen(),
                  ViewedRecentlyScreen.routeName: (context) =>
                      ViewedRecentlyScreen(),
                  LoginScreen.routeName: (context) => const LoginScreen(),
                  RegisterScreen.routeName: (context) => const RegisterScreen(),
                  OrderScreen.routeName: (context) => const OrderScreen(),
                  ForgetPasswordScreen.routeName: (context) =>
                      const ForgetPasswordScreen(),
                  SearchScreen.routeName: (context) => const SearchScreen(),
                  HomeScreen.routeName: (context) => const HomeScreen(),
                  CartScreen.routeName: (context) => const CartScreen(),
                  BottomBarScreen.routeName: (context) =>
                      const BottomBarScreen(),
                },
              );
            }),
          );
        },
      ),
    );
  }
}
