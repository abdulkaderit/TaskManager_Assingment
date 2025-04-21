import 'package:email_validator/email_validator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:task_liveclass/data/service/network_client.dart';
import 'package:task_liveclass/ui/screens/forgot_password_pin_verification.dart';
import '../../data/utils/urls.dart';
import '../widgets/screen_background.dart';

class ForgotPasswordVerifyScreen extends StatefulWidget {
  const ForgotPasswordVerifyScreen({super.key});

  @override
  State<ForgotPasswordVerifyScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<ForgotPasswordVerifyScreen> {
  final TextEditingController _emailTEController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  // final RegExp emailRegExp = RegExp(
  //   r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
  // );

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
                  Text("Your Email Address",
                    style: Theme
                        .of(context)
                        .textTheme
                        .titleLarge,
                  ),
                  SizedBox(height: 4),
                  Text(
                    "Enter your email address. We will send you a 6 digit code to your email address. for verification",
                    style: Theme
                        .of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(
                        color: Colors.grey
                    ),
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.emailAddress,
                    controller: _emailTEController,
                    decoration: const InputDecoration(
                      hintText: 'Email',
                    ),
                    // validator: (value) {
                    //   if (value == null || value.isEmpty) {
                    //     return 'Please enter your email';
                    //   } else if (!emailRegExp.hasMatch(value.trim())) {
                    //     return 'Enter a valid email';
                    //   }
                    //   return null;
                    // },

                    validator: (String? value){
                      String email = value?.trim() ?? '';
                      if(EmailValidator.validate(email)== false){
                        return 'Enter a valid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                      onPressed: _onTapSubmitButton,
                      child: const Icon(
                        Icons.arrow_circle_right_outlined, size: 26,)
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

  void _onTapSubmitButton() {
    if (_formKey.currentState!.validate()) {
      _verifyForgotPassword();
    }
  }

  Future<void> _verifyForgotPassword() async {
    final email = _emailTEController.text.trim();

    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your email address')),
      );
      return;
    }

    // Optional: Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final response = await NetworkClient.getRequest(
        url: "${Urls.recoverVerifyEmailUrl}?email=$email",
      );

      Navigator.pop(context);

      if (response.isSuccess && response.data != null) {
        final message = response.data!['data'] ?? 'Verification email sent successfully';

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ForgotPasswordPinVerifyScreen(email: email),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${response.errorMessage}')),
        );
      }
    } catch (e) {
      Navigator.pop(context); // Ensure dialog is removed even on error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Unexpected error: $e')),
      );
    }
  }




  void _onTapSignInButton() {
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _emailTEController.dispose();
    super.dispose();
  }
}