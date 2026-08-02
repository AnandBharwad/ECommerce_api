import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddProduct extends StatefulWidget {
  const AddProduct({super.key});

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _productName = TextEditingController();
  final TextEditingController _productPrice = TextEditingController();
  final TextEditingController _productDescription = TextEditingController();
  final TextEditingController _productImageUrl = TextEditingController();
  final TextEditingController _productRating = TextEditingController();
  final TextEditingController _productCategory = TextEditingController();

  @override
  void dispose() {
    _productName.dispose();
    _productPrice.dispose();
    _productDescription.dispose();
    _productImageUrl.dispose();
    _productRating.dispose();
    _productCategory.dispose();
    super.dispose();
  }

  Future<void> addProduct() async {
    final response = await http.post(
      Uri.parse("https://6a44f2a5aab3faec3f69164c.mockapi.io/api/studentData"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "name": _productName.text,
        "price": int.parse(_productPrice.text),
        "description": _productDescription.text,
        "imageUrl": _productImageUrl.text,
        "rating": num.parse(_productRating.text),
        "category": _productCategory.text,
      }),
    );

    print(response.statusCode);
    print(response.body);

    if (response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.green,
          content: Text("Product Added Successfully"),
        ),
      );

      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text("Failde to Add Product"),
        ),
      );
    }
  }

  InputDecoration inputDecoration(String label, String hint, IconData icon) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: Icon(icon, color: Colors.deepPurple),
      filled: true,
      fillColor: Colors.grey[300],
      border: OutlineInputBorder(),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.black, width: 1.5),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Add Product",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              TextFormField(
                controller: _productName,
                decoration: inputDecoration(
                  "Product Name",
                  "Enter Product Name",
                  Icons.shopping_basket,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Please enter product name";
                  }
                  return null;
                },
              ),

              SizedBox(height: 12),

              TextFormField(
                controller: _productPrice,
                keyboardType: TextInputType.number,
                decoration: inputDecoration(
                  "Price",
                  "Enter Product Price",
                  Icons.currency_rupee_sharp,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Please enter product price";
                  }

                  if (int.tryParse(value) == null) {
                    return "Enter a valid price";
                  }

                  return null;
                },
              ),

              const SizedBox(height: 12),

              TextFormField(
                controller: _productDescription,
                maxLines: 3,
                decoration: inputDecoration(
                  "Description",
                  "Enter Product Description",
                  Icons.description,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Please enter description";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 12),

              TextFormField(
                controller: _productImageUrl,
                decoration: inputDecoration(
                  "Image URL",
                  "Enter Product Image URL",
                  Icons.link,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Please enter image URL";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 12),

              TextFormField(
                controller: _productRating,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: inputDecoration(
                  "Rating",
                  "Enter Product Rating",
                  Icons.star,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Please enter rating";
                  }

                  if (num.tryParse(value) == null) {
                    return "Enter a valid rating";
                  }

                  return null;
                },
              ),

              const SizedBox(height: 12),

              TextFormField(
                controller: _productCategory,
                decoration: inputDecoration(
                  "Category",
                  "Enter Product Category",
                  Icons.category,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Please enter category";
                  }

                  return null;
                },
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      await addProduct();
                    }
                  },
                  child: const Text("Add Product"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
