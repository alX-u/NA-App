// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:peces_app/domain/controllers/user_controller.dart';

import '../general/ResumenMuestreoPage.dart';

class AddMuestreoSiembra extends StatefulWidget {
  const AddMuestreoSiembra({Key? key}) : super(key: key);

  @override
  State<AddMuestreoSiembra> createState() => _AddMuestreoSiembraState();
}

class _AddMuestreoSiembraState extends State<AddMuestreoSiembra> {
  UserController userController = Get.find();
  final TextEditingController _pecesSembradosController =
      TextEditingController();
  final TextEditingController _pesoSiembraPorUnidadController =
      TextEditingController();

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
                    Text('Registra tu muestreo de siembra: ',
                        style: estiloTexto(28)),
                    const SizedBox(height: 10),
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
}
