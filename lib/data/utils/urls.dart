class Urls{
  static const String _baseUrl = 'http://35.73.30.144:2005/api/v1';
  static const String registerUrl = '$_baseUrl/Registration';
  static const String loginUrl = '$_baseUrl/Login';
  static final String updateProfileUrl = '$_baseUrl/ProfileUpdate';
  static final String profileDetailsUrl = '$_baseUrl/ProfileDetails';
  static const String resetPasswordUrl = '$_baseUrl/RecoverResetPassword';

  static final String createTaskUrl = '$_baseUrl/createTask';
  static final String taskStatusCountUrl = '$_baseUrl/taskStatusCount';

  static getTaskUrl(status) {
    return '$_baseUrl/listTaskByStatus/$status';
  }


  static deleteTaskUrl(id) {
    return '$_baseUrl/deleteTask/$id';
  }

  static updateTaskStatusUrl({required String taskId, required status}) {
    return '$_baseUrl/updateTaskStatus/$taskId/$status';
  }

  static pswEmailVerity(email) {
    return '$_baseUrl/RecoverVerifyEmail/$email';
  }
  static forgetPasswordEmailVerifyUrl(email) {
    return '$_baseUrl/RecoverVerifyEmail/$email';
  }
  static forgetPasswordEmailOPTVerifyUrl({email, otp}) {
    return '$_baseUrl/RecoverVerifyOtp/$email/$otp';
  }

}