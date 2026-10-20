class TargetContact {
  final String id;
  final String name;
  final String phoneNumber;

  TargetContact({
    required this.id,
    required this.name,
    required this.phoneNumber,
  });

  factory TargetContact.fromJson(Map<String, dynamic> json) {
    return TargetContact(
      id: json['id'] as String,
      name: json['name'] as String,
      phoneNumber: json['phoneNumber'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phoneNumber': phoneNumber,
    };
  }
}
