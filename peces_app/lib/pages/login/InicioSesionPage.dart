// ignore_for_file: file_names
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:peces_app/domain/constants/firebase_constants.dart';
import 'package:peces_app/pages/general/GeneralPage.dart';
import 'package:peces_app/pages/login/RegistroPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../domain/controllers/user_controller.dart';

class InicioSesionPage extends StatefulWidget {
  const InicioSesionPage({Key? key}) : super(key: key);

  @override
  _InicioSesionPage createState() => _InicioSesionPage();
}

class _InicioSesionPage extends State<InicioSesionPage> {
  FirebaseAuth auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool circulo = false;
  UserController userController = Get.find();
  var usuarios = userFirebase;

  @override
  Widget build(BuildContext context) {
    //Buildeamos el contexto de la página en un Scaffold
    return Scaffold(
      //Evitamos renderflex problems
      body: SingleChildScrollView(
        //El container contendrá nuestros widgets
        child: Container(
          //Ajustamos el tamaño del container al size del contexto
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          //Añadimos un color azul
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/loginpage.jpg"), fit: BoxFit.cover),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //Título de la app
              Row(
                children: const [
                  SizedBox(width: 100),
                  Icon(MdiIcons.shipWheel, color: Colors.white, size: 43),
                  Text('NA',
                      style: TextStyle(
                          fontSize: 38,
                          color: Color(0xFF65AAFE),
                          fontWeight: FontWeight.bold,
                          shadows: <Shadow>[
                            Shadow(
                                offset: Offset(2.0, 2.0),
                                blurRadius: 3.0,
                                color: Color.fromARGB(255, 0, 0, 0))
                          ])),
                  Text(' App',
                      style: TextStyle(
                          fontSize: 38,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          shadows: <Shadow>[
                            Shadow(
                                offset: Offset(2.0, 2.0),
                                blurRadius: 3.0,
                                color: Color.fromARGB(255, 0, 0, 0))
                          ])),
                ],
              ),
              //Espaciado
              const SizedBox(height: 20),
              //Subtítulo de Inicio de Sesión
              const Text('Inicia Sesión',
                  style: TextStyle(
                      fontSize: 28,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      shadows: <Shadow>[
                        Shadow(
                            offset: Offset(2.0, 2.0),
                            blurRadius: 3.0,
                            color: Color.fromARGB(255, 0, 0, 0))
                      ])),
              const SizedBox(height: 20),
              //Input text para el email
              itemTexto(
                  'Email',
                  const Icon(MdiIcons.email,
                      color: Color.fromARGB(255, 101, 170, 254)),
                  _emailController,
                  false),
              const SizedBox(height: 10),
              //Input text para la contraseña
              itemTexto(
                  'Contraseña',
                  const Icon(MdiIcons.lock,
                      color: Color.fromARGB(255, 101, 170, 254)),
                  _passwordController,
                  true),
              const SizedBox(height: 15),
              //Botón encargado de realizar el ingreso
              boton('Ingresar'),
              const SizedBox(height: 15),
              //Texto por si el usuario quiere registrarse
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text('¿Aún no tienes una cuenta? ', style: estiloTexto(16)),
                //Si se hunde aquí se va hacia la pantalla de registro de usuario
                InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const RegistroPage()));
                    },
                    child: const Text('¡Regístrate ya AQUÍ!',
                        style: TextStyle(
                            color: Color(0xFF65AAFE),
                            fontSize: 16,
                            shadows: <Shadow>[
                              Shadow(
                                  offset: Offset(2.0, 2.0),
                                  blurRadius: 3.0,
                                  color: Color.fromARGB(255, 0, 0, 0))
                            ],
                            fontWeight: FontWeight.bold)))
              ]),
              const SizedBox(height: 15),
              //Texto de separación
              Text('O', style: estiloTexto(18)),
              const SizedBox(height: 15),
              //Botón de inicio de sesión con Google
              Obx(() => googleBoton(userController.userEmail)),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
