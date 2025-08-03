import 'package:supabase_flutter/supabase_flutter.dart';

class appBD{
  static Future<void> init() async{
    await Supabase.initialize(
       url: 'https://jkcdrmfnzohdemtuqizc.supabase.co',
      anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImprY2RybWZuem9oZGVtdHVxaXpjIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTI5ODEzNzAsImV4cCI6MjA2ODU1NzM3MH0.qn1_UtV3OQcEbCmdqAOpbqveAT6abvzV7GgtLZpbl7c',
    );
  }
  static SupabaseClient get client => Supabase.instance.client;
}
