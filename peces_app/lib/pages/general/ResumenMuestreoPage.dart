// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:peces_app/domain/controllers/user_controller.dart';
import 'package:peces_app/model/Muestreo.dart';
import 'package:peces_app/pages/muestreos/AddMuestreo.dart';
import 'package:peces_app/pages/general/GeneralPage.dart';
import 'package:peces_app/pages/general/UltimoVsPenultimoMuestreo.dart';
import 'package:peces_app/pages/muestreos/AddMuestroCosecha.dart';
import 'package:peces_app/service/Auth_Service.dart';
import 'package:peces_app/service/sheets.dart';

import '../muestreos/AddMuestreoSiembra.dart';

class ResumenMuestreoPage extends StatefulWidget {
  const ResumenMuestreoPage({Key? key}) : super(key: key);

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
    String nombreLote = userController.userLote;
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
    //_fetchUltimoMuestreo(); //running initialisation code; getting prefs etc.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 77, 82, 92),
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const GeneralPage()));
            },
            icon: const Icon(Icons.home)),
        automaticallyImplyLeading: false,
        title: Text(userController.userLote, style: estiloTexto(20)),
        backgroundColor: const Color.fromARGB(255, 55, 57, 65),
      ),
      body: Column(
        children: [
          const SizedBox(height: 40),
          Center(child: Text('Resumen', style: estiloTexto(28))),
          const SizedBox(height: 50),
          //Botón para ver tus muestreos realizados
          botonBuscar(userController.userEmail),
          const SizedBox(height: 15),
          //Botón para añadir un muestreo de siembra
          botonAddSiembra(),
          const SizedBox(height: 15),
          //Botón para añadir un muestreo
          botonAdd(),
          //Botón para añadir un muestreo de cosecha
          const SizedBox(height: 15),
          botonAddCosecha(),
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

  TextStyle estiloTextoAzul(double size) {
    return TextStyle(
      color: Colors.white,
      fontSize: size,
    );
  }

  //Widget del botón de buscar último muestreo realizado
  Widget botonBuscar(String email) {
    return InkWell(
      onTap: () async {
        //Extraemos el nombre del lote que estamos viendo
        String nombreLote = userController.userLote;
        //Extraemos el spreadsheet y la worksheet
        await sheetsAPI.init(email, nombreLote);
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
                    nLote: userController.userLote,
                    posLote: userController.userLotePos)));
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
                    nLote: userController.userLote,
                    posLote: userController.userLotePos)));
      },
      child: Container(
        height: 60,
        width: MediaQuery.of(context).size.width - 50,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(13),
            color: Color.fromARGB(255, 101, 170, 254)),
        child: Center(
          child: Text(
            'Añadir Muestreo de Control',
            style: estiloTextoAzul(18),
          ),
        ),
      ),
    );
  }

  //Widget añadir botón de siembras
  Widget botonAddSiembra() {
    return InkWell(
      onTap: () async {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const AddMuestreoSiembra()));
      },
      child: Container(
        height: 60,
        width: MediaQuery.of(context).size.width - 50,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(13),
            color: Color.fromARGB(255, 101, 170, 254)),
        child: Center(
          child: Text(
            'Añadir Muestreo de Siembra',
            style: estiloTextoAzul(18),
          ),
        ),
      ),
    );
  }

  //Widget añadir botón de cosechas
  Widget botonAddCosecha() {
    return InkWell(
      onTap: () async {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const AddMuestreoCosecha()));
      },
      child: Container(
        height: 60,
        width: MediaQuery.of(context).size.width - 50,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(13),
            color: Color.fromARGB(255, 101, 170, 254)),
        child: Center(
          child: Text(
            'Añadir Muestreo de Cosecha',
            style: estiloTextoAzul(18),
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
