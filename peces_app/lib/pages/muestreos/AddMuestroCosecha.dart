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
  TextEditingController rendimientoController = TextEditingController();
  DateTime? _fechaController;
  String? fecha;
  String biomasaInicial = '';
  String areaTanque = '';
  //Obtenemos la referencia a la collection 'usuario' que se encuentra en nuestra base de datos
  var usuarios = userFirebase;
  // Initial Selected Value
  String dropdownvalue = 'Escoja una Siembra';

  // List of items in our dropdown menu
  List<String> items = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    obtenerSiembras();
  }

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
                        style: estiloTexto(22)),
                    const SizedBox(height: 20),
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
                        const Icon(MdiIcons.weightKilogram,
                            color: Color.fromARGB(255, 101, 170, 254))),
                    const SizedBox(height: 15),
                    //Campo que indica la producción final (esto tiene que calcularse)
                    campoCalculado(
                        'Producción Final',
                        'Kg',
                        const Icon(MdiIcons.chartLine,
                            color: Color.fromARGB(255, 101, 170, 254)),
                        getProduccionFinal(biomasaInicial,
                            biomasaFinalController.text.trim())),
                    const SizedBox(height: 15),
                    //Campo que indica el rendimiento (esto tiene que calcularse)
                    campoCalculado(
                        'Rendimiento Final',
                        'Kg/m^2',
                        const Icon(MdiIcons.chartBox,
                            color: Color.fromARGB(255, 101, 170, 254)),
                        getRendimientoFinal(
                            produccionFinalController.text, areaTanque)),
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
    return SizedBox(
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
                borderRadius: BorderRadius.all(Radius.circular(7.0)),
                borderSide: BorderSide(
                    color: Color.fromARGB(255, 101, 170, 254), width: 3)),
            enabledBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(7.0)),
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
                //Aquí va el código para cambiar los valores de la biomasa inicial y el tamaño del tanque
                for (var i = 0; i < userController.listaSiembras.length; i++) {
                  if (_value == userController.listaSiembras[i]['fecha'] &&
                      userController.listaSiembras[i]['lote'] ==
                          userController.userLote) {
                    biomasaInicial =
                        userController.listaSiembras[i]['biomasa_inicial'];
                    areaTanque = userController.listaSiembras[i]['area'];
                    debugPrint(
                        'Biomasa Inicial de la siembra: ' + biomasaInicial);
                    debugPrint('Área de la siembra: ' + areaTanque);
                  }
                }
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
          'siembra': dropdownvalue,
          'peces_cosechados': pecesCosechadosController.text.trim(),
          'biomasa_final': biomasaFinalController.text.trim(),
          'produccion_final': produccionFinalController.text.trim(),
          'rendimiento_final': rendimientoController.text.trim()
        };
        //Nos aseguramos de que la información no esté vacía
        if (dropdownvalue != 'Escoja una siembra' &&
            pecesCosechadosController.text != '' &&
            biomasaFinalController.text != '' &&
            biomasaFinalController.text != '' &&
            rendimientoController.text != '') {
          try {
            //Llamamos a la función que añadirá la información a la spreadsheet
            // await sheetsAPI.insert([info]);

            //Enviamos la información a la base de datos
            addMuestreoCosecha(userController.userEmail, map);
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

  //Función que añadirá el muestreo de siembra a la base de datos
  void addMuestreoCosecha(email, map) async {
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
    List<dynamic> muestreoCosechaUsuario = user.docs[0]['muestreo_cosecha'];
    //Añadimos un muestreo de siembra a la lista de muestreos del usuario
    muestreoCosechaUsuario.add(muestreo);
    //Actualizamos la información del usuario con el nuevo muestreo incluido
    usuarios.doc(userID).update({'muestreo_cosecha': muestreoCosechaUsuario});
  }

  //Función que calculará el valor de la produccion final
  TextEditingController getProduccionFinal(
      String biomasaInicial, String biomasaFinal) {
    if (biomasaInicial != '' && biomasaFinal != '') {
      produccionFinalController.text =
          (double.parse(biomasaFinal) - double.parse(biomasaInicial))
              .toString();
      return produccionFinalController;
    } else {
      produccionFinalController.text = '';
      return produccionFinalController;
    }
  }

  //Función que calculará el valor del rendimiento final
  TextEditingController getRendimientoFinal(String produccion, String area) {
    if (produccion != '' && area != '') {
      rendimientoController.text =
          (double.parse(produccion) / double.parse(area)).toString();
      return rendimientoController;
    } else {
      rendimientoController.text = '';
      return rendimientoController;
    }
  }

  //Widget para los campos que serán calculados
  Widget campoCalculado(String titulo, String unidad, Icon icono,
      TextEditingController controller) {
    return TextField(
        style: const TextStyle(color: Colors.white),
        readOnly: true,
        controller: controller,
        decoration: InputDecoration(
          prefixIcon: icono,
          suffixText: unidad,
          suffixStyle: const TextStyle(color: Colors.white),
          labelText: titulo,
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
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
              borderSide: BorderSide(
                  color: Color.fromARGB(255, 101, 170, 254), width: 3)),
          enabledBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
              borderSide: BorderSide(color: Colors.white, width: 1.3)),

          //contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 15)
        ));
  }

  //Función para obtener las fechas de la lista de siembras
  void obtenerSiembras() {
    for (var i = 0; i < userController.listaSiembras.length; i++) {
      if (userController.listaSiembras[i]['lote'] == userController.userLote) {
        items.add(userController.listaSiembras[i]['fecha']);
      }
    }
  }
}
