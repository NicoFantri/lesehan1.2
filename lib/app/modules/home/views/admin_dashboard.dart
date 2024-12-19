import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import '../theme/app_colors.dart';
import '../models/food_item.dart';

class AdminDashboardView extends StatelessWidget {
  final HomeController controller = Get.put(HomeController());
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _imageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Dashboard'),
        backgroundColor: AppColors.primary,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: controller.popularItems.length,
              itemBuilder: (context, index) {
                final item = controller.popularItems[index];
                return ListTile(
                  leading: Image.asset(item.image, width: 50, height: 50),
                  title: Text(item.name),
                  subtitle: Text('Rp ${item.price.toStringAsFixed(0)}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.blue),
                        onPressed: () => _showEditDialog(item),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteItem(item),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: _showAddItemDialog,
            child: Text('Add New Item'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddItemDialog() {
    Get.defaultDialog(
      title: 'Add New Food Item',
      content: Column(
        children: [
          TextField(
            controller: _nameController,
            decoration: InputDecoration(hintText: 'Item Name'),
          ),
          TextField(
            controller: _descriptionController,
            decoration: InputDecoration(hintText: 'Description'),
          ),
          TextField(
            controller: _priceController,
            decoration: InputDecoration(hintText: 'Price'),
            keyboardType: TextInputType.number,
          ),
          TextField(
            controller: _imageController,
            decoration: InputDecoration(hintText: 'Image Path'),
          ),
        ],
      ),
      actions: [
        TextButton(
          child: Text('Cancel'),
          onPressed: () => Get.back(),
        ),
        ElevatedButton(
          child: Text('Add'),
          onPressed: () {
            final newItem = FoodItem(
              name: _nameController.text,
              description: _descriptionController.text,
              price: double.parse(_priceController.text),
              image: _imageController.text,
            );
            controller.popularItems.add(newItem);
            Get.back();
            _clearControllers();
          },
        ),
      ],
    );
  }

  void _showEditDialog(FoodItem item) {
    _nameController.text = item.name;
    _descriptionController.text = item.description;
    _priceController.text = item.price.toString();
    _imageController.text = item.image;

    Get.defaultDialog(
      title: 'Edit Food Item',
      content: Column(
        children: [
          TextField(
            controller: _nameController,
            decoration: InputDecoration(hintText: 'Item Name'),
          ),
          TextField(
            controller: _descriptionController,
            decoration: InputDecoration(hintText: 'Description'),
          ),
          TextField(
            controller: _priceController,
            decoration: InputDecoration(hintText: 'Price'),
            keyboardType: TextInputType.number,
          ),
          TextField(
            controller: _imageController,
            decoration: InputDecoration(hintText: 'Image Path'),
          ),
        ],
      ),
      actions: [
        TextButton(
          child: Text('Cancel'),
          onPressed: () => Get.back(),
        ),
        ElevatedButton(
          child: Text('Save'),
          onPressed: () {
            final index = controller.popularItems.indexOf(item);
            controller.popularItems[index] = FoodItem(
              name: _nameController.text,
              description: _descriptionController.text,
              price: double.parse(_priceController.text),
              image: _imageController.text,
            );
            Get.back();
            _clearControllers();
          },
        ),
      ],
    );
  }

  void _deleteItem(FoodItem item) {
    controller.popularItems.remove(item);
  }

  void _clearControllers() {
    _nameController.clear();
    _descriptionController.clear();
    _priceController.clear();
    _imageController.clear();
  }
}