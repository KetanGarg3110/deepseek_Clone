import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:deepseek/provider/chat_provider.dart';
import 'package:deepseek/utiles/util_helper.dart';
import 'package:deepseek/widgets/bot_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:speech_to_text/speech_to_text.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController promptController = TextEditingController();
  final SpeechToText _speechToText = SpeechToText();
  final DateFormat dtFormat = DateFormat.Hm();

  bool _showWelcomeTxt = true; // show animation at start
  bool _isListening = false;
  String _lastWords = ""; // holds converted text

  @override
  void dispose() {
    promptController.dispose();
    _speechToText.stop(); // Stop speech-to-text on dispose
    super.dispose();
  }

  Future<void> _listen() async {
    if (!_isListening) {
      bool available = await _speechToText.initialize(
        onStatus: (status) {
          if(status== "done" || status == "notListening"){
            setState(() => _isListening=false);
            }
          print('Status: $status');
            },
        onError: (errorNotification) {
          print('Error: $errorNotification');
          setState(() {
            _isListening=false;
          });
        },
      );

      if (available) {
        setState(() {
          _isListening = true;
          _speechToText.listen(
            onResult: (result) {
              setState(() {
                _lastWords = result.recognizedWords;
                promptController.text = _lastWords; // update our text filed
              });
            },
          );
        });
      } else {
        await _speechToText.stop();
        setState(() {
          _isListening = false;
        });
      }
    }
  }

  void _sendMessage() {
    //  ApiHelper().generateAiMessage(url: Urls.CHAT_COMPELETION_API, prompt: promptController.text);
    // hum esko provider ki help se kare ge .agar hamko kisi or page per list ki need hogi to provider will be help

    // yeha per hum read kare ge write nahi to listen false kare ge .

    if (promptController.text.trim().isEmpty) return;

    // Hide welcome animation when first message sent
    if (_showWelcomeTxt) {
      setState(() {
        _showWelcomeTxt = false;
      });
    }
    Provider.of<ChatProvider>(
      context,
      listen: false,
    ).sendMyPrompt(prompt: promptController.text.trim());
    promptController.clear();
  }

  Widget _buildInputField() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: TextField(
        controller: promptController,
        enableSuggestions: true,
        style: mTextStyle16(mColor: Colors.white),
        decoration: InputDecoration(
          fillColor: AppColors.secondaryColor,
          filled: true,
          prefixIcon: InkWell(
            onTap: _listen,
            child:
                _isListening
                    ? Padding(
                      padding: const EdgeInsets.all(11.0),
                      child: LoadingAnimationWidget.staggeredDotsWave(
                        color: Colors.white,
                        size: 24,
                      ),
                    )
                    : Icon(Icons.mic, color: Colors.white),
          ),
          suffixIcon: InkWell(
            onTap: _sendMessage,
            child: Icon(Icons.send, color: Colors.white),
          ),
          hintText: "Write a question ..",
          hintStyle: mTextStyle16(
            mColor: AppColors.whiteColor,
            mFontWeight: FontWeight.bold,
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(21)),
        ),
      ),
    );
  }

  Widget _buildWelcomeScreen() {
    return Column(
      children: [
        Expanded(
          child: Center(
            child: Column(
              children: [
                SizedBox(height: 70),
                Image.asset(
                  'assets/images/deepseekLogo.png',
                  width: 200,
                  height: 200,
                ),
                SizedBox(height: 5),
                SelectableText(
                  'Hey, What Can I Help With ?',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 5),
                Center(
                  child: SelectableText(
                    'You can tell anything  you want they can generate answer ',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 15, color: Colors.white,),
                  ),
                ),
              ],
            ),
          ),
        ),
        _buildInputField(),
      ],
    );
  }

  Widget _buildChatScreen() {
    return Column(
      children: [
        // es view main data leke ana hoga to vo kaha se mile ga .to Consumer wigid lege.
        //Consumer helps to only  build wigit not that all page .
        Expanded(
          child: Consumer<ChatProvider>(
            builder: (_, provider, child) {
              // jab bhi hun notifyListner kar rahe hoge to ye vo changes lake dega .or flutter main jab bhi data chnge hota to use reflect kaewaan hota .to ye esi component ko rebuild karta rahe ga
              var listMsg = provider.getAllMessage();

              return ListView.builder(
                reverse: true, // bottom se chatting hogi
                itemCount: listMsg.length,
                itemBuilder: (_, index) {
                  var msgModel = listMsg[index];
                  return msgModel.senderID == 1
                      ? BotMessageWidget(messageModel: msgModel) //bot
                      : Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8.0,
                          horizontal: 12.0,
                        ),
                        child: Row(
                          // User Work
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Flexible(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: const EdgeInsets.all(11.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    SelectableText(
                                      maxLines: null,
                                      msgModel.msg,
                                      style: mTextStyle16(
                                        mColor: Colors.black,
                                        mFontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      dtFormat.format(
                                        DateTime.fromMillisecondsSinceEpoch(
                                          msgModel.sentAt,
                                        ),
                                      ),
                                      style: mTextStyle12(
                                        mColor: Colors.grey[200]!,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(width: 11),
                            CircleAvatar(
                              backgroundColor: Colors.black,
                              radius: 20,
                              child: Image.asset(
                                "assets/images/user_icon.png",
                                width: 20,
                                height: 20,
                              ),
                            ),
                          ],
                        ),
                      );
                  // ye sab karne ke baad provider ko inject bhi karna hoga splashscreen main .
                },
              );
            },
          ),
        ),
        // ADD this below ListView
        Consumer<ChatProvider>(
          builder: (_, provider, __) {
            return provider.isTyping
                ? Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: LoadingAnimationWidget.staggeredDotsWave(
                    color: Colors.white,
                    size: 40,
                  ),
                )
                : SizedBox.shrink();
          },
        ),
        _buildInputField(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: PreferredSize(
        // Custom height
        preferredSize: Size.fromHeight(60),
        child: Container(
          padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
          decoration: BoxDecoration(
            color: Colors.grey[900],
            boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 5)],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Image.network(
                  'https://artificialanalysis.ai/img/logos/deepseek.png',
                  width: 100,
                  height: 80,
                  fit: BoxFit.contain,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 15.0),
                child:
                // TextLiquidFill(
                //   text: "ChatBot",
                //   waveColor: Colors.blueAccent,
                //   textStyle: TextStyle(
                //     fontWeight: FontWeight.bold,
                //     fontSize: 22.0,
                //   ),
                //   boxHeight: 46,
                // ),
                Text(
                  'ChatBot',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.menu, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
      body: _showWelcomeTxt ? _buildWelcomeScreen() : _buildChatScreen(),
    );
  }
}
