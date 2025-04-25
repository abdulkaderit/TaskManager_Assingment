import 'package:flutter/material.dart';
import 'package:task_liveclass/ui/widgets/get_task_list_by_status.dart';
import 'package:task_liveclass/ui/widgets/pop_up_message.dart';
import '../../data/models/task_details_model.dart';
import '../../data/models/task_list_model.dart';
import '../../data/models/task_status_count_list_model.dart';
import '../../data/models/task_status_count_model.dart';
import '../../data/service/network_client.dart';
import '../../data/utils/urls.dart';
import '../widgets/summary_card.dart';
import '../widgets/task_card.dart';

class NewTaskScreen extends StatefulWidget {
  const NewTaskScreen({super.key});

  @override
  State<NewTaskScreen> createState() => _NewTaskScreenState();
}

class _NewTaskScreenState extends State<NewTaskScreen> {
  @override
  void initState() {
    getTask();
    getAllTaskStatusCount();
    super.initState();
  }

  List<TaskStatusCountModel> _taskStatusCount = [];

  bool isLoading = false;
  late List<TaskDetailsModel> taskList;

  Future<void> _refreshTask() async {
    await getTask();
    await getAllTaskStatusCount();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: _onTapAddTask,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        child: Icon(Icons.add),
      ),
      body: isLoading
          ? Center(child: const CircularProgressIndicator())
          : RefreshIndicator(
        onRefresh: _refreshTask,
        child: ListView(
          children: [
            Column(
              children: [
                const SizedBox(height: 5),
                _buildSummarySection(),

                taskList.isEmpty
                    ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    SizedBox(
                      height:
                      MediaQuery.of(context).size.height / 3,
                    ),
                    Center(child: Text('Empty')),
                  ],
                )
                    : ListView.separated(
                  primary: false,
                  shrinkWrap: true,
                  itemCount: taskList.length,
                  separatorBuilder:
                      (context, index) => SizedBox(height: 10),
                  itemBuilder: (BuildContext context, int index) {
                    var task = taskList[index];
                    String dateTime = task.createdDate;
                    String dateOnly = dateTime.split('T')[0];
                    return TaskCard(
                      id: task.id,
                      status: 'New',
                      taskTitle: task.title,
                      taskDescription: task.description,
                      date: dateOnly,
                      onDelete: () async {
                        taskList.removeAt(index);
                        await getAllTaskStatusCount(); // Update summary
                        setState(() {});
                      },
                      onUpdateRefreshScreen: () async {
                        await getTask();
                        setState(() {});
                      },
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _onTapAddTask() {
    Navigator.pushNamed(
      context,
      '/AddNewTaskScreen',
      arguments: () {
        getAllTaskStatusCount();
        getTask();
        setState(() {});
      },
    );
  }

  Widget _buildSummarySection() {
    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _taskStatusCount.length,
        itemBuilder: (context, index) {
          return SummaryCard(
            title: _taskStatusCount[index].status,
            count: _taskStatusCount[index].count,
          );
        },
      ),
    );
  }

  Future<void> getAllTaskStatusCount() async {
    isLoading = true;
    setState(() {});
    final NetworkResponse response = await NetworkClient.getRequest(
      url: Urls.taskStatusCountUrl,
    );

    if (response.statusCode == 200) {
      TaskStatusCountListModel taskStatusListModel =
      TaskStatusCountListModel.fromJson(response.data ?? {});
      _taskStatusCount = taskStatusListModel.statusCountList;
    } else {
      if (!mounted) return;
      showPopUp(context, response.errorMessage);
    }
    isLoading = false;
    setState(() {});
  }

  Future<void> getTask() async {
    isLoading = true;
    setState(() {});
    try {
      taskList = await getTaskListByStatus(status: 'New');
    } catch (e) {
      print(e);
    }
    isLoading = false;
    setState(() {});
  }

}




