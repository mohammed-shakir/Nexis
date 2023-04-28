import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> loadTestEnvironment() async {
  await dotenv.load(fileName: '.env');
}
