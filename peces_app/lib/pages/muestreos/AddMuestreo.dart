// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:peces_app/domain/constants/firebase_constants.dart';
import 'package:peces_app/domain/controllers/user_controller.dart';
import 'package:peces_app/model/UserFields.dart';
import 'package:peces_app/pages/general/GeneralPage.dart';
import 'package:peces_app/pages/general/ResumenMuestreoPage.dart';
import 'package:peces_app/service/sheets.dart';

class AddMuestreoPage extends StatefulWidget {
  const AddMuestreoPage({Key? key, required this.nLote, required this.posLote})
      : super(key: key);
  final String nLote;
  final int posLote;

  @override
  _AddMuestreoPageState createState() => _AddMuestreoPageState();
}

class _AddMuestreoPageState extends State<AddMuestreoPage> {
  final TextEditingController _cantidadPecesController =
      TextEditingController();
  final TextEditingController _biomasaParcialController =
      TextEditingController();
  DateTime? _fechaController;
  String? fecha;
  final TextEditingController _cantidadDiasController = TextEditingController();
  final TextEditingController _observacionesController =
      TextEditingController();
  final TextEditingController _produccionParcialController =
      TextEditingController();
  final TextEditingController _tasaDeProduccionController =
      TextEditingController();
  final TextEditingController _rendimientoController = TextEditingController();
  final TextEditingController _pesoMetaController = TextEditingController();
  final TextEditingController _porcentajeMetaController =
      TextEditingController();
  final TextEditingController _indiceDeSupervivenciaController =
      TextEditingController();
  final TextEditingController _mortalidadController = TextEditingController();
  UserController userController = Get.find();
  String dropdownvalue = 'Escoja una Siembra';
  String biomasaInicial = '';
  String areaTanque = '';
  String cantidadPecesInicial = '';

  var usuarios = userFirebase;

  // List of items in our dropdown menu
  List<String> items = [];

  @override
  void initState() {
    super.initState();
    obtenerSiembras();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    super.dispose();
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
              Center(child: Text(widget.nLote, style: estiloTexto(36))),
              //Cuerpo de la página con la información a rellenar
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Registra tu muestreo de control:',
                        style: estiloTexto(22)),
                    const SizedBox(height: 20),
                    //Campo que indica la siembra a la que pertenece el muestreo
                    listaDeSiembras(),
                    const SizedBox(height: 15),
                    //Campo que indica la cantidad de peces presentes en el estanque
                    formField(
                        'Cantidad de Peces',
                        _cantidadPecesController,
                        const Icon(MdiIcons.fish,
                            color: Color.fromARGB(255, 101, 170, 254))),
                    const SizedBox(height: 15),
                    //Campo que indica la biomasa meta
                    formField(
                        'Biomasa Meta',
                        _pesoMetaController,
                        const Icon(MdiIcons.weight,
                            color: Color.fromARGB(255, 101, 170, 254))),
                    const SizedBox(height: 15),
                    //Campo que indica la biomasa del estanque en este momento
                    formField(
                        'Biomasa Parcial',
                        _biomasaParcialController,
                        const Icon(MdiIcons.weightKilogram,
                            color: Color.fromARGB(255, 101, 170, 254))),
                    const SizedBox(height: 15),
                    //Campo que indica la fecha en la que se realiza el muestreo
                    botonFecha(),
                    const SizedBox(height: 15),
                    //Campo que indica los días que lleva la siembra hasta la fecha
                    formField(
                        'Días',
                        _cantidadDiasController,
                        const Icon(MdiIcons.counter,
                            color: Color.fromARGB(255, 101, 170, 254))),
                    const SizedBox(height: 15),
                    //Campo que indica la producción
                    campoCalculado(
                        'Producción',
                        'Kg',
                        const Icon(MdiIcons.chartLine,
                            color: Color.fromARGB(255, 101, 170, 254)),
                        getProduccionParcial(biomasaInicial,
                            _biomasaParcialController.text.trim())),
                    const SizedBox(height: 15),
                    //Campo que indica la tasa de producción
                    campoCalculado(
                        'Tasa de Producción',
                        'Kg/día',
                        const Icon(MdiIcons.chartBar,
                            color: Color.fromARGB(255, 101, 170, 254)),
                        getTasaProduccion(
                            _produccionParcialController.text.trim(),
                            _cantidadDiasController.text.trim())),
                    const SizedBox(height: 15),
                    //Campo que indica el rendimiento actual
                    campoCalculado(
                        'Rendimiento',
                        'Kg/m^2',
                        const Icon(MdiIcons.chartBox,
                            color: Color.fromARGB(255, 101, 170, 254)),
                        getRendimiento(_produccionParcialController.text.trim(),
                            areaTanque)),
                    const SizedBox(height: 15),
                    //Campo que indica el porcentaje de la biomasa meta
                    campoCalculado(
                        'Porcentaje Biomasa Meta',
                        '%',
                        const Icon(MdiIcons.percentOutline,
                            color: Color.fromARGB(255, 101, 170, 254)),
                        getPorcentajeMeta(_biomasaParcialController.text.trim(),
                            _pesoMetaController.text.trim())),
                    const SizedBox(height: 15),
                    //Campo que indica el porcentaje de supervivencia
                    campoCalculado(
                        'Índice de Supervivencia',
                        '%',
                        const Icon(MdiIcons.percent,
                            color: Color.fromARGB(255, 101, 170, 254)),
                        getIndiceDeSupervivencia(cantidadPecesInicial,
                            _cantidadPecesController.text.trim())),
                    const SizedBox(height: 15),
                    //Campo que indica el porcentaje de mortalidad
                    campoCalculado(
                        'Índice de Mortalidad',
                        '%',
                        const Icon(MdiIcons.skull,
                            color: Color.fromARGB(255, 101, 170, 254)),
                        getIndiceMortalidad(
                            _indiceDeSupervivenciaController.text.trim())),
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

