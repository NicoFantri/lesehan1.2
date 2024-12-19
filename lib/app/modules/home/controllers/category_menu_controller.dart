import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/food_item.dart';
import '../controllers/home_controller.dart';

class CategoryMenuController extends GetxController {
  final String category;
  var isLoading = true.obs;
  var categoryItems = <FoodItem>[].obs;

  CategoryMenuController(this.category);

  @override
  void onInit() {
    super.onInit();
    _fetchCategoryItems();
  }

  void _fetchCategoryItems() {
    Future.delayed(Duration(milliseconds: 500), () {
      final homeController = Get.find<HomeController>();

      categoryItems.value = homeController.popularItems.where((item) {
        switch (category) {
          case 'Nasi':
            return item.name.toLowerCase().contains('nasi');
          case 'Ayam':
            return item.name.toLowerCase().contains('ayam');
          case 'Ikan':
            return item.name.toLowerCase().contains('ikan') ||
                item.name.toLowerCase().contains('gurame') ||
                item.name.toLowerCase().contains('kakap');
          case 'Minuman':
            return item.name.toLowerCase().contains('es') ||
                item.name.toLowerCase().contains('jus') ||
                item.name.toLowerCase().contains('teh') ||
                item.name.toLowerCase().contains('kopi') ||
                item.name.toLowerCase().contains('air') ||
                item.name.toLowerCase().contains('smoothie') ||
                item.name.toLowerCase().contains('coklat');
          case 'Daging':
            return item.name.toLowerCase().contains('rawon') ||
                item.name.toLowerCase().contains('sate') ||
                item.name.toLowerCase().contains('sop') ||
                item.name.toLowerCase().contains('rendang') ||
                item.name.toLowerCase().contains('bistik') ||
                item.name.toLowerCase().contains('semur') ||
                item.name.toLowerCase().contains('tongseng') ||
                item.name.toLowerCase().contains('gulai');
          case 'Sayur':
            return item.name.toLowerCase().contains('sayur') ||
                item.name.toLowerCase().contains('gado') ||
                item.name.toLowerCase().contains('capcay');
          default:
            return false;
        }
      }).toList();

      isLoading.value = false;
    });
  }

  void addToCart(FoodItem item) {
    final homeController = Get.find<HomeController>();
    homeController.addToCart(item);
  }
}