import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';

class LoaddataService {
  Future<List<dynamic>> loadProduct() async {
    final jsonString = await rootBundle.loadString("assets/products.json");

    return jsonDecode(jsonString);
  }

  Future<void> uploadProducts() async {
    final products = await loadProduct();

    // Map each product to an http.post Future
    final uploadFutures = products.map((product) {
      return http.post(
        Uri.parse(
          "https://6a44f2a5aab3faec3f69164c.mockapi.io/api/studentData",
        ),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(product),
      );
    });

    // Wait for all upload futures to complete in parallel
    await Future.wait(uploadFutures);
    print("All products are uploaded");
  }

  Future<void> seedDatabase() async {
    final response = await http.get(
      Uri.parse("https://6a44f2a5aab3faec3f69164c.mockapi.io/api/studentData"),
    );

    final data = jsonDecode(response.body);

    if (data.isNotEmpty) {
      print("Database already contain data");
      return;
    } else {
      await uploadProducts();
    }
  }
}


/*
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';

class LoaddataService {
  Future<List<dynamic>> loadProduct() async {
    final jsonString = await rootBundle.loadString("assets/products.json");
    return jsonDecode(jsonString);
  }

  Future<void> uploadProducts() async {
    final products = await loadProduct();

    // Map each product to an http.post Future
    final uploadFutures = products.map((product) {
      return http.post(
        Uri.parse(
          "https://6a44f2a5aab3faec3f69164c.mockapi.io/api/studentData",
        ),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(product),
      );
    });

    // Wait for all upload futures to complete in parallel
    await Future.wait(uploadFutures);
    print("All products are uploaded");
  }

  Future<void> seedDatabase() async {
    final response = await http.get(
      Uri.parse("https://6a44f2a5aab3faec3f69164c.mockapi.io/api/studentData"),
    );

    final data = jsonDecode(response.body);

    if (data.isNotEmpty) {
      print("Database already contain data");
      return;
    } else {
      await uploadProducts();
    }
  }
}

*/