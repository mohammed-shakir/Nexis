import 'package:flutter/material.dart';
import '../widgets/custom_button.dart';
import '../firebase/firestore_write.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  final TextEditingController messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Nexis',
              style: Theme.of(context).textTheme.displayMedium,
            ),
            const SizedBox(height: 10),
            // TODO: Replace this in the future with a custom text field
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.6,
              child: TextField(
                controller: messageController,
                decoration: InputDecoration(
                  labelText: 'Enter your message',
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
            const SizedBox(height: 10),
            // TODO: Replace this in the future with a icon button
            CustomButton(
              text: 'Send Message',
              onPressed: () async {
                try {
                  await FirestoreWrite.sendMessage(
                    message: messageController.text,
                    // TODO: Replace this with the actual user's name
                    sender: 'some user',
                  );

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Message sent successfully!')),
                  );

                  messageController.clear();
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error sending message: $e')),
                  );
                }
              },
            ),
            const SizedBox(height: 10),
            CustomButton(
              text: 'Test Page',
              onPressed: () {
                Navigator.pushNamed(context, '/test_page');
              },
            ),
          ],
        ),
      ),
    );
  }

  // Clean up resources that are no longer needed (messageController). If it is not removed, it could cause a memory leak.
  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }
}
