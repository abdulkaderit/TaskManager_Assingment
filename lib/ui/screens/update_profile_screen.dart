import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:task_liveclass/data/models/user_model.dart';
import 'package:task_liveclass/ui/controllers/auth_controller.dart';
import 'package:task_liveclass/ui/widgets/centered_circular_progress_indicator.dart';
import '../../data/models/profile_details_model.dart';
import '../../data/service/network_client.dart';
import '../../data/utils/urls.dart';
import '../widgets/screen_background.dart';
import '../widgets/tm_app_bar.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({super.key});

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {

  final TextEditingController _fistNameTEController = TextEditingController();
  final TextEditingController _lastNameTEController = TextEditingController();
  final TextEditingController _mobileTEController = TextEditingController();
  final TextEditingController _emailTEController = TextEditingController();
  final TextEditingController _passwordTEController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ImagePicker _imagePicker = ImagePicker();
  bool _updateProfileInProgress = false;
  bool passwordVisibility = true;

  _passwordVisibilityStateControl(){
    setState(() {
      passwordVisibility = !passwordVisibility;
    });
  }

  XFile? _pickedImage;

  @override
  void initState(){
    UserModel userModel = AuthController.userInfoModel!;
    _emailTEController.text = userModel.email;
    _fistNameTEController.text = userModel.firstName;
    _lastNameTEController.text = userModel.lastName;
    _mobileTEController.text = userModel.mobile;
    super.initState();
  }

  VoidCallback? onUpdate;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)!.settings.arguments as VoidCallback;
    onUpdate = args;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TMAppBar(fromProfileScreen: true),
      body: ScreenBackground(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),
                  Text('Update Profile',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 18),
                  _buildPhotoPickerWidgets(),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _emailTEController,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.emailAddress,
                    enabled: false,
                    decoration: const InputDecoration(
                        hintText: 'Email'
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _fistNameTEController,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                        hintText: 'First Name'
                    ),
                    validator: (String? value) {
                      if (value?.trim().isEmpty ?? true) {
                        return 'Enter your first name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _lastNameTEController,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                        hintText: 'Last Name'
                    ),
                    validator: (String? value) {
                      if (value?.trim().isEmpty ?? true) {
                        return 'Enter your Last name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _mobileTEController,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                        hintText: 'Mobile Number'
                    ),
                    validator: (String? value) {
                      String phone = value?.trim() ?? '';
                      RegExp regExp = RegExp(r"^(?:\+?88|0088)?01[15-9]\d{8}$");
                      if (regExp.hasMatch(phone) == false) {
                        return 'Enter your valid phone';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    obscureText: true,
                    controller: _passwordTEController,
                    decoration: InputDecoration(
                        suffixIcon: IconButton(
                          onPressed: _passwordVisibilityStateControl,
                          icon:
                          passwordVisibility
                              ? Icon(Icons.visibility)
                              : Icon(Icons.visibility_off),
                        ),
                        hintText: 'Password'
                    ),
                  ),
                  const SizedBox(height: 16),
                  Visibility(
                    visible: _updateProfileInProgress == false,
                    replacement: const CenteredCircularProgressIndicator(),
                    child: ElevatedButton(
                      onPressed: _onTapSubmitButton,
                      child: const Icon(Icons.arrow_circle_right_outlined),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPhotoPickerWidgets() {
    return GestureDetector(
      onTap: _onTapPhotoPicker,
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
        ),
        child: Row(
          children: [
            Container(
              height: 50,
              width: 80,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8),
                  bottomLeft: Radius.circular(8),
                ),
              ),
              child: Center(
                child: Text('Photo', style: TextStyle(color: Colors.white)),
              ),
            ),
            const SizedBox(width: 8),
            SizedBox(
              width: 210,
              child: Text(
                _pickedImage == null ? 'Select your photo' : _pickedImage!.name,
                overflow: TextOverflow.ellipsis,
                style: TextTheme.of(context).bodyLarge,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _onTapPhotoPicker() async {
    XFile? image = await _imagePicker.pickImage(source: ImageSource.gallery);
    if(image !=null){
      _pickedImage = image;
      setState(() {});
    }
  }

  void _onTapSubmitButton(){
    if(_formKey.currentState!.validate()){
      _updateProfile();
    }
  }

  bool isCamera = true;
  final Logger _logger = Logger();

  Future<void> _updateProfile() async{
    _updateProfileInProgress =true;
    setState(() {});

    Map<String, dynamic> requestBody ={
      "email":_emailTEController.text.trim(),
      "firstName":_fistNameTEController.text.trim(),
      "lastName":_lastNameTEController.text.trim(),
      "mobile":_mobileTEController.text.trim(),
    };
    if(_passwordTEController.text.isNotEmpty){
      requestBody["password"]= _passwordTEController.text;
    }
    if(_pickedImage != null){
      List<int> imageByte = await _pickedImage!.readAsBytes();
      String encodedImage = base64Encode(imageByte);
      requestBody['photo'] = encodedImage;
    }
    NetworkResponse response = await NetworkClient.postRequest(
        url: Urls.updateProfileUrl,
        body: requestBody
    );

    _updateProfileInProgress =false;
    setState(() {});

    if (response.statusCode == 200) {
      getProfileDetails();
      setState(() {});
    } else {
      _logger.e(response.errorMessage);
    }
  }

  Future<void> getProfileDetails() async {
    NetworkResponse response = await NetworkClient.getRequest(
      url: Urls.profileDetailsUrl,
    );
    if (response.statusCode == 200) {
      String token = AuthController.token!;

      Map<String, dynamic> userDetailsMap = response.data!['data'][0];
      _logger.w(userDetailsMap);
      UpdateProfileModel updateProfileModel = UpdateProfileModel.fromJson(
        response.data!,
      );

      Map<String, dynamic> prepareJsonDataForInitiatingUserModel = {
        "_id": updateProfileModel.data.id,
        "email": updateProfileModel.data.email,
        "firstName": updateProfileModel.data.firstName,
        "lastName": updateProfileModel.data.lastName,
        "mobile": updateProfileModel.data.mobile,
        "createdDate": updateProfileModel.data.createdDate,
        "photo": updateProfileModel.data.photo,
      };
      UserModel userModel = UserModel.fromJson(
        prepareJsonDataForInitiatingUserModel,
      );

      await AuthController.saveUserInformation(token, userModel);
      await AuthController.getUserInformation();
      if (AuthController.token != null) {
        _logger.i('State update Successfully ${AuthController.userInfoModel}');
        setState(() {});
        if(onUpdate != null){
          _logger.w('Got the notifier from update screen');
          onUpdate!();
        }else{
          _logger.e('Failed to got the notifier form profile update screen');
        }
      } else {
        _logger.e('Fail to update the state');
      }
    }
  }

  Future<void> imagePicker() async {
    final picker = ImagePicker();
    final pickFile = await picker.pickImage(
      source: isCamera ? ImageSource.camera : ImageSource.gallery,
    );
    if (pickFile != null) {
      setState(() {
        _pickedImage = pickFile;
      });
    }
  }

  void showAlertDialogue() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                height: 100,
                child: Column(
                  children: [
                    IconButton(
                      onPressed: () {
                        isCamera = true;
                        imagePicker();
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.camera, color: Colors.blue, size: 50),
                    ),
                    Text('Camera'),
                  ],
                ),
              ),
              SizedBox(
                height: 100,
                child: Column(
                  children: [
                    IconButton(
                      onPressed: () {
                        isCamera = false;
                        imagePicker();
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.image, color: Colors.blue, size: 50),
                    ),
                    Text('Gallery'),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

}

