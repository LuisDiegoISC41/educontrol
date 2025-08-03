import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;
import '../database/appBD.dart';
import '../../features/alumno/data/models/alumnoModels.dart';
import '../../features/docente/data/models/docenteModels.dart';

class GoogleAuthService {
  final supabase.SupabaseClient client = appBD.client;
  final fb_auth.FirebaseAuth _auth = fb_auth.FirebaseAuth.instance;

  /// Inicia sesión con Google, Firebase y Supabase
  Future<fb_auth.User?> signInWithGoogle(String tipoUsuario) async {
    try {
      // 1. Google Sign-In
      final googleUser = await GoogleSignIn(scopes: ['email']).signIn();
      if (googleUser == null) {
        print("Inicio de sesión cancelado por el usuario");
        return null;
      }

      final googleAuth = await googleUser.authentication;

      // 2. Iniciar sesión en Firebase
      final credential = fb_auth.GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );

      final fb_auth.UserCredential firebaseUserCred =
          await _auth.signInWithCredential(credential);
      final fb_auth.User? firebaseUser = firebaseUserCred.user;

      print("Firebase login OK: ${firebaseUser?.email}");

      // 3. Iniciar sesión en Supabase usando el token de Google
      final response = await client.auth.signInWithIdToken(
        provider: supabase.OAuthProvider.google,
        idToken: googleAuth.idToken!,
        accessToken: googleAuth.accessToken!,
      );

      if (response.user == null) {
        throw Exception("No se pudo iniciar sesión en Supabase");
      }
      print("Supabase login OK: ${response.user?.email}");

      // 4. Guardar el usuario en la tabla correspondiente
      if (firebaseUser != null) {
        await _saveUserInTable(firebaseUser, tipoUsuario);
      }

      return firebaseUser;
    } catch (e) {
      print("Error en signInWithGoogle: $e");
      rethrow;
    }
  }

  /// Guarda el usuario en la tabla Alumno o Docente si no existe
  Future<void> _saveUserInTable(fb_auth.User user, String tipoUsuario) async {
    final correo = user.email ?? "";
    final fullName = user.displayName ?? correo.split('@').first;
    final tipo = tipoUsuario.toLowerCase();

    if (tipo == "alumno") {
      final existing = await client.from('alumno').select().eq('correo', correo).maybeSingle();
      if (existing == null) {
        try {
          final alumno = AlumnoModel.fromGoogle(fullName, correo);
          await client.from('alumno').insert(alumno.toMap());
          print("Usuario registrado en alumno: $correo");
        } catch (e) {
          print("Error al insertar usuario en alumno: $e");
          rethrow;
        }
      } else {
        print("Usuario ya existe en alumno: $correo");
      }
    } else if (tipo == "docente") {
      final existing = await client.from('docente').select().eq('correo', correo).maybeSingle();
      if (existing == null) {
        try {
          final docente = DocenteModel.fromGoogle(fullName, correo);
          await client.from('docente').insert(docente.toMap());
          print("Usuario registrado en docente: $correo");
        } catch (e) {
          print("Error al insertar usuario en docente: $e");
          rethrow;
        }
      } else {
        print("Usuario ya existe en docente: $correo");
      }
    } else {
      print("Tipo de usuario desconocido: $tipoUsuario");
    }
  }

  /// Cierra sesión en Firebase, Supabase y Google
  Future<void> signOut() async {
    await _auth.signOut();
    await client.auth.signOut();
    await GoogleSignIn().signOut();
    print("Sesión cerrada correctamente");
  }
}