import 'package:evento/Manager/Providers/LoginProvider.dart';
import 'package:evento/Manager/Providers/ManagerProvider.dart';
import 'package:evento/Manager/Screens/splashScreen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import 'Boys/Providers/boys_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
        ChangeNotifierProvider(create: (context) => LoginProvider(),),
        ChangeNotifierProvider(create: (context) => ManagerProvider(),),
        ChangeNotifierProvider(create: (context) => BoysProvider(),),
        ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Evento',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const SplashScreen(),
      ),
    );
  }
}

