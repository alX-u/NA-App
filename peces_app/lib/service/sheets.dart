// ignore_for_file: file_names, camel_case_types
// ignore: camel_case_types
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:gsheets/gsheets.dart';
import 'package:peces_app/domain/constants/firebase_constants.dart';
import 'package:peces_app/model/Muestreo.dart';
import 'package:peces_app/model/UserFields.dart';
import 'package:peces_app/service/Auth_Service.dart';

class sheetsAPI {
  sheetsAPI({required this.userEmail, required this.lote});

  final String? userEmail;
  final String lote;

  static const _credentials = r''' {
  "type": "service_account",
  "project_id": "app-peces",
  "private_key_id": "984a82077257342e40d473bbc51d919f6f794841",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQDZFEf8w5jfuHnO\nCBKeY7z4ktQFGhd09j1qi4LwHUySlMaWJaMKGwWc9YEGH2WOdFBAhoR/ocEqxfYw\nDmlL2LjjJqh859o6Kub5/Zy5BPjiYqgqlJ1gZX8qpMkxST166HzJWA6oAoPHlhKY\n8DW93B2KmylgCaijGFiOj0VwL5xVBNMwqLL12l6rXugcC0DkuTJKK7pJfU6BAwDg\nZLruh2xuZKP8Zh8+oFqb5Cg85bOomloo4q4OG20czttmEkX12z23ESRceC2MeKja\ntZXEbmZof5XEIO7dq8LokAAC2YsavZC2NBoSvRbBRFQWToZWO9cIlKAvl4CBsUSC\n1FVicWzfAgMBAAECggEASMACxiOZGrT84T8UWk+rt5ShiJovbUvO1mOt/KGdFWzV\nxuETLGJU9b7TQEWKZ/z0HkPWqN2BWr/gW0ehI0Gc6Md+ZOng2WiiYvqLKPiRHnGY\n0ThgK7uoLBbwtFtKxuOeWm3v7390QZG6ZtXt9NSNc/O/IIfsI8iXeSNrzoauOlFX\nE+NzdZVJW1T7vWdLXJARG2bOHPXFxCESvBgpuE+yckPWnd6XvJk89vH3E45oiiw9\nkzbtomx0FDn4t9GKz/COYlVKt5SJSauBWZi7aBwhlnwgNPaQqrAJRFieT47kff2E\nkANkN4cA8UGQSX6aOjwTGWX+V1s3aZ42zQucCkUbtQKBgQDx7oneNneZq3oWkaJJ\nfPLMh1uF/pur7/ZyhJCDfVQb4Eo6YjzCr0iICv+52VGYkWzBi3rImzk+zaeMrDVn\n66by5HAUbyfbahkU7z88QUj6nuimk73xLtnpsdEMgALQY9JFZAk/Pnxtgzy/QfAn\nobYyOVYlgoJE+8qr1KeH14ZgiwKBgQDls8faJk2EHGTVDmGdSn2p+HQwK0u3fV7J\n5OI8FlhgdbFcbcew/dneymn84TKysIFuxvnSVE3DU0L3lyemF7t0Ly9dt/lsXO8b\nG3QljZJe0zD/Rdj08Cu+Xca/Pq9+5Jv+eX0K1AdPQF3TxQluqGt/BCjszf3855vp\n14HWCQT7fQKBgQCZd8zjNj/2Li27RVTiMy2+CptHS7SqhAUcrfUSRB1ntYbAtHKA\nuTpUek2wMigtlQqdWAJiYP0WVtTTSqZyLq1v5PMoMz7gU9RnUEEX0v4dZVKF4LCb\n3zGCqjbHLCkc0kWfmQ64nMXHnnmZhZV3PoDaKT75emlyoxr0l2hSpqhqcwKBgDDH\nLbBwo9NjKDJqPGZndCoM/bdg6lJLyD49YaF66UeKlqBXG6nFLmf2Oe2ecOKrQsEg\nddqpVl4dJ0Jmkd/eeEsi3f8b21acoZXzDYYP+z4xwNzkmz7gZZmmVlc0W5Ypu8qd\nR+VtwyOcOpCG7grWrwUo//vRfpcfI+fTgNnPzoQNAoGAGsGynzejx8+yDt2v1bYh\nP6bWRV0wNI1eZnwUP50SWA/s9O+uhO6uY5EIH3cyFn94f/Pf0Q/ctrA3rBDcRGj1\n2dSGgnuCHEq5oJD6M1yiShE8GvHQ+jQyCbmhUEN+TWLewBKSNgRC3TPWE/hYkhf6\nQ0vVTCctSInxwS5mbjvHdfo=\n-----END PRIVATE KEY-----\n",
  "client_email": "app-peces@app-peces.iam.gserviceaccount.com",
  "client_id": "118018965115906127794",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/app-peces%40app-peces.iam.gserviceaccount.com"
}''';

