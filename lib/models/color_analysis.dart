import 'package:hive/hive.dart';

part 'color_analysis.g.dart';

@HiveType(typeId: 1)
class ColorAnalysis {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String seasonType;

  @HiveField(2)
  final List<String> primaryColors;

  @HiveField(3)
  final String description;

  @HiveField(4)
  final List<String> styleTips;

  @HiveField(5)
  final DateTime createdAt;

  ColorAnalysis({
    required this.id,
    required this.seasonType,
    required this.primaryColors,
    required this.description,
    required this.styleTips,
    required this.createdAt,
  });

  factory ColorAnalysis.fromJson(Map<String, dynamic> json) {
    return ColorAnalysis(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      seasonType: json['season_type'],
      primaryColors: List<String>.from(json['primary_colors']),
      description: json['description'],
      styleTips: List<String>.from(json['style_tips']),
      createdAt: DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'season_type': seasonType,
      'primary_colors': primaryColors,
      'description': description,
      'style_tips': styleTips,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
