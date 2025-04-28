import 'package:deepseek/models/home_type.dart';
import 'package:deepseek/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lottie/lottie.dart';

import '../utiles/util_helper.dart';

class HomeCard extends StatelessWidget {
  final HomeType homeType;
  const HomeCard({super.key,required this.homeType});

  @override
  Widget build(BuildContext context) {

      return InkWell(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => homeType.navigate,));
        },
        child: Container(
          margin: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.blue[200],
          ),
          width: double.infinity,
          height: 100,
          child: homeType.leftAlign
          ? Row(
            children: [
              Padding(
                padding: homeType.padding,
                child: SizedBox(width:150,child: Lottie.asset(homeType.lottie)),
              ),
              Expanded(
                child: Center(
                  child: Text(
                    homeType.title,
                    style: mTextStyle16(
                      mColor: Colors.black,
                      mFontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          )
          :   Row(
            children: [
              Expanded(
                child: Center(
                  child: Text(
                    homeType.title,
                    style: mTextStyle16(
                      mColor: Colors.black,
                      mFontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 200,
               // child: Padding(
                 // padding: homeType.padding,
                  child: Lottie.asset(homeType.lottie),
                ),
            //  ),

            ],
          )// 0 -> Invisible 0.5-> 505 VISIBLE  1-> visible
        ).animate().fade(duration: 1.seconds),
      );
  }
}
