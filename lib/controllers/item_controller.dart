import 'package:get/get.dart';

import '../db/database_helper.dart';
import '../models/item_model.dart';

class ItemController extends GetxController {
  var items = <ItemModel>[].obs;

  final DatabaseHelper _dbHelper = DatabaseHelper();

  // final tempDb = TempDb();

  var loading = false.obs;

  @override
  void onInit() async {
    super.onInit();
    await getItems();
  }

  Future<void> getItems() async {
    loading.value = false;
    final data = await _dbHelper.getItems();
    items.assignAll(data);
    loading.value = true;
  }

  void toggleItemStatus(ItemModel item) {
    item.status = item.status == 1 ? 0 : 1;
    _dbHelper.updateItem(item);
    items.refresh();
  }

  Future<void> addItem(String name, int quantity) async {
    final item = ItemModel(
      name: name,
      quantity: quantity,
      status: 0,
    );

    await _dbHelper.insertItem(item);
    getItems();
  }

  Future<void> updateItem(ItemModel item, int index) async {
    await _dbHelper.updateItem(item);
    getItems();
  }

  Future<void> deleteItem(int? id) async {
    if (id != null) {
      await _dbHelper.deleteItem(id);
    }
    getItems();
  }
}
