import 'package:ecommerce_self_project/screen/login%20&%20registration/loginScreen.dart';
import 'package:ecommerce_self_project/service/shared_preferences_service.dart';
import 'package:flutter/material.dart';

class Registrationscreen extends StatefulWidget {
  const Registrationscreen({super.key});

  @override
  State<Registrationscreen> createState() => _Registrationscreen();
}

class _Registrationscreen extends State<Registrationscreen> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  bool see = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple,
      body: Center(
        child: Container(
          height: 500,
          width: 400,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Register Info",
                  style: TextStyle(
                    color: Colors.deepPurple,
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                  ),
                ),
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
                Align(
                  alignment: AlignmentGeometry.centerEnd,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.green,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Loginscreen(),
                          ),
                        );
                      },
                      child: Text("Already Logged-In"),
                    ),
                  ),
                ),
                SizedBox(height: 30),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple.withOpacity(0.36),
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
                      SharedPreferencesService service =
                          SharedPreferencesService();

                      await service.saveData(
                        _emailController.text.toString(),
                        _passwordController.text.toString(),
                      );

                      await service.saveLogin(true);

                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => Loginscreen()),
                      );
                  },
                  child: Text("Sign Up"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
