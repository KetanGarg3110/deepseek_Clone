import 'dart:async';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:deepseek/provider/chat_provider.dart';
import 'package:deepseek/screens/chat_screen.dart';
import 'package:deepseek/screens/home_screen.dart';
import 'package:deepseek/screens/on_boardScreen.dart';
import 'package:deepseek/utiles/pref_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatelessWidget {
//   const SplashScreen({super.key});
//
//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }
//
// class _SplashScreenState extends State<SplashScreen> {
//
//   @override
//   void initState() {
//     super.initState();
//     _navigateToHome();
//   }

 void  _navigateToHome(BuildContext context) async{

    await Future.delayed(const Duration(seconds: 4),(){
      // getting the onboard value
      final shouldShowOnBoarding =Pref.showOnBoarding;

      Navigator.pushReplacement(
        context,
        // MaterialPageRoute(builder: (context) => ChatScreen()),
        MaterialPageRoute(
          builder:
              (context) =>
          //Provider ke data ko access kon kare ga . vo particular class ka reference too mile .jisme function bna rakher hai.
          // ab ye chatProvider ka access puri Chat screen ko mil giya uya puri Ui ko.
          //     ChangeNotifierProvider(
          //   create: (context) => ChatProvider(),
          //   child:
          //      // ChatScreen(), // agar muje puri app lagana hoya to app per lagata
          //   //Pref.showOnBoarding ? const OnBoardScreen() : const HomeScreen(),
          //   OnBoardScreen()
          // ),
         shouldShowOnBoarding? OnBoardScreen(): HomeScreen(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {

   // initState for StatelessWidget
    WidgetsBinding.instance.addPostFrameCallback((_){
      _navigateToHome(context);
    });

    const colorizeColors = [
      Colors.purple,
      Colors.blue,
      Colors.yellow,
      Colors.red,
    ];

    const colorizeTextStyle = TextStyle(fontSize: 50.0, fontFamily: 'Horizon');

    return Scaffold(
      body: Center(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.black,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(30.0),
                child: Image.asset(
                  'assets/images/robot_appIcon.png',
                  width: 150,
                  height: 150,
                ),
              ),
              AnimatedTextKit(
                animatedTexts: [
                  ColorizeAnimatedText(
                    'Welcome to ...',
                    textStyle: colorizeTextStyle,
                    colors: colorizeColors,
                  ),
                  ColorizeAnimatedText(
                    'DeepSeek AI',
                    textStyle: colorizeTextStyle,
                    colors: colorizeColors,
                  ),
                ],
                isRepeatingAnimation: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
