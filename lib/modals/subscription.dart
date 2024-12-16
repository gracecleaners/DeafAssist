class SubscriptionModel {
  final String userId;
  final DateTime purchaseDate;
  final bool isActive;

  SubscriptionModel({
    required this.userId,
    required this.purchaseDate,
    required this.isActive,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'purchaseDate': purchaseDate.toIso8601String(),
      'isActive': isActive,
    };
  }

  factory SubscriptionModel.fromMap(Map<String, dynamic> map) {
    return SubscriptionModel(
      userId: map['userId'],
      purchaseDate: DateTime.parse(map['purchaseDate']),
      isActive: map['isActive'],
    );
  }
}