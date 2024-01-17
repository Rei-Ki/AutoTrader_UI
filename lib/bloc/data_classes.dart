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
  // late List<Candle> candles;

  Instrument({
    required this.title,
    required this.type,
    required this.tags,
    // this.candles = const [],
  });

  Instrument.fromJson(Map<String, dynamic> json) {
    title = json['title'] ?? '';
    type = json['type'] ?? '';
    // candles = List<Candle>.empty();
    tags = (json['tags'] as List<dynamic>? ?? [])
        .map((tag) => tag.toString())
        .toList();
  }
}

// Candle для свечей
class Candle {
  late double open;
  late double high;
  late double low;
  late double close;
  late DateTime datetime;
  late String sec;
  late double volume;
  late String classCode;
  late int interval;

  Candle({
    required this.close,
    required this.low,
    required this.open,
    required this.high,
    required this.datetime,
    required this.sec,
    required this.volume,
    required this.classCode,
    required this.interval,
  });

  //! Сделать перевод даты в датувремя
  // datetime: {month: 1, week_day: 1, sec: 0, hour: 17, ms: 0, year: 2024, count: 1, min: 58, day: 15}}

  Candle.fromJson(Map<String, dynamic> json) {
    open = json['open'] ?? 0;
    high = json['high'] ?? 0;
    low = json['low'] ?? 0;
    close = json['close'] ?? 0;
    sec = json['sec'] ?? "";
    volume = json['volume'] ?? 0;
    classCode = json['class'] ?? "";
    interval = json['interval'] ?? 1;
    datetime = parseDateTime(json['datetime']);
  }
}

DateTime parseDateTime(Map<String, dynamic> jsonDatetime) {
  return DateTime(
    jsonDatetime['year'],
    jsonDatetime['month'],
    jsonDatetime['day'],
    jsonDatetime['hour'],
    jsonDatetime['min'],
    jsonDatetime['sec'],
    jsonDatetime['ms'],
  );
}
