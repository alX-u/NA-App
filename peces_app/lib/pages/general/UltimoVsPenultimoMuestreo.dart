import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:peces_app/model/Muestreo.dart';

import '../../domain/constants/firebase_constants.dart';
import '../../domain/controllers/user_controller.dart';
import 'ResumenMuestreoPage.dart';

class UltimoVsPenultimoMuestreo extends StatefulWidget {
  const UltimoVsPenultimoMuestreo({Key? key}) : super(key: key);

  //Número del lote que obtenemos de la collection usuarios
  @override
  _UltimoVsPenultimoMuestreoState createState() =>
      _UltimoVsPenultimoMuestreoState();
}

class _UltimoVsPenultimoMuestreoState extends State<UltimoVsPenultimoMuestreo> {
  int index = 0;
  UserController userController = Get.find();
  String dropdownvalue = 'Escoja una Siembra';
  String biomasaInicial = '';
  String areaTanque = '';
  String cantidadPecesInicial = '';

  var usuarios = userFirebase;

  // List of items in our dropdown menu
  List<String> items = [];
  List muestreos = [];

  @override
  void initState() {
    super.initState();
    obtenerSiembras();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
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
            //Flecha para devolverse al menú de resumen de muestreo
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
            //Cuerpo de la página
            Center(
                child: Text(userController.userLote, style: estiloTexto(36))),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Resumen de tus muestreos: ', style: estiloTexto(22)),
                  const SizedBox(height: 20),
                  //Campo que indica la siembra a la que pertenecen los muestreos
                  listaDeSiembras(),
                  const SizedBox(height: 15),
                  if (muestreos.isNotEmpty) buildMuestreosControl(),
                  const SizedBox(height: 15),
                  //Campo que indica la cantidad de peces en este muestreo
                  if (muestreos.isNotEmpty)
                    SizedBox(
                        height: 35,
                        width: 400,
                        child: Card(
                            color: const Color.fromARGB(255, 72, 73, 75),
                            child: Text(
                                ' Cantidad de peces: ' +
                                    muestreos[index]['cantidad_peces'] +
                                    ' Kg',
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    shadows: <Shadow>[
                                      Shadow(
                                          offset: Offset(1.5, 1.5),
                                          blurRadius: 3.0,
                                          color: Color.fromARGB(255, 0, 0, 0))
                                    ])))),
                  const SizedBox(height: 2),
                  //Campo que indica la biomasa meta
                  if (muestreos.isNotEmpty)
                    SizedBox(
                        height: 35,
                        width: 400,
                        child: Card(
                            color: const Color.fromARGB(255, 72, 73, 75),
                            child: Text(
                                ' Biomasa Meta: ' +
                                    muestreos[index]['biomasa_meta'] +
                                    ' Kg',
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    shadows: <Shadow>[
                                      Shadow(
                                          offset: Offset(1.5, 1.5),
                                          blurRadius: 3.0,
                                          color: Color.fromARGB(255, 0, 0, 0))
                                    ])))),
                  const SizedBox(height: 2),
                  //Campo que indica la biomasa meta
                  if (muestreos.isNotEmpty)
                    SizedBox(
                        height: 35,
                        width: 400,
                        child: Card(
                            color: const Color.fromARGB(255, 72, 73, 75),
                            child: Text(
                                ' Biomasa parcial: ' +
                                    muestreos[index]['biomasa_parcial'] +
                                    ' Kg',
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    shadows: <Shadow>[
                                      Shadow(
                                          offset: Offset(1.5, 1.5),
                                          blurRadius: 3.0,
                                          color: Color.fromARGB(255, 0, 0, 0))
                                    ])))),
                  const SizedBox(height: 2),
                  //Campo que indica la biomasa meta
                  if (muestreos.isNotEmpty)
                    SizedBox(
                        height: 35,
                        width: 400,
                        child: Card(
                            color: const Color.fromARGB(255, 72, 73, 75),
                            child: Text(
                                ' Fecha: ' + muestreos[index]['fecha'] + ' Kg',
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    shadows: <Shadow>[
                                      Shadow(
                                          offset: Offset(1.5, 1.5),
                                          blurRadius: 3.0,
                                          color: Color.fromARGB(255, 0, 0, 0))
                                    ])))),
                  const SizedBox(height: 2),
                  //Campo que indica la biomasa meta
                  if (muestreos.isNotEmpty)
                    SizedBox(
                        height: 35,
                        width: 400,
                        child: Card(
                            color: const Color.fromARGB(255, 72, 73, 75),
                            child: Text(
                                ' Dias transcurridos: ' +
                                    muestreos[index]['dias'] +
                                    ' Kg',
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    shadows: <Shadow>[
                                      Shadow(
                                          offset: Offset(1.5, 1.5),
                                          blurRadius: 3.0,
                                          color: Color.fromARGB(255, 0, 0, 0))
                                    ])))),
                  const SizedBox(height: 2),
                  //Campo que indica la biomasa meta
                  if (muestreos.isNotEmpty)
                    SizedBox(
                        height: 35,
                        width: 400,
                        child: Card(
                            color: const Color.fromARGB(255, 72, 73, 75),
                            child: Text(
                                ' Produccion parcial: ' +
                                    muestreos[index]['produccion_parcial'] +
                                    ' Kg',
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    shadows: <Shadow>[
                                      Shadow(
                                          offset: Offset(1.5, 1.5),
                                          blurRadius: 3.0,
                                          color: Color.fromARGB(255, 0, 0, 0))
                                    ])))),
                  const SizedBox(height: 2),
                  //Campo que indica la biomasa meta
                  if (muestreos.isNotEmpty)
                    SizedBox(
                        height: 35,
                        width: 400,
                        child: Card(
                            color: const Color.fromARGB(255, 72, 73, 75),
                            child: Text(
                                ' Tasa de produccion: ' +
                                    muestreos[index]['tasa_de_produccion'] +
                                    ' Kg',
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    shadows: <Shadow>[
                                      Shadow(
                                          offset: Offset(1.5, 1.5),
                                          blurRadius: 3.0,
                                          color: Color.fromARGB(255, 0, 0, 0))
                                    ])))),
                  const SizedBox(height: 2),
                  //Campo que indica la biomasa meta
                  if (muestreos.isNotEmpty)
                    SizedBox(
                        height: 35,
                        width: 400,
                        child: Card(
                            color: const Color.fromARGB(255, 72, 73, 75),
                            child: Text(
                                ' Rendimiento parcial: ' +
                                    muestreos[index]['rendimiento_parcial'] +
                                    ' Kg',
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    shadows: <Shadow>[
                                      Shadow(
                                          offset: Offset(1.5, 1.5),
                                          blurRadius: 3.0,
                                          color: Color.fromARGB(255, 0, 0, 0))
                                    ])))),
                  const SizedBox(height: 2),
                  //Campo que indica la biomasa meta
                  if (muestreos.isNotEmpty)
                    SizedBox(
                        height: 35,
                        width: 400,
                        child: Card(
                            color: const Color.fromARGB(255, 72, 73, 75),
                            child: Text(
                                ' Porcentaje de biomasa meta: ' +
                                    muestreos[index]
                                        ['porcentaje_biomasa_meta'] +
                                    ' Kg',
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    shadows: <Shadow>[
                                      Shadow(
                                          offset: Offset(1.5, 1.5),
                                          blurRadius: 3.0,
                                          color: Color.fromARGB(255, 0, 0, 0))
                                    ])))),
                  const SizedBox(height: 2),
                  //Campo que indica la biomasa meta
                  if (muestreos.isNotEmpty)
                    SizedBox(
                        height: 35,
                        width: 400,
                        child: Card(
                            color: const Color.fromARGB(255, 72, 73, 75),
                            child: Text(
                                ' Indice de supervivencia: ' +
                                    muestreos[index]['indice_supervivencia'] +
                                    ' Kg',
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    shadows: <Shadow>[
                                      Shadow(
                                          offset: Offset(1.5, 1.5),
                                          blurRadius: 3.0,
                                          color: Color.fromARGB(255, 0, 0, 0))
                                    ])))),
                  const SizedBox(height: 2),
                  //Campo que indica la biomasa meta
                  if (muestreos.isNotEmpty)
                    SizedBox(
                        height: 35,
                        width: 400,
                        child: Card(
                            color: const Color.fromARGB(255, 72, 73, 75),
                            child: Text(
                                ' Indice de mortalidad: ' +
                                    muestreos[index]['indice_mortalidad'] +
                                    ' Kg',
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    shadows: <Shadow>[
                                      Shadow(
                                          offset: Offset(1.5, 1.5),
                                          blurRadius: 3.0,
                                          color: Color.fromARGB(255, 0, 0, 0))
                                    ])))),
                  const SizedBox(height: 2),
                ],
              ),
            )
          ],
        ),
      ),
    ));
  }
