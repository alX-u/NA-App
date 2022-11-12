import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:peces_app/service/Auth_Service.dart';

class UserController extends GetxController {
  FirebaseAuth auth = FirebaseAuth.instance;
  final RxString _userEmail = ''.obs;
  final RxString _userLote = 'Ejemplo'.obs;
  final RxInt _userLotePos = 0.obs;

  String get userEmail => _userEmail.value;
  String get userLote => _userLote.value;
  int get userLotePos => _userLotePos.value;

  void setUserEmail() {
    AuthClass authClass = AuthClass();
    _userEmail.value = authClass.auth.currentUser!.email!;
  }

  Future<void> googleSignIn(BuildContext context) async {
    AuthClass authClass = AuthClass();
    await authClass.googleSignIn(context);
  }

  Future<void> signIn(String email, String password) async {
    UserCredential userCredential =
        await auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<void> signUp(String email, String password) async {
    UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email, password: password);
  }

  Future<void> logOut() async {
    AuthClass authClass = AuthClass();
    await authClass.logOut();
  }

  Future<String?> getToken() async {
    AuthClass authClass = AuthClass();
    return await authClass.guardarToken();
  }

  //Aquí obtenemos el nombre y la posición del lote que decida el usuario en el menú principal
  void getUserLote(String nombre, int pos) {
    _userLote.value = nombre;
    _userLotePos.value = pos;
  }
}