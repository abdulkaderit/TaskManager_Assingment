import 'package:flutter/material.dart';
import 'package:task_liveclass/app.dart';
import 'package:task_liveclass/ui/widgets/pop_up_message.dart';
import '../../data/service/network_client.dart';
import '../../data/utils/urls.dart';

class TaskCard extends StatelessWidget {
  const TaskCard({
    super.key,
    required this.status,
    this.taskTitle,
    this.taskDescription,
    this.date,
    required this.id,
    this.onDelete,
    this.onUpdateRefreshScreen,
  });

  final String status;
  final String? taskTitle;
  final String? taskDescription;
  final String? date;
  final String id;
  final VoidCallback? onDelete;
  final VoidCallback? onUpdateRefreshScreen;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              taskTitle ?? "Title will be here",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            Text(taskDescription ?? "Description will be here"),
            Text(date ?? "Date will be here"),
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: _statusColorBuilder(),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                    child: Text(
                      status.toString(),
                      style: TextStyle(color: Colors.white, fontSize: 10),
                    ),
                  ),
                ),

                //for Beautification I skip the chip

                // Chip(
                //   label: Text(
                //     '${status}',
                //     style: TextStyle(color: Colors.white),
                //   ),
                //   backgroundColor: _statusColorBuilder(),
                //   shape: RoundedRectangleBorder(
                //     borderRadius: BorderRadius.circular(10),
                //   ),
                //   side: BorderSide.none,
                // ),
                Spacer(),
                IconButton(
                  onPressed: () {
                    editTaskStatusDialogue(context);
                  },
                  icon: Icon(Icons.edit),
                ),
                IconButton(
                  onPressed: () => onTapDelete(id),
                  icon: Icon(Icons.delete),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  onTapDelete(id) {
    deleteTask(id);
  }

  _statusColorBuilder() {
    if (status == 'New') {
      return Colors.blue;
    } else if (status == 'Progress') {
      return Colors.purple;
    } else if (status == 'Canceled') {
      return Colors.redAccent;
    } else if (status == 'Completed') {
      return Colors.green;
    }
  }

  editTaskStatusDialogue(context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text('New'),
                trailing: IconButton(
                  onPressed: () {
                    if (isCurrentStatus('New')) {
                      Navigator.pop(context);
                      return;
                    } else {
                      updateTaskStatus(id, 'New');
                      Navigator.pop(context);
                    }
                  },
                  icon:
                  status == 'New'
                      ? Icon(
                    Icons.check_circle_rounded,
                    color: Colors.green,
                  )
                      : Icon(Icons.circle_outlined),
                ),
              ),
              ListTile(
                title: Text('Completed'),
                trailing: IconButton(
                  onPressed: () {
                    if (isCurrentStatus('Completed')) {
                      Navigator.pop(context);
                      return;
                    } else {
                      updateTaskStatus(id, 'Completed');
                      Navigator.pop(context);
                    }
                  },
                  icon:
                  status == 'Completed'
                      ? Icon(
                    Icons.check_circle_rounded,
                    color: Colors.green,
                  )
                      : Icon(Icons.circle_outlined),
                ),
              ),
              ListTile(
                title: Text('Canceled'),
                trailing: IconButton(
                  onPressed: () {
                    if (isCurrentStatus('Canceled')) {
                      Navigator.pop(context);
                      return;
                    } else {
                      updateTaskStatus(id, 'Canceled');
                      Navigator.pop(context);
                    }
                  },
                  icon:
                  status == 'Canceled'
                      ? Icon(
                    Icons.check_circle_rounded,
                    color: Colors.green,
                  )
                      : Icon(Icons.circle_outlined),
                ),
              ),
              ListTile(
                title: Text('Progress'),
                trailing: IconButton(
                  onPressed: () {
                    if (isCurrentStatus('Progress')) {
                      Navigator.pop(context);
                      return;
                    } else {
                      updateTaskStatus(id, 'Progress');
                      Navigator.pop(context);
                    }
                  },
                  icon:
                  status == 'Progress'
                      ? Icon(
                    Icons.check_circle_rounded,
                    color: Colors.green,
                  )
                      : Icon(Icons.circle_outlined),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> deleteTask(id) async {
    String url = Urls.deleteTaskUrl(id);
    NetworkResponse response = await NetworkClient.getRequest(url: url);
    if (response.statusCode == 200) {
      if (onDelete != null) {
        onDelete!();
      }
      showPopUp(TaskManagerApp.navigatorKey.currentContext, '$taskTitle deleted');
    } else {
      showPopUp(
        TaskManagerApp.navigatorKey.currentContext,
        'Something went wrong',
      );
    }
  }

  bool isCurrentStatus(String currentStatus) {
    if (currentStatus == status) {
      return true;
    } else {
      return false;
    }
    ;
  }

  Future<void> updateTaskStatus(id, status) async {
    String Url = Urls.updateTaskStatusUrl(taskId: id, status: status);
    NetworkResponse response = await NetworkClient.getRequest(url: Url);
    if (response.statusCode == 200) {
      if (onUpdateRefreshScreen != null) {
        onUpdateRefreshScreen!();
      }
      showPopUp(TaskManagerApp.navigatorKey.currentContext, 'Update Successful');
    } else {
      showPopUp(TaskManagerApp.navigatorKey.currentContext, 'Update faild');
    }
  }
}