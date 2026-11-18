import 'package:hive/hive.dart';

part 'message_model.g.dart';

@HiveType(typeId: 1)
class MessageModel extends HiveObject {
  @HiveField(0)
  final String msg;
  @HiveField(1)
  final int sentAt;
  @HiveField(2)
  final int senderID; // 0=> user  1=> bot
  @HiveField(3)
  bool isAnimated; // NEW Field
  // It's good practice to have a unique ID for each message
  @HiveField(4)
  final String messageId;

  MessageModel({
    required this.messageId,
    required this.msg,
    required this.senderID,
    required this.sentAt,
    this.isAnimated = false,
  });

  // Factory constructor to create a MessageModel from a Map (from Firebase)
  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      messageId: json['messageId'],
      msg: json['msg'],
      senderID: json['senderID'],
      sentAt: json['sentAt'],
      isAnimated: json['isAnimated'] ?? false,
    );
  }
  //Method to convert a MessageModel instance to a Map (for Firebase)
  Map<String, dynamic> toJson() {
    return {
      'msg': msg,
      'sentAt': sentAt,
      'senderID': senderID,
      'messageId': messageId,
      'isAnimated': isAnimated,
    };
  }
}
