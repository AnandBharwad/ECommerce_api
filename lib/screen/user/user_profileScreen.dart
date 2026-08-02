import 'package:ecommerce_self_project/service/shared_preferences_service.dart';
import 'package:flutter/material.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final SharedPreferencesService _service = SharedPreferencesService();

  String _userName = "Loading...";
  String _userPassword = "Loading..."; // Renamed from email to match your data
  bool _isLoading = true;

  @override
  void initState() {
    _loadUserData();
    super.initState();
  }

  Future<void> _loadUserData() async {
    try {
      String? name = await _service.getUserName();
      // 1. Corrected: Fetch the password instead of reading the name twice
      String? password = await _service.getPassword(); 

      if (!mounted) return;

      setState(() {
        _userName = name ?? "No Name Found";
        _userPassword = password ?? "No Password Found";
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("User Profile"),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Colors.deepPurple),
            )
          : Padding(
              padding: const EdgeInsets.all(20.0),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    const CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.deepPurple,
                      child: Icon(Icons.person, size: 55, color: Colors.white),
                    ),
                    const SizedBox(height: 30),

                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        leading: const Icon(
                          Icons.account_circle,
                          color: Colors.deepPurple,
                        ),
                        title: const Text(
                          "Name",
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          _userName,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),

                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        leading: const Icon(
                          Icons.lock, // Changed icon to lock for password
                          color: Colors.deepPurple,
                        ),
                        title: const Text(
                          "Password", // 2. Renamed title label from Email to Password
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          // Masking the password text for standard privacy
                          _userPassword.length > 2 
                              ? "*" * _userPassword.length 
                              : _userPassword,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 40),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(180, 45),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () async {
                        await _service.saveLogin(false);
                        
                        // 3. Added missing safety check before navigating
                        if (!mounted) return; 
                        
                        Navigator.of(context).popUntil((route) => route.isFirst);
                      },
                      icon: const Icon(Icons.logout),
                      label: const Text("Log Out"),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
