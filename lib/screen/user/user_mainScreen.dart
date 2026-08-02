import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ecommerce_self_project/model/ecommerce_model.dart';
import 'package:ecommerce_self_project/screen/user/user_categoryScreen.dart';

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
        List<dynamic> decodedList = jsonDecode(response.body);

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          "MyShopp",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        actions: [
          IconButton(icon: const Icon(Icons.shopping_cart), onPressed: () {}),
        ],
      ),

      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      errorMessage,
                      style: TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          isLoading = true;
                          errorMessage = "";
                        });
                        fetchProducts();
                      },
                      child: Text("Try Again"),
                    ),
                  ],
                ),
              ),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. Promo Banner
                    Container(
                      height: 140,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.deepPurple,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Center(
                        child: Text(
                          "50% Special Sale Offer!",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    //Categories Title & List Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Categories",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const UserCategoryscreen(),
                              ),
                            );
                          },
                          child: Text("View All"),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),

                    // Categories Row
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 16.0),
                            child: Column(
                              children: [
                                CircleAvatar(
                                  radius: 28,
                                  backgroundColor: Colors.orange.withOpacity(
                                    0.2,
                                  ),
                                  child: const Icon(
                                    Icons.phone_android,
                                    color: Colors.orange,
                                    size: 28,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                const Text(
                                  "Mobiles",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.only(right: 16.0),
                            child: Column(
                              children: [
                                CircleAvatar(
                                  radius: 28,
                                  backgroundColor: Colors.blue.withOpacity(0.2),
                                  child: const Icon(
                                    Icons.laptop,
                                    color: Colors.blue,
                                    size: 28,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                const Text(
                                  "Laptop",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 16.0),
                            child: Column(
                              children: [
                                CircleAvatar(
                                  radius: 28,
                                  backgroundColor: Colors.green.withOpacity(
                                    0.2,
                                  ),
                                  child: const Icon(
                                    Icons.headphones,
                                    color: Colors.green,
                                    size: 28,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                const Text(
                                  "Headphone",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 16.0),
                            child: Column(
                              children: [
                                CircleAvatar(
                                  radius: 28,
                                  backgroundColor: Colors.teal.withOpacity(0.2),
                                  child: const Icon(
                                    Icons.watch,
                                    color: Colors.teal,
                                    size: 28,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                const Text(
                                  "SmartWatch",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Beauty Category
                          Padding(
                            padding: const EdgeInsets.only(right: 16.0),
                            child: Column(
                              children: [
                                CircleAvatar(
                                  radius: 28,
                                  backgroundColor: Colors.red.withOpacity(0.2),
                                  child: Icon(
                                    Icons.games_outlined,
                                    color: Colors.red,
                                    size: 28,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  "GamePad",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const UserCategoryscreen(),
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(right: 16.0),
                              child: Column(
                                children: [
                                  CircleAvatar(
                                    radius: 28,
                                    backgroundColor: Colors.grey.withOpacity(
                                      0.2,
                                    ),
                                    child: const Icon(
                                      Icons.arrow_forward,
                                      color: Colors.grey,
                                      size: 28,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  const Text(
                                    "More",
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // 3. Flash Sale Section (Cards are coded entirely inline)
                    const Text(
                      "Flash Sale 🔥",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 200,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: products.length,
                        itemBuilder: (context, index) {
                          final product = products[index];
                          return Card(
                            elevation: 2,
                            margin: const EdgeInsets.only(
                              right: 12,
                              top: 4,
                              bottom: 4,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: SizedBox(
                              width: 150,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(12),
                                    ),
                                    child: Image.network(
                                      product.imageUrl,
                                      height: 110,
                                      width: 150,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                            return Container(
                                              height: 110,
                                              width: 150,
                                              color: Colors.grey[200],
                                              child: const Icon(
                                                Icons.image,
                                                color: Colors.grey,
                                              ),
                                            );
                                          },
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                          children: [
                                            const Icon(
                                              Icons.star,
                                              color: Colors.amber,
                                              size: 14,
                                            ),
                                            const SizedBox(width: 2),
                                            Text(
                                              product.rating.toString(),
                                              style: const TextStyle(
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          "₹${product.price}",
                                          style: const TextStyle(
                                            color: Colors.green,
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
                        },
                      ),
                    ),
                    const SizedBox(height: 20),

                    // 4. Best Selling Section (Cards are coded entirely inline)
                    const Text(
                      "Best Selling 🌟",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 200,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: products.reversed.toList().length,
                        itemBuilder: (context, index) {
                          List<EcommerceModel> reversedList = products.reversed
                              .toList();
                          final product = reversedList[index];
                          return Card(
                            elevation: 2,
                            margin: const EdgeInsets.only(
                              right: 12,
                              top: 4,
                              bottom: 4,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: SizedBox(
                              width: 150,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(12),
                                    ),
                                    child: Image.network(
                                      product.imageUrl,
                                      height: 110,
                                      width: 150,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                            return Container(
                                              height: 110,
                                              width: 150,
                                              color: Colors.grey[200],
                                              child: const Icon(
                                                Icons.image,
                                                color: Colors.grey,
                                              ),
                                            );
                                          },
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                          children: [
                                            const Icon(
                                              Icons.star,
                                              color: Colors.amber,
                                              size: 14,
                                            ),
                                            const SizedBox(width: 2),
                                            Text(
                                              product.rating.toString(),
                                              style: const TextStyle(
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          "₹${product.price}",
                                          style: const TextStyle(
                                            color: Colors.green,
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
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),

     
    );
  }
}
