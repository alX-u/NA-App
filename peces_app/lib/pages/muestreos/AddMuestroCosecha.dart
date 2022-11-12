import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../domain/constants/firebase_constants.dart';
import '../../domain/controllers/user_controller.dart';
import '../general/GeneralPage.dart';
import '../general/ResumenMuestreoPage.dart';

class AddMuestreoCosecha extends StatefulWidget {
  const AddMuestreoCosecha({Key? key}) : super(key: key);

  @override
  State<AddMuestreoCosecha> createState() => _AddMuestreoCosechaState();
}

class _AddMuestreoCosechaState extends State<AddMuestreoCosecha> {
  UserController userController = Get.find();
  final TextEditingController pecesCosechadosController =
      TextEditingController();
  final TextEditingController biomasaFinalController = TextEditingController();
  final TextEditingController produccionFinalController =
      TextEditingController();
  final TextEditingController rendimientoController = TextEditingController();
  DateTime? _fechaController;
  String? fecha;
  //Obtenemos la referencia a la collection 'usuario' que se encuentra en nuestra base de datos
  var usuarios = userFirebase;
  // Initial Selected Value
  String dropdownvalue = 'Escoja una Siembra';
  // List of items in our dropdown menu
  var items = [
    'Item 1',
    'Item 2',
    'Item 3',
    'Item 4',
    'Item 5',
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        //Establecemos el tamaño del container con respecto al size y width del contexto
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        //Aplicamos un coloreado degradado para el background (se puede cambiar)
        decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [
          Color.fromARGB(255, 44, 44, 44),
          Color.fromARGB(255, 34, 34, 34),
          Color.fromARGB(255, 14, 14, 14)
        ])),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              //Flecha para devolverse al menú general
              Row(
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const ResumenMuestreoPage()));
                      },
                      icon: const Icon(Icons.keyboard_arrow_left,
                          color: Colors.white, size: 30)),
                ],
              ),
              Obx(() => Center(
                  child:
                      Text(userController.userLote, style: estiloTexto(36)))),
              //Cuerpo de la página con la información a rellenar
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Registra tu muestreo de cosecha:',
                        style: estiloTexto(28)),
                    const SizedBox(height: 30),
                    //Campo que indica la siembra sobre la que se hará la cosecha
                    listaDeSiembras(),
                    const SizedBox(height: 15),
                    //Campo que indica los peces cosechados
                    formField(
                        'Peces Cosechados',
                        pecesCosechadosController,
                        const Icon(MdiIcons.fish,
                            color: Color.fromARGB(255, 101, 170, 254))),
                    const SizedBox(height: 15),
                    //Campo que indica la biomasa final de la siembra
                    formField(
                        'Biomasa Final',
                        biomasaFinalController,
                        const Icon(MdiIcons.weightGram,
                            color: Color.fromARGB(255, 101, 170, 254))),
                    const SizedBox(height: 15),
                    //Campo que indica la producción final (esto tiene que calcularse)
                    formField(
                        'Producción Final',
                        produccionFinalController,
                        const Icon(MdiIcons.chartLine,
                            color: Color.fromARGB(255, 101, 170, 254))),
                    const SizedBox(height: 15),
                    //Campo que indica el rendimiento (esto tiene que calcularse)
                    formField(
                        'Rendimiento',
                        rendimientoController,
                        const Icon(MdiIcons.chartBox,
                            color: Color.fromARGB(255, 101, 170, 254))),
                    const SizedBox(height: 15),
                    botonEnviar()
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  //---------------------------------------------------------------------------------------------------------
// Widgets, métodos y herramientas utilizadas
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

  //Widget de los form fields donde el usuario colocará su información
  Widget formField(
      String textname, TextEditingController controller, Icon icono) {
    return Container(
      height: 55,
      width: MediaQuery.of(context).size.width,
      /*decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(13)),*/
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
            prefixIcon: icono,
            labelText: textname,
            labelStyle: const TextStyle(
                fontSize: 15,
                color: Colors.white,
                shadows: <Shadow>[
                  Shadow(
                      offset: Offset(2.0, 2.0),
                      blurRadius: 3.0,
                      color: Color.fromARGB(255, 0, 0, 0))
                ]),

            // border: InputBorder.none,
            focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                    color: Color.fromARGB(255, 101, 170, 254), width: 3)),
            enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white, width: 1.3))
            //contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 15)
            ),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
      ),
    );
  }

