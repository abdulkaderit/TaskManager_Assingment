import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:task_liveclass/ui/widgets/pop_up_message.dart';
import '../../data/service/network_client.dart';
import '../../data/utils/urls.dart';
import '../widgets/screen_background.dart';

class ForgotPasswordOtpVerifyScreen extends StatefulWidget {
  final String email;
  const ForgotPasswordOtpVerifyScreen({super.key, required this.email});

  @override
  State<ForgotPasswordOtpVerifyScreen> createState() => _ForgotPasswordOtpVerifyScreenState();
}

class _ForgotPasswordOtpVerifyScreenState extends State<ForgotPasswordOtpVerifyScreen> {
  final TextEditingController _otpTEController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void didChangeDependencies(){
    super.didChangeDependencies();
    final argument = ModalRoute.of(context)!.settings.arguments;
    receivedEmail = argument as String;
  }
  String? receivedEmail;
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
                    Text("PIN Verification",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    SizedBox(height: 10),
                    Text(
                      "A 6 digit pin verification will sent to your email address.",
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
                      controller: _otpTEController,
                      appContext: context,
                      validator: (String? value){
                        if(value!.trim().isEmpty == true){
                          return 'Please enter your OTP';
                        }else if (value.trim().length <6){
                          return 'Enter 6 digit OTP';
                        }
                        return null;
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
                            child: const Text('Verify')
                        )
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
            ),
          )
      ),
    );
  }

  void _onTapSubmitButton() {
    if (_formKey.currentState!.validate()== true) {
      _forgetPasswordOTPVerify();
    }
  }
  Future<void> _forgetPasswordOTPVerify()async{
    final String otp = _otpTEController.text;
    isLoading = true;
    setState(() {});

    String url= Urls.forgetPasswordEmailOPTVerifyUrl(
      email: receivedEmail,
      otp: otp,
    );
    NetworkResponse response = await NetworkClient.getRequest(url: url);

    if( !mounted)return;
    if(response.statusCode == 200){
      Navigator.pushNamedAndRemoveUntil(
          context, '/resetPassword', (route)=> false,
        arguments: {'email': receivedEmail, 'OTP': _otpTEController.text},
      );
      return;
    } else {
      showPopUp(context, 'Invalid OTP !!!', true);
    }
    isLoading = false;
  }


  void _onTopSignInButton(){
    Navigator.pushNamed(context, '/login');
  }
  @override
  void dispose() {
    _otpTEController.dispose();
    super.dispose();
  }
}