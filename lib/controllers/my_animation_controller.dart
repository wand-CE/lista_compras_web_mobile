import 'package:get/get.dart';

class MyAnimationController extends GetxController {
  var isAnimationVisible = false.obs;

  void startAnimation() {
    isAnimationVisible.value = true;

    Future.delayed(Duration(milliseconds: 3333), () {
      isAnimationVisible.value = false;
    });
  }

  void toggleAnimation() {
    isAnimationVisible.value = !isAnimationVisible.value;
  }
}