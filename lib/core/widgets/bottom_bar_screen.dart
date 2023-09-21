import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';
import 'package:shop_smart_user/cart/presentation/controller/provider.dart';
import 'package:shop_smart_user/cart/presentation/screens/cart_screen.dart';
import 'package:shop_smart_user/home/presentation/screens/home_screen.dart';
import 'package:shop_smart_user/products_details/presentation/controller/provider.dart';
import 'package:shop_smart_user/profile/presentation/screens/profile_screen.dart';

import '../../auth/user/presentation/controller/provider.dart';
import '../../inner_screens/wish_list/presentation/controller/provider.dart';
import '../../search/presentation/screens/search_screen.dart';

class BottomBarScreen extends StatefulWidget {
  static const routeName = '/BottomBarScreen';

  const BottomBarScreen({super.key});

  @override
  State<BottomBarScreen> createState() => _BottomBarScreenState();
}

class _BottomBarScreenState extends State<BottomBarScreen> {
  late PageController pageController;
  int currentScreen = 0;
  bool isLoadingProds = true;

  List<Widget> screens = [
    const HomeScreen(),
    const SearchScreen(),
    const CartScreen(),
    const ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: currentScreen);
  }

  Future<void> fetchFCT() async {
    final productsProvider =
        Provider.of<ProductProvider>(context, listen: false);
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    final wishListProvider =
        Provider.of<WishListProvider>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      Future.wait({
        productsProvider.fetchProduct(),
        userProvider.fetchUserInfo(),
      });
      Future.wait({
        cartProvider.fetchCart(),
        wishListProvider.fetchWishList(),
      });
    } catch (error) {
      log(error.toString());
    } finally {
      setState(() {
        isLoadingProds = false;
      });
    }
  }

  @override
  void didChangeDependencies() {
    if (isLoadingProds) {
      fetchFCT();
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    return Scaffold(
      body: PageView(
        controller: pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentScreen,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 2,
        onDestinationSelected: (index) {
          setState(() {
            currentScreen = index;
          });
          pageController.jumpToPage(currentScreen);
        },
        destinations: [
          const NavigationDestination(
            selectedIcon: Icon(IconlyBold.home),
            icon: Icon(IconlyLight.home),
            label: "Home",
          ),
          const NavigationDestination(
            selectedIcon: Icon(IconlyBold.search),
            icon: Icon(IconlyLight.search),
            label: "Search",
          ),
          NavigationDestination(
            selectedIcon: const Icon(IconlyBold.bag2),
            icon: Badge(
                label: Text(cartProvider.getCartItems.length.toString()),
                backgroundColor: Colors.red,
                child: const Icon(IconlyLight.bag2)),
            label: "Cart",
          ),
          const NavigationDestination(
            selectedIcon: Icon(IconlyBold.profile),
            icon: Icon(IconlyLight.profile),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}
