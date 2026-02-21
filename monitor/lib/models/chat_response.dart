class ChatResponse {
  final String reply;
  final List<String>? suggestions;
  final String? action;
  final Map<String, dynamic>? data;

  const ChatResponse({
    required this.reply,
    this.suggestions,
    this.action,
    this.data,
  });

  factory ChatResponse.fromJson(Map<String, dynamic> json) {
    return ChatResponse(
      reply: json['reply'] ?? 'I am not sure about that.',
      suggestions: json['suggestions'] != null
          ? List<String>.from(json['suggestions'])
          : null,
      action: json['action'],
      data: json['data'],
    );
  }
}
