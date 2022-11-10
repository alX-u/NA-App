// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:peces_app/pages/general/GeneralPage.dart';
import 'package:peces_app/pages/login/RegistroPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:peces_app/service/Auth_Service.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

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
  AuthClass authClass = AuthClass();

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
          color: Colors.lightBlue[900],
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //Título de la app
              Row(
                children: const [
                  SizedBox(width: 100),
                  Icon(MdiIcons.shipWheel, color: Colors.white, size: 43),
                  Text('NA App',
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
              itemTexto('Email', _emailController, false),
              const SizedBox(height: 10),
              //Input text para la contraseña
              itemTexto('Contraseña', _passwordController, true),
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
                            color: Colors.white,
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
              googleBoton(),
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
  Widget googleBoton() {
    return InkWell(
      onTap: () async {
        await authClass.googleSignIn(context);
        if (authClass.auth.currentUser!.email != null) {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const GeneralPage()));
        }
      },
      child: Container(
        width: MediaQuery.of(context).size.width - 70,
        height: 55,
        //Carta que representa el botón de ingreso con Google
        child: Card(
          color: const Color(0xFF9E1711),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.center, children: const [
            Icon(MdiIcons.google, color: Colors.black),
            SizedBox(width: 5),
            Text(
              'Ingresa Con Google',
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  shadows: <Shadow>[
                    Shadow(
                        offset: Offset(2.0, 2.0),
                        blurRadius: 3.0,
                        color: Color.fromARGB(255, 0, 0, 0))
                  ]),
            )
          ]),
        ),
      ),
    );
  }

  //Widget para los textfield de llenado de información
  Widget itemTexto(
      String name, TextEditingController controller, bool verTexto) {
    return Container(
      width: MediaQuery.of(context).size.width - 70,
      height: 50,
      child: TextFormField(
        controller: controller,
        style: const TextStyle(color: Colors.white),
        obscureText: verTexto,
        decoration: InputDecoration(
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
          UserCredential userCredential = await auth.signInWithEmailAndPassword(
              email: _emailController.text.trim(),
              password: _passwordController.text.trim());
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
        decoration: const BoxDecoration(color: Colors.white),
        child: Center(
            //Cambiamos el texto con un círculo de carga
            child: circulo
                ? const CircularProgressIndicator(color: Colors.black)
                : Text(nombre,
                    style: const TextStyle(color: Colors.black, fontSize: 16))),
      ),
    );
  }
}
