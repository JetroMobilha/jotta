class VaultItem {
  final String id;
  final String phoneNumber;
  final String contactName;
  final String content;
  final DateTime timestamp;
  final String type; // 'sms_in', 'sms_out', 'call_in', 'call_out', 'call_missed'

  VaultItem({
    required this.id,
    required this.phoneNumber,
    required this.contactName,
    required this.content,
    required this.timestamp,
    required this.type,
  });

  factory VaultItem.fromJson(Map<String, dynamic> json) {
    return VaultItem(
      id: json['id'] as String,
      phoneNumber: json['phoneNumber'] as String,
      contactName: json['contactName'] as String,
      content: json['content'] as String,
      timestamp: DateTime.fromMillisecondsSinceEpoch(json['timestamp'] as int),
      type: json['type'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'phoneNumber': phoneNumber,
      'contactName': contactName,
      'content': content,
      'timestamp': timestamp.millisecondsSinceEpoch,
      'type': type,
    };
  }
}
