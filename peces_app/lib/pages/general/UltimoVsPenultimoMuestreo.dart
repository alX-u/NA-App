import 'package:flutter/material.dart';
import 'package:peces_app/model/Muestreo.dart';

import 'ResumenMuestreoPage.dart';

class UltimoVsPenultimoMuestreo extends StatefulWidget {
  const UltimoVsPenultimoMuestreo(
      {Key? key,
      required this.muestreos,
      required this.nLote,
      required this.posLote})
      : super(key: key);

  final List<Muestreo>? muestreos;
  //Número del lote que obtenemos de la collection usuarios
  final String nLote;
  //Posición de ese lote en la el array
  final int posLote;
  @override
  _UltimoVsPenultimoMuestreoState createState() =>
      _UltimoVsPenultimoMuestreoState();
}

class _UltimoVsPenultimoMuestreoState extends State<UltimoVsPenultimoMuestreo> {
  int index = 0;

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
                  Text('Resumen de tu muestreo: ', style: estiloTexto(30)),
                  const SizedBox(height: 20),
                  if (widget.muestreos!.isNotEmpty) buildMuestreosControl(),
                  const SizedBox(height: 20),
                  //Peces sembrados
                  inputLabel('Peces Sembrados: '),
                  const SizedBox(height: 15),
                  Text(widget.muestreos![index].pecesSembrados,
                      style: estiloTexto(20)),
                  //Peso de la Siembra por Unidad
                  const SizedBox(height: 20),
                  inputLabel('Peso de la Siembra Por Unidad(en gr): '),
                  const SizedBox(height: 15),
                  Text(widget.muestreos![index].pesoSiembraPorUnidad,
                      style: estiloTexto(20)),
                  //Fecha
                  const SizedBox(height: 20),
                  inputLabel('Fecha: '),
                  const SizedBox(height: 15),
                  Text(
                      dateFromGsheets(widget.muestreos![index].fecha)
                          .toString(),
                      style: estiloTexto(20)),
                  //No. del Muestreo
                  const SizedBox(height: 20),
                  inputLabel('No. del Muestreo: '),
                  const SizedBox(height: 15),
                  Text(widget.muestreos![index].noMuestreo,
                      style: estiloTexto(20)),
                  //Peces Captura
                  const SizedBox(height: 20),
                  inputLabel('Peces Capturados: '),
                  const SizedBox(height: 15),
                  Text(widget.muestreos![index].pecesCaptura,
                      style: estiloTexto(20)),
                  //Peso Captura
                  const SizedBox(height: 20),
                  inputLabel('Peso de la Captura: '),
                  const SizedBox(height: 15),
                  Text(widget.muestreos![index].pesoCaptura,
                      style: estiloTexto(20)),
                  //Peso Promedio en gr
                  const SizedBox(height: 20),
                  inputLabel('Peso Promedio (en gr): '),
                  const SizedBox(height: 15),
                  Text(widget.muestreos![index].pesoPromedioGR,
                      style: estiloTexto(20)),
                  //Semana
                  const SizedBox(height: 20),
                  inputLabel('Semana: '),
                  const SizedBox(height: 15),
                  Text(widget.muestreos![index].semana, style: estiloTexto(20)),
                  //Biomasa Parcial
                  const SizedBox(height: 20),
                  inputLabel('Biomasa Parcial (en Kg): '),
                  const SizedBox(height: 15),
                  Text(widget.muestreos![index].biomasa,
                      style: estiloTexto(20)),
                  //Observaciones
                  const SizedBox(height: 20),
                  inputLabel('Observaciones: '),
                  const SizedBox(height: 15),
                  Text(widget.muestreos![index].observaciones,
                      style: estiloTexto(20)),
                  //Ganancia
                  const SizedBox(height: 20),
                  inputLabel('Ganancia Semanal: '),
                  const SizedBox(height: 15),
                  Text(widget.muestreos![index].gananciaSemanal,
                      style: estiloTexto(20)),
                  //Peso Meta
                  const SizedBox(height: 20),
                  inputLabel('Peso Meta: '),
                  const SizedBox(height: 15),
                  Text(widget.muestreos![index].pesoMeta,
                      style: estiloTexto(20)),
                  //Porcentaje Meta
                  const SizedBox(height: 20),
                  inputLabel('% Meta: '),
                  const SizedBox(height: 15),
                  Text(widget.muestreos![index].porcentajeMeta,
                      style: estiloTexto(20)),
                  //Porcentaje Alimento
                  const SizedBox(height: 20),
                  inputLabel('% Alimento: '),
                  const SizedBox(height: 15),
                  Text(widget.muestreos![index].porcentajeAlimento,
                      style: estiloTexto(20)),
                  //Q Alimento
                  const SizedBox(height: 20),
                  inputLabel('Q Alimento: '),
                  const SizedBox(height: 15),
                  Text(widget.muestreos![index].qAlimento,
                      style: estiloTexto(20)),
                  // Mortalidad
                  const SizedBox(height: 20),
                  inputLabel('Mortalidad: '),
                  const SizedBox(height: 15),
                  Text(widget.muestreos![index].mortalidad,
                      style: estiloTexto(20)),
                  const SizedBox(height: 20),
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
      text: '${index + 1} /${widget.muestreos!.length} Muestreo',
      onClickedNext: () {
        final nextIndex = index >= widget.muestreos!.length - 1 ? 0 : index + 1;

        setState(() {
          index = nextIndex;
        });
      },
      onClickedPrevious: () {
        final previousIndex =
            index <= 0 ? widget.muestreos!.length - 1 : index - 1;

        setState(() {
          index = previousIndex;
        });
      });

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
