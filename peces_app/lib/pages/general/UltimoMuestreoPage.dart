// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:peces_app/model/Muestreo.dart';
import 'package:peces_app/pages/general/ResumenMuestreoPage.dart';

class UltimoMuestreoPage extends StatefulWidget {
  const UltimoMuestreoPage(
      {Key? key,
      required this.muestreo,
      required this.nLote,
      required this.posLote})
      : super(key: key);
  //Clase muestreo en model/Muestreo, para obtener el objeto muestreo y poder mostrar toda la info que extraemos del sheets
  final Muestreo? muestreo;
  //Número del lote que obtenemos de la collection usuarios
  final String nLote;
  //Posición de ese lote en la el array
  final int posLote;

  @override
  _UltimoMuestreoPageState createState() => _UltimoMuestreoPageState();
}

class _UltimoMuestreoPageState extends State<UltimoMuestreoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
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
            //Flecha para devolverse al menú de resumen de muestreo
            Row(
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ResumenMuestreoPage(
                                  nLote: widget.nLote,
                                  posLote: widget.posLote)));
                    },
                    icon: const Icon(Icons.keyboard_arrow_left,
                        color: Colors.white, size: 30)),
              ],
            ),
            Center(child: Text(widget.nLote, style: estiloTexto(36))),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Resumen de tu anterior muestreo: ',
                      style: estiloTexto(30)),
                  const SizedBox(height: 30),
                  //Peces sembrados
                  inputLabel('Peces Sembrados: '),
                  const SizedBox(height: 15),
                  Text(widget.muestreo!.pecesSembrados, style: estiloTexto(20)),
                  //Peso de la Siembra por Unidad
                  const SizedBox(height: 20),
                  inputLabel('Peso de la Siembra Por Unidad(en gr): '),
                  const SizedBox(height: 15),
                  Text(widget.muestreo!.pesoSiembraPorUnidad,
                      style: estiloTexto(20)),
                  //Fecha
                  const SizedBox(height: 20),
                  inputLabel('Fecha: '),
                  const SizedBox(height: 15),
                  Text(dateFromGsheets(widget.muestreo!.fecha).toString(),
                      style: estiloTexto(20)),
                  //No. del Muestreo
                  const SizedBox(height: 20),
                  inputLabel('No. del Muestreo: '),
                  const SizedBox(height: 15),
                  Text(widget.muestreo!.noMuestreo, style: estiloTexto(20)),
                  //Peces Captura
                  const SizedBox(height: 20),
                  inputLabel('Peces Capturados: '),
                  const SizedBox(height: 15),
                  Text(widget.muestreo!.pecesCaptura, style: estiloTexto(20)),
                  //Peso Captura
                  const SizedBox(height: 20),
                  inputLabel('Peso de la Captura: '),
                  const SizedBox(height: 15),
                  Text(widget.muestreo!.pesoCaptura, style: estiloTexto(20)),
                  //Peso Promedio en gr
                  const SizedBox(height: 20),
                  inputLabel('Peso Promedio (en gr): '),
                  const SizedBox(height: 15),
                  Text(widget.muestreo!.pesoPromedioGR, style: estiloTexto(20)),
                  //Semana
                  const SizedBox(height: 20),
                  inputLabel('Semana: '),
                  const SizedBox(height: 15),
                  Text(widget.muestreo!.semana, style: estiloTexto(20)),
                  //Biomasa Parcial
                  const SizedBox(height: 20),
                  inputLabel('Biomasa Parcial (en Kg): '),
                  const SizedBox(height: 15),
                  Text(widget.muestreo!.biomasa, style: estiloTexto(20)),
                  //Observaciones
                  const SizedBox(height: 20),
                  inputLabel('Observaciones: '),
                  const SizedBox(height: 15),
                  Text(widget.muestreo!.observaciones, style: estiloTexto(20)),
                  //Ganancia
                  const SizedBox(height: 20),
                  inputLabel('Ganancia Semanal: '),
                  const SizedBox(height: 15),
                  Text(widget.muestreo!.gananciaSemanal,
                      style: estiloTexto(20)),
                  //Peso Meta
                  const SizedBox(height: 20),
                  inputLabel('Peso Meta: '),
                  const SizedBox(height: 15),
                  Text(widget.muestreo!.pesoMeta, style: estiloTexto(20)),
                  //Porcentaje Meta
                  const SizedBox(height: 20),
                  inputLabel('% Meta: '),
                  const SizedBox(height: 15),
                  Text(widget.muestreo!.porcentajeMeta, style: estiloTexto(20)),
                  //Porcentaje Alimento
                  const SizedBox(height: 20),
                  inputLabel('% Alimento: '),
                  const SizedBox(height: 15),
                  Text(widget.muestreo!.porcentajeAlimento,
                      style: estiloTexto(20)),
                  //Q Alimento
                  const SizedBox(height: 20),
                  inputLabel('Q Alimento: '),
                  const SizedBox(height: 15),
                  Text(widget.muestreo!.qAlimento, style: estiloTexto(20)),
                  // Mortalidad
                  const SizedBox(height: 20),
                  inputLabel('Mortalidad: '),
                  const SizedBox(height: 15),
                  Text(widget.muestreo!.mortalidad, style: estiloTexto(20)),
                  const SizedBox(height: 20)
                ],
              ),
            )
          ],
        ),
      ),
    ));
  }

//------------------------------------------------------------------------------------------------------------------------------------

  //Widgets y Métodos
  //Pasamos el valor que obtenemos de la fecha de google sheets a un formato que se pueda leer bien
  DateTime? dateFromGsheets(String value) {
    const gsDateBase = 2209161600 / 86400;
    const gsDateFactor = 86400000;
    final date = double.tryParse(value);
    if (date == null) return null;
    final millis = (date - gsDateBase) * gsDateFactor;
    return DateTime.fromMillisecondsSinceEpoch(millis.round(), isUtc: true);
  }

  //Estilo de los labels que irán arriba de cada formfield
  Widget inputLabel(String input) {
    return Text(input,
        style: const TextStyle(
            fontSize: 24,
            color: Colors.white,
            shadows: <Shadow>[
              Shadow(
                  offset: Offset(2.0, 2.0),
                  blurRadius: 3.0,
                  color: Color.fromARGB(255, 0, 0, 0))
            ],
            letterSpacing: 0.2));
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
