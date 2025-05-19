class Message {
  final int from, to;
  final String message;

  const Message({required this.from, required this.to, required this.message});

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      from: json['from'],
      to: json['to'],
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() => {'from': from, 'to': to, 'message': message};
}
