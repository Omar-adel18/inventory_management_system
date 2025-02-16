import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient supabase = Supabase.instance.client;

  Future<AuthResponse> signInWithEmailPassword(
      String email, String password) async {
    return await supabase.auth.signInWithPassword(
      password: password,
      email: email,
    );
  }

  Future<AuthResponse> signUpWithEmailPassword(
    String userName,
    String userRole,
    String email,
    String password,
  ) async {
    return await supabase.auth.signUp(
      password: password,
      email: email,
      data: {
        'UserName': userName,
        'UserRole': userRole,
      },
    );
  }

  Future<void> resetPassword(String email) async {
    await supabase.auth.resetPasswordForEmail(email);
  }

  Future<void> signOut() async {
    await supabase.auth.signOut();
  }

  String? getCurrentUserEmail() {
    final session = supabase.auth.currentSession;
    final user = session?.user;
    return user?.email;
  }

  String? getCurrentUserName(){
    final session = supabase.auth.currentSession;
    final user = session?.user;
    return user!.userMetadata?['UserName'];
  }

  String? getCurrentUserRole(){
    final session = supabase.auth.currentSession;
    final user = session?.user;
    return user!.userMetadata?['UserRole'];
  }
}
