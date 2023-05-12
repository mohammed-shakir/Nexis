import 'package:flutter/material.dart';
import 'package:firedart/firedart.dart';
import 'package:logger/logger.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../widgets/custom_button.dart';
import '../firebase/firestore_write.dart';
import '../firebase/firestore_read.dart';
import '../firebase/login.dart';
import 'dart:async';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  final TextEditingController messageController = TextEditingController();
  StreamSubscription<List<Document>>? messagesSubscription;
  late final FirestoreRead firestoreRead;
  var logger = Logger();

  Future<void> signIn() async {
    try {
      await dotenv.load(fileName: ".env");
      await Login.signIn(
          dotenv.env['TEMP_TEST_EMAIL']!, dotenv.env['TEMP_TEST_PASSWORD']!);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error signing in: $e')),
      );
    }
  }

  void sendMessage() async {
    try {
      await FirestoreWrite.sendMessage(
        message: messageController.text,
        sender: dotenv.env['TEMP_TEST_EMAIL']!,
        groupChatId: 'aNAgqEvRvtFLDmjw7Ivz',
      );
      messageController.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error sending message: $e')),
      );
    }
  }

  void listenToMessages() async {    
    try {
      firestoreRead = FirestoreRead();
      firestoreRead.collectionStream.listen((documents) {
        // Do something with the updated documents here if needed
        
        setState(() {
          // Update the UI here

        });
      });
    } catch (e) {
      logger.e('Error listening to messages: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    signIn().then((_) {
      listenToMessages();
    }).catchError((error) {
      logger.e('Error signing in: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Spacer(),
            Text(
              'Nexis',
              style: Theme.of(context).textTheme.displayMedium,
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: messageController,
                      onSubmitted: (_) => sendMessage(),
                      decoration: InputDecoration(
                        // labelText: 'Enter your message',
                        hintText: 'Enter your message',
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        hintStyle: const TextStyle(
                          color: Colors.white,
                        ),
                        fillColor: Theme.of(context).colorScheme.tertiary,
                        filled: true,
                        border: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        labelStyle: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  CustomButton(
                    text: 'Send Message',
                    onPressed: () async {
                      sendMessage();
                    },
                  ),
                  const SizedBox(width: 10),
                  CustomButton(
                    icon: const Icon(Icons.settings),
                    onPressed: () {
                      Navigator.pushNamed(context, '/settings_page');
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: MediaQuery.of(context).padding.bottom),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // Clean up resources that are no longer needed (messageController). If it is not removed, it could cause a memory leak.
  @override
  void dispose() {
    messagesSubscription?.cancel();
    messageController.dispose();
    firestoreRead.cancel();
    super.dispose();
  }
}
