import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/item_controller.dart';
import '../../controllers/my_animation_controller.dart';
import '../../controllers/validate_form_controller.dart';
import '../../models/item_model.dart';

class ItemDialog {
  static void showDialog({
    String dialogTitle = 'Adicionar produto',
    ItemModel? item,
  }) {
    final validateFormController = Get.find<ValidateFormController>();
    final itemController = Get.find<ItemController>();
    final riveAnimationController = Get.find<MyAnimationController>();

    validateFormController.nameEditingController.text =
        item != null ? item.name : '';
    validateFormController.quantityEditingController.text =
        item != null ? item.quantity.toString() : '';

    var statusValue = item?.status.obs;

    Get.defaultDialog(
      title: dialogTitle,
      content: Form(
        key: validateFormController.formKey,
        child: Column(
          children: [
            TextFormField(
              decoration: InputDecoration(hintText: 'Nome'),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              controller: validateFormController.nameEditingController,
              validator: (value) => validateFormController.validateName(
                  validateFormController.nameEditingController.text),
            ),
            TextFormField(
              keyboardType: TextInputType.number,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              controller: validateFormController.quantityEditingController,
              validator: (value) => validateFormController.validateQuantity(
                  validateFormController.quantityEditingController.text),
              decoration: const InputDecoration(labelText: 'Quantidade'),
            ),
            item != null
                ? Obx(() => Row(
                      children: [
                        InkWell(
                          onTap: () {
                            statusValue?.value = statusValue.value == 1 ? 0 : 1;
                          },
                          child: Row(
                            children: [
                              const Text('Comprado?'),
                              SizedBox(width: 10),
                              Icon(
                                statusValue?.value == 1
                                    ? Icons.check_box
                                    : Icons.check_box_outline_blank,
                              )
                            ],
                          ),
                        ),
                      ],
                    ))
                : const SizedBox()
          ],
        ),
      ),
      onConfirm: () async {
        if (validateFormController.submit()) {
          if (item == null) {
            await itemController.addItem(
              validateFormController.nameEditingController.text,
              int.parse(validateFormController.quantityEditingController.text),
            );
            riveAnimationController.startAnimation();
          } else {
            final index = itemController.items.indexOf(item);

            item.name = validateFormController.nameEditingController.text;
            item.quantity = int.parse(
                validateFormController.quantityEditingController.text);
            item.status = statusValue!.value;
            itemController.updateItem(item, index);
          }
          Get.back();
        }
      },
      textConfirm: 'Salvar',
      cancelTextColor: Colors.red,
      confirmTextColor: Colors.green,
      buttonColor: Colors.transparent,
      textCancel: 'Cancelar',
    );
  }
}
