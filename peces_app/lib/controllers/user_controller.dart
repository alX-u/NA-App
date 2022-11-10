import 'package:get/get.dart';

class UserController extends GetxController {

  final RxString _userEmail = ''.obs;

  String get userEmail => _userEmail.value; 

}