import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:peces_app/pages/general/GeneralPage.dart';
import 'package:peces_app/pages/login/InicioSesionPage.dart';
import 'package:peces_app/service/Auth_Service.dart';

import 'domain/controllers/user_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp().then((value) {
    Get.put(UserController());
    runApp(const MyApp());
  });
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  AuthClass authClass = AuthClass();
  UserController userController = Get.find();
  Widget currentPage = const InicioSesionPage();

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
    //Inicializamos
    verificarLoggeo();
  }

  //Verificamos si ya hay una cuenta loggeada
  void verificarLoggeo() async {
    String? token = await userController.getToken();
    if (token != null) {
      setState(() {
        currentPage = const GeneralPage();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //Procedemos a la página de Inicio de sesión de Usuarios
      theme: ThemeData(fontFamily: "Kanit"),
      home: currentPage,
    );
  }
}
