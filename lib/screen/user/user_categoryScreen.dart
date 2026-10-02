import 'dart:convert';

import 'package:ecommerce_self_project/model/ecommerce_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UserCategoryscreen extends StatefulWidget {
  const UserCategoryscreen({super.key});

  @override
  State<UserCategoryscreen> createState() => _UserCategoryscreenState();
}

class _UserCategoryscreenState extends State<UserCategoryscreen> {
  // Product Data
  List<EcommerceModel> allProducts = [];
  List<EcommerceModel> displayedProducts = [];

  // Category State
  String selectedCategory = "All";

  // UI State
  bool isLoading = true;
  String errorMessage = "";

  // Available Categories
  List<String> categories = ["All"];

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  // Fetch Products
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
          allProducts = decodedList
              .map((item) => EcommerceModel.fromJson(item))
              .toList();

          displayedProducts = allProducts;

          final dynamicCategories = allProducts
              .map((p) => p.category.trim())
              .where((c) => c.isNotEmpty)
              .toSet()
              .toList();

          categories = ["All", ...dynamicCategories];

          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = "Failed to load products: ${response.statusCode}";
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = "Error occurred: $e";
        isLoading = false;
      });
    }
  }

  // Filter Products By Category
  void filterByCategory(String categoryName) {
    setState(() {
      selectedCategory = categoryName;

      if (categoryName == "All") {
        displayedProducts = allProducts;
      } else {
        displayedProducts = allProducts.where((product) {
          return product.category.toLowerCase() == categoryName.toLowerCase();
        }).toList();
      }
    });
  }

  // Product Card
  Widget productGridCard(EcommerceModel product) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      elevation: 0,
      color: colorScheme.surfaceContainer,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Image
          Expanded(
            child: Image.network(
              product.imageUrl,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: double.infinity,
                  color: colorScheme.surfaceContainerLow,
                  child: Icon(
                    Icons.image_outlined,
                    color: colorScheme.onSurface.withValues(alpha: 0.45),
                    size: 40,
                  ),
                );
              },
            ),
          ),

          // Product Details
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Name
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

                // Category & Rating
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        product.category,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: colorScheme.onSurface.withValues(alpha: 0.6),
                          fontSize: 11,
                        ),
                      ),
                    ),

                    const SizedBox(width: 6),

                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.star,
                          color: colorScheme.secondary,
                          size: 13,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          product.rating.toString(),
                          style: TextStyle(
                            color: colorScheme.onSurface,
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 6),

                // Product Price
                Text(
                  "₹${product.price}",
                  style: TextStyle(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
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
          "Categories",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),

      body: isLoading
          ? Center(child: CircularProgressIndicator(color: colorScheme.primary))
          : errorMessage.isNotEmpty
          ? _buildErrorState(colorScheme)
          : Column(
              children: [
                // Category Tabs
                Container(
                  color: colorScheme.surface,
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 4,
                  ),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: categories.map((categoryName) {
                        final bool isSelected =
                            categoryName == selectedCategory;

                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: ChoiceChip(
                            label: Text(categoryName),
                            selected: isSelected,
                            selectedColor: colorScheme.primary,
                            backgroundColor: colorScheme.surfaceContainer,
                            labelStyle: TextStyle(
                              color: isSelected
                                  ? colorScheme.onPrimary
                                  : colorScheme.onSurface,
                              fontWeight: FontWeight.w600,
                            ),
                            side: BorderSide.none,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            onSelected: (selected) {
                              if (selected) {
                                filterByCategory(categoryName);
                              }
                            },
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),

                const SizedBox(height: 4),

                // Product Grid
                Expanded(
                  child: displayedProducts.isEmpty
                      ? _buildEmptyState(colorScheme)
                      : Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: GridView.builder(
                            padding: const EdgeInsets.only(top: 6, bottom: 16),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 0.8,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10,
                                ),
                            itemCount: displayedProducts.length,
                            itemBuilder: (context, index) {
                              return productGridCard(displayedProducts[index]);
                            },
                          ),
                        ),
                ),
              ],
            ),
    );
  }

  Widget _buildErrorState(ColorScheme colorScheme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 48, color: colorScheme.primary),
            const SizedBox(height: 12),
            Text(
              errorMessage,
              textAlign: TextAlign.center,
              style: TextStyle(color: colorScheme.onSurface, fontSize: 15),
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
              child: const Text("Retry"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(ColorScheme colorScheme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inventory_2_outlined,
            size: 48,
            color: colorScheme.onSurface.withValues(alpha: 0.45),
          ),
          const SizedBox(height: 12),
          Text(
            "No products found in this category",
            style: TextStyle(
              color: colorScheme.onSurface.withValues(alpha: 0.65),
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
