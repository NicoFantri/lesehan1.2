import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../theme/app_colors.dart';
import 'home_view.dart';  // Import HomeView
import 'admin_dashboard.dart'; // Import AdminDashboard

class LoginView extends StatefulWidget {
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final AuthController authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Register',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                SizedBox(height: 40),
                // Email Input
                TextField(
                  controller: authController.emailController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.email, color: AppColors.primary),
                    hintText: 'Email',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                SizedBox(height: 16),
                // Username Input
                TextField(
                  controller: authController.usernameController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.person, color: AppColors.primary),
                    hintText: 'Username',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                SizedBox(height: 16),
                // Password Input
                TextField(
                  controller: authController.passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.lock, color: AppColors.primary),
                    hintText: 'Password',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                SizedBox(height: 24),
                Text(
                  'Register As:',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildRoleButton(
                      text: 'User',
                      icon: Icons.person_outline,
                      onTap: () => _registerAndRedirect('user'),
                      color: Colors.blue,
                    ),
                    SizedBox(width: 20),
                    _buildRoleButton(
                      text: 'Admin',
                      icon: Icons.admin_panel_settings,
                      onTap: () => _registerAndRedirect('admin'),
                      color: Colors.orange,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRoleButton({
    required String text,
    required IconData icon,
    required VoidCallback onTap,
    required Color color,
  }) {
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: Icon(icon),
      label: Text(text),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  // Fungsi untuk mendaftar dan mengarahkan berdasarkan peran
  void _registerAndRedirect(String role) async {
    final String username = authController.usernameController.text.trim();
    final String password = authController.passwordController.text.trim();
    final String email = authController.emailController.text.trim();

    if (username.isEmpty || password.isEmpty || email.isEmpty) {
      // Jika username, password, atau email kosong
      Get.snackbar('Error', 'Please fill in all fields',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    // Melakukan pendaftaran
    await authController.register(
      username: username,
      email: email,
      password: password,
      role: role,
    );

    // Setelah berhasil, arahkan ke halaman sesuai peran
    if (role == 'user') {
      Get.offAll(() => HomeView());  // Redirect ke HomeView untuk User
    } else if (role == 'admin') {
      Get.offAll(() => AdminDashboardView());  // Redirect ke AdminDashboard untuk Admin
    }
  }
}
