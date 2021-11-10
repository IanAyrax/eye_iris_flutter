final String tableLog = 'log';

class LogFields {
  static final List<String> values = [
    id, result, imagePath, time
  ];

  static final String id = '_id';
  static final String result = 'result';
  static final String imagePath = 'imagePath';
  static final String time = 'time';
}

class Log {
  final int? id;
  final String result;
  final String imagePath;
  final DateTime createdTime;

  const Log({
    this.id,
    required this.result,
    required this.imagePath,
    required this.createdTime,
  });

  Log copy({
    int? id,
    String? result,
    String? imagePath,
    DateTime? createdTime,
  }) =>
      Log(
        id: id ?? this.id,
        result: result ?? this.result,
        imagePath: imagePath ?? this.imagePath,
        createdTime: createdTime ?? this.createdTime,
      );

  static Log fromJson(Map<String, Object?> json) => Log(
        id: json[LogFields.id] as int?,
        result: json[LogFields.result] as String,
        imagePath: json[LogFields.imagePath] as String,
        createdTime: DateTime.parse(json[LogFields.time] as String),
      );

  Map<String, Object?> toJson() => {
    LogFields.id: id,
    LogFields.result: result,
    LogFields.imagePath: imagePath,
    LogFields.time : createdTime.toIso8601String(),
  };
}