import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:responsive_framework/responsive_framework.dart';
import 'package:rive/rive.dart';

import '../controllers/item_controller.dart';
import '../controllers/my_animation_controller.dart';
import '../controllers/validate_form_controller.dart';
import '../models/item_model.dart';
import '../services/print_itens.dart';
import 'components/item_dialog.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final _itemController = Get.find<ItemController>();
  final _validateFormController = Get.find<ValidateFormController>();
  final _myAnimationController = Get.find<MyAnimationController>();

  @override
  Widget build(BuildContext context) {
    _itemController.getItems();
    return Obx(() {
      if (_myAnimationController.isAnimationVisible.value) {
        return Stack(children: [
          Positioned.fill(
            child: GestureDetector(
              onTap: _myAnimationController.toggleAnimation,
              child: Container(
                width: Get.width,
                height: Get.height,
                color: const Color(0xFF313131),
                child: RiveAnimation.asset(
                  'assets/rive/added_to_list.riv',
                  fit: BoxFit.contain,
                  controllers: [
                    SimpleAnimation(
                      'writing',
                      autoplay: true,
                    )
                  ],
                ),
              ),
            ),
          ),
        ]);
      }
      return Scaffold(
        appBar: AppBar(
          title: const Text('Lista de Compras'),
          centerTitle: true,
          backgroundColor: Colors.blueGrey,
          foregroundColor: Colors.white,
          actions: [
            _itemController.items.isNotEmpty
                ? IconButton(
                    onPressed: () => PrintItens.generatePdfAndPrint(),
                    icon: const Icon(Icons.print),
                  )
                : IconButton(
                    onPressed: () => Get.showSnackbar(
                      const GetSnackBar(
                        messageText: Text(
                          'Adicione itens à lista para imprimir.',
                          style: TextStyle(color: Colors.white),
                        ),
                        duration: Duration(milliseconds: 1500),
                      ),
                    ),
                    icon: const Icon(Icons.print_disabled),
                  )
          ],
        ),
        body: Obx(
          () {
            if (!_itemController.loading.value) {
              return const Center(child: CircularProgressIndicator());
            }

            return _itemController.items.isEmpty
                ? const Center(
                    child: Text('Seus itens adicionados aparecerão aqui'))
                : Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: ResponsiveBreakpoints.of(context)
                                .smallerThan(DESKTOP)
                            ? 0
                            : 200),
                    child: ListView.builder(
                      itemBuilder: (BuildContext context, index) {
                        final ItemModel currentItem =
                            _itemController.items[index];

                        var itemStatus = currentItem.status;

                        return ListTile(
                          shape: const Border(
                              bottom: BorderSide(color: Colors.grey)),
                          title: Text(
                            currentItem.name,
                            style: TextStyle(
                              overflow: TextOverflow.ellipsis,
                              decoration: itemStatus == 1
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                            ),
                          ),
                          subtitle: Text(
                            'Quantidade: ${currentItem.quantity}',
                            style: TextStyle(
                              decoration: itemStatus == 1
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                            ),
                          ),
                          leading: IconButton(
                            onPressed: () =>
                                _itemController.toggleItemStatus(currentItem),
                            icon: Icon(
                              itemStatus == 1
                                  ? Icons.check_box
                                  : Icons.check_box_outline_blank,
                            ),
                          ),
                          trailing: SizedBox(
                            width: 100,
                            child: Row(
                              children: [
                                IconButton(
                                  onPressed: () => ItemDialog.showDialog(
                                    dialogTitle: 'Editar Item',
                                    item: currentItem,
                                  ),
                                  icon: const Icon(Icons.edit),
                                ),
                                IconButton(
                                  onPressed: () => Get.defaultDialog(
                                    title: '',
                                    titlePadding: EdgeInsets.zero,
                                    content: Text(
                                        'Tem certeza que deseja excluir o item: ${currentItem.name}'),
                                    onConfirm: () {
                                      _itemController
                                          .deleteItem(currentItem.id);
                                      Get.back();
                                    },
                                    textConfirm: 'Excluir',
                                    cancelTextColor: Colors.green,
                                    confirmTextColor: Colors.red,
                                    buttonColor: Colors.transparent,
                                    textCancel: 'Cancelar',
                                  ),
                                  icon: const Icon(Icons.delete_outline),
                                  style: IconButton.styleFrom(
                                      foregroundColor: Colors.red),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      itemCount: _itemController.items.length,
                    ),
                  );
          },
        ),
        floatingActionButton: !_myAnimationController.isAnimationVisible.value
            ? FloatingActionButton(
                onPressed: () {
                  _validateFormController.nameEditingController.text = '';
                  _validateFormController.quantityEditingController.text = '';

                  ItemDialog.showDialog();
                },
                backgroundColor: Colors.blueGrey,
                foregroundColor: Colors.white,
                child: const Icon(Icons.add),
              )
            : const SizedBox(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      );
    });
  }
}
