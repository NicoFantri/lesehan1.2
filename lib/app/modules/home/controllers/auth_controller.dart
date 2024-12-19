import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final firebaseUser = Rx<User?>(null);
  final isLoading = false.obs;

  // Controllers untuk input
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    firebaseUser.bindStream(_auth.authStateChanges());
  }

  // Add email validation
  bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  // Add password validation
  String? validatePassword(String password) {
    if (password.length < 6) {
      return 'Password harus minimal 6 karakter';
    }
    if (!password.contains(RegExp(r'[A-Z]'))) {
      return 'Password harus mengandung minimal 1 huruf besar';
    }
    if (!password.contains(RegExp(r'[0-9]'))) {
      return 'Password harus mengandung minimal 1 angka';
    }
    return null;
  }

  // Register function
  Future<void> register({
    required String username,
    required String email,
    required String password,
    required String role,
  }) async {
    try {
      isLoading.value = true;

      // Validate inputs
      if (username.isEmpty || email.isEmpty || password.isEmpty) {
        throw 'Semua field harus diisi';
      }

      if (!isValidEmail(email)) {
        throw 'Format email tidak valid';
      }

      String? passwordError = validatePassword(password);
      if (passwordError != null) {
        throw passwordError;
      }

      // Create user
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Save user data to Firestore with role
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'username': username,
        'email': email,
        'createdAt': Timestamp.now(),
      });

      // Update display name
      await userCredential.user!.updateDisplayName(username);

      // Logout after registration
      await _auth.signOut();

      Get.snackbar(
        'Sukses',
        'Registrasi berhasil! Silakan login dengan email dan password yang telah didaftarkan.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );

      // Navigate to login page
      await Future.delayed(const Duration(seconds: 1));
      Get.offAllNamed('/login');

    } on FirebaseAuthException catch (e) {
      String message;
      switch (e.code) {
        case 'weak-password':
          message = 'Password terlalu lemah';
          break;
        case 'email-already-in-use':
          message = 'Email sudah terdaftar. Silakan login atau gunakan email lain.';
          break;
        case 'invalid-email':
          message = 'Format email tidak valid';
          break;
        default:
          message = 'Terjadi kesalahan saat registrasi: ${e.message}';
      }
      _showError(message);
    } catch (e) {
      _showError(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // Show error function
  void _showError(String message) {
    Get.snackbar(
      'Error',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
    );
  }
}
