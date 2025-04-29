import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_liveclass/counter/counter_controller.dart';
import 'home.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Settings"),),
      body: Center(
        child: Column(
          children: [
            GetBuilder<CounterController>(builder: (controller){
              return Text(controller.count.toString());
            }),
            TextButton(onPressed: () {
              // Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)
                //   => const HomeScreen()), (predicate) => false,
                // );
              Get.offAll(const HomeScreen(), predicate: (_) => false);
              },
              child: Text('Go to Home'),
            ),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.find<CounterController>().increment();
        }, child: Icon(Icons.add),),
    );
  }
}
