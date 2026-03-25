/// إعدادات Supabase — يُفضّل استخدام --dart-define في الإنتاج:
/// flutter run --dart-define=SUPABASE_URL=... --dart-define=SUPABASE_ANON_KEY=...
class SupabaseConfig {
  static const String supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://omkjmtyaodsibyvsqtfo.supabase.co',
  );

  static const String supabaseAnonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im9ta2ptdHlhb2RzaWJ5dnNxdGZvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzE4NzE4MDksImV4cCI6MjA4NzQ0NzgwOX0.2TNvob0lb2S1syXVBTVDFCa8JNzmF92Iu_SH0ge1hQM',
  );
}
