import 'dart:convert';

import 'package:ecommerce_self_project/model/ecommerce_model.dart';
import 'package:ecommerce_self_project/screen/admin/admin_add_product.dart';
import 'package:ecommerce_self_project/screen/admin/admin_update_product.dart';
import 'package:ecommerce_self_project/screen/product_display.dart';
import 'package:ecommerce_self_project/screen/user/user_mainScreen.dart';
import 'package:ecommerce_self_project/service/loadData_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  late Future<List<EcommerceModel>> _recordsFuture;
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    _recordsFuture = fetchRecords();
  }

  void _refreshRecords() {
    setState(() {
      _recordsFuture = fetchRecords();
    });
  }

  Future<List<EcommerceModel>> fetchRecords() async {
    final response = await http.get(
      Uri.parse("https://6a44f2a5aab3faec3f69164c.mockapi.io/api/studentData"),
    );
    if (response.statusCode == 200) {
      List<dynamic> dataList = jsonDecode(response.body);
      List<EcommerceModel> productList = dataList
          .map<EcommerceModel>((jsonObj) => EcommerceModel.fromJson(jsonObj))
          .toList();

      return productList;
    } else {
      throw Exception("Failed to fetch data");
    }
  }

  Future<void> deleteProduct(String id) async {
    final response = await http.delete(
      Uri.parse(
        "https://6a44f2a5aab3faec3f69164c.mockapi.io/api/studentData/$id",
      ),
      headers: {"Content-Type": "application/json"},
    );

    print(response.statusCode);
    print(response.body);

    if (response.statusCode == 200 || response.statusCode == 204) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.green,
          content: Text("Record deleted successfully"),
        ),
      );

      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text("Failde to delete product"),
        ),
      );
    }
  }
  // Future<void> deleteApiBody() async {
  //   final url = Uri.parse(
  //     'https://6a44f2a5aab3faec3f69164c.mockapi.io/api/studentData',
  //   );

  //   final response = await http.post(
  //     url,
  //     headers: {'Content-Type': 'application/json'},

  //     body: jsonEncode({}),
  //   );

  //   if (response.statusCode == 200) {
  //     print('data deleted!');
  //   }
  //   setState(() {

  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Admin",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              spacing: 9,
              children: [
                Container(
                  height: 38,
                  width: 200,
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    spacing: 6,

                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.upload, color: Colors.green),
                      TextButton(
                        onPressed: _isUploading
                            ? null
                            : () async {
                                setState(() {
                                  _isUploading = true;
                                });
                                try {
                                  await LoaddataService().seedDatabase();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        "Default data uploaded successfully!",
                                      ),
                                    ),
                                  );
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text("Failed to upload: $e"),
                                    ),
                                  );
                                } finally {
                                  setState(() {
                                    _isUploading = false;
                                  });
                                  _refreshRecords();
                                }
                              },
                        child: _isUploading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 3,
                                ),
                              )
                            : Text(
                                "Upload Default Data",
                                style: TextStyle(color: Colors.blueGrey),
                              ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 38,
                  width: 200,
                  decoration: BoxDecoration(
                    color: Colors.deepPurple.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    spacing: 6,

                    children: [
                      Icon(Icons.navigate_next, color: Colors.purple),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UserMainscreen(),
                            ),
                          );
                        },
                        child: Text(
                          "Navigate to usescreen",
                          style: TextStyle(
                            color: Colors.blueGrey,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 38,
                  width: 200,
                  decoration: BoxDecoration(
                    color: Colors.blueGrey.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    spacing: 6,
                    children: [
                      Icon(Icons.add, color: Colors.blueGrey),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddProduct(),
                            ),
                          );
                        },
                        child: Text(
                          "Add New Product",
                          style: TextStyle(color: Colors.blueGrey),
                        ),
                      ),
                    ],
                  ),
                ),

                // ElevatedButton(
                //   onPressed: () async {
                //     await deleteApiBody();
                //   },
                //   child: Text("Delete Data"),
                // ),
              ],
            ),
          ),

          Expanded(
            child: FutureBuilder<List<EcommerceModel>>(
              future: _recordsFuture,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<EcommerceModel> data = snapshot.data!;
                  if (data.isEmpty) {
                    return const Center(child: Text("No products found"));
                  }
                  return ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        child: Card(
                          elevation: 6,
                          color: const Color.fromARGB(200, 189, 189, 189),
                          shadowColor: Colors.black12,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Product Image
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: Image.network(
                                    data[index].imageUrl,
                                    height: 180,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                ),

                                const SizedBox(height: 12),

                                // Category
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.blue.shade50,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    data[index].category,
                                    style: TextStyle(
                                      color: Colors.blue.shade700,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 10),

                                // Product Name
                                Text(
                                  data[index].name,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                const SizedBox(height: 6),

                                // Description
                                Text(
                                  data[index].description,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontSize: 14,
                                  ),
                                ),

                                const SizedBox(height: 12),

                                // Rating
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                      size: 18,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      data[index].rating.toString(),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 14),

                                // Price + Button
                                Row(
                                  children: [
                                    Text(
                                      "₹${data[index].price}",
                                      style: const TextStyle(
                                        fontSize: 22,
                                        color: Colors.green,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),

                                    const Spacer(),

                                    Row(
                                      spacing: 9,
                                      children: [
                                        ElevatedButton.icon(
                                          onPressed: () {
                                            showDialog(
                                              context: context,
                                              builder: (_) => AlertDialog(
                                                title: const Text(
                                                  "Delete Product",
                                                ),
                                                content: Text(
                                                  "Are you sure you want to delete '${data[index].name}'?",
                                                ),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () =>
                                                        Navigator.pop(context),
                                                    child: Text("Cancel"),
                                                  ),
                                                  ElevatedButton(
                                                    style:
                                                        ElevatedButton.styleFrom(
                                                          backgroundColor:
                                                              Colors.red,
                                                          foregroundColor:
                                                              Colors.white,
                                                        ),
                                                    onPressed: () async {
                                                      String id =
                                                          data[index].id;

                                                      await deleteProduct(id);
                                                    },
                                                    child: Text("Delete"),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.redAccent,
                                            foregroundColor: Colors.white,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                          ),
                                          icon: const Icon(Icons.delete),
                                          label: const Text("Delete"),
                                        ),

                                        ElevatedButton.icon(
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    AdminUpdateProduct(
                                                      emodel: data[index],
                                                    ),
                                              ),
                                            );
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.green,
                                            foregroundColor: Colors.white,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                          ),
                                          icon: const Icon(Icons.edit),
                                          label: const Text("Edit"),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
