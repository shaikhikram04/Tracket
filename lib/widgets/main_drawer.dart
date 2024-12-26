import 'package:flutter/material.dart';
import 'package:tracket/resources/firebase_auth_methods.dart';
import 'package:tracket/authentication/auth_screen.dart';
import 'package:tracket/utils/colors.dart';
import 'package:tracket/utils/utils.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    Future<void> logoutUser() async {
      final result = await FirebaseAuthMethods.logoutUser();
      if (!context.mounted) return;
      if (result != 'success') {
        showSnackBar(result, context);
      } else {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const AuthScreen(),
          ),
          (route) => false,
        );
      }
    }

    return Drawer(
      backgroundColor: lightBackgroundColor,
      width: width * 0.7,
      child: Column(
        children: [
          DrawerHeader(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  lightDrawerBgColor,
                  lightDrawerBgColor.withOpacity(0.7),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Row(
              children: [
                const CircleAvatar(
                  backgroundImage: AssetImage(
                    'assets/images/Default_user_pfp.jpg',
                  ),
                  radius: 40,
                ),
                const SizedBox(width: 18),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Username',
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge!
                          .copyWith(color: onLightDrawer),
                    ),
                    Text(
                      'Role',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(color: onLightDrawer),
                    )
                  ],
                ),
              ],
            ),
          ),
          ListTile(
            tileColor: const Color.fromARGB(255, 221, 237, 221),
            leading: const Icon(
              Icons.logout,
              size: 26,
              color: Colors.red,
            ),
            title: Text(
              'Logout',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(color: Colors.red),
            ),
            onTap: logoutUser,
          ),
        ],
      ),
    );
  }
}
