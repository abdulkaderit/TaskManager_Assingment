import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:task_liveclass/ui/screens/reset_password_screen.dart';
import '../../data/service/network_client.dart';
import '../../data/utils/urls.dart';
import '../widgets/screen_background.dart';
import 'login_screen.dart';

class ForgotPasswordPinVerifyScreen extends StatefulWidget {
  final String email;
  const ForgotPasswordPinVerifyScreen({super.key, required this.email});

  @override
  State<ForgotPasswordPinVerifyScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<ForgotPasswordPinVerifyScreen> {
  final TextEditingController _pinCodeTEController = TextEditingController();
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
                  Text("Pin Verification",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  SizedBox(height: 4),
                  Text(
                    "We have been send you a 6 digit verification code to your email address.",
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.grey
                    ),
                  ),
                  const SizedBox(height: 24),
                  PinCodeTextField(
                    length: 6,
                    obscureText: false,
                    animationType: AnimationType.fade,
                    keyboardType: TextInputType.number,
                    pinTheme: PinTheme(
                      shape: PinCodeFieldShape.box,
                      borderRadius: BorderRadius.circular(5),
                      fieldHeight: 50,
                      fieldWidth: 45,
                      activeFillColor: Colors.white,
                      selectedFillColor: Colors.white,
                      inactiveFillColor: Colors.white
                    ),
                    animationDuration: Duration(milliseconds: 300),
                    backgroundColor: Colors.transparent,
                    enableActiveFill: true,
                    controller: _pinCodeTEController,
                    appContext: context,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                      onPressed: _onTapSubmitButton,
                      child: const Text('Verify')
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
                                  ..onTap = _onTopSignInButton,
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
    if (_formKey.currentState!.validate()) {
      String otp = _pinCodeTEController.text.trim();
      String email = widget.email;

      NetworkResponse response = await NetworkClient.getRequest(
        url: "${Urls.recoverVerifyOtpUrl}$email/$otp", // e.g., /recover-verify-otp/email/123456
      );

      if (response.isSuccess) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ResetPasswordScreen(email: email, otp: otp),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Invalid OTP')),
        );
      }
    }
  }


  void _onTopSignInButton(){
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context)=> const LoginScreen()),
            (pre)=> false);
  }
  @override
  void dispose() {
    _pinCodeTEController.dispose();
    super.dispose();
  }
}