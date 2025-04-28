import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:deepseek/models/message_model.dart';
import 'package:flutter/material.dart';
import '../utiles/util_helper.dart';

class BotMessageWidget extends StatefulWidget {
  final MessageModel messageModel;
  const BotMessageWidget({super.key, required this.messageModel});

  @override
  State<BotMessageWidget> createState() => _BotMessageWidgetState();
}

class _BotMessageWidgetState extends State<BotMessageWidget> {
  @override
  Widget build(BuildContext context) {
    bool _shouldAnimate = !widget.messageModel.isAnimated;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: Colors.black,
            radius: 20,
            child: Image.asset(
              "assets/images/bot_Icon.png",
              width: 20,
              height: 20,
            ),
          ),
          SizedBox(width: 11),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.yellow.shade700,
                borderRadius: BorderRadius.circular(8),
              ),
              child:
                  _shouldAnimate
                      ? DefaultTextStyle(
                        style: mTextStyle16(
                          mColor: Colors.black,
                          mFontWeight: FontWeight.bold,
                        ),
                        child: AnimatedTextKit(
                          repeatForever:
                              false, // ye text or text ke animation ko repeat ko band karne ke liye false laye ge.
                          totalRepeatCount: 1,
                          isRepeatingAnimation: false,
                          animatedTexts: [
                            TypewriterAnimatedText(widget.messageModel.msg),
                          ],
                          onFinished: () {
                            setState(() {
                              widget.messageModel.isAnimated = true;
                            });
                          },
                        ),
                      )
                      : SelectableText(
                        widget.messageModel.msg,
                        style: mTextStyle16(
                          mColor: Colors.black,
                          mFontWeight: FontWeight.bold,
                        ),
                      ),
            ),
          ),
        ],
      ),
    );
  }
}
