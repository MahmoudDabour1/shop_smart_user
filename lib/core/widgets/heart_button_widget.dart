import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';
import 'package:shop_smart_user/core/widgets/error_methods_widget.dart';
import 'package:shop_smart_user/inner_screens/wish_list/presentation/controller/provider.dart';

class HeartButtonWidget extends StatefulWidget {
  const HeartButtonWidget({
    super.key,
    this.size = 24,
    this.color = Colors.transparent,
    required this.productId,
  });

  final double size;
  final Color color;
  final String productId;

  @override
  State<HeartButtonWidget> createState() => _HeartButtonWidgetState();
}

class _HeartButtonWidgetState extends State<HeartButtonWidget> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final wishListProvider = Provider.of<WishListProvider>(context);
    return Material(
      color: widget.color,
      shape: const CircleBorder(),
      child: IconButton(
        style: IconButton.styleFrom(
          shape: const CircleBorder(),
        ),
        onPressed: () async {
          // wishListProvider.addOrRemoveProductToWishList(
          //   productId: widget.productId,
          // );

          setState(() {
            isLoading = true;
          });
          try {
            if (wishListProvider.getWishListItems
                .containsKey(widget.productId)) {
              wishListProvider.removeWishListItemFromFirebase(
                wishListId:
                    wishListProvider.getWishListItems[widget.productId]!.id,
                productId: widget.productId,
              );
            } else {
              wishListProvider.addToWishListFirebase(
                productId: widget.productId,
                context: context,
              );
            }
            await wishListProvider.fetchWishList();
          } catch (error) {
            MyAppErrorMethods.showErrorOrWarningDialog(
              context: context,
              title: error.toString(),
              fct: () {},
            );
          } finally {
            setState(() {
              isLoading = false;
            });
          }
        },
        icon: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Icon(
                wishListProvider.isProductInWishList(
                        productId: widget.productId)
                    ? IconlyBold.heart
                    : IconlyLight.heart,
                size: widget.size,
                color: wishListProvider.isProductInWishList(
                        productId: widget.productId)
                    ? Colors.red
                    : Colors.grey,
              ),
      ),
    );
  }
}