//-----------------------------------------------------------------------------------------------------------------------------------

  //Widget y Métodos
//Widgets y Métodos
  Widget buildMuestreosControl() => NavigateMuestreosWidget(
      text: '${index + 1} /${userController.listaControles.length} Muestreo',
      onClickedNext: () {
        final nextIndex =
            index >= userController.listaControles.length - 1 ? 0 : index + 1;

        setState(() {
          index = nextIndex;
        });
      },
      onClickedPrevious: () {
        final previousIndex =
            index <= 0 ? userController.listaControles.length - 1 : index - 1;

        setState(() {
          index = previousIndex;
        });
      });

  // //Pasamos el valor que obtenemos de la fecha de google sheets a un formato que se pueda leer bien
  // DateTime? dateFromGsheets(String value) {
  //   const gsDateBase = 2209161600 / 86400;
  //   const gsDateFactor = 86400000;
  //   final date = double.tryParse(value);
  //   if (date == null) return null;
  //   final millis = (date - gsDateBase) * gsDateFactor;
  //   return DateTime.fromMillisecondsSinceEpoch(millis.round(), isUtc: true);
  // }

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
                    debugPrint(
                        'Biomasa Inicial de la siembra: ' + biomasaInicial);
                    debugPrint('Área de la siembra: ' + areaTanque);
                  }
                }
                dropdownvalue = _value.toString();
                obtenerControles();
                debugPrint(muestreos[0]['fecha']);
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

  //Función para obtener los muestreos de la lista de controles
  void obtenerControles() {
    for (var i = 0; i < userController.listaControles.length; i++) {
      if (userController.listaControles[i]['lote'] == userController.userLote &&
          userController.listaControles[i]['siembra'] == dropdownvalue) {
        muestreos.add(userController.listaControles[i]);
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
}

//Clase que contiene el widget usado para alternar entre el penúltimo muestreo y el último
class NavigateMuestreosWidget extends StatelessWidget {
  final String text;
  final VoidCallback onClickedPrevious;
  final VoidCallback onClickedNext;

  const NavigateMuestreosWidget(
      {Key? key,
      required this.text,
      required this.onClickedNext,
      required this.onClickedPrevious})
      : super(key: key);

  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //Ícono para pasar al muestreo previo
          IconButton(
              onPressed: onClickedPrevious,
              icon: const Icon(Icons.navigate_before, color: Colors.white),
              iconSize: 48),
          //Texto que índica el muestreo que se ve en pantalla
          Text(text,
              style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
          //Ícono para pasar al muestreo siguiente
          IconButton(
              onPressed: onClickedNext,
              icon: const Icon(Icons.navigate_next, color: Colors.white),
              iconSize: 48)
        ],
      );
}
