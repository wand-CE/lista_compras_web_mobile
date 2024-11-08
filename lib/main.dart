import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lista_de_compras/views/home_page.dart';
import 'package:responsive_framework/responsive_framework.dart';

import 'controllers/item_controller.dart';
import 'controllers/my_animation_controller.dart';
import 'controllers/validate_form_controller.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  final itemController = Get.put(ItemController());
  final validateFormController = Get.put(ValidateFormController());
  final myAnimationController = Get.put(MyAnimationController());

  runApp(GetMaterialApp(
    debugShowCheckedModeBanner: false,
    builder: (context, child) {
      return ResponsiveBreakpoints.builder(
        child: child!,
        breakpoints: [
          const Breakpoint(start: 0, end: 450, name: MOBILE),
          const Breakpoint(start: 451, end: 800, name: TABLET),
          const Breakpoint(start: 801, end: 1920, name: DESKTOP),
          const Breakpoint(start: 1921, end: double.infinity, name: '4K'),
        ],
      );
    },
    home: HomePage(),
    title: 'Lista de Compras',
  ));
}
