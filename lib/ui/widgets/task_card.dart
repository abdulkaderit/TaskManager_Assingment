import 'package:flutter/material.dart';

enum TaskStatus{
  sNew,
  progress,
  completed,
  cancelled
}
class TaskCard extends StatelessWidget {
  const TaskCard({
    super.key, required this.taskStatus,
  });

 final TaskStatus taskStatus;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      color: Colors.white,
      margin: EdgeInsets.symmetric(horizontal: 12),
      child:Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Title will be here',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18)),
            Text('Description will be here',style: TextStyle(fontSize: 16)),
            Text('Data: 12/03/2024'),
            Row(
              children: [
                Chip(label: Text('New',style: TextStyle(color: Colors.white),),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40)
                  ),
                  backgroundColor: _getStatusChipColor(),
                  side: BorderSide.none,
                ),
                const Spacer(),
                IconButton(onPressed: (){}, icon: Icon(Icons.delete,color: Colors.red,)),
                IconButton(onPressed: (){}, icon: Icon(Icons.edit))
              ],
            )
          ],
        ),
      ),
    );
  }
  Color _getStatusChipColor(){
    late Color color;

    switch (taskStatus){
      case TaskStatus.sNew:
        color = Colors.blue;
      case TaskStatus.progress:
        color = Colors.purple;
      case TaskStatus.completed:
        color = Colors.green;
      case TaskStatus.cancelled:
        color = Colors.red;
    }
    return color;
  }
}