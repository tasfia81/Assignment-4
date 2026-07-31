enum PassCategoryType {
  event,
  access,
  credential,
}

enum PassStatus {
  active,
  expired,
  redeemed,
}

class PassModel {
  final String passId;
  final String title;
  final PassCategoryType category;
  final String categoryId;
  final String venue;
  final String date;
  final String time;
  final String? seat;
  final PassStatus status;
  final String qrCodeValue;
  final String ownerName;
  final String? price;
  final String? gate;

  PassModel({
    required this.passId,
    required this.title,
    required this.category,
    required this.categoryId,
    required this.venue,
    required this.date,
    required this.time,
    this.seat,
    required this.status,
    required this.qrCodeValue,
    required this.ownerName,
    this.price,
    this.gate,
  });

  factory PassModel.fromJson(Map<String, dynamic> json) {
    return PassModel(
      passId: json['passId'] as String,
      title: json['title'] as String,
      category: PassCategoryType.values.firstWhere(
        (e) => e.toString().split('.').last == json['category'],
        orElse: () => PassCategoryType.event,
      ),
      categoryId: json['categoryId'] as String,
      venue: json['venue'] as String,
      date: json['date'] as String,
      time: json['time'] as String,
      seat: json['seat'] as String?,
      status: PassStatus.values.firstWhere(
        (e) => e.toString().split('.').last == json['status'],
        orElse: () => PassStatus.active,
      ),
      qrCodeValue: json['qrCodeValue'] as String,
      ownerName: json['ownerName'] as String,
      price: json['price'] as String?,
      gate: json['gate'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'passId': passId,
      'title': title,
      'category': category.toString().split('.').last,
      'categoryId': categoryId,
      'venue': venue,
      'date': date,
      'time': time,
      'seat': seat,
      'status': status.toString().split('.').last,
      'qrCodeValue': qrCodeValue,
      'ownerName': ownerName,
      'price': price,
      'gate': gate,
    };
  }
}
