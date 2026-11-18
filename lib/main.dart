import 'dart:io';
import 'package:deepseek/provider/auth_provider.dart';
import 'package:deepseek/provider/chat_provider.dart';
import 'package:deepseek/provider/image_provider.dart';
import 'package:deepseek/provider/onBoardingProvider.dart';
import 'package:deepseek/provider/theme_provider.dart';
import 'package:deepseek/screens/splash_screen.dart';
import 'package:deepseek/utiles/pref_helper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive_flutter/adapters.dart';
import 'firebase_options.dart'; // Make sure this file exists
import 'package:provider/provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'models/message_model.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  //registerAdapter → Hive needs it for custom object
  Hive.registerAdapter(MessageModelAdapter());
  //chatBox → stores all messages permanently
  await Hive.openBox<MessageModel>('chatBox');

  await Pref.initialize();
  // non web platforms
  // if(!kIsWeb) {
  //   await dotenv.load(fileName: ".env");
  // }
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  if(!kIsWeb) {
    await MobileAds.instance.initialize();
  }
  // Required for desktop (Windows, Linux, macOS) or Web if using sqflite_common_ffi
  if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ChatProvider()),
        ChangeNotifierProvider(create: (context) => ImageGeneratorProvider()),
        ChangeNotifierProvider(create: (context) => OnBoardingProvider()),
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => AuthProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      themeMode:
          context.watch<ThemeProvider>().getThemeValue()
              ? ThemeMode.dark
              : ThemeMode.light,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      // theme: ThemeData(
      //   colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      // ),
      home: SplashScreen(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