  static final _gsheets = GSheets(_credentials);
  static Worksheet? _userSheet;
  static AuthClass authClass = AuthClass();

  //Método para inicilizar la spreadsheet
  static Future init(String userEmail, String lote) async {
    //Inicializamos la colección
    var usuarios = userFirebase;
    //Buscamos al usuario con el email correspondiente
    var query = usuarios.where('email', isEqualTo: userEmail);
    //Obtenemos al usuario
    QuerySnapshot user = await query.get();
    //Obtenemos el user id
    var userID = user.docs[0].id;
    //Si el usuario aún no tiene una spreadsheet creada, la creamos
    if (user.docs[0]['spreadsheet'] == null ||
        user.docs[0]['spreadsheet'] == '') {
      //Creamos una nueva spreadsheet
      debugPrint(userEmail);
      final spreadsheet =
          await _gsheets.createSpreadsheet(userEmail, worksheetTitles: [lote]);
      //Comparto el spreadsheet con la cuenta del developer
      spreadsheet.share('app-peces@app-peces.iam.gserviceaccount.com');
      spreadsheet.share('app.peces@gmail.com');
      spreadsheet.share(userEmail, role: PermRole.reader);
      //Obtenemos el spreadsheet id de esta spreadsheet
      String spreadsheetId = spreadsheet.id;
      //Añadimos el spreadsheetId del usuario a la base de datos
      usuarios.doc(userID).update({'spreadsheet': spreadsheetId});
      //Accedemos a la worksheet respectiva y si no existe la creamos
      _userSheet = await _getWorkSheet(spreadsheet, lote);
      //Llenamos la primera fila de la worksheet respectiva con las variables básicas
      final primeraFila = UserFields.getFields();
      _userSheet!.values.insertRow(1, primeraFila);
      //Si ya tiene una spreadsheet asignada, se utiliza
    } else {
      //Obtenemos la spreadsheet buscando el spreadsheet id en la base de datos
      try {
        //Inicializamos la spreadsheet del usuario
        final spreadsheet =
            await _gsheets.spreadsheet(user.docs[0]['spreadsheet']);
        //Accedemos a la worksheet respectiva y si no existe la creamos
        _userSheet = await _getWorkSheet(spreadsheet, lote);
        final primeraFila = UserFields.getFields();
        _userSheet!.values.insertRow(1, primeraFila);
      } on Exception catch (e) {
        print('Error');
      }
    }
  }

  //Función para añadir una worksheet con el nombre especificado a la spreadsheet especificada
  static Future<Worksheet> _getWorkSheet(
      Spreadsheet spreadsheet, String title) async {
    try {
      return await spreadsheet.addWorksheet(title);
    } on Exception catch (e) {
      return spreadsheet.worksheetByTitle(title)!;
    }
  }

  //Función para insertar información a las worksheets determinadas
  static Future insert(List<Map<String, dynamic>> rowlist) async {
    if (_userSheet == null) return;
    _userSheet!.values.map.appendRows(rowlist);
  }

  //Función para imprimir el último muestreo realizado
  static Future<Muestreo?> imprimirUltima() async {
    if (_userSheet == null) return null;
    final json = await _userSheet!.values.map.lastRow();
    debugPrint('Soy values: ');
    return json == null ? null : Muestreo.fromJson(json);
  }

  //Función para imprimir varios muestreos
  static Future<List<Muestreo>?> getMuestreos() async {
    if (_userSheet == null) return <Muestreo>[];
    final muestreos = await _userSheet!.values.map.allRows();
    return muestreos == null
        ? <Muestreo>[]
        : muestreos.map(Muestreo.fromJson).toList();
  }
}
