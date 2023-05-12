import 'package:firedart/firedart.dart';
import 'package:logger/logger.dart';

class Login {
  static final FirebaseAuth auth = FirebaseAuth.instance;
  static final logger = Logger();

  static Future<void> signIn(String email, String password) async {
    try {
      await auth.signIn(email, password);
      logger.i("Signed in successfully");
    } catch (e) {
      logger.i("Failed to sign in: $e");
    }
  }
}
