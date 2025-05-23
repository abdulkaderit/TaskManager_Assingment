class TaskDetailsModel {
  final String id;
  final String title;
  final String description;
  final String status;
  final String email;
  final String createdDate;

  TaskDetailsModel({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.email,
    required this.createdDate
  });

  factory TaskDetailsModel.fromJson(Map<String, dynamic>jsonData){
    return TaskDetailsModel(
        id: jsonData['_id'],
        title: jsonData['title'],
        description: jsonData['description'],
        status: jsonData['status'],
        email: jsonData['email'],
        createdDate: jsonData['createdDate']
    );
  }
}

// class TaskModel {
//   late final String id;
//   late final String title;
//   late final String description;
//   late final String status;
//   late final String createdDate;
//
//   TaskModel.fromJson(Map<String, dynamic> jsonData) {
//     id = jsonData['_id'];
//     title = jsonData['title'] ?? '';
//     description = jsonData['description'] ?? '';
//     status = jsonData['status'];
//     createdDate = jsonData['createdDate'] ?? '';
//   }
// }