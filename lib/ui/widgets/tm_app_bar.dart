import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:task_liveclass/ui/controllers/auth_controller.dart';

class TMAppBar extends StatelessWidget implements PreferredSizeWidget{
  final VoidCallback? onUpdate;
  final bool? fromProfileScreen;
  const TMAppBar({super.key, this.fromProfileScreen, this.onUpdate,});



  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return AppBar(
      backgroundColor: Colors.blueAccent,
      title: GestureDetector(
        onTap: (){
          if (fromProfileScreen ?? false) {
            return;
          }
          _onTapProfileUpdate(context);
          },
        child: Row(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundImage:
              shouldShowImage(AuthController.userInfoModel?.photo)
                  ? MemoryImage(
                base64Decode(AuthController.userInfoModel?.photo ?? ''),
              )
                  : null,
            ),
            const SizedBox(width: 8,),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(AuthController.userInfoModel?.fulName ??'',
                    style: textTheme.bodyLarge?.copyWith(color: Colors.white),),
                  Text(AuthController.userInfoModel?. email ??'Unknown',
                    style: textTheme.bodySmall?.copyWith(color: Colors.white),)
                ],
              ),
            ),
            IconButton(onPressed: () => _onTapLogOut(context),
                icon: Icon(Icons.logout, color: Colors.white,))
          ],
        ),
      ),
    );
  }

  Future<void> _onTapLogOut(context) async {
    await AuthController.clearUserData();
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  void _onTapProfileUpdate(BuildContext context) {
    Navigator.pushNamed(
        context,
        '/UpdateProfileScreen',
        arguments: (){
          // AuthController.getUserInformation();
          onUpdate!();
          Logger().w('Got the notifier from TMAPP Bar');
        }
    );
  }

  fullName({required String firstName, required String lastName}) {
    return '$firstName $lastName';
  }

  bool shouldShowImage(String? photo) {
    return photo != null && photo.isNotEmpty;
  }
}