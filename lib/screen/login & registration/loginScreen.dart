import 'package:ecommerce_self_project/screen/admin/admins_homeScreen.dart';
import 'package:ecommerce_self_project/screen/user/bottomnavScreen.dart';
import 'package:ecommerce_self_project/screen/user/user_mainScreen.dart';
import 'package:ecommerce_self_project/service/shared_preferences_service.dart';
import 'package:flutter/material.dart';

class Loginscreen extends StatefulWidget {
  const Loginscreen({super.key});

  @override
  State<Loginscreen> createState() => _Loginscreen();
}

class _Loginscreen extends State<Loginscreen> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool see = false;
  bool loginAsAdmin = true;

  void changeLoginUser() {
    setState(() {
      loginAsAdmin = !loginAsAdmin;
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: Center(
        child: Container(
          height: 520,
          width: 400,
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainer,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Login",
                  style: TextStyle(
                    color: theme.colorScheme.onSurface,
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                Card(
                  elevation: 2.5,
                  child: TextButton(
                    onPressed: () {
                      changeLoginUser();
                    },
                    child: loginAsAdmin ? Text("As Admin") : Text("As User"),
                  ),
                ),
                Text("Click to change", style: TextStyle(fontSize: 10)),
                SizedBox(height: 45),

                Padding(
                  padding: const EdgeInsets.all(10),
                  child: TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      hintText: "Enter Your Name",
                      labelText: "Name",
                      prefixIcon: Icon(Icons.person),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextField(
                    controller: _passwordController,
                    obscureText: see,
                    obscuringCharacter: "*",
                    decoration: InputDecoration(
                      hintText: "Enter Password",
                      labelText: "Password",
                      prefixIcon: Icon(Icons.password),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            see = !see;
                          });
                        },
                        icon: see
                            ? Icon(Icons.visibility_off)
                            : Icon(Icons.visibility),
                      ),

                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 30),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary.withOpacity(
                      0.88,
                    ),
                    foregroundColor: Colors.white,
                    fixedSize: Size(160, 40),
                    elevation: 6,
                    shadowColor: Colors.black,

                    textStyle: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () async {
                    final service = SharedPreferencesService();
                    final String inputName = _emailController.text.trim();
                    final String inputPassword = _passwordController.text
                        .trim();

                    String? expectedName;
                    String? expectedPassword;

                    if (loginAsAdmin) {
                      final (adminName, adminPassword) = await service
                          .getAdminData();
                      expectedName = adminName;
                      expectedPassword = adminPassword;
                    } else {
                      expectedName = await service.getUserName();
                      expectedPassword = await service.getPassword();
                    }

                    if (inputName == expectedName &&
                        inputPassword == expectedPassword) {
                      await service.saveLogin(true);

                      // if (!mounted) return;

                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => loginAsAdmin
                              ? const AdminHomeScreen() // Opens Admin Panel
                              : const Bottomnavscreen(), // Opens User Panel
                        ),
                      );
                    } else {
                      // if (!mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Invalid Username or Password"),
                          backgroundColor: Colors.redAccent,
                        ),
                      );
                    }
                  },
                  child: Text("Login"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
