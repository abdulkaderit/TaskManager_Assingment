class Urls{
  static const String _baseUrl = 'http://35.73.30.144:2005/api/v1';
  static const String registerUrl = '$_baseUrl/Registration';
  static const String loginUrl = '$_baseUrl/Login';
  static final updateProfileUrl = '$_baseUrl/ProfileUpdate';
  static final profileDetailsUrl = '$_baseUrl/ProfileDetails';
  static final taskStatusCountUrl = '$_baseUrl/taskStatusCount';
  static final createTaskUrl = '$_baseUrl/createTask';
  static const String resetPasswordUrl = '$_baseUrl/RecoverResetPassword';

  static getTaskUrl(status) {
    return '$_baseUrl/listTaskByStatus/$status';
  }

  static pswEmailVerity(email) {
    return '$_baseUrl/RecoverVerifyEmail/$email';
  }

  static deleteTaskUrl(id) {
    return '$_baseUrl/deleteTask/$id';
  }
  static forgetPasswordEmailVerifyUrl(email) {
    return '$_baseUrl/RecoverVerifyEmail/$email';
  }
  static forgetPasswordEmailOPTVerifyUrl({email, otp}) {
    return '$_baseUrl/RecoverVerifyOtp/$email/$otp';
  }

}