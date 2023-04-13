import 'package:flutter/material.dart';
import '../widgets/custom_button.dart';
import '../src/theme.dart';
import 'package:firedart/firedart.dart';

const projectId = 'nexis-4723a';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late CollectionReference msgs;
  String _messageText = '';

  _HomeState() {
    _initializeFirestore();
  }

  Future<void> _initializeFirestore() async {
    Firestore.initialize(projectId);
    msgs = Firestore.instance.collection('messages');
  }

  Future<void> _addMessage() async {
    if (_messageText.trim().isNotEmpty) {
      await msgs.add({'text': _messageText});
      setState(() {
        _messageText = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF171c2a),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Nexis',
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Arial',
                fontSize: 24,
              ),
            ),
            const SizedBox(height: 10),
            CustomButton(
              text: 'Test Page',
              onPressed: () {
                Navigator.pushNamed(context, '/test_page');
              },
            ),
            const SizedBox(height: 10),
            CustomButton(
              text: 'Get all messages',
              onPressed: () async {
                final messages = await msgs.get();
                print(messages);
              },
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    _messageText = value;
                  });
                },
                decoration: const InputDecoration(
                  labelText: 'Enter your message',
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(),
                ),
                maxLines: null,
              ),
            ),
            const SizedBox(height: 10),
            CustomButton(
              text: 'Submit',
              onPressed: () {
                _addMessage();
              },
            ),
          ],
        ),
      ),
    );
  }
}
