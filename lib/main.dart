import 'package:deepseek/provider/auth_provider.dart';
import 'package:deepseek/provider/chat_provider.dart';
import 'package:deepseek/provider/onBoardingProvider.dart';
import 'package:deepseek/provider/theme_provider.dart';
import 'package:deepseek/screens/home_screen.dart';
import 'package:deepseek/screens/login_page.dart';
import 'package:deepseek/screens/regestration_page.dart';
import 'package:deepseek/screens/splash_screen.dart';
import 'package:deepseek/utiles/pref_helper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart'; // Make sure this file exists
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Pref.initialize();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ChatProvider()),
        ChangeNotifierProvider(create: (context) => OnBoardingProvider(),),
        ChangeNotifierProvider(create: (context) => ThemeProvider(),),
        ChangeNotifierProvider(create: (context) => AuthProvider(),),
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
      themeMode: context.watch<ThemeProvider>().getThemeValue()
      ?ThemeMode.dark
      :ThemeMode.light,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      // theme: ThemeData(
      //   colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      // ),
      home: SplashScreen(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
