import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_smart_user/core/resources/assets_manager.dart';
import 'package:shop_smart_user/core/widgets/empty_bag_widget.dart';
import 'package:shop_smart_user/home/presentation/screens/home_screen.dart';
import 'package:shop_smart_user/products_details/data/models/products_model.dart';
import 'package:shop_smart_user/products_details/presentation/controller/provider.dart';
import 'package:shop_smart_user/core/widgets/text_form_widget.dart';
import '../../../products_details/presentation/widgets/products_widget.dart';

class SearchScreen extends StatefulWidget {
  static const routeName = '/SearchScreen';

  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<ProductModel> productListSearch = [];

  late TextEditingController searchController;

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    String? passedCategory =
        ModalRoute.of(context)!.settings.arguments as String?;
    final List<ProductModel> productList = passedCategory == null
        ? productProvider.getProducts
        : productProvider.findByCategory(category: passedCategory);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text(
            passedCategory ?? "Store Products",
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          ),
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(AssetsManager.shoppingCart),
          ),
        ),
        body: StreamBuilder<List<ProductModel>>(
          stream: productProvider.fetchProductsStream(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text(
                  snapshot.error.toString(),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            }else if (snapshot.data == null) {
              return const Center(
                child: Text(
                  "No products has been added",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            }
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  const SizedBox(
                    height: 15,
                  ),
                  CustomTextFormWidget(
                    function: () {
                      setState(() {
                        productListSearch = productProvider.searchQuery(
                          searchText: searchController.text,
                          passedList: productList,
                        );
                      });
                    },
                    onTap: () {
                      setState(() {
                        searchController.clear();
                        passedCategory == null;
                        FocusScope.of(context).unfocus();
                      });
                    },
                    controller: searchController,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  if (productListSearch.isEmpty &&
                      searchController.text.isNotEmpty) ...[
                    const Center(
                      child: Text(
                        "No results found",
                        style: TextStyle(fontSize: 40),
                      ),
                    ),
                  ],
                  Expanded(
                    child: productList.isEmpty
                        ? SingleChildScrollView(
                            child: EmptyBagWidget(
                                imagePath: AssetsManager.orderBag,
                                text: "No Items Found",
                                subText: "Select Another Category",
                                buttonText: "Shop Now",
                                function: () {
                                  Navigator.pushNamed(
                                    context,
                                    HomeScreen.routeName,
                                  );
                                }),
                          )
                        : DynamicHeightGridView(
                            itemCount: searchController.text.isNotEmpty
                                ? productListSearch.length
                                : productList.length,
                            crossAxisCount: 2,
                            builder: (context, index) {
                              return ChangeNotifierProvider.value(
                                value: productList[index],
                                child: ProductsWidget(
                                    productId: searchController.text.isNotEmpty
                                        ? productListSearch[index].productId
                                        : productList[index].productId),
                              );
                            },
                          ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
