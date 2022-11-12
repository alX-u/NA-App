// ignore_for_file: file_names
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:peces_app/pages/general/GeneralPage.dart';
import 'package:peces_app/pages/login/InicioSesionPage.dart';
import 'package:peces_app/service/Auth_Service.dart';

class RegistroPage extends StatefulWidget {
  const RegistroPage({Key? key}) : super(key: key);

  @override
  _RegistroPageState createState() => _RegistroPageState();
}

class _RegistroPageState extends State<RegistroPage> {
  FirebaseAuth auth = FirebaseAuth.instance;
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _repasswordController = TextEditingController();

  bool circulo = false;
  AuthClass authClass = AuthClass();

  //Build del contexto
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
              image: AssetImage("assets/registrationpage.jpg"),
              fit: BoxFit.cover),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //Título de la App
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
              const SizedBox(height: 30),
              //Subtítulo de Registrarse
              const Text('Regístrate',
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
              //Input para el nombre del usuario
              itemTexto('Nombre Completo', _nombreController, false),
              const SizedBox(height: 10),
              //Input text para el email
              itemTexto('Email', _emailController, false),
              const SizedBox(height: 10),
              //Input text para la contraseña
              itemTexto('Contraseña', _passwordController, true),
              const SizedBox(height: 15),
              //Confirmar Contraseña
              itemTexto('Confirmar Contraseña', _repasswordController, true),
              const SizedBox(height: 15),
              //Botón de registrarse
              boton('Regístrarse'),
              const SizedBox(height: 15),
              //Texto en pantalla sobre ir a inicio de sesión
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text('¿Ya tienes una cuenta? ', style: estiloTexto(16)),
                //Si se hunde aquí se va hacia la pantalla de inicio de sesión
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const InicioSesionPage()));
                  },
                  child: const Text('¡Inicia sesión AQUÍ!',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          shadows: <Shadow>[
                            Shadow(
                                offset: Offset(2.0, 2.0),
                                blurRadius: 3.0,
                                color: Color.fromARGB(255, 0, 0, 0))
                          ],
                          fontWeight: FontWeight.bold)),
                )
              ]),
              const SizedBox(height: 15),
            ],
          ),
        ),
      ),
    );
  }
//-----------------------------------------------------------------------------------------------------------------------------------------
  //WIDGETS Y MÉTODOS

  //Estilo de texto para los textos normales
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
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const GeneralPage()));
      },
      child: Container(
        width: MediaQuery.of(context).size.width - 70,
        height: 55,
        //Carta que representa el botón de ingreso con Google
        child: Card(
          color: const Color(0xFF9E1711),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.center, children: const [
            Text(
              'Regístrate Con Google',
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

  //Widget para los textfields de información
  Widget itemTexto(
      String name, TextEditingController controller, bool ocultarTexto) {
    return Container(
      width: MediaQuery.of(context).size.width - 70,
      height: 50,
      child: TextFormField(
        obscureText: ocultarTexto,
        style: const TextStyle(color: Colors.white),
        controller: controller,
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

  //Widget para el botón de registro
  Widget boton(String nombreBoton) {
    return InkWell(
      onTap: () async {
        setState(() {
          circulo = true;
        });
        //Credencial del usuario. Nos servirá para realizar el registro de usuario con Firebase Auth
        if (_passwordController.text.trim() ==
            _repasswordController.text.trim()) {
          try {
            UserCredential userCredential =
                await auth.createUserWithEmailAndPassword(
                    email: _emailController.text.trim(),
                    password: _passwordController.text.trim());
            //Accedemos a la collection
            var usuarios = FirebaseFirestore.instance.collection('usuario');
            //Añadimos el usuario a la base de datos
            List<String> lotes = [];
            await usuarios.add({
              'propietario': _nombreController.text.trim(),
              'lotes': lotes,
              'email': _emailController.text.trim(),
              'spreadsheet': ''
            });
            print(userCredential.user!.email);
            setState(() {
              circulo = false;
            });
            showDialog(
                context: context,
                builder: (context) => AlertDialog(
                      title: const Text("Registro Exitoso"),
                      content: const Text("Gracias por registrarte"),
                      actions: <Widget>[
                        TextButton(
                            onPressed: () {
                              //Vamos hacia la página de Inicio de Sesión
                              Navigator.pop(context, true);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const InicioSesionPage()));
                              //Borramos el texto escrito en los textfield
                              _nombreController.clear();
                              _emailController.clear();
                              _passwordController.clear();
                            },
                            child: const Text("OK"))
                      ],
                    ));
          } on Exception catch (e) {
            //Mostramos un mensaje por snackbar indicando si hay algún error
            final snackbar = SnackBar(content: Text(e.toString()));
            ScaffoldMessenger.of(context).showSnackBar(snackbar);
            setState(() {
              circulo = false;
            });
          }
        } else {
          const snackbar = SnackBar(
              content: Text('Asegúrese de que las contraseñas sean iguales'));
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
            child: circulo
                ? const CircularProgressIndicator(color: Colors.black)
                : Text(nombreBoton,
                    style: const TextStyle(color: Colors.black, fontSize: 16))),
      ),
    );
  }
}
