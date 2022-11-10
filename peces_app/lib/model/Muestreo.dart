// ignore_for_file: file_names

import 'UserFields.dart';

class Muestreo {
  final String pecesSembrados;
  final String pesoSiembraPorUnidad;
  final String fecha;
  final String noMuestreo;
  final String pecesCaptura;
  final String pesoCaptura;
  final String pesoPromedioGR;
  final String semana;
  final String biomasa;
  final String observaciones;
  final String gananciaSemanal;
  final String pesoMeta;
  final String porcentajeMeta;
  final String porcentajeAlimento;
  final String qAlimento;
  final String mortalidad;

  const Muestreo(
      {required this.pecesSembrados,
      required this.pesoSiembraPorUnidad,
      required this.fecha,
      required this.noMuestreo,
      required this.pecesCaptura,
      required this.pesoCaptura,
      required this.pesoPromedioGR,
      required this.semana,
      required this.biomasa,
      required this.observaciones,
      required this.gananciaSemanal,
      required this.pesoMeta,
      required this.porcentajeMeta,
      required this.porcentajeAlimento,
      required this.qAlimento,
      required this.mortalidad});

  static Muestreo fromJson(Map<String, dynamic> json) => Muestreo(
      pecesSembrados: json[UserFields.pecesSembrados],
      pesoSiembraPorUnidad: json[UserFields.pesoSiembraPorUnidad],
      fecha: json[UserFields.fecha],
      noMuestreo: json[UserFields.noMuestreo],
      pecesCaptura: json[UserFields.pecesCaptura],
      pesoCaptura: json[UserFields.pesoCaptura],
      pesoPromedioGR: json[UserFields.pesoPromedioGR],
      semana: json[UserFields.semana],
      biomasa: json[UserFields.biomasa],
      observaciones: json[UserFields.observaciones],
      gananciaSemanal: json[UserFields.gananciaSemanal],
      pesoMeta: json[UserFields.pesoMeta],
      porcentajeMeta: json[UserFields.porcentajeMeta],
      porcentajeAlimento: json[UserFields.porcentajeAlimento],
      qAlimento: json[UserFields.qAlimento],
      mortalidad: json[UserFields.mortalidad]);

  Map<String, dynamic> toJson() => {
        UserFields.pecesSembrados: pecesSembrados,
        UserFields.pesoSiembraPorUnidad: pesoSiembraPorUnidad,
        UserFields.fecha: fecha,
        UserFields.noMuestreo: noMuestreo,
        UserFields.pecesCaptura: pecesCaptura,
        UserFields.pesoCaptura: pesoCaptura,
        UserFields.pesoPromedioGR: pesoPromedioGR,
        UserFields.semana: semana,
        UserFields.biomasa: biomasa,
        UserFields.observaciones: observaciones,
        UserFields.gananciaSemanal: gananciaSemanal,
        UserFields.pesoMeta: pesoMeta,
        UserFields.porcentajeMeta: porcentajeMeta,
        UserFields.porcentajeAlimento: porcentajeAlimento,
        UserFields.qAlimento: qAlimento,
        UserFields.mortalidad: mortalidad 
      };
}
