import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_liveclass/counter/profile.dart';
import 'package:task_liveclass/counter/settings.dart';

import 'counter_controller.dart';

class HomeScreen extends StatefulWidget {
   const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  CounterController  counterController = Get.find<CounterController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home'),),
      body:  Center(
        child: Column(
          children: [
            GetBuilder(
                init: counterController, builder: (controller){
              return Text(
                '${counterController.count}',
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 24),);
             },
            ),
            TextButton(onPressed: () {
              // Navigator.push(context, MaterialPageRoute(builder: (context){
              //   return const ProfileScreen();
              // }));
              Get.to(const ProfileScreen());
            },
              child: Text('Go to profile'),
            ),

            TextButton(onPressed: () {
              // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
              //   return const ProfileScreen();
              // }));
              Get.off(const SettingsScreen());
            },
              child: Text('Go to settings'),
            ),

          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          counterController.increment();
        }, child: Icon(Icons.add),),
    );
  }
}

