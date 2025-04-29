import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_liveclass/counter/counter_controller.dart';
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profile'),),
      body: Center(
        child: Column(
          children: [
            GetBuilder<CounterController>(builder: (controller){
              return Text(style: TextStyle(fontSize: 24,),
                  controller.count.toString());
            }),
            TextButton(onPressed: () {
              // Navigator.pop(context,'data');
              Get.back();
            }, child: Text('Back')
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(onPressed: (){
        Get.find<CounterController>().increment();
      },
        child: const Icon(Icons.add),
      ),
    );
  }
}
