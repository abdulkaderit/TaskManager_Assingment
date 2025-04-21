import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:task_liveclass/ui/controllers/auth_controller.dart';
import 'package:task_liveclass/ui/screens/login_screen.dart';
import 'package:task_liveclass/ui/screens/main_bottom_nav.dart';
import 'package:task_liveclass/ui/utils/assets_path.dart';
import 'package:task_liveclass/ui/widgets/screen_background.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    _moveToNextScreen();
  }

  Future<void> _moveToNextScreen() async {
    await Future.delayed(const Duration(seconds: 3));

    final bool isLoggedIn = await AuthController.checkIfUserLoggedIn();

    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => isLoggedIn ? MainBottomNavScreen(): const LoginScreen()
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: ScreenBackground(
          child: Center(
            child: SvgPicture.asset(
              AssetsPath.logoSvg,
              width: 120,
            ),
          )
      )
    );
  }
}
