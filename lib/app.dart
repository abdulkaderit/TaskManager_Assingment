import 'package:task_liveclass/ui/screens/add_new_task_screen.dart';
import 'package:task_liveclass/ui/screens/forgot_password_email_verify_screen.dart';
import 'package:task_liveclass/ui/screens/forgot_password_otp_verification_screen.dart';
import 'package:task_liveclass/ui/screens/login_screen.dart';
import 'package:task_liveclass/ui/screens/main_bottom_nav.dart';
import 'package:task_liveclass/ui/screens/register_screen.dart';
import 'package:task_liveclass/ui/screens/reset_password_screen.dart';
import 'package:task_liveclass/ui/screens/splash_screen.dart';
import 'package:task_liveclass/ui/screens/update_profile_screen.dart';
import 'package:flutter/material.dart';


class TaskManagerApp extends StatelessWidget {
  const TaskManagerApp({super.key});

  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: TaskManagerApp.navigatorKey,
      title: 'Task Manager',
      initialRoute:'/splash' ,
      routes: {
        '/splash': (context) => SplashScreen(),
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/resetPassword': (context) => ResetPasswordScreen(),
        '/forgetPasswordEmail': (context) => ForgotPasswordEmailVerifyScreen(),
        '/forgetPasswordPin': (context) => ForgotPasswordOtpVerifyScreen(),
        '/MainBottomNavScreen': (context)=> MainBottomNavScreen(),
        '/AddNewTaskScreen': (context) =>AddNewTaskScreen(),
        '/UpdateProfileScreen': (context)=> UpdateProfileScreen(),

      },
      theme: ThemeData(
        colorSchemeSeed: Colors.green,
        inputDecorationTheme: InputDecorationTheme(
            hintStyle: TextStyle(fontWeight: FontWeight.w400,
                color: Colors.grey
            ),
            fillColor: Colors.white,
            filled: true,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16,
            ),
            border: _getZeroBorder(),
            enabledBorder: _getZeroBorder(),
          errorBorder: _getZeroBorder(),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            fixedSize: const Size.fromWidth(double.maxFinite),
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8)
            )
          )
        ),
        textTheme: const TextTheme(
          titleLarge: TextStyle(fontSize: 24,fontWeight: FontWeight.w600),
        ),
      ),
      // home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
  OutlineInputBorder _getZeroBorder(){
    return const OutlineInputBorder(
      borderSide: BorderSide.none,
    );
  }
}
