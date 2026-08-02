import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ecommerce_self_project/model/ecommerce_model.dart';

class UserCategoryscreen extends StatefulWidget {
  const UserCategoryscreen({super.key});

  @override
  State<UserCategoryscreen> createState() => _UserCategoryscreenState();
}

class _UserCategoryscreenState extends State<UserCategoryscreen> {
  // Simple lists to store our data
  List<EcommerceModel> allProducts = [];
  List<EcommerceModel> displayedProducts = [];

  // Track selected category state (Starts with "All")
  String selectedCategory = "All";

  // State control variables
  bool isLoading = true;
  String errorMessage = "";

  // The categories list we want to filter by
  final List<String> categories = [
    "All",
    "Mobiles",
    "Fashion",
    "Electronics",
    "Home",
    "Beauty",
  ];

  @override
  void initState() {
    super.initState();
    // Fetch products list on screen startup
    fetchProducts();
  }

  // Fetch product list directly from API
  Future<void> fetchProducts() async {
    try {
      final response = await http.get(
        Uri.parse(
          "https://6a44f2a5aab3faec3f69164c.mockapi.io/api/studentData",
        ),
      );

      if (response.statusCode == 200) {
        List<dynamic> decodedList = jsonDecode(response.body);

        setState(() {
          // Convert decoded JSON list to EcommerceModel list
          allProducts = decodedList
              .map((item) => EcommerceModel.fromJson(item))
              .toList();
          // Initially show all products
          displayedProducts = allProducts;
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

  // Filter products when a category tab is clicked
  void filterByCategory(String categoryName) {
    setState(() {
      selectedCategory = categoryName;
      if (categoryName == "All") {
        displayedProducts = allProducts;
      } else {
        // Find products matching selected category (case-insensitive)
        displayedProducts = allProducts.where((product) {
          return product.category.toLowerCase() == categoryName.toLowerCase();
        }).toList();
      }
    });
  }

  // Builder for individual product cards in the grid
  Widget productGridCard(EcommerceModel product) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image widget with network error loading handling
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
              child: Image.network(
                product.imageUrl,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[200],
                    child: const Icon(
                      Icons.image,
                      color: Colors.grey,
                      size: 40,
                    ),
                  );
                },
              ),
            ),
          ),
          // Product Details
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      product.category,
                      style: TextStyle(color: Colors.grey[600], fontSize: 11),
                    ),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 12),
                        Text(
                          product.rating.toString(),
                          style: const TextStyle(fontSize: 11),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  "₹${product.price}",
                  style: const TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
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
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          "Categories",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator()) // Loading State UI
          : errorMessage.isNotEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      errorMessage,
                      style: const TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          isLoading = true;
                          errorMessage = "";
                        });
                        fetchProducts();
                      },
                      child: const Text("Retry"),
                    ),
                  ],
                ),
              ),
            )
          : Column(
              children: [
                // 1. Horizontal Category Tabs Scroll Area
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    vertical: 8.0,
                    horizontal: 4.0,
                  ),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: categories.map((categoryName) {
                        final bool isSelected =
                            categoryName == selectedCategory;
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6.0),
                          child: ChoiceChip(
                            label: Text(categoryName),
                            selected: isSelected,
                            selectedColor: Colors.deepPurple,
                            labelStyle: TextStyle(
                              color: isSelected ? Colors.white : Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                            onSelected: (bool selected) {
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
                const SizedBox(height: 8),

                // 2. Product Grid Section
                Expanded(
                  child: displayedProducts.isEmpty
                      ? const Center(
                          child: Text(
                            "No products found in this category",
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2, // 2 items per row
                                  childAspectRatio:
                                      0.8, // Adjust scale of items
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
}
