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
  late List<String> tags;

  Pulse({
    required this.title,
    required this.operation,
    required this.price,
    required this.date,
    required this.quantity,
    required this.tags,
  });

  Pulse.fromJson(Map<String, dynamic> json) {
    title = json['title'] ?? '';
    operation = json['operation'] ?? '';
    price = json['price'] ?? '';
    quantity = json['quantity'] ?? '';
    date = json['date'] ?? '';
    tags = (json['tags'] as List<dynamic>? ?? [])
        .map((tag) => tag.toString())
        .toList();
  }
}

// Instrument для страницы инструментов
class Instrument {
  late String title;
  late String type;
  late List<String> tags;

  Instrument({
    required this.title,
    required this.type,
    required this.tags,
  });

  Instrument.fromJson(Map<String, dynamic> json) {
    title = json['title'] ?? '';
    type = json['type'] ?? '';
    tags = (json['tags'] as List<dynamic>? ?? [])
        .map((tag) => tag.toString())
        .toList();
  }
}
