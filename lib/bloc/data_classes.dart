// Segment для графика аналитики
class Segment {
  late String name;
  late int value;

  Segment({required this.name, required this.value});

  Segment.fromJson(Map<String, dynamic> json) {
    name = json['name'] ?? '';
    value = json['value'] ?? '';
  }
}

// Pulse для страницы пульса
class Pulse {
  late String title;
  late String operation;
  late int price;
  late int quantity;
  late String date;

  Pulse({
    required this.title,
    required this.operation,
    required this.price,
    required this.date,
    required this.quantity,
  });

  Pulse.fromJson(Map<String, dynamic> json) {
    title = json['title'] ?? '';
    operation = json['operation'] ?? '';
    price = json['price'] ?? '';
    quantity = json['quantity'] ?? '';
    date = json['date'] ?? '';
  }
}

// Instrument для страницы инструментов
class Instrument {
  late String title;
  late String type;
  late bool isActive;

  Instrument({
    required this.title,
    required this.type,
    required this.isActive,
  });

  Instrument.fromJson(Map<String, dynamic> json) {
    title = json['title'] ?? '';
    type = json['type'] ?? '';
    isActive = json['isActive'] ?? '';
  }
}
