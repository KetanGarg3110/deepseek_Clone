import 'package:deepseek/models/home_type.dart';
import 'package:deepseek/provider/theme_provider.dart';
import 'package:deepseek/utiles/util_helper.dart';
import 'package:deepseek/widgets/home_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import '../utiles/pref_helper.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen> {
//   @override
//   void initState() {
//     super.initState();
//     Pref.showOnBoarding = false;
//   }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "AI Assistant",
          style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
        ),
        actions: [
          Consumer<ThemeProvider>(
            builder: (context, provider, child) {
              return IconButton(
                padding: const EdgeInsets.only(right: 10),
                onPressed: () {
                  provider.toggleTheme();
                },
                icon: Icon(
                  Icons.brightness_4_rounded,
                  size: 26,
                  color: Colors.blue,
                ),
              );
            },
          ),
        ],
        centerTitle: true,
        elevation: 5,
        bottomOpacity: 4,
        shadowColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(6.0),
        child: ListView(
          padding: EdgeInsets.symmetric(vertical: 5),
          children: HomeType.values.map((e) => HomeCard(homeType: e)).toList(),
        ),
      ),
    );
  }
}
