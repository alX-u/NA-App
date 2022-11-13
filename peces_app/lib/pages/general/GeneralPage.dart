// ignore_for_file: file_names
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:peces_app/domain/constants/firebase_constants.dart';
import 'package:peces_app/pages/login/InicioSesionPage.dart';
import 'package:peces_app/pages/general/ResumenMuestreoPage.dart';

import '../../domain/controllers/user_controller.dart';

class GeneralPage extends StatefulWidget {
  const GeneralPage({Key? key}) : super(key: key);

  @override
  _GeneralPageState createState() => _GeneralPageState();
}

class _GeneralPageState extends State<GeneralPage> {
  final TextEditingController _nombreAddLote = TextEditingController();
  final TextEditingController _nombreDelLote = TextEditingController();
  UserController userController = Get.find();
  //Obtenemos la referencia a la collection 'usuario' que se encuentra en nuestra base de datos
  var usuarios = userFirebase;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //Color de fondo de la page en general
        backgroundColor: const Color.fromARGB(255, 77, 82, 92),
        //Barra de arriba
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: false,
          //Título de la barra
          title: const Center(
              child: Icon(
            MdiIcons.shipWheel,
            size: 45,
          )),

          //Color de fondo de la barra
          backgroundColor: const Color.fromARGB(255, 55, 57, 65),
        ),
        //Barra de abajo
        bottomNavigationBar: BottomNavigationBar(
          unselectedItemColor: Colors.white,
          unselectedFontSize: 14,
          backgroundColor: const Color.fromARGB(255, 58, 59, 61),
          fixedColor: Colors.white,
          items: [
            //Botón de cerrar sesión
            BottomNavigationBarItem(
              icon: InkWell(
                onTap: () async {
                  showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                            title: const Text("Cerrar sesión"),
                            content: const Text("¿Desea cerrar su sesión?"),
                            actions: <Widget>[
                              //Botón de sí para cerrar sesión
                              TextButton(
                                  onPressed: () async {
                                    await userController.logOut();
                                    //Nos movemos a la pantalla de inicio de sesión
                                    //Vamos hacia la página de Inicio de Sesión
                                    Navigator.pop(context, true);
                                    Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                            builder: (builder) =>
                                                const InicioSesionPage()),
                                        (route) => false);
                                  },
                                  child: const Text("Sí")),
                              //Botón de no para cerrar sesión
                              TextButton(
                                  onPressed: () {
                                    Navigator.pop(context, true);
                                  },
                                  child: const Text('No'))
                            ],
                          ));
                },
                child: const Icon(
                  Icons.logout_rounded,
                  size: 30,
                  color: Colors.white,
                ),
              ),
              label: 'Cerrar Sesión',
            ),
            //Botón de borrar un lote
            BottomNavigationBarItem(
                icon: InkWell(
                  onTap: () async {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          //Añadiremos un lote, pidiéndole al usuario el número del lote
                          title: const Text('Borre un lote'),
                          //Número escogido
                          content: TextField(
                            controller: _nombreDelLote,
                            decoration: const InputDecoration(
                                hintText: "Nombre del lote a borrar"),
                          ),
                          actions: [
                            //Cancelar proceso
                            TextButton(
                              child: const Text('Cancelar'),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                            //Realizar proceso
                            TextButton(
                              child: const Text('OK'),
                              onPressed: () {
                                deleteLote(_nombreDelLote.text.trim(),
                                    userController.userEmail);
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        );
                      },
                    );
                    //Borramos un lote
                    _nombreDelLote.clear();
                  },
                  child: const Icon(
                    Icons.delete,
                    size: 30,
                    color: Colors.white,
                  ),
                ),
                label: 'Borrar Lote'),
            //Botón de añadir un lote
            BottomNavigationBarItem(
                icon: InkWell(
                  onTap: () async {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          //Añadiremos un lote, pidiéndole al usuario el número del lote
                          title: const Text('Añada un lote'),
                          //Número escogido
                          content: TextField(
                            controller: _nombreAddLote,
                            decoration: const InputDecoration(
                                hintText: "Añada el nombre del lote"),
                          ),
                          actions: [
                            //Cancelar proceso
                            TextButton(
                              child: const Text('Cancelar'),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                            //Realizar proceso
                            TextButton(
                              child: const Text('OK'),
                              onPressed: () {
                                addLote(_nombreAddLote.text.trim(),
                                    userController.userEmail);
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        );
                      },
                    );
                    //Borramos el campo
                    _nombreAddLote.clear();
                  },
                  child: const Icon(
                    Icons.add,
                    size: 30,
                    color: Colors.white,
                  ),
                ),
                label: 'Añadir Lote')
          ],
        ),
        //Cuerpo de la page
        body: StreamBuilder(
            stream: userFirebase.snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                    child: CircularProgressIndicator(color: Colors.white));
              }
              //Variable que guardará número de lotes de la persona
              int index = 0;
              //Guardo la posición del documento del usuario
              int pos = 0;
              //Utilizamos el email del usuario que se inició sesión
              String? emailUsuario = userController.userEmail;
              //Reviso la cantidad de lotes que tiene el usuario que inicio sesión
              for (var i = 0; i < snapshot.data!.docs.length; i++) {
                if (snapshot.data!.docs[i]['email'] == emailUsuario) {
                  pos = i;
                  index = snapshot.data!.docs[i]['lotes'].length;
                }
              }
              //Se muestra el item que corresponde al lote del usuario
              return ListView.builder(
                  itemCount: index,
                  itemBuilder: (context, index) {
                    //Se muestra la card usando el índice
                    return loteItem(
                        snapshot.data!.docs[pos]['lotes'][index], index);
                  });
            }));
  }

