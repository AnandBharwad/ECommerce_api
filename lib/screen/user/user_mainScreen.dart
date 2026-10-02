import 'dart:convert';

import 'package:ecommerce_self_project/model/ecommerce_model.dart';
import 'package:ecommerce_self_project/screen/user/user_categoryScreen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UserMainscreen extends StatefulWidget {
  const UserMainscreen({super.key});

  @override
  State<UserMainscreen> createState() => _UserMainscreenState();
}

class _UserMainscreenState extends State<UserMainscreen> {
  List<EcommerceModel> products = [];

  bool isLoading = true;
  String errorMessage = "";

  int currentTabIndex = 0;

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    try {
      final response = await http.get(
        Uri.parse(
          "https://6a44f2a5aab3faec3f69164c.mockapi.io/api/studentData",
        ),
      );

      if (response.statusCode == 200) {
        final List<dynamic> decodedList = jsonDecode(response.body);

        setState(() {
          products = decodedList
              .map((item) => EcommerceModel.fromJson(item))
              .toList();

          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage =
              "Could not load products. Status Code: ${response.statusCode}";
          isLoading = false;
        });
      }
    } catch (error) {
      setState(() {
        errorMessage = "Error occurred: $error";
        isLoading = false;
      });
    }
  }

  void navigateToCategories() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const UserCategoryscreen()),
    );
  }

  Widget buildProductCard(EcommerceModel product) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      elevation: 0,
      color: colorScheme.surfaceContainer,
      margin: const EdgeInsets.only(right: 12, top: 4, bottom: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
      child: SizedBox(
        width: 150,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            SizedBox(
              height: 110,
              width: 150,
              child: Image.network(
                product.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: colorScheme.surfaceContainerLow,
                    child: Icon(
                      Icons.image_outlined,
                      color: colorScheme.onSurface.withValues(alpha: 0.45),
                    ),
                  );
                },
              ),
            ),

            // Product Details
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Row(
                    children: [
                      Icon(Icons.star, color: colorScheme.secondary, size: 14),
                      const SizedBox(width: 2),
                      Text(
                        product.rating.toString(),
                        style: TextStyle(
                          color: colorScheme.onSurface,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 4),

                  Text(
                    "₹${product.price}",
                    style: TextStyle(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildProductSection({
    required String title,
    required List<EcommerceModel> productList,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),

        const SizedBox(height: 8),

        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: productList.length,
            itemBuilder: (context, index) {
              return buildProductCard(productList[index]);
            },
          ),
        ),
      ],
    );
  }

  Widget buildCategoryItem({
    required IconData icon,
    required String title,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: Column(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: color.withValues(alpha: 0.15),
            child: Icon(icon, color: color, size: 28),
          ),

          const SizedBox(height: 4),

          Text(
            title,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,

      // App Bar
      appBar: AppBar(
        title: const Text(
          "MyShopp",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        actions: [
          // IconButton(
          //   icon: const Icon(Icons.shopping_cart_outlined),
          //   onPressed: () {},
          // ),
        ],
      ),

      // Body
      body: isLoading
          ? Center(child: CircularProgressIndicator(color: colorScheme.primary))
          : errorMessage.isNotEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 48,
                      color: colorScheme.primary,
                    ),

                    const SizedBox(height: 12),

                    Text(
                      errorMessage,
                      style: TextStyle(color: colorScheme.onSurface),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 16),

                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          isLoading = true;
                          errorMessage = "";
                        });

                        fetchProducts();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorScheme.primary,
                        foregroundColor: colorScheme.onPrimary,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text("Try Again"),
                    ),
                  ],
                ),
              ),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Promo Banner
                    Container(
                      height: 140,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: colorScheme.primary,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Center(
                        child: Text(
                          "50% Special Sale Offer!",
                          style: TextStyle(
                            color: colorScheme.onPrimary,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Categories Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Categories",
                          style: TextStyle(
                            color: colorScheme.onSurface,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),

                        TextButton(
                          onPressed: navigateToCategories,
                          child: Text(
                            "View All",
                            style: TextStyle(
                              color: colorScheme.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    // Categories
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          buildCategoryItem(
                            icon: Icons.phone_android,
                            title: "Mobiles",
                            color: colorScheme.primary,
                          ),

                          buildCategoryItem(
                            icon: Icons.laptop,
                            title: "Laptop",
                            color: colorScheme.secondary,
                          ),

                          buildCategoryItem(
                            icon: Icons.headphones,
                            title: "Headphone",
                            color: colorScheme.primary,
                          ),

                          buildCategoryItem(
                            icon: Icons.watch,
                            title: "SmartWatch",
                            color: colorScheme.secondary,
                          ),

                          buildCategoryItem(
                            icon: Icons.games_outlined,
                            title: "GamePad",
                            color: colorScheme.primary,
                          ),

                          GestureDetector(
                            onTap: navigateToCategories,
                            child: buildCategoryItem(
                              icon: Icons.arrow_forward,
                              title: "More",
                              color: colorScheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Flash Sale
                    buildProductSection(
                      title: "Flash Sale 🔥",
                      productList: products,
                    ),

                    const SizedBox(height: 24),

                    // Best Selling
                    buildProductSection(
                      title: "Best Selling 🌟",
                      productList: products.reversed.toList(),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
