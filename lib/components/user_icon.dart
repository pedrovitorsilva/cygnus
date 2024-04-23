import 'package:flutter/material.dart';
import 'package:cygnus/state.dart';

class UserIcon extends StatelessWidget {
  final bool hasUser;
  final VoidCallback onLogout;
  final VoidCallback onLogin;

  const UserIcon({
    super.key,
    required this.hasUser,
    required this.onLogout,
    required this.onLogin,
  });

  @override
  Widget build(BuildContext context) {
    if (hasUser) {
      return GestureDetector(
        onTap: onLogout,
        child: Padding(
          padding: const EdgeInsets.only(top: 2, right: 15, left: 11),
          child: CircleAvatar(
            backgroundImage: NetworkImage(
              stateApp.user?.photoUrl ?? "",
            ),
            radius: 11,
          ),
        ),
      );
    } else {
      return IconButton(
        onPressed: onLogin,
        icon: const Icon(Icons.account_circle_rounded),
      );
    }
  }
}
