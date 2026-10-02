import 'package:ecommerce_self_project/screen/admin/admins_homeScreen.dart';
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
  String _userPassword = "Loading...";
  bool _isLoading = true;
  bool _isAdmin = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      String? name = await _service.getUserName();
      String? password = await _service.getPassword();
      bool isAdmin = false;

      if (name == null || name.isEmpty) {
        final (adminName, adminPassword) = await _service.getAdminData();
        if (adminName != null && adminName.isNotEmpty) {
          name = adminName;
          password = adminPassword;
          isAdmin = true;
        }
      }

      if (!mounted) return;

      setState(() {
        _userName = name ?? "No Name Found";
        _userPassword = password ?? "No Password Found";
        _isAdmin = isAdmin;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget _buildProfileInfoCard({
    required IconData icon,
    required String title,
    required String value,
    required ColorScheme colorScheme,
  }) {
    return Card(
      elevation: 0,
      color: colorScheme.surfaceContainer,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: colorScheme.primary.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: colorScheme.primary),
            ),

            const SizedBox(width: 14),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: colorScheme.onSurface.withValues(alpha: 0.60),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    value,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: colorScheme.onSurface,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,

      // App Bar
      appBar: AppBar(
        title: const Text(
          "Profile",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),

      // Body
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: colorScheme.primary))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const SizedBox(height: 12),

                  // Profile Avatar
                  Container(
                    width: 104,
                    height: 104,
                    decoration: BoxDecoration(
                      color: colorScheme.primary,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: colorScheme.primary.withValues(alpha: 0.20),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.person_outline,
                      size: 56,
                      color: colorScheme.onPrimary,
                    ),
                  ),

                  const SizedBox(height: 16),

                  Text(
                    _userName,
                    style: TextStyle(
                      color: colorScheme.onSurface,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    _isAdmin
                        ? "Administrator (Preview Mode)"
                        : "Customer Account",
                    style: TextStyle(
                      color: _isAdmin
                          ? colorScheme.primary
                          : colorScheme.onSurface.withValues(alpha: 0.55),
                      fontSize: 13,
                      fontWeight: _isAdmin
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Name
                  _buildProfileInfoCard(
                    icon: Icons.account_circle_outlined,
                    title: "Name",
                    value: _userName,
                    colorScheme: colorScheme,
                  ),

                  const SizedBox(height: 14),

                  // Password
                  _buildProfileInfoCard(
                    icon: Icons.lock_outline,
                    title: "Password",
                    value: "*" * _userPassword.length,
                    colorScheme: colorScheme,
                  ),

                  const SizedBox(height: 40),

                  if (_isAdmin) ...[
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AdminHomeScreen(),
                            ),
                            (route) => false,
                          );
                        },
                        icon: const Icon(Icons.admin_panel_settings_outlined),
                        label: const Text("Back to Admin Dashboard"),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: colorScheme.primary,
                          side: BorderSide(color: colorScheme.primary),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                  // Logout Button
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        await _service.saveLogin(false);

                        if (!mounted) return;

                        Navigator.of(
                          context,
                        ).popUntil((route) => route.isFirst);
                      },
                      icon: const Icon(Icons.logout),
                      label: const Text(
                        "Log Out",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorScheme.primary,
                        foregroundColor: colorScheme.onPrimary,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
