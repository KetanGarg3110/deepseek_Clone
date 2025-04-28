class MessageModel {
  final String msg;
  final int sentAt;
  final int senderID; // 0=> user  1=> bot
  bool isAnimated; // NEW Field

  MessageModel({
    required this.msg,
    required this.senderID,
    required this.sentAt,
    this.isAnimated = false,
  });
}
