class Email {
  final String id;
  final String sender;
  final String subject;
  final String body;
  final DateTime time;
  bool isRead;

  Email({
    required this.id,
    required this.sender,
    required this.subject,
    required this.body,
    required this.time,
    this.isRead = false,
  });
}