  //---------------------------------------------------------------------------------------------------------------------------------
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

  //Widget del botón para enviar el muestreo
  Widget botonEnviar() {
    return InkWell(
      onTap: () async {
        String nombreLote = widget.nLote;
        //Inicializamos la clase sheetsAPI, pasando el email del usuario, esto decide la spreadsheet y la worksheet
        //await sheetsAPI.init(authClass.auth.currentUser!.email!, nombreLote);
        //Establecemos la información que vamos a pasar al spreadsheet en formato JSON
        // final info = {
        //   UserFields.fecha: fecha,
        //   UserFields.noMuestreo: _noMuestreoController.text.trim(),
        //   UserFields.semana: _semanaController.text.trim(),
        //   UserFields.biomasa: _biomasaParcialController,
        //   UserFields.observaciones: _observacionesController.text.trim(),
        //   UserFields.gananciaSemanal: _gananciaSemanalController,
        //   UserFields.pesoMeta: _pesoMetaController.text.trim(),
        //   UserFields.porcentajeMeta: _porcentajeMetaController,
        //   UserFields.porcentajeAlimento:
        //       _porcentajeAlimentoController.text.trim(),
        //   UserFields.qAlimento: _qAlimentoController,
        //   UserFields.mortalidad: _mortalidadController.text.trim()
        // };

        //Mapeamos la información extraída del formulario
        Map map = {
          'lote': userController.userLote,
          'siembra': dropdownvalue,
          'cantidad_peces': _cantidadPecesController.text.trim(),
          'biomasa_parcial': _biomasaParcialController.text.trim(),
          'fecha': fecha,
          'dias': _cantidadDiasController.text.trim(),
          'produccion_parcial': _produccionParcialController.text.trim(),
          'tasa_de_produccion': _tasaDeProduccionController.text.trim(),
          'rendimiento_parcial': _rendimientoController.text.trim(),
          'biomasa_meta': _pesoMetaController.text.trim(),
          'porcentaje_biomasa_meta': _porcentajeMetaController.text.trim(),
          'indice_supervivencia': _indiceDeSupervivenciaController.text.trim(),
          'indice_mortalidad': _mortalidadController.text.trim()
        };

        //Nos aseguramos de que la información no esté vacía
        if (_fechaController != null &&
            _cantidadPecesController.text != '' &&
            _biomasaParcialController.text != '' &&
            _cantidadDiasController.text != '' &&
            _produccionParcialController.text != '' &&
            _tasaDeProduccionController.text != '' &&
            _rendimientoController.text != '' &&
            _pesoMetaController.text != '' &&
            _porcentajeMetaController.text != '' &&
            _indiceDeSupervivenciaController.text != '' &&
            _mortalidadController.text != '') {
          try {
            //Llamamos a la función que añadirá la información a la spreadsheet
            //await sheetsAPI.insert([info]);
            //Se mostrará después de realizar el registro

            //Enviamos la información a la base de datos
            addMuestreoControl(userController.userEmail, map);
            userController.addControl(map);
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
                              _observacionesController.clear();
                              _pesoMetaController.clear();
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
            borderRadius: BorderRadius.circular(13),
            color: Color.fromARGB(255, 101, 170, 254)),
        child: const Center(
          child: Text('Enviar Muestreo',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w500)),
        ),
      ),
    );
  }

