import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:task_liveclass/ui/screens/login_screen.dart';
import '../../data/service/network_client.dart';
import '../../data/utils/urls.dart';
import '../widgets/screen_background.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String email;
  final String otp;

  const ResetPasswordScreen({
    super.key,
    required this.email,
    required this.otp,
  });

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}


class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController _newPasswordTEController = TextEditingController();
  final TextEditingController _confirmPasswordTEController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenBackground(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 80),
                  Text("Set Password",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  SizedBox(height: 4),
                  Text(
                    "Pleses set your new password minimum 6 characters length ",
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.grey
                    ),
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.emailAddress,
                    controller: _newPasswordTEController,
                    decoration: const InputDecoration(
                      hintText: 'New Password',
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    controller: _confirmPasswordTEController,
                    decoration: const InputDecoration(
                      hintText: 'Confirm Password',
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                      onPressed: _onTapSubmitButton,
                      child: const Text('Confirm')
                  ),
                  const SizedBox(height: 32),
                  Center(
                    child: RichText(
                        text: TextSpan(
                            style: TextStyle(
                              color: Colors.black54,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                            children: [
                              TextSpan(text: "Do You have Password? "),
                              TextSpan(text: " Sign In",
                                style: TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = _onTapSignInButton,
                              ),
                            ]
                        )),
                  )
                ],
              ),
            ),
          )
      ),
    );
  }

  void _onTapSubmitButton() async {
    String newPassword = _newPasswordTEController.text.trim();
    String confirmPassword = _confirmPasswordTEController.text.trim();

    if (newPassword != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Passwords do not match')),
      );
      return;
    }

    if (newPassword.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Password must be at least 6 characters')),
      );
      return;
    }

    final Map<String, dynamic> body = {
      "email": widget.email,
      "OTP": widget.otp,
      "password": newPassword
    };

    NetworkResponse response = await NetworkClient.postRequest(
      url: Urls.recoverResetPasswordUrl,
      body: body,
    );

    if (response.isSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Password reset successful')),
      );
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
            (route) => false,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${response.errorMessage}')),
      );
    }
  }


  void _onTapSignInButton(){
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context)=> const LoginScreen()
    ), (pre)=> false);
  }
  @override
  void dispose() {
    _newPasswordTEController.dispose();
    _confirmPasswordTEController.dispose();
    super.dispose();
  }
}