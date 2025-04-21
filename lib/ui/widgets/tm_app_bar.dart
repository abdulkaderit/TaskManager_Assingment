import 'package:flutter/material.dart';
import 'package:task_liveclass/ui/controllers/auth_controller.dart';

import '../screens/login_screen.dart';
import '../screens/update_profile_screen.dart';
class TMAppBar extends StatelessWidget implements PreferredSizeWidget{
  const TMAppBar({
    super.key,
  });



  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return AppBar(
      backgroundColor: Colors.blueAccent,
      title: GestureDetector(
        onTap: (){
          _onTapProfileSection(context);
          },
        child: Row(
          children: [
            CircleAvatar(
              radius: 22,
            ),
            const SizedBox(width: 8,),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(AuthController.userModel?.fulName ??'',
                    style: textTheme.bodyLarge?.copyWith(color: Colors.white),),
                  Text(AuthController.userModel?. email ??'Unknown',
                    style: textTheme.bodySmall?.copyWith(color: Colors.white),)
                ],
              ),
            ),
            IconButton(onPressed: () => _onTapLogOutButton(context),
                icon: Icon(Icons.logout, color: Colors.white,))
          ],
        ),
      ),
    );
  }

  void _onTapProfileSection(BuildContext context) {
    Navigator.push(context,
      MaterialPageRoute(builder: (context) => const UpdateProfileScreen(),),);
  }

  Future<void> _onTapLogOutButton(BuildContext context) async {
    await AuthController.clearUserData();

    Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (context) => const LoginScreen(),),
            (predicate) => false
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}