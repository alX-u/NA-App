// ignore_for_file: file_names

class UserFields {
  static const String pecesSembrados = 'Peces Sembrados';
  static const String pesoSiembraPorUnidad = 'Peso Siembra Por Unidad(Gr)';
  static const String fecha = 'fecha';
  static const String noMuestreo = 'No. del Muestreo';
  static const String pecesCaptura = 'Peces Captura';
  static const String pesoCaptura = 'Peso Captura';
  static const String pesoPromedioGR = 'Peso Promedio (Gr)';
  static const String semana = 'Semana';
  static const String biomasa = 'Biomasa Parcial (Kg)';
  static const String observaciones = 'Observaciones';
  static const String gananciaSemanal = 'Ganancia Semanal';
  static const String pesoMeta = 'Peso Meta';
  static const String porcentajeMeta = '% meta';
  static const String porcentajeAlimento = '% alimento';
  static const String qAlimento = 'Q alimento';
  static const String mortalidad = 'Mortalidad';

  static List<String> getFields() => [
        pecesSembrados,
        pesoSiembraPorUnidad,
        fecha,
        noMuestreo,
        pecesCaptura,
        pesoCaptura,
        pesoPromedioGR,
        semana,
        biomasa,
        observaciones,
        gananciaSemanal,
        pesoMeta,
        porcentajeMeta,
        porcentajeAlimento,
        qAlimento,
        mortalidad
      ];
}