//----------------------------------------------------------------------------------------------------------------------------
  //WIDGETS Y MÉTODOS

  //Estilo del texto
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

  //Widget encargado de cada item de los lotes
  Widget loteItem(String title, int index) {
    return InkWell(
      onTap: () {
        //Obtenemos de forma global los valores del nombre del lote y su posición
        userController.getUserLote(title, index);
        //Aquí enviamos también el index para saber a qué lote accede la persona
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const ResumenMuestreoPage()));
      },
      child: SizedBox(
        //El ancho del widget será el del contexto
        width: MediaQuery.of(context).size.width,
        child: Row(
          children: [
            //Permite que el container ocupe todo el espacio disponible
            Expanded(
              child: SizedBox(
                  height: 75,
                  //Card que hará de botón para acceder a cada lote
                  child: Card(
                      //Forma de la card
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      //Color de la card
                      color: Colors.white,
                      child: Row(
                        children: [
                          //Espacio entre el borde del container y el ícono
                          const SizedBox(width: 15),
                          const SizedBox(
                              height: 33,
                              width: 36,
                              child: Icon(MdiIcons.fish)),
                          const SizedBox(width: 15),
                          //Texto de la card
                          Text(title,
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5,
                                  fontSize: 18)),
                        ],
                      ))),
            )
          ],
        ),
      ),
    );
  }

  //Método por el cual añadimos un lote a la cuenta de lotes del usuario
  void addLote(String nombreAddLote, String email) async {
    //Utilizamos el email del usuario que se inició sesión
    String? emailUsuario = email;
    //Printeo para ver si lo recibe bien (tanto en el caso de Google como en el normal)
    debugPrint(emailUsuario);
    //Realizamos una consulta en la base de datos sobre el usuario con ese email
    var query = usuarios.where('email', isEqualTo: emailUsuario);
    //Extraemos la consulta
    QuerySnapshot user = await query.get();
    //Obtenemos el id del usuario en la base de datos para realizar
    var userID = user.docs[0].id;
    //Obtenemos la lista de lotes del usuario
    List<dynamic> lotesUsuario = user.docs[0]['lotes'];
    //Añadimos un lote a la lista de lotes del usuario
    lotesUsuario.add('Lote ' + nombreAddLote);
    //Actualizamos la información del usuario con el nuevo lote incluido
    usuarios.doc(userID).update({'lotes': lotesUsuario});
  }

  void deleteLote(String nombreDelLote, String email) async {
    //Utilizamos el email del usuario que se inició sesión
    String? emailUsuario = email;
    //Printeo para ver si lo recibe bien (tanto en el caso de Google como en el normal)
    debugPrint(emailUsuario);
    //Realizamos una consulta en la base de datos sobre el usuario con ese email
    var query = usuarios.where('email', isEqualTo: emailUsuario);
    //Extraemos la consulta
    QuerySnapshot user = await query.get();
    //Obtenemos el id del usuario en la base de datos para realizar
    var userID = user.docs[0].id;
    //Obtenemos la lista de lotes del usuario en cuestión
    List<dynamic> lotesUsuario = user.docs[0]['lotes'];
    int pos = 9999999;
    debugPrint(nombreDelLote);
    for (var i = 0; i < lotesUsuario.length; i++) {
      if (user.docs[0]['lotes'][i] == 'Lote ' + nombreDelLote) {
        pos = i;
      }
    }
    if (pos != 9999999) {
      lotesUsuario.removeAt(pos);
    } else {
      debugPrint('No se encuentra');
    }

    //Actualizamos la información del usuario, añadiendo un lote a su n_lotes
    usuarios.doc(userID).update({'lotes': lotesUsuario});
  }
}
