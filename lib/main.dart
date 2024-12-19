import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'app/modules/home/controllers/order_controller.dart';
import 'app/routes/app_pages.dart';
import 'firebase_options.dart'; // Make sure to generate this

void main() async {
  Get.put(OrderController());
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'lesehan bu dewi',
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    );
  }
}