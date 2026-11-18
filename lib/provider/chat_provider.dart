import 'package:deepseek/data/remote/api/api_helper.dart';
import 'package:deepseek/models/ai_generatedModel.dart';
import 'package:deepseek/models/message_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';

import '../data/remote/api/urls.dart';

//  Data ko handle kar sake or usko notify kar sake to esko changeNotifier se extend kare ge.
class ChatProvider extends ChangeNotifier {
  // yaha per sabhi events hoge jo user ko UI main reflect karwane hai like data set, change , update
  // jitne bhi question prompt hote rahe ge vo yaha ListMsg main add hote rahe ge.
  List<MessageModel> listMsg = [];
  bool isTyping = false;

  // We will:
  // Load old chats on startup
  // Save every new message to Hive.
  final Box<MessageModel> chatBox = Hive.box<MessageModel>('chatBox');

  ChatProvider() {
    loadChatHistory();
  }

  // 📌 Why reversed?
  // Hive stores old → new
  // Your UI uses new messages at top
  void loadChatHistory() {
    listMsg = chatBox.values.toList().reversed.toList();
    notifyListeners();
  }

  void saveToHive(MessageModel messageModel) {
    chatBox.put(messageModel.messageId, messageModel);
  }

  void sendMyPrompt({required String prompt}) async {
    isTyping = true;

    final userMessage = MessageModel(
      messageId: DateTime.now().millisecondsSinceEpoch.toString(),
      msg: prompt,
      senderID: 0,
      sentAt: DateTime.now().millisecondsSinceEpoch,
    );

    // list of items moving bottom to top or reverse mod
    /// User asking
    listMsg.insert(0, userMessage);
    saveToHive(userMessage);
    // Ui main reflect karwana hai
    notifyListeners();

    /// AiBot Answering
    // Now call the Api to get Ai response
    // because of ai_helper main throw kiya tha to yaha catch kare ge .
    //koi error na aa jaye to try catch lagaye ge
    try {
      // firstly phele data nikale ge APihelper se
      final mData = await ApiHelper().generateAiMessage(
        url: Urls.CHAT_COMPELETION_API,
        prompt: prompt,
      );

      // mdata aa giya usko Ai model main insert kardo.
      // from json :- Map ki form main jo data hoga usko Json main convert karde ga
      //Converts JSON data to a Dart object (AiGeneratedModel), which contains AI-generated messages.
      AiGeneratedModel aiGeneratedModel = AiGeneratedModel.fromJson(mData);
      isTyping = false;

      final botMessage = MessageModel(
        messageId: "${DateTime.now().millisecondsSinceEpoch}_bot",
        msg: aiGeneratedModel.choices![0].message!.content!,
        senderID: 1,
        sentAt: DateTime.now().millisecondsSinceEpoch,
      );
      // !mark check null operator ki tra work karta hai. Esse compiler ko shurity mil gayi ki ye null nahi hogi
      // Add Ai message to list
      listMsg.insert(0, botMessage);
      saveToHive(botMessage);

      notifyListeners();
    } catch (e) {
      final errorMsg = MessageModel(
        messageId: "${DateTime.now().millisecondsSinceEpoch}_err",
        msg: e.toString(),
        senderID: 1,
        sentAt: DateTime.now().millisecondsSinceEpoch,
      );
      listMsg.insert(0, errorMsg);
      saveToHive(errorMsg);
      // jo bhi es data ko watch kar rahe hoge to content rebuild ho jaye ge
      notifyListeners();
    }
  }

  // ye function list ka reference dega . hum directly bhi get kar sakte the.
  // Returns the current list of all messages for other parts of the app to read.
  List<MessageModel> getAllMessage() {
    return listMsg;
  }
}
