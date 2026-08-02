import 'package:ecommerce_self_project/model/ecommerce_model.dart';
import 'package:ecommerce_self_project/screen/admin/admin_add_product.dart';
import 'package:ecommerce_self_project/screen/admin/admin_update_product.dart';
import 'package:ecommerce_self_project/screen/admin/admins_homeScreen.dart';
import 'package:ecommerce_self_project/screen/login%20&%20registration/loginScreen.dart';
import 'package:ecommerce_self_project/screen/login%20&%20registration/registrationScreen.dart';
import 'package:ecommerce_self_project/screen/product_display.dart';
import 'package:ecommerce_self_project/screen/user/user_categoryScreen.dart';
import 'package:ecommerce_self_project/screen/user/user_mainScreen.dart';
import 'package:ecommerce_self_project/screen/user/user_profileScreen.dart';
import 'package:ecommerce_self_project/service/shared_preferences_service.dart';
import 'package:flutter/material.dart';

void main() {
  SharedPreferencesService service = SharedPreferencesService();
  service.saveAdminData();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Registrationscreen(),
    );
  }
}
