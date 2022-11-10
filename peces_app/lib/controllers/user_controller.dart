import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:peces_app/service/Auth_Service.dart';

class UserController extends GetxController {
  final RxString _userEmail = ''.obs;

  String get userEmail => _userEmail.value;

  void setUserEmail() {
    AuthClass authClass = AuthClass();
    _userEmail.value = authClass.auth.currentUser!.email!;
  }

  Future<void> googleSignIn(BuildContext context) async {
    AuthClass authClass = AuthClass();
    await authClass.googleSignIn(context);
  }
}
