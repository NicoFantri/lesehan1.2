import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppColors {
  static const Color background = Color(0xFFF5F5F5);
  static const Color primary = Color(0xFFFFA726); // Warna untuk tombol dan logo
}

class SplashView extends StatelessWidget {
  const SplashView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 3), () {
      Get.offNamed('/welcome'); // Beralih ke WelcomeView setelah 3 detik
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.restaurant_menu,
              size: 100,
              color: AppColors.primary,
            ),
            const SizedBox(height: 16),
            Text(
              'Lesehan Bu Dewi',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
