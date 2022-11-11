// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:peces_app/model/UserFields.dart';
import 'package:peces_app/pages/general/GeneralPage.dart';
import 'package:peces_app/pages/general/ResumenMuestreoPage.dart';
import 'package:peces_app/service/Auth_Service.dart';
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
  final TextEditingController _pecesSembradosController =
      TextEditingController();
  final TextEditingController _pesoSiembraPorUnidadController =
      TextEditingController();
  DateTime? _fechaController;
  String? fecha;
  final TextEditingController _noMuestreoController = TextEditingController();
  final TextEditingController _pecesCapturaController = TextEditingController();
  final TextEditingController _pesoCapturaController = TextEditingController();
  String? _pesoPromedioGrController;
  final TextEditingController _semanaController = TextEditingController();
  String? _biomasaParcialController;
  final TextEditingController _observacionesController =
      TextEditingController();
  String? _gananciaSemanalController;
  final TextEditingController _pesoMetaController = TextEditingController();
  String? _porcentajeMetaController;
  final TextEditingController _porcentajeAlimentoController =
      TextEditingController();
  String? _qAlimentoController;
  AuthClass authClass = AuthClass();
  final TextEditingController _mortalidadController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    _pecesCapturaController.dispose();
    _pesoCapturaController.dispose();
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
          Color(0xFF42008D),
          Color(0xFF26007B),
          Color(0xFF0A0068)
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
                    Text('Registra tu muestreo: ', style: estiloTexto(28)),
                    const SizedBox(height: 10),
                    Text(
                        'Recuerde dar enter en su teclado después de llenar los campos para realizar los cálculos correctamente.',
                        style: estiloTexto(12)),
                    const SizedBox(height: 30),
                    //Input de los peces sembrados
                    inputLabel('Peces Sembrados:'),
                    const SizedBox(height: 15),
                    formField(_pecesSembradosController),
                    const SizedBox(height: 20),
                    //Input del peso de la siembra por unidad
                    inputLabel('Peso de la siembra por unidad (en Gr):'),
                    const SizedBox(height: 15),
                    formField(_pesoSiembraPorUnidadController),
                    const SizedBox(height: 20),
                    //Input de la fecha
                    inputLabel('Fecha:'),
                    const SizedBox(height: 15),
                    //DatePicker
                    botonFecha(),
                    //Input No. del Muestreo
                    const SizedBox(height: 20),
                    inputLabel('No. del Muestreo:'),
                    const SizedBox(height: 15),
                    formField(_noMuestreoController),
                    //Input Peces Captura
                    const SizedBox(height: 20),
                    inputLabel('Peces Captura:'),
                    const SizedBox(height: 15),
                    formField(_pecesCapturaController),
                    //Input Peso Captura
                    const SizedBox(height: 20),
                    inputLabel('Peso Captura:'),
                    const SizedBox(height: 15),
                    formField(_pesoCapturaController),
                    //Input Peso Promedio (en gramos)
                    const SizedBox(height: 20),
                    inputLabel('Peso Promedio (en gramos):'),
                    const SizedBox(height: 15),
                    Text(
                        getPesoPromedioGR(_pecesCapturaController.text,
                            _pesoCapturaController.text)!,
                        style: estiloTexto(18)),
                    //Input de respectiva Semana
                    const SizedBox(height: 20),
                    inputLabel('Semana:'),
                    const SizedBox(height: 15),
                    formField(_semanaController),
                    //Input de la Biomasa Parcial en Kg
                    const SizedBox(height: 20),
                    inputLabel('Biomasa Parcial (en Kg):'),
                    const SizedBox(height: 15),
                    Text(
                        getBiomasaParcial(_pecesSembradosController.text,
                            _pesoPromedioGrController!)!,
                        style: estiloTexto(20)),
                    //Input de Observaciones
                    const SizedBox(height: 20),
                    inputLabel('Observaciones:'),
                    const SizedBox(height: 15),
                    formField(_observacionesController),
                    //Input de Ganancia Semanal
                    const SizedBox(height: 20),
                    inputLabel('Ganancia Semanal:'),
                    const SizedBox(height: 15),
                    Text(
                        getGanancia(_pesoSiembraPorUnidadController.text,
                            _pesoPromedioGrController!)!,
                        style: estiloTexto(20)),
                    //Input de peso meta
                    const SizedBox(height: 20),
                    inputLabel('Peso Meta:'),
                    const SizedBox(height: 15),
                    formField(_pesoMetaController),
                    //Input de % meta
                    const SizedBox(height: 20),
                    inputLabel('Meta %:'),
                    const SizedBox(height: 15),
                    Text(
                        getPorcentajeMeta(_pesoPromedioGrController!,
                            _pesoMetaController.text)!,
                        style: estiloTexto(20)),
                    //Input de % alimento
                    const SizedBox(height: 20),
                    inputLabel('Alimento %:'),
                    const SizedBox(height: 15),
                    formField(_porcentajeAlimentoController),
                    //Input de Q Alimento
                    const SizedBox(height: 20),
                    inputLabel('Q Alimento:'),
                    const SizedBox(height: 15),
                    Text(
                        getQAlimento(_biomasaParcialController!,
                            _porcentajeAlimentoController.text)!,
                        style: estiloTexto(20)),
                    //Input de Mortalidad
                    const SizedBox(height: 20),
                    inputLabel('Mortalidad:'),
                    const SizedBox(height: 15),
                    formField(_mortalidadController),
                    const SizedBox(height: 35),
                    //Botón de enviar la información
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
  Widget formField(TextEditingController controller) {
    return Container(
      height: 55,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(13)),
      child: TextFormField(
        controller: controller,
        decoration: const InputDecoration(
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 15)),
        style: const TextStyle(
          color: Colors.black,
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
            borderRadius: BorderRadius.circular(13), color: Colors.blue[900]),
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
        await sheetsAPI.init(authClass.auth.currentUser!.email!, nombreLote);
        //Establecemos la información que vamos a pasar al spreadsheet en formato JSON
        final info = {
          UserFields.pecesSembrados: _pecesSembradosController.text.trim(),
          UserFields.pesoSiembraPorUnidad:
              _pesoSiembraPorUnidadController.text.trim(),
          UserFields.fecha: fecha,
          UserFields.noMuestreo: _noMuestreoController.text.trim(),
          UserFields.pecesCaptura: _pecesCapturaController.text.trim(),
          UserFields.pesoCaptura: _pesoCapturaController.text.trim(),
          UserFields.pesoPromedioGR: _pesoPromedioGrController,
          UserFields.semana: _semanaController.text.trim(),
          UserFields.biomasa: _biomasaParcialController,
          UserFields.observaciones: _observacionesController.text.trim(),
          UserFields.gananciaSemanal: _gananciaSemanalController,
          UserFields.pesoMeta: _pesoMetaController.text.trim(),
          UserFields.porcentajeMeta: _porcentajeMetaController,
          UserFields.porcentajeAlimento:
              _porcentajeAlimentoController.text.trim(),
          UserFields.qAlimento: _qAlimentoController,
          UserFields.mortalidad: _mortalidadController.text.trim()
        };
        //Nos aseguramos de que la información no esté vacía
        if (_fechaController != null &&
            _pesoPromedioGrController != '' &&
            _biomasaParcialController != '' &&
            _qAlimentoController != '' &&
            _porcentajeMetaController != '' &&
            _gananciaSemanalController != '') {
          try {
            //Llamamos a la función que añadirá la información a la spreadsheet
            await sheetsAPI.insert([info]);
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
                              _noMuestreoController.clear();
                              _pecesCapturaController.clear();
                              _pesoCapturaController.clear();
                              _semanaController.clear();
                              _observacionesController.clear();
                              _pesoMetaController.clear();
                              _porcentajeAlimentoController.clear();
                              _mortalidadController.clear();
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
              Color(0xFFEC3E1E),
              Color(0xFFDE300B),
              Color(0xFFC40806)
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

  //Calculamos el peso promedio en gr a partir de los peces capturados y el peso de la captura
  String? getPesoPromedioGR(String pecesCaptura, String pesoCaptura) {
    if (pecesCaptura != '' &&
        pesoCaptura != '' &&
        double.parse(pesoCaptura) != 0.0) {
      _pesoPromedioGrController =
          (double.parse(pesoCaptura) / double.parse(pecesCaptura)).toString();
      return _pesoPromedioGrController;
    } else {
      _pesoPromedioGrController = '';
      return _pesoPromedioGrController;
    }
  }

  //Obtener el peso promedio
  void getPromedioPeso() {
    if (_pecesCapturaController.text != '' &&
        _pesoCapturaController.text != '' &&
        double.parse(_pesoCapturaController.text) != 0.0) {
      _pesoPromedioGrController = (double.parse(_pesoCapturaController.text) /
              double.parse(_pecesCapturaController.text))
          .toString();
    } else {
      _pesoPromedioGrController = '';
    }
  }

  //Calculamos la biomasa parcial con la cantidad de peces sembrados en la siembra determinada y el peso promedio del muestreo
  String? getBiomasaParcial(String pecesSembrados, String pesoPromedio) {
    if (pecesSembrados != '' && pesoPromedio != '') {
      _biomasaParcialController =
          ((double.parse(pecesSembrados) * double.parse(pesoPromedio)) / 1000)
              .toString();
      return _biomasaParcialController;
    } else {
      _biomasaParcialController = '';
      return _biomasaParcialController;
    }
  }

  //Calculamos la ganancia
  String? getGanancia(String pesoSiembraPorUnidad, String pesoPromedio) {
    if (pesoSiembraPorUnidad != '' && pesoPromedio != '') {
      _gananciaSemanalController =
          (double.parse(pesoPromedio) - double.parse(pesoSiembraPorUnidad))
              .toString();
      return _gananciaSemanalController;
    } else {
      _gananciaSemanalController = '';
      return _gananciaSemanalController;
    }
  }

  //Calculamos el porcentaje de la meta con el peso promedio y el peso meta
  String? getPorcentajeMeta(String pesoPromedio, String pesoMeta) {
    if (pesoPromedio != '' && pesoMeta != '' && double.parse(pesoMeta) != 0) {
      _porcentajeMetaController =
          ((double.parse(pesoPromedio) / double.parse(pesoMeta)) * 100)
              .toString();
      return _porcentajeMetaController;
    } else {
      _porcentajeMetaController = '';
      return _porcentajeMetaController;
    }
  }

  //Calculamos el Q alimento a partir de la biomasa parcial y el porcentaje de alimento
  String? getQAlimento(String biomasa, String porcentajeAlimento) {
    if (biomasa != '' && porcentajeAlimento != '') {
      _qAlimentoController =
          (double.parse(biomasa) * double.parse(porcentajeAlimento) / 100)
              .toString();
      return _qAlimentoController;
    } else {
      _qAlimentoController = '';
      return _qAlimentoController;
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
}
