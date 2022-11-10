// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:peces_app/domain/controllers/user_controller.dart';
import 'package:peces_app/model/Muestreo.dart';
import 'package:peces_app/pages/AddMuestreo.dart';
import 'package:peces_app/pages/general/GeneralPage.dart';
import 'package:peces_app/pages/general/UltimoVsPenultimoMuestreo.dart';
import 'package:peces_app/service/Auth_Service.dart';
import 'package:peces_app/service/sheets.dart';

class ResumenMuestreoPage extends StatefulWidget {
  const ResumenMuestreoPage(
      {Key? key, required this.nLote, required this.posLote})
      : super(key: key);
  final String nLote;
  final int posLote;

  @override
  _ResumenMuestreoPageState createState() => _ResumenMuestreoPageState();
}

class _ResumenMuestreoPageState extends State<ResumenMuestreoPage> {
  AuthClass authClass = AuthClass();
  Muestreo? muestreo;
  List<Muestreo>? muestreos = [];
  UserController userController = Get.find();

  //Iniciamos consultando si existe información ya añadida a los muestreos
  _fetchUltimoMuestreo() async {
    //Extraemos el nombre del lote que estamos viendo
    String nombreLote = widget.nLote;
    //Extraemos el spreadsheet y la worksheet
    try {
      await sheetsAPI.init(userController.userEmail, nombreLote);
      //Realizamos la función que le indica a la clase sheets qué información buscará
      final info = await sheetsAPI.imprimirUltima();
      //Imprimo la info en formato json (reviso que no sea nulo; de serlo, se imprime '')
      debugPrint(info?.toJson().toString() ?? '');
      // Revisamos que la información no sea null
      // ignore: unnecessary_null_comparison
      if (info != null) {
        //Seteamos el muestreo
        setState(() {
          muestreo = info;
        });
      } else {
        //Se imprime que no se pudo realizar la consulta
        const snackbar = SnackBar(content: Text('No tienes muestreos aún'));
        ScaffoldMessenger.of(context).showSnackBar(snackbar);
      }
    } on Exception catch (e) {}
  }

  @override
  void initState() {
    super.initState();
    //La función de la búsqueda del muestreo se corre en la inicialización de la ventana, confirmando si la variable 'muestreo'
    //poseerá información o no
    _fetchUltimoMuestreo(); //running initialisation code; getting prefs etc.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0369AF),
      appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const GeneralPage()));
              },
              icon: const Icon(Icons.home)),
          automaticallyImplyLeading: false,
          title: Text(widget.nLote, style: estiloTexto(20))),
      body: Column(
        children: [
          const SizedBox(height: 40),
          Center(child: Text('Resumen', style: estiloTexto(28))),
          const SizedBox(height: 50),
          botonBuscar(),
          const SizedBox(height: 15),
          botonAdd(),
          const SizedBox(height: 30),
          Center(
              child: Text('Último peso promedio registrado:',
                  style: estiloTexto(18))),
          const SizedBox(height: 15),
          Center(
              child: Text(muestreo?.pesoPromedioGR ?? 'Buscando...',
                  style: estiloTexto(20)))
        ],
      ),
    );
  }

//-------------------------------------------------------------------------------------------------------------------------------------
// Widgets Y Métodos
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

  //Widget del botón de buscar último muestreo realizado
  Widget botonBuscar() {
    return InkWell(
      onTap: () async {
        //Extraemos el nombre del lote que estamos viendo
        String nombreLote = widget.nLote;
        //Extraemos el spreadsheet y la worksheet
        await sheetsAPI.init(authClass.auth.currentUser!.email!, nombreLote);
        //Ejecutamos la función que extraerá la lista de muestreos
        final muestreos = await sheetsAPI.getMuestreos();
        //Seteamos el state, guardando la lista de meustreos del usuario
        setState(() {
          this.muestreos = muestreos;
        });
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => UltimoVsPenultimoMuestreo(
                    muestreos: muestreos,
                    nLote: widget.nLote,
                    posLote: widget.posLote)));
      },
      child: Container(
        height: 60,
        width: MediaQuery.of(context).size.width - 50,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(13), color: Colors.white),
        child: const Center(
          child: Text(
            'Consultar muestreos',
            style: TextStyle(color: Colors.black, fontSize: 18),
          ),
        ),
      ),
    );
  }

  //Widget botón de añadir
  Widget botonAdd() {
    return InkWell(
      onTap: () async {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AddMuestreoPage(
                    nLote: widget.nLote, posLote: widget.posLote)));
      },
      child: Container(
        height: 60,
        width: MediaQuery.of(context).size.width - 50,
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
            'Añadir Muestreo',
            style: estiloTexto(18),
          ),
        ),
      ),
    );
  }

  //Widget para el field de textos
  Widget formField(TextEditingController controller) {
    return Container(
      height: 55,
      width: MediaQuery.of(context).size.width - 20,
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
}