  //Calculamos el porcentaje de la meta con el peso promedio y el peso meta
  TextEditingController getPorcentajeMeta(
      String biomasaParcial, String pesoMeta) {
    if (biomasaParcial != '' && pesoMeta != '' && double.parse(pesoMeta) != 0) {
      _porcentajeMetaController.text =
          ((double.parse(biomasaParcial) / double.parse(pesoMeta)) * 100)
              .toString();
      return _porcentajeMetaController;
    } else {
      _porcentajeMetaController.text = '';
      return _porcentajeMetaController;
    }
  }

  //Estilo del texto general
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
                    cantidadPecesInicial =
                        userController.listaSiembras[i]['peces_sembrados'];
                    debugPrint('Biomasa: ' + biomasaInicial);
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

  //Función para obtener las fechas de la lista de siembras
  void obtenerSiembras() {
    for (var i = 0; i < userController.listaSiembras.length; i++) {
      if (userController.listaSiembras[i]['lote'] == userController.userLote) {
        items.add(userController.listaSiembras[i]['fecha']);
      }
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

  //Función que calculará el valor de la produccion parcial
  TextEditingController getProduccionParcial(
      String biomasaInicial, String biomasaParcial) {
    if (biomasaInicial != '' && biomasaParcial != '') {
      _produccionParcialController.text =
          (double.parse(biomasaParcial) - double.parse(biomasaInicial))
              .toString();
      return _produccionParcialController;
    } else {
      _produccionParcialController.text = '';
      return _produccionParcialController;
    }
  }

  //Función que calculará el valor de la produccion parcial
  TextEditingController getTasaProduccion(
      String produccionParcial, String dias) {
    if (produccionParcial != '' && dias != '') {
      _tasaDeProduccionController.text =
          (double.parse(produccionParcial) / double.parse(dias)).toString();
      return _tasaDeProduccionController;
    } else {
      _tasaDeProduccionController.text = '';
      return _tasaDeProduccionController;
    }
  }

  //Función que calculará el valor de la produccion parcial
  TextEditingController getIndiceDeSupervivencia(
      String cantidadPecesInicial, String cantidadPecesParcial) {
    if (cantidadPecesInicial != '' && cantidadPecesParcial != '') {
      _indiceDeSupervivenciaController.text =
          ((double.parse(cantidadPecesParcial) * 100) /
                  double.parse(cantidadPecesInicial))
              .toString();
      return _indiceDeSupervivenciaController;
    } else {
      _indiceDeSupervivenciaController.text = '';
      return _indiceDeSupervivenciaController;
    }
  }

  //Función que calculará el valor de la produccion parcial
  TextEditingController getIndiceMortalidad(String indiceSupervivencia) {
    if (indiceSupervivencia != '') {
      _mortalidadController.text =
          (100 - double.parse(indiceSupervivencia)).toString();
      return _mortalidadController;
    } else {
      _mortalidadController.text = '';
      return _mortalidadController;
    }
  }

  //Función que calculará el valor del rendimiento final
  TextEditingController getRendimiento(String produccion, String area) {
    if (produccion != '' && area != '') {
      _rendimientoController.text =
          (double.parse(produccion) / double.parse(area)).toString();
      return _rendimientoController;
    } else {
      _rendimientoController.text = '';
      return _rendimientoController;
    }
  }

  //Función que añadirá el muestreo de siembra a la base de datos
  void addMuestreoControl(email, map) async {
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
    List<dynamic> muestreoCosechaUsuario = user.docs[0]['muestreo_control'];
    //Añadimos un muestreo de siembra a la lista de muestreos del usuario
    muestreoCosechaUsuario.add(muestreo);
    //Actualizamos la información del usuario con el nuevo muestreo incluido
    usuarios.doc(userID).update({'muestreo_control': muestreoCosechaUsuario});
  }
}
