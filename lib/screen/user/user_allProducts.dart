import 'package:flutter/material.dart';

class UserAllproducts extends StatefulWidget {
  const UserAllproducts({super.key});

  @override
  State<UserAllproducts> createState() => _UserAllproductsState();
}

class _UserAllproductsState extends State<UserAllproducts> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("All {Category name}")),
      body: SafeArea(
        child: Column(
          children: [
            // SegmentedButton(segments: List , selected: selected);
          ],
        ),
      ),
    );
  }
}
