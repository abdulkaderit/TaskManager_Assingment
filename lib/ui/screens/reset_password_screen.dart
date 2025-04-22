import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:task_liveclass/ui/widgets/pop_up_message.dart';
import '../../data/service/network_client.dart';
import '../../data/utils/urls.dart';
import '../widgets/screen_background.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key,});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}


class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController _passwordTEController = TextEditingController();
  final TextEditingController _cfmPasswordTEController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _passwordVisibility = true;
  bool _cfmPasswordVisibility = true;

  pswVisibilityControl({required bool isCfmPsw}){
    if(isCfmPsw == false){
      setState(() {
        _passwordVisibility = !_passwordVisibility;
      });
    } else if (isCfmPsw == true){
      setState(() {
        _cfmPasswordVisibility = !_cfmPasswordVisibility;
      });
    }
  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final argument = ModalRoute.of(context)!.settings.arguments;
    receivedEmailAndOtp = argument as Map<String, dynamic>;
  }
  Map<String,dynamic>? receivedEmailAndOtp;
  bool isLoading = false;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenBackground(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Form(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 120),
                    Text("Set Password",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Pleses set your new password minimum 6 characters length ",
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.grey
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      obscureText: !_passwordVisibility,
                      textInputAction: TextInputAction.next,
                      controller: _passwordTEController,
                      validator: (value){
                        if(value!.isEmpty){
                          return 'Enter your password';
                        } else if(value.length<6){
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          onPressed: () =>
                              pswVisibilityControl(isCfmPsw: false),
                          icon: _passwordVisibility
                              ? Icon(Icons.visibility)
                              : Icon(Icons.visibility_off),
                        ),
                        hintText: 'New Password',
                      ),
                    ),
                    const SizedBox(height: 10),

                    TextFormField(
                      obscureText: !_cfmPasswordVisibility,
                      controller: _cfmPasswordTEController,
                      validator: (value){
                        if(value != _passwordTEController.text){
                          return 'Password not matched';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          onPressed: () => pswVisibilityControl(isCfmPsw: true),
                          icon: _cfmPasswordVisibility
                              ? Icon(Icons.visibility)
                              : Icon(Icons.visibility_off),
                        ),
                        hintText: 'Confirm Password',
                      ),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                        onPressed: _onTapSubmitButton,

                        child: Visibility(
                          visible: isLoading == false,
                            replacement: Padding(
                                padding: EdgeInsets.all(3),
                              child: CircularProgressIndicator(),
                            ),
                            child: const Text('Confirm')
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

  void _onTapSubmitButton() async {
    if(_formKey.currentState!.validate() == true){
      _resetPassword();
    }
  }
  Future<void> _resetPassword()async{
    isLoading = true;
    setState(() {});

    String newPassword = _passwordTEController.text;
    Map<String,dynamic> requestBody = {
      "email": receivedEmailAndOtp!['email'],
      "OTP": receivedEmailAndOtp!['OTP'],
      "password": newPassword,
    };
    String url =Urls.resetPasswordUrl;
    NetworkResponse response = await NetworkClient.postRequest(
        url: url,
       body: requestBody,
    );
    if(response.statusCode== 200){
      if(!mounted)return;
      showPopUp(context, 'Password reset successfully');
      Navigator.pushNamedAndRemoveUntil(context, '/login', (predicate)=> false,
      );
    }
    isLoading = false;
    setState(() {});
  }


  void _onTapSignInButton(){
    Navigator.pushNamed(context, '/login');
  }
  @override
  void dispose() {
    _passwordTEController.dispose();
    _cfmPasswordTEController.dispose();
    super.dispose();
  }
}