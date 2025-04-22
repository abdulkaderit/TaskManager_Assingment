
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:task_liveclass/data/service/network_client.dart';
import '../../data/utils/urls.dart';
import '../widgets/pop_up_message.dart';
import '../widgets/screen_background.dart';
import '../widgets/validator.dart';

class ForgotPasswordEmailVerifyScreen extends StatefulWidget {
  const ForgotPasswordEmailVerifyScreen({super.key});

  @override
  State<ForgotPasswordEmailVerifyScreen> createState() => _ForgetPasswordEmailVerifyScreenState();
}

class _ForgetPasswordEmailVerifyScreenState extends State<ForgotPasswordEmailVerifyScreen> {
  final TextEditingController _emailTEController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenBackground(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 120),
                    Text("Your Email Address",
                      style: Theme
                          .of(context)
                          .textTheme
                          .titleLarge,
                    ),
                    SizedBox(height: 4),
                    Text(
                      "Enter your email address. will get A 6 digit code to your email address. for verification",
                      style: Theme
                          .of(context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(
                          color: Colors.grey
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.emailAddress,
                      controller: _emailTEController,
                      decoration: const InputDecoration(hintText: 'Email'),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (String? value){
                        return validator(
                          value!,
                          isEmptyTitle: 'Enter your email address',
                          alertTitle: 'Enter a valid email',
                          regExp: RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                        onPressed: _onTapSubmitButton,
                        child: Visibility(
                          visible: isLoading == false,
                          replacement: Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: CircularProgressIndicator(),
                          ),
                          child: const Icon(
                            Icons.arrow_circle_right_outlined, size: 26,),
                        )
                    ),
                    const SizedBox(height: 20),
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
                                  recognizer:
                                  TapGestureRecognizer()
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

  void _onTapSubmitButton() {
    if (_formKey.currentState!.validate() == true ) {
      _forgotPasswordEmailVerify();
    }
  }

  Future<void> _forgotPasswordEmailVerify() async {
    isLoading = true;
    setState(() {});
    String email = _emailTEController.text.trim();
    String url =Urls.forgetPasswordEmailVerifyUrl(email);

    NetworkResponse response = await NetworkClient.getRequest(url: url);
    if (response.statusCode == 200) {
      if (!mounted) return;
      Navigator.pushNamedAndRemoveUntil(
        context, '/forgetPasswordPin', (route) => false, arguments: email,
      );
    }else{
      isLoading = false;
      setState(() {});
      if(!mounted)return;
      showPopUp(context, 'Email not found',true);
    }
    isLoading = false;
    setState(() {});
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