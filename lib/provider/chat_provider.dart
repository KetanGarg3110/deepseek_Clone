import 'package:deepseek/data/remote/api/api_helper.dart';
import 'package:deepseek/models/ai_generatedModel.dart';
import 'package:deepseek/models/message_model.dart';
import 'package:flutter/cupertino.dart';

import '../data/remote/api/urls.dart';


//  Data ko handle kar sal=ke or usko notify kar sake to esko changenotifier se extend kare ge.
class ChatProvider extends ChangeNotifier {

  // yaha per sabhi events hoge jo user ko UI main reflecct karwane hai .
  // like data set, change , update
  // jitne bhi question prompt hote rahe ge vo yaha add hote rahe ge.
  List<MessageModel> listMsg = [];
  bool isTyping = false;

  void sendMyPrompt({required String prompt}) async {
    isTyping =true;
    // list of items moving bottom to top or reverse mod
    // user asking
    listMsg.insert(
      0,
      MessageModel(
        msg: prompt,
        senderID: 0,
        sentAt: DateTime.now().millisecondsSinceEpoch,
      ),
    );
    // Ui main reflect karwana hai
    notifyListeners();

    // aiBot Answering
    // yaha ai handling kare ge because of ai_helper main trow kiya tha to yaha catch kare ge .
    //koi error na aa
    // jaye to try catch lagaye ge
    try {
      // firlstly phele data nikale ge APihelper se
      final mData = await ApiHelper().generateAiMessage(
        url: Urls.CHAT_COMPELETION_API,
        prompt: prompt,
      );

      // mdata aa giya usko Ai model main insert kardo
      // from json :- Map ki form main jo data hoga usko Json main convert karde ga
      AiGeneratedModel aiGeneratedModel = AiGeneratedModel.fromJson(mData);
      isTyping =false;
      // !mark ckeck null operator ki tra work karta hai. esse compiler ko shurity mil gayi ki ye null nahi hogi
      listMsg.insert(
        0,
        MessageModel(
          msg: aiGeneratedModel.choices![0].message!.content!,
          senderID: 1,
          sentAt: DateTime.now().millisecondsSinceEpoch,
        ),
      );

      notifyListeners();
    } catch (e) {
      listMsg.insert(
        0,
        MessageModel(
          msg: e.toString(),
          senderID: 1,
          sentAt: DateTime.now().millisecondsSinceEpoch,
        ),
      );
      notifyListeners(); // jo bhi es data ko watch kar rahe hoge to content rebuild ho jaye ge
    }
  }

  // ye function list ka reference dega . hun directly bhi get kar sakte the.

  List<MessageModel> getAllMessage() {
    return listMsg;
  }
}
