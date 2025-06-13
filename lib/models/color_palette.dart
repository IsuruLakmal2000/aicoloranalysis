import 'package:hive/hive.dart';

part 'color_palette.g.dart';

@HiveType(typeId: 2)
class ColorPalette {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final List<String> colors;

  @HiveField(3)
  final String? description;

  @HiveField(4)
  final String? imageUrl;

  @HiveField(5)
  final DateTime createdAt;

  @HiveField(6)
  final String? mood;

  @HiveField(7)
  final List<String>? usageTips;

  ColorPalette({
    required this.id,
    required this.name,
    required this.colors,
    this.description,
    this.imageUrl,
    required this.createdAt,
    this.mood,
    this.usageTips,
  });

  factory ColorPalette.fromJson(Map<String, dynamic> json) {
    return ColorPalette(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: json['name'] ?? 'Custom Palette',
      colors: List<String>.from(json['colors']),
      description: json['description'],
      imageUrl: json['image_url'],
      createdAt: DateTime.now(),
      mood: json['mood'],
      usageTips: json['usage_tips'] != null ? List<String>.from(json['usage_tips']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'colors': colors,
      'description': description,
      'image_url': imageUrl,
      'created_at': createdAt.toIso8601String(),
      'mood': mood,
      'usage_tips': usageTips,
    };
  }
}