//Widgets y Métodos
  Widget inputLabel(String input) {
    return Text(input,
        style: const TextStyle(
            fontSize: 16,
            color: Colors.white,
            shadows: <Shadow>[
              Shadow(
                  offset: Offset(2.0, 2.0),
                  blurRadius: 3.0,
                  color: Color.fromARGB(255, 0, 0, 0))
            ],
            letterSpacing: 0.2));
  }

  //Función para la fecha
  Future pickDate() async {
    //Escogemos fecha inicial como el día de hoy
    final initialDate = DateTime.now();
    //Escogemos una nueva fecha
    final newDate = await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: DateTime(DateTime.now().year - 10),
        lastDate: DateTime(DateTime.now().year + 10));
    //Revisamos si es nulo
    if (newDate == null) return;
    //Seteamos el controller de la fecha como la newDate
    setState(() {
      _fechaController = newDate;
      //Enviaremos la fecha como un string al spreadsheet
      fecha =
          '${_fechaController!.year.toString()}/${_fechaController!.month.toString()}/${_fechaController!.day.toString()}';
      debugPrint('Soy la fecha que vas a enviar: ' + fecha!);
    });
  }

  //Función para el texto que se verá en el botón de escoger fecha
  String getTextFecha() {
    if (_fechaController == null) {
      return 'Seleccione una fecha';
    } else {
      return '${_fechaController!.year}/${_fechaController!.month}/${_fechaController!.day}';
    }
  }

  //Botón para escoger fecha
  Widget botonFecha() {
    return InkWell(
      onTap: () {
        pickDate();
      },
      child: Container(
        height: 60,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(13),
            color: Color.fromARGB(255, 70, 76, 83)),
        child: Center(
          child: Text(
            getTextFecha(),
            style: estiloTexto(18),
          ),
        ),
      ),
    );
  }

  Widget listaDeSiembras() {
    return DropdownButtonFormField(
        items: items.map((String item) {
          return DropdownMenuItem(
              child: Text(item, style: const TextStyle(color: Colors.white)),
              value: item);
        }).toList(),
        onChanged: (_value) => {
              setState(() {
                dropdownvalue = _value.toString();
              })
            },
        hint: Text(dropdownvalue, style: const TextStyle(color: Colors.white)),
        icon: const Icon(
          MdiIcons.fishbowl,
          color: Color.fromARGB(255, 101, 170, 254),
        ),
        dropdownColor: const Color.fromARGB(255, 101, 170, 254),
        decoration: const InputDecoration(
            labelText: 'Siembra',
            enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white)),
            labelStyle: TextStyle(
              color: Colors.white,
            )));
  }

  //Widget del botón para enviar el muestreo
  Widget botonEnviar() {
    return InkWell(
      onTap: () async {
        // String nombreLote = userController.userLote;
        //Inicializamos la clase sheetsAPI, pasando el email del usuario, esto decide la spreadsheet y la worksheet
        // await sheetsAPI.init(userController.userEmail, nombreLote);
        //Establecemos la información que vamos a pasar al spreadsheet en formato JSON
        // final info = {
        //   UserFields.pecesSembrados: _pecesSembradosController.text.trim(),
        //   UserFields.pesoSiembraPorUnidad:
        //       _pesoSiembraPorUnidadController.text.trim(),
        //   UserFields.fecha: fecha,
        // };

        //Mapeamos la información extraída del formulario
        Map map = {
          'lote': userController.userLote,
          'fecha': fecha,
        };
        //Nos aseguramos de que la información no esté vacía
        if (_fechaController != null) {
          try {
            //Llamamos a la función que añadirá la información a la spreadsheet
            // await sheetsAPI.insert([info]);

            //Enviamos la información a la base de datos
            addMuestreoSiembra(userController.userEmail, map);
            //Se mostrará después de realizar el registro
            showDialog(
                context: context,
                builder: (context) => AlertDialog(
                      title: const Text("Muestreo registrado exitósamente"),
                      content: const Text("Gracias por registrar su muestreo"),
                      actions: <Widget>[
                        TextButton(
                            onPressed: () {
                              //Vamos hacia la página de Inicio de Sesión
                              Navigator.pop(context, true);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const GeneralPage()));
                              //Borramos el texto escrito en los textfield
                              _fechaController == null;
                            },
                            child: const Text("OK"))
                      ],
                    ));
          } on Exception catch (e) {
            final snackbar = SnackBar(content: Text(e.toString()));
            ScaffoldMessenger.of(context).showSnackBar(snackbar);
          }
        } else {
          const snackbar = SnackBar(
              content: Text('Asegúrese de que todos los campos estén llenos'));
          ScaffoldMessenger.of(context).showSnackBar(snackbar);
        }
      },
      child: Container(
        height: 60,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [
              Color.fromARGB(255, 101, 170, 254),
              Color.fromARGB(255, 101, 170, 254),
              Color.fromARGB(255, 101, 170, 254)
            ]),
            borderRadius: BorderRadius.circular(13),
            color: Colors.white),
        child: Center(
          child: Text(
            'Enviar Muestreo',
            style: estiloTexto(18),
          ),
        ),
      ),
    );
  }

  void addMuestreoSiembra(email, map) async {
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
    //Mapeamos la información del muestreo de siembra
    Map muestreo = map;
    //Obtenemos la lista de muestreos de siembra del usuario
    List<dynamic> muestreosSiembraUsuario = user.docs[0]['muestreo_siembra'];
    //Añadimos un muestreo de siembra a la lista de muestreos del usuario
    muestreosSiembraUsuario.add(muestreo);
    //Actualizamos la información del usuario con el nuevo muestreo incluido
    usuarios.doc(userID).update({'muestreo_siembra': muestreosSiembraUsuario});
  }
}
