import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

import '../models/color_analysis.dart';
import '../models/color_meaning.dart';
import '../models/color_palette.dart';

class StorageService {
  static const String colorAnalysisBoxName = 'color_analyses';
  static const String colorMeaningBoxName = 'color_meanings';
  static const String colorPaletteBoxName = 'color_palettes';

  Future<void> init() async {
    // Initialize Hive for web and mobile differently
    if (kIsWeb) {
      // For web, use the default path
      await Hive.initFlutter();
    } else {
      // For mobile, use the app documents directory
      final appDocumentDir = await getApplicationDocumentsDirectory();
      await Hive.initFlutter(appDocumentDir.path);
    }

    // Register adapters
    Hive.registerAdapter(ColorAnalysisAdapter());
    Hive.registerAdapter(ColorMeaningAdapter());
    Hive.registerAdapter(ColorPaletteAdapter());

    // Open boxes
    await Hive.openBox<ColorAnalysis>(colorAnalysisBoxName);
    await Hive.openBox<ColorMeaning>(colorMeaningBoxName);
    await Hive.openBox<ColorPalette>(colorPaletteBoxName);
  }

  // Color Analysis methods
  Future<void> saveColorAnalysis(ColorAnalysis analysis) async {
    final box = Hive.box<ColorAnalysis>(colorAnalysisBoxName);
    await box.put(analysis.id, analysis);
  }

  List<ColorAnalysis> getAllColorAnalyses() {
    final box = Hive.box<ColorAnalysis>(colorAnalysisBoxName);
    return box.values.toList();
  }

  Future<void> deleteColorAnalysis(String id) async {
    final box = Hive.box<ColorAnalysis>(colorAnalysisBoxName);
    await box.delete(id);
  }

  // Color Meaning methods
  Future<void> saveColorMeaning(ColorMeaning meaning) async {
    final box = Hive.box<ColorMeaning>(colorMeaningBoxName);
    await box.put(meaning.id, meaning);
  }
  
  Future<void> deleteColorMeaning(String id) async {
    final box = Hive.box<ColorMeaning>(colorMeaningBoxName);
    await box.delete(id);
  }

  ColorMeaning? getColorMeaning(String colorHex) {
    final box = Hive.box<ColorMeaning>(colorMeaningBoxName);
    // Find by colorHex field
    try {
      return box.values.firstWhere(
        (meaning) => meaning.colorHex == colorHex,
      );
    } catch (e) {
      return null;
    }
  }

  List<ColorMeaning> getAllColorMeanings() {
    final box = Hive.box<ColorMeaning>(colorMeaningBoxName);
    return box.values.toList();
  }

  // Color Palette methods
  Future<void> saveColorPalette(ColorPalette palette) async {
    final box = Hive.box<ColorPalette>(colorPaletteBoxName);
    await box.put(palette.id, palette);
  }

  List<ColorPalette> getAllColorPalettes() {
    final box = Hive.box<ColorPalette>(colorPaletteBoxName);
    return box.values.toList();
  }

  Future<void> deleteColorPalette(String id) async {
    final box = Hive.box<ColorPalette>(colorPaletteBoxName);
    await box.delete(id);
  }
}
