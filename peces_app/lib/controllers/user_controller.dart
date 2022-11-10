import 'package:get/get.dart';

class UserController extends GetxController {

  final RxString _userEmail = RxString('Hola');

  String get userEmail => _userEmail.value; 

}