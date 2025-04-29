import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends StatefulWidget {
   const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  CounterController  counterController = CounterController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home'),),
      body:  Center(
        child: Obx((){
          return Text('${counterController.count}',
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 24),);
        }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          counterController.increment();
        }, child: Icon(Icons.add),),
    );
  }
}
class CounterController {
  RxInt count = 0.obs;

  void increment(){
    count ++;
  }
}
