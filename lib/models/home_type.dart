import 'package:deepseek/screens/AiBotImage.dart';
import 'package:deepseek/screens/AiBotMovie.dart';
import 'package:deepseek/screens/chat_screen.dart';
import 'package:flutter/material.dart';

enum HomeType{aiChatBot ,aiImage, aiMovie}


// if we want to make we get type.text or lottie images then make a extention

extension MyHomeType on HomeType {

  String get title => switch (this) {
    HomeType.aiChatBot =>"AI ChatBot" ,
    HomeType.aiImage =>"AI Images" ,
    HomeType.aiMovie =>"AI Generated Movies" ,
  };
  String get lottie => switch (this) {
    HomeType.aiChatBot =>"assets/lottie_files/chatting.json" ,
    HomeType.aiImage =>"assets/lottie_files/liking.json" ,
    HomeType.aiMovie =>"assets/lottie_files/audio_Setup.json" ,
  };
  // for alignment
  bool get leftAlign => switch (this) {
    HomeType.aiChatBot =>true ,
    HomeType.aiImage =>false,
    HomeType.aiMovie =>true ,
  };

  EdgeInsets get padding=> switch(this){
    HomeType.aiChatBot => EdgeInsets.zero,
    HomeType.aiImage => EdgeInsets.all(20),
    HomeType.aiMovie => EdgeInsets.zero,
  };
  Widget get navigate=> switch(this){
    HomeType.aiChatBot => ChatScreen(),
    HomeType.aiImage => AiBotImage(),
    HomeType.aiMovie => AiBotMovie(),
  };
}