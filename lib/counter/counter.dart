import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_liveclass/counter/counter_controller.dart';
import 'package:task_liveclass/counter/home.dart';

class CounterApp extends StatelessWidget {
  const CounterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      home: const HomeScreen(),
      initialBinding: ControllerBinder(),
    );
  }
}

class ControllerBinder extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(()=> CounterController());
  }
}
