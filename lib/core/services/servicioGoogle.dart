import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;
import '../database/appBD.dart';
import '../../features/alumno/data/models/alumnoModels.dart';
import '../../features/docente/data/models/docenteModels.dart';

class GoogleAuthService {
  final supabase.SupabaseClient client = appBD.client;
  final fb_auth.FirebaseAuth _auth = fb_auth.FirebaseAuth.instance;

  Future<fb_auth.User?> signInWithGoogle(String tipoUsuario) async {
    try {
      final googleUser = await GoogleSignIn(scopes: ['email']).signIn();
      if (googleUser == null) return null;

      final googleAuth = await googleUser.authentication;
      final credential = fb_auth.GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );

      // Inicia sesión en Firebase
      final fb_auth.UserCredential firebaseUserCred = await _auth.signInWithCredential(credential);
      final fb_auth.User? firebaseUser = firebaseUserCred.user;

      // Ahora usa el token para Supabase
      await client.auth.signInWithIdToken(
        provider: supabase.OAuthProvider.google,
        idToken: googleAuth.idToken!,
        accessToken: googleAuth.accessToken!,
      );

      if (firebaseUser != null) {
        await _saveUserInTable(firebaseUser, tipoUsuario);
      }
      return firebaseUser;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> _saveUserInTable(fb_auth.User user, String tipoUsuario) async {
    final correo = user.email ?? "";
    final fullName = user.displayName ?? correo.split('@').first;
    final table = tipoUsuario.toLowerCase() == "alumno" ? "Alumno" : "Docente";

    final existing = await client.from(table).select().eq('Correo', correo).maybeSingle();
    if (existing == null) {
      if (table == "Alumno") {
        final alumno = AlumnoModel.fromGoogle(fullName, correo);
        await client.from('Alumno').insert(alumno.toMap());
      } else {
        final docente = DocenteModel.fromGoogle(fullName, correo);
        await client.from('Docente').insert(docente.toMap());
      }
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    await client.auth.signOut();
    await GoogleSignIn().signOut();
  }
}
