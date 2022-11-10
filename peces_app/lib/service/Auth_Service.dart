// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthClass {
  static final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'https://mail.google.com/',
      'email',
      'https://www.googleapis.com/auth/contacts',
      'https://www.googleapis.com/auth/spreadsheets'
    ],
  );

  final FirebaseAuth auth = FirebaseAuth.instance;
  final storage = const FlutterSecureStorage();

  Future<void> googleSignIn(BuildContext context) async {
    try {
      //Abrimos el pop up para iniciar sesión
      GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();
      //Revisamos que nada haya ido mal
      if (googleSignInAccount != null) {
        //Buscamos las credenciales
        GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;
        //Credenciales
        AuthCredential credential = GoogleAuthProvider.credential(
            idToken: googleSignInAuthentication.idToken,
            accessToken: googleSignInAuthentication.accessToken);
        //Iniciamos sesión con las credenciales de Google
        try {
          UserCredential userCredential =
              await auth.signInWithCredential(credential);
          guardarTokenYData(userCredential);
          var usuarios = FirebaseFirestore.instance.collection('usuario');
          //Primero revisamos si el usuario ya existe
          var query =
              usuarios.where('email', isEqualTo: auth.currentUser!.email);
          QuerySnapshot user = await query.get();
          //Si el usuario no existía previamente
          List<String> lotes = [];
          if (user.docs.isEmpty) {
            //Añadimos el usuario a la base de datos
            await usuarios.add({
              'propietario': auth.currentUser!.displayName,
              'lotes': lotes,
              'email': auth.currentUser!.email,
              'spreadsheet': ''
            });
          }
        } on Exception catch (e) {
          final snackbar = SnackBar(content: Text(e.toString()));
          ScaffoldMessenger.of(context).showSnackBar(snackbar);
        }
      } else {
        final snackbar =
            const SnackBar(content: Text('No se pudo iniciar sesión'));
        ScaffoldMessenger.of(context).showSnackBar(snackbar);
      }
    } catch (e) {
      final snackbar = SnackBar(content: Text(e.toString()));
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
    }
  }

  Future<void> guardarTokenYData(UserCredential userCredential) async {
    //Con flutter storage guardamos el token de la user credential
    await storage.write(
        key: 'token', value: userCredential.credential!.token.toString());
    await storage.write(
        key: 'userCredential', value: userCredential.toString());
  }

  Future<String?> guardarToken() async {
    //Obtenemos el token que previamente guardamos
    return await storage.read(key: 'token');
  }

  Future<void> logOut() async {
    try {
      //Realizamos un logout
      await _googleSignIn.signOut();
      await auth.signOut();
      await storage.delete(key: 'token');
    } catch (e) {}
  }
}
