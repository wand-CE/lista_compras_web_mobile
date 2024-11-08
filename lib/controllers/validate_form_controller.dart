import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ValidateFormController extends GetxController {
  final formKey = GlobalKey<FormState>();

  var nameEditingController = TextEditingController();
  var quantityEditingController = TextEditingController();
  var statusEditingController = TextEditingController();

  String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Nome não pode estar vázio';
    }
    return null;
  }

  String? validateQuantity(String? value) {
    if (value == null || value.isEmpty) {
      return 'Quantidade não pode estar vázio';
    } else if (!GetUtils.isNumericOnly(value)) {
      return 'Esse campo só aceita números';
    }
    return null;
  }

  bool validateForm() {
    return validateName(nameEditingController.text) == null &&
        validateQuantity(quantityEditingController.text) == null;
  }

  bool submit() {
    return formKey.currentState!.validate();
  }
}