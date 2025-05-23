import 'package:email_validator/email_validator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:task_liveclass/data/service/network_client.dart';
import 'package:task_liveclass/ui/widgets/snak_bar_message.dart';
import '../../data/utils/urls.dart';
import '../widgets/centered_circular_progress_indicator.dart';
import '../widgets/pop_up_message.dart';
import '../widgets/screen_background.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _fistNameTEController = TextEditingController();
  final TextEditingController _lastNameTEController = TextEditingController();
  final TextEditingController _mobileTEController = TextEditingController();
  final TextEditingController _emailTEController = TextEditingController();
  final TextEditingController _passwordTEController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _registrationInProgress = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenBackground(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 80),
                    Text("Join With Us",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 24),
                    TextFormField(
                      textInputAction: TextInputAction.next,
                      controller: _fistNameTEController,
                      decoration: const InputDecoration(
                        hintText: 'First Name',
                      ),
                      validator: (String? value){
                        if(value?.trim().isEmpty ?? true){
                          return 'First Name is required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      textInputAction: TextInputAction.next,
                      controller: _lastNameTEController,
                      decoration: const InputDecoration(
                        hintText: 'Last Name',
                      ),
                      validator: (String? value){
                        if(value?.trim().isEmpty ?? true){
                          return 'Last Name is required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.phone,
                      controller: _mobileTEController,
                      decoration: const InputDecoration(
                          hintText: 'Mobile Number',
                      ),
                      validator: (String? value){
                        String phone = value?.trim() ?? '';
                        RegExp regExp = RegExp(r"^(?:\+?88|0088)?01[15-9]\d{8}$");
                        if(regExp.hasMatch(phone)== false){
                          return 'Enter valid phone number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 8),
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
                      controller: _passwordTEController,
                      obscureText: true,
                      decoration: const InputDecoration(
                          hintText: 'Password'
                      ),
                      validator: (String? value){
                        if((value?.isEmpty ?? true) || (value!.length <6 )){
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    Visibility(
                      visible: _registrationInProgress == false,
                      replacement: const CenteredCircularProgressIndicator(),
                      child: ElevatedButton(
                          onPressed: _onTapSubmitButton,
                          child: const Icon(Icons.arrow_circle_right_outlined, size: 26,)
                      ),
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
                                TextSpan(text: "Already have an account? "),
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
            ),
          )
      ),
    );
  }

  void _onTapSubmitButton(){
    if(_formKey.currentState!.validate()){
      _registerUser();
    }
  }

  Future<void> _registerUser() async{
    _registrationInProgress =true;
    setState(() {});

    Map<String, dynamic> requestBody ={
      "email":_emailTEController.text.trim(),
      "firstName":_fistNameTEController.text.trim(),
      "lastName":_lastNameTEController.text.trim(),
      "mobile":_mobileTEController.text.trim(),
      "password":_passwordTEController.text
    };
    NetworkResponse response = await NetworkClient.postRequest(
        url: Urls.registerUrl,
        body: requestBody
    );
    if (response.statusCode == 200) {
      _clearTextFields();
      if (!mounted) return;
      showPopUp(context, 'Registration Successfully');
    } else  {
      print('Registration fail due to invalid mail');
    }
    _registrationInProgress = false;
    setState(() {
    });
  }

  void _clearTextFields(){
    _fistNameTEController.clear();
    _lastNameTEController.clear();
    _mobileTEController.clear();
    _emailTEController.clear();
    _passwordTEController.clear();
  }

  void _onTapSignInButton(){
    Navigator.pop(context);
  }
  @override
  void dispose() {
    _fistNameTEController.dispose();
    _lastNameTEController.dispose();
    _mobileTEController.dispose();
    _emailTEController.dispose();
    _passwordTEController.dispose();
    super.dispose();
  }
}
