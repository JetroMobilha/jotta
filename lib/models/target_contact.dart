class TargetContact {
  final String id;
  final String name;
  final String phoneNumber;
  final bool blockCalls;
  final String groupName;

  TargetContact({
    required this.id,
    required this.name,
    required this.phoneNumber,
    this.blockCalls = false,
    this.groupName = 'Geral',
  });

  factory TargetContact.fromJson(Map<String, dynamic> json) {
    return TargetContact(
      id: json['id'] as String,
      name: json['name'] as String,
      phoneNumber: json['phoneNumber'] as String,
      blockCalls: json['blockCalls'] as bool? ?? false,
      groupName: json['groupName'] as String? ?? 'Geral',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phoneNumber': phoneNumber,
      'blockCalls': blockCalls,
      'groupName': groupName,
    };
  }

  TargetContact copyWith({
    String? id,
    String? name,
    String? phoneNumber,
    bool? blockCalls,
    String? groupName,
  }) {
    return TargetContact(
      id: id ?? this.id,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      blockCalls: blockCalls ?? this.blockCalls,
      groupName: groupName ?? this.groupName,
    );
  }
}
