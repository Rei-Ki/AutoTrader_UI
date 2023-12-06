class PulseData {
  late String title;
  late String operation;
  late int price;
  late int quantity;
  late String date;

  PulseData({
    required this.title,
    required this.operation,
    required this.price,
    required this.date,
    required this.quantity,
  });

  PulseData.fromJson(Map<String, dynamic> json) {
    title = json['title'] ?? '';
    operation = json['operation'] ?? '';
    price = json['price'] ?? '';
    quantity = json['quantity'] ?? '';
    date = json['date'] ?? '';
  }
}

class InstrumentData {
  late String title;
  late String type;
  late bool isActive;

  InstrumentData({
    required this.title,
    required this.type,
    required this.isActive,
  });

  InstrumentData.fromJson(Map<String, dynamic> json) {
    title = json['title'] ?? '';
    type = json['type'] ?? '';
    isActive = json['isActive'] ?? '';
  }
}