//--------------------------------------------------------------------------------------------------------------------------------------------
  //WIDGETS Y MÉTODOS

  //Estilo de Texto para los párrafos normales
  TextStyle estiloTexto(double size) {
    return TextStyle(
        color: Colors.white,
        fontSize: size,
        shadows: const <Shadow>[
          Shadow(
              offset: Offset(2.0, 2.0),
              blurRadius: 3.0,
              color: Color.fromARGB(255, 0, 0, 0))
        ]);
  }

  //Widget para el botón de Google
  Widget googleBoton(String emailUsuario) {
    return InkWell(
      onTap: () async {
        //Iniciamos sesión con google
        await userController.googleSignIn(context);
        //Utilizamos el email del usuario que se inició sesión
        String? emailUsuario = userController.userEmail;
        //Printeo para ver si lo recibe bien (tanto en el caso de Google como en el normal)
        debugPrint(emailUsuario);
        //Realizamos una consulta en la base de datos sobre el usuario con ese email
        var query = usuarios.where('email', isEqualTo: emailUsuario);
        //Extraemos la consulta
        QuerySnapshot user = await query.get();
        //Obtenemos el id del usuario en la base de datos para realizar
        var userID = user.docs[0].id;
        //Obtenemos la lista de siembras del usuario
        List<dynamic> siembras = user.docs[0]['muestreo_siembra'];
        List<dynamic> controles = user.docs[0]['muestreo_control'];
        //Enviamos esta lista para que se conozca de forma global
        await userController.setListaSiembras(siembras);
        await userController.setListaControles(controles);
        if (emailUsuario != '') {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const GeneralPage()));
        }
      },
      child: SizedBox(
        width: MediaQuery.of(context).size.width - 70,
        height: 55,
        //Carta que representa el botón de ingreso con Google
        child: Card(
          color: const Color(0xFFFFFFFF),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.center, children: const [
            Icon(MdiIcons.google, color: Colors.black),
            SizedBox(width: 5),
            Text(
              'Ingresa Con Google',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            )
          ]),
        ),
      ),
    );
  }

  //Widget para los textfield de llenado de información
  Widget itemTexto(String name, Icon icono, TextEditingController controller,
      bool verTexto) {
    return Container(
      width: MediaQuery.of(context).size.width - 70,
      height: 50,
      child: TextFormField(
        controller: controller,
        style: const TextStyle(color: Colors.white),
        obscureText: verTexto,
        decoration: InputDecoration(
            prefixIcon: icono,
            labelText: name,
            labelStyle: const TextStyle(
                fontSize: 15,
                color: Colors.white,
                shadows: <Shadow>[
                  Shadow(
                      offset: Offset(2.0, 2.0),
                      blurRadius: 3.0,
                      color: Color.fromARGB(255, 0, 0, 0))
                ]),
            focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white, width: 1)),
            enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white, width: 1.3))),
      ),
    );
  }

  //Widget para los botones normales
  Widget boton(String nombre) {
    return InkWell(
      onTap: () async {
        try {
          //Obtenemos las credenciales del usuario para iniciar sesión
          await userController.signIn(
              _emailController.text.trim(), _passwordController.text.trim());
          //Seteamos el email de usuario de forma global
          userController.setUserEmail();
          //Utilizamos el email del usuario que se inició sesión
          String? emailUsuario = userController.userEmail;
          //Printeo para ver si lo recibe bien (tanto en el caso de Google como en el normal)
          debugPrint(emailUsuario);
          //Realizamos una consulta en la base de datos sobre el usuario con ese email
          var query = usuarios.where('email', isEqualTo: emailUsuario);
          //Extraemos la consulta
          QuerySnapshot user = await query.get();
          //Obtenemos el id del usuario en la base de datos para realizar
          var userID = user.docs[0].id;
          //Obtenemos la lista de siembras del usuario
          List<dynamic> siembras = user.docs[0]['muestreo_siembra'];
          //Enviamos esta lista para que se conozca de forma global
          userController.setListaSiembras(siembras);
          //Vamos hacia la homepage
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const GeneralPage()));
          //Borramos el texto escrito en los textfield
          _emailController.clear();
          _passwordController.clear();
        } catch (e) {
          final snackbar = SnackBar(content: Text(e.toString()));
          ScaffoldMessenger.of(context).showSnackBar(snackbar);
          setState(() {
            circulo = false;
          });
        }
      },
      child: Container(
        width: MediaQuery.of(context).size.width - 70,
        height: 55,
        decoration: const BoxDecoration(color: Color(0xFF65AAFE)),
        child: Center(
            //Cambiamos el texto con un círculo de carga
            child: circulo
                ? const CircularProgressIndicator(color: Colors.black)
                : Text(nombre,
                    style: const TextStyle(color: Colors.white, fontSize: 16))),
      ),
    );
  }
}
