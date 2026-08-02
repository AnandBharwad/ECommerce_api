import 'dart:convert';

import 'package:ecommerce_self_project/model/ecommerce_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AdminUpdateProduct extends StatefulWidget {
  final EcommerceModel emodel;

  const AdminUpdateProduct({super.key, required this.emodel});

  @override
  State<AdminUpdateProduct> createState() => _AdminUpdateProductState();
}

class _AdminUpdateProductState extends State<AdminUpdateProduct> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _productName = TextEditingController();
  final TextEditingController _productPrice = TextEditingController();
  final TextEditingController _productDescription = TextEditingController();
  final TextEditingController _productImageUrl = TextEditingController();
  final TextEditingController _productRating = TextEditingController();
  final TextEditingController _productCategory = TextEditingController();

  @override
  void initState() {
    super.initState();

    _productName.text = widget.emodel.name;
    _productPrice.text = widget.emodel.price.toString();
    _productDescription.text = widget.emodel.description;
    _productImageUrl.text = widget.emodel.imageUrl;
    _productRating.text = widget.emodel.rating.toString();
    _productCategory.text = widget.emodel.category;
  }

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

  Future<void> updateProduct() async {
    final response = await http.put(
      Uri.parse(
        "https://6a44f2a5aab3faec3f69164c.mockapi.io/api/studentData/${widget.emodel.id}",
      ),
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

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Product updated successfully")),
      );

      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Update Failed : ${response.statusCode}")),
      );
    }
  }

  InputDecoration inputDecoration(String label, String hint, IconData icon) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      icon: Icon(icon, color: Colors.deepPurple),
      border: const OutlineInputBorder(),
      enabledBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.black, width: 1.5),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Update Product",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Form(
          key: _formKey,
          child: Column(
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

              const SizedBox(height: 12),

              TextFormField(
                controller: _productPrice,
                keyboardType: TextInputType.number,
                decoration: inputDecoration(
                  "Price",
                  "Enter Product Price",
                  Icons.currency_rupee_sharp,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter price";
                  }

                  if (int.tryParse(value) == null) {
                    return "Enter valid price";
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
                    return "Please enter image url";
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
                  if (value == null || value.isEmpty) {
                    return "Please enter rating";
                  }

                  if (num.tryParse(value) == null) {
                    return "Enter valid rating";
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
                      await updateProduct();
                    }
                  },
                  child: const Text("Update Product"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
