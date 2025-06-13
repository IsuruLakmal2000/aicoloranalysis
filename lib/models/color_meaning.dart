import 'package:hive/hive.dart';

part 'color_meaning.g.dart';

@HiveType(typeId: 3)
class ColorMeaning {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String colorHex;

  @HiveField(2)
  final String colorName;

  @HiveField(3)
  final String shortDescription;

  @HiveField(4)
  final String psychologicalEffects;
  
  @HiveField(5)
  final String culturalAssociations;

  @HiveField(6)
  final List<String> commonUses;

  @HiveField(7)
  final DateTime createdAt;

  ColorMeaning({
    required this.id,
    required this.colorHex,
    required this.colorName,
    required this.shortDescription,
    required this.psychologicalEffects,
    required this.culturalAssociations,
    required this.commonUses,
    required this.createdAt,
  });

  factory ColorMeaning.fromJson(Map<String, dynamic> json) {
    return ColorMeaning(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      colorHex: json['hex_code'],
      colorName: json['color_name'],
      shortDescription: json['short_description'],
      psychologicalEffects: json['psychological_effects'],
      culturalAssociations: json['cultural_associations'],
      commonUses: List<String>.from(json['common_uses']),
      createdAt: DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'hex_code': colorHex,
      'color_name': colorName,
      'short_description': shortDescription,
      'psychological_effects': psychologicalEffects,
      'cultural_associations': culturalAssociations,
      'common_uses': commonUses,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
