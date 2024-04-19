// ignore_for_file: unnecessary_getters_setters
import 'package:google_sign_in/google_sign_in.dart';

class User {
  String? _name = "";
  String? get name => _name;
  set name(String? name) {
    _name = name;
  }

  String _email = "";
  String get email => _email;
  set email(String email) {
    _email = email;
  }

  late String? _photoUrl;
  String get photoUrl => _photoUrl ?? "";
  set photoUrl(String photoUrl) {
    _photoUrl = photoUrl;
  }

  User(String? name, String email, String? photoUrl) {
    _name = name;
    _email = email;
    _photoUrl = photoUrl;
  }
}

class Autenticator {
  static Future<User> login() async {
    final gUser = await GoogleSignIn().signIn();
    final user = User(gUser!.displayName, gUser.email,gUser.photoUrl); // Renamed variable

    return user;
  }

  static Future<User?> recoverUser() async {
    User? user; // Renamed variable

    final gSignIn = GoogleSignIn();
    if (await gSignIn.isSignedIn()) {
      await gSignIn.signInSilently();

      final gUser = gSignIn.currentUser;
      if (gUser != null) {
        user = User(
            gUser.displayName, gUser.email, gUser.photoUrl); // Renamed variable
      }
    }

    return user;
  }

  static Future<void> logout() async {
    await GoogleSignIn().signOut();
  }
}
