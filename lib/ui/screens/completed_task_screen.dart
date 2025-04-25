import 'package:flutter/material.dart';
import '../../data/models/task_details_model.dart';
import '../widgets/get_task_list_by_status.dart';
import '../widgets/task_card.dart';

class CompletedTaskScreen extends StatefulWidget {
  const CompletedTaskScreen({super.key});

  @override
  State<CompletedTaskScreen> createState() => _CompletedTaskScreenState();
}

class _CompletedTaskScreenState extends State<CompletedTaskScreen> {

  bool isLoading = false;
  List<TaskDetailsModel> taskList = [];

  @override
  void initState() {
    super.initState();
    getTask();
  }

  Future<void> _onRefresh() async {
    await getTask();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child:
        isLoading
            ? ListView(
          children: const [
            SizedBox(height: 300),
            Center(child: CircularProgressIndicator()),
          ],
        )
            : taskList.isEmpty
            ? ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            SizedBox(height: MediaQuery.of(context).size.height / 3),
            const Center(child: Text("Empty")),
          ],
        )
            : ListView.separated(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(vertical: 10),
          itemCount: taskList.length,
          separatorBuilder:
              (context, index) => const SizedBox(height: 10),
          itemBuilder: (BuildContext context, int index) {
            var task = taskList[index];
            String dateOnly = task.createdDate.split('T')[0];
            return TaskCard(
              id: task.id,
              status: 'Completed',
              taskTitle: task.title,
              taskDescription: task.description,
              date: dateOnly,
              onDelete: () async {
                setState(() => taskList.removeAt(index));
              },
              onUpdateRefreshScreen: () async {
                await getTask();
                setState(() {});
              },
            );
          },
        ),
      ),
    );
  }

  Future<void> getTask() async {
    setState(() => isLoading = true);
    taskList = await getTaskListByStatus(status: 'Completed');
    setState(() => isLoading = false);
  }
}
