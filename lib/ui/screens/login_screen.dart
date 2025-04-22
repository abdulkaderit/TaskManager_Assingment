import 'package:email_validator/email_validator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:task_liveclass/data/models/login_model.dart';
import 'package:task_liveclass/ui/controllers/auth_controller.dart';
import 'package:task_liveclass/ui/screens/forgot_password_email_verify_screen.dart';
import 'package:task_liveclass/ui/screens/main_bottom_nav.dart';
import 'package:task_liveclass/ui/screens/register_screen.dart';
import 'package:task_liveclass/ui/widgets/screen_background.dart';

import '../../data/service/network_client.dart';
import '../../data/utils/urls.dart';
import '../widgets/centered_circular_progress_indicator.dart';
import '../widgets/snak_bar_message.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailTEController = TextEditingController();
  final TextEditingController _passwordTEController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _loginInProgress = false;
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenBackground(
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 80),
                   Text("Get Started With",
                    style: Theme.of(context).textTheme.titleLarge,
                   ),
                  const SizedBox(height: 24),
                  TextFormField(
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.emailAddress,
                    controller: _emailTEController,
                    decoration: const InputDecoration(
                      hintText: 'Email',
                    ),
                    validator: (String? value){
                      String email = value?.trim() ?? '';
                      if(EmailValidator.validate(email)== false){
                        return 'Enter a valid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    obscureText: !_isPasswordVisible,
                    controller: _passwordTEController,
                    decoration: InputDecoration(
                      hintText: 'Password',
                      suffixIcon: IconButton(
                        icon: Icon(_isPasswordVisible ? Icons.visibility : Icons
                            .visibility_off
                        ),
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                      ),
                    ),
                    validator: (String? value) {
                      if ((value?.isEmpty ?? true) || (value!.length < 6)) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                  ),
                const SizedBox(height: 16),
                  Visibility(
                    visible: _loginInProgress == false,
                    replacement: const CenteredCircularProgressIndicator(),
                    child: ElevatedButton(
                        onPressed: _onTapSignInButton,
                        child: const Icon(Icons.arrow_circle_right_outlined, size: 26,)
                    ),
                  ),
                  const SizedBox(height: 32),
                  Center(
                    child: Column(
                      children: [
                        TextButton(onPressed: _onTapForgotPasswordButton,
                            child: const Text("Forgot Password?")
                        ),
                        RichText(
                            text: TextSpan(
                          style: TextStyle(
                              color: Colors.black54,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                          children: [
                            TextSpan(text: "Don't have an account? "),
                            TextSpan(text: " Sign Up",
                              style: TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = _onTapSignUpButton,
                            ),
                          ]
                        )),
                      ],
                    ),
                  )
                ],
              ),
            ),
          )
      ),
    );
  }
  void _onTapSignInButton(){
    if(_formKey.currentState!.validate()){
      _login();
    }
  }
  Future<void> _login() async{
    _loginInProgress = true;
    setState(() {});

    Map<String, dynamic> requestBody ={
      "email":_emailTEController.text.trim(),
      "password":_passwordTEController.text
    };
    NetworkResponse response = await NetworkClient.postRequest(
        url: Urls.loginUrl,
        body: requestBody
    );
    _loginInProgress = false;
    setState(() {});

    if(response.isSuccess){
      LoginModel loginModel = LoginModel.fromJson(response.data!);
      // ToDo: save user data in shared preference
      AuthController.saveUserInformation(loginModel.token, loginModel.userModel);

      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context)=> const MainBottomNavScreen()),
              (predicate)=> false);
      showSnackBarMessage(context, 'Uers login successfully!');
    }else{
      showSnackBarMessage(context, response.errorMessage, true);
    }
  }
  void _onTapSignUpButton(){
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context)=> const RegisterScreen(),
        )
    );
  }
  void _onTapForgotPasswordButton(){
    Navigator.push(context, MaterialPageRoute(builder: (context)=> const ForgotPasswordEmailVerifyScreen(),
    ),
    );
  }

  @override
  void dispose() {
    _emailTEController.dispose();
    _passwordTEController.dispose();
    super.dispose();
  }
}
