import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ParaCareApp());
}

class ParaCareApp extends StatelessWidget {
  const ParaCareApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ParaCare',
      home: Scaffold(
        appBar: AppBar(title: const Text('ParaCare')),
        body: Center(
          child: Text(
            'Firebase connected: ${Firebase.app().options.projectId}',
          ),
        ),
      ),
    );
  }
}