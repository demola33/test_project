class Level {
  Level({
    required this.level,
  });

  final String level;

  Map<String, String> toMap() {
    return {
      'level': level,
    };
  }

  factory Level.fromMap(Map<String, dynamic> map) {
    return Level(
      level: map['level'],
    );
  }

  @override
  String toString() => 'Level(level: $level)';
